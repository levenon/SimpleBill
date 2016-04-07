//
//  SBInputVC.m
//  SimpleBill
//
//  Created by Marike Jave on 15/4/5.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import <XLFCommonKit/XLFCommonKit.h>

#import "SBInputVC.h"

#import "SBUserSelectorVC.h"

#import "SBPayWaySelectorVC.h"

#import "SBBillManager.h"

#import "SBCoreDataManager.h"

#import "SBBill.h"

#import "SBUser.h"

#import "SBPayWay.h"

@interface SBInputVC ()<UITableViewDelegate, UITextFieldDelegate, SBUserSelectorVCDelegate, SBPayWaySelectorVCDelegate>

@property (weak, nonatomic) IBOutlet UITableViewCell *evtbvcUserName;

@property (weak, nonatomic) IBOutlet UITableViewCell *evtbvcPayWay;

@property (weak, nonatomic) IBOutlet UITextField *evtxfPrice;

@property (weak, nonatomic) IBOutlet UITextView *evtxvMark;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *evlcPrice;

@property (strong, nonatomic) SBUser *evUser;

@property (strong, nonatomic) SBPayWay *evPayWay;

@end

@implementation SBInputVC

- (void)loadView{
    [super loadView];

    [self setTitle:NSLocalizedString(@"label.income", @"Income")];

    if ([self evEditType] != SBEditTypeOnlyPreview) {

        [self efSetBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didClickSave:)] type:XLFNavButtonTypeRight];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self _efConfigSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - accessory

- (void)setEvBill:(SBBill *)evBill{
    if (_evBill != evBill) {

        _evBill = evBill;
        [self setEvUser:[evBill user]];
        [self setEvPayWay:[evBill payWay]];
    }
    [self _efConfigSubviews];
}

- (void)setEvEditType:(SBEditType)evEditType{

    _evEditType = evEditType;

    [self _efConfigSubviews];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    NSString *text = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    return [text isNumberOrDecimals] || ![text length];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self evEditType] == SBEditTypeOnlyPreview) {
        return 40;
    }
    return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if ([self evEditType] == SBEditTypeOnlyPreview) {

        UILabel *etlbHeader = [UILabel emptyFrameView];
        [etlbHeader setTextColor:[UIColor lightGrayColor]];
        [etlbHeader setFont:[UIFont systemFontOfSize:12]];
        [etlbHeader setTextAlignment:NSTextAlignmentRight];
        [etlbHeader setText:[NSDate stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[[self evBill] time] floatValue]] format:@"yyyy-MM-dd hh:mm:ss"]];

        return etlbHeader;
    }

    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([self evEditType] == SBEditTypeOnlyPreview) {
        return;
    }
    switch ([indexPath row]) {
        case 0:
        {
            SBUserSelectorVC *etUserSelectorVC = [[SBUserSelectorVC alloc] init];
            [etUserSelectorVC setEvDelegate:self];

            [[self navigationController] pushViewController:etUserSelectorVC animated:YES];
        }
            break;

        case 1:
        {
            SBPayWaySelectorVC *etPayWayVC = [[SBPayWaySelectorVC alloc] init];
            [etPayWayVC setEvDelegate:self];

            [[self navigationController] pushViewController:etPayWayVC animated:YES];
        }
            break;

        case 2:
        {
            [[self evtxfPrice] becomeFirstResponder];
        }
            break;

        case 3:
        {
            [[self evtxvMark] becomeFirstResponder];
        }
            break;
        default:
            break;
    }
}

#pragma mark - SBUserSelectorVCDelegate

- (void)epUserSelector:(SBUserSelectorVC*)selector user:(SBUser*)user;{

    [self setEvUser:user];
    [[[self evtbvcUserName] detailTextLabel] setText:ntoe([user name])];
}

#pragma mark - SBPayWaySelectorVCDelegate

- (void)epPayWaySelector:(SBPayWaySelectorVC*)selector payWay:(SBPayWay*)payWay;{

    [self setEvPayWay:payWay];
    [[[self evtbvcPayWay] detailTextLabel] setText:ntoe([payWay name])];
}

#pragma mark - private 

- (void)_efConfigSubviews;{

    if ([self evEditType] != SBEditTypeAdd) {

        [[[self evtbvcUserName] detailTextLabel] setText:ntodefault([[[self evBill] user] name], NSLocalizedString(@"label.none", @"None"))];
        [[[self evtbvcPayWay] detailTextLabel] setText:ntodefault([[[self evBill] payWay] name], NSLocalizedString(@"label.none", @"None"))];
        [[self evtxfPrice] setText:itos([[[self evBill] price] integerValue])];
        [[self evtxvMark] setText:ntoe([[self evBill] mark])];
    }

    if ([self evEditType] == SBEditTypeOnlyPreview) {

        [[self evtbvcUserName] setAccessoryType:UITableViewCellAccessoryNone];
        [[self evtbvcPayWay] setAccessoryType:UITableViewCellAccessoryNone];

        [[self evtxfPrice] setEnabled:NO];
        [[self evtxvMark] setEditable:NO];
        [[self evtxvMark] setSelectable:NO];
        [[self evtxfPrice] setTextAlignment:NSTextAlignmentRight];
        [[self evtxfPrice] setTextColor:[UIColor colorWithHexRGB:0x8E8E93]];
        [[self evtxvMark] setTextColor:[UIColor colorWithHexRGB:0x8E8E93]];
        [[self evlcPrice] setConstant:0];
    }
}

- (BOOL)_efSave;{

    NSString *etPrice = [[self evtxfPrice] text];
    NSString *etMark = [[self evtxvMark] text];

    if (![self evUser]) {

        [MBProgressHUD showWithStatus:NSLocalizedString(@"label.please.select.member", @"Please select member!")];
        return NO;
    }

    if (![self evPayWay]) {

        [MBProgressHUD showWithStatus:NSLocalizedString(@"label.please.select.pay.way", @"Please select Peyment!")];
        return NO;
    }

    if (![etPrice floatValue]) {

        [MBProgressHUD showWithStatus:NSLocalizedString(@"label.price.must.be.greater.than.zero", @"Price must be greater than 0!")];
        return NO;
    }

    SBBill *etBill = [self evBill];
    
    if ([self evEditType] == SBEditTypeAdd) {
        etBill = [SBBill createObject];
    }
    [etBill setPrice:fton([etPrice floatValue])];
    [etBill setMark:etMark];
    [etBill setUser:[self evUser]];
    [etBill setPayWay:[self evPayWay]];
    [etBill setType:[NSNumber numberWithInteger:SBBillTypeInput]];

    if(![[SBCoreDataManager sharedInstance] saveContext] && [self evEditType] == SBEditTypeAdd){
        BOOL etRemove = [[SBCoreDataManager sharedInstance] deleteWithObject:etBill];
        NSAssert(etRemove, NSLocalizedString(@"label.clear.failed", @"Clear Failed"));
        return NO;
    }

    return YES;
}

#pragma mark - actions

- (IBAction)didClickSave:(id)sender{

    if ([self _efSave]) {

        [self efBack];
    }
}

- (IBAction)didClickNavBackButton:(id)sender;{
    
    [super didClickNavBackButton:sender];
}

@end
