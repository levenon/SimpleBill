//
//  SBExpenditureBillVC.m
//  SimpleBill
//
//  Created by Marike Jave on 15/4/5.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import <XLFCommonKit/XLFCommonKit.h>

#import <XLFMasonryKit/XLFMasonryKit.h>
#import "SBBaseNavigationController.h"
#import "SBExpenditureBillVC.h"
#import "SBPayVC.h"
#import "SBInputVC.h"
#import "SBSettingVC.h"
#import "SBBillSelectorVC.h"

#import "SBConstants.h"

#import "SBBillManager.h"
#import "SBShareManager.h"

#import "SBBill.h"
#import "SBBillKind.h"
#import "SBMonthBill.h"
#import "SBUser.h"
#import "SBUserBill.h"

@interface SBExpenditureBillVC () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *evtbvRecentBill;

@property(nonatomic, strong) NSArray* evRecentBills;

@property(nonatomic, strong) UILabel* evlbTotalOutput;

@property(nonatomic, strong) UILabel* evlbTotalInput;

@property(nonatomic, strong) UILabel* evlbHighestExpendPerson;
@property(nonatomic, strong) UILabel* evlbHighestExpendPersonPrice;

@property(nonatomic, strong) UILabel* evlbMostPoorPerson;
@property(nonatomic, strong) UILabel* evlbMostPoorPersonPrice;

@property(nonatomic, strong) UIToolbar* evtlbBottomBar;

@property(nonatomic, strong) NSTimer* evTimerAutoScroll;

@end

@implementation SBExpenditureBillVC

- (void)loadView{
    [super loadView];

    [self efSetBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(didClickShare:)] type:XLFNavButtonTypeRight];

    [[self view] setBackgroundColor:kSBColorControllerBackground];
    [[self view] addSubview:[self evlbTotalOutput]];
    [[self view] addSubview:[self evlbTotalInput]];
    [[self view] addSubview:[self evlbHighestExpendPerson]];
    [[self view] addSubview:[self evlbHighestExpendPersonPrice]];
    [[self view] addSubview:[self evlbMostPoorPerson]];
    [[self view] addSubview:[self evlbMostPoorPersonPrice]];
    [[self view] addSubview:[self evtbvRecentBill]];
    [[self view] addSubview:[self evtlbBottomBar]];

    [self _efInstalledConstraints];
}

- (void)viewDidLoad{
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self efRefresh];
}

#pragma mark - private

- (void)efRefresh;{

    [self _efUpdateMonthBill:[[SBBillManager sharedInstance] evCurrentMonthInput] type:SBBillTypeInput];
    [self _efUpdateMonthBill:[[SBBillManager sharedInstance] evCurrentMonthOutput] type:SBBillTypeOutput];

    [self _efUpdateUserBill:[[SBBillManager sharedInstance] evHighestExpendUserBill] highestExpend:YES];
    [self _efUpdateUserBill:[[SBBillManager sharedInstance] evMostPoorUserBill] highestExpend:NO];

    [self _efEndTimer];

    [self setEvRecentBills:[[SBBillManager sharedInstance] evBills]];
    [[self evtbvRecentBill] reloadData];

    [self _efBeginTimer];
}

- (void)_efInstalledConstraints;{

    WeakSelf(ws);

    [[self evlbTotalInput] mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(ws.view.mas_left).offset(20);
        make.right.greaterThanOrEqualTo(ws.view.mas_right).offset(20);
        make.top.equalTo(ws.view.mas_top).offset(70);
    }];
    

    [[self evlbTotalOutput] mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(ws.view.mas_left).offset(20);
        make.right.greaterThanOrEqualTo(ws.view.mas_right).offset(20);
        make.top.equalTo(ws.evlbTotalInput.mas_bottom).offset(20);
    }];

    [[self evlbHighestExpendPerson] mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(ws.evlbTotalOutput.mas_bottom).offset(40);
        make.left.equalTo(ws.view.mas_left).offset(20);
    }];

    [[self evlbHighestExpendPersonPrice] mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(ws.evlbHighestExpendPerson.mas_right).offset(20);
        make.right.lessThanOrEqualTo(ws.view.mas_right).offset(-20);
        make.bottom.equalTo(ws.evlbHighestExpendPerson.mas_bottom).offset(-5);
        make.width.greaterThanOrEqualTo(@50);
    }];

    [[self evlbMostPoorPerson] mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(ws.evlbHighestExpendPerson.mas_bottom).offset(20);
        make.left.equalTo(ws.view.mas_left).offset(20);
    }];

    [[self evlbMostPoorPersonPrice] mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(ws.evlbHighestExpendPersonPrice.mas_left).offset(0);
        make.bottom.equalTo(ws.evlbMostPoorPerson.mas_bottom).offset(-5);
    }];

    [[self evtbvRecentBill] mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(ws.evlbMostPoorPerson.mas_bottom).offset(50);
        make.bottom.equalTo(ws.evtlbBottomBar.mas_top).offset(-20);
        make.left.equalTo(ws.view.mas_left).offset(10);
        make.right.equalTo(ws.view.mas_right).offset(-70);
    }];

    [[self evtlbBottomBar] mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(ws.view.mas_left).offset(0);
        make.right.equalTo(ws.view.mas_right).offset(0);
        make.bottom.equalTo(ws.view.mas_bottom).offset(0);
    }];
}

- (void)_efUpdateMonthBill:(SBMonthBill*)monthBill type:(SBBillType)type;{

    NSString *etIndicate = select([monthBill state] == SBMonthBillStateUp, @"↑", select([monthBill state] == SBMonthBillStateDown, @"↓", @""));
    NSString *etPrice = fmts(@"%.1f%@", [monthBill price], etIndicate);
    NSString *etTitleIn = NSLocalizedString(@"label.month.income",@"In ");
    NSString *etTitleOut = NSLocalizedString(@"label.month.expend",@"Out");

    NSString *etContent = fmts(@"%@：%@", select(type&SBBillTypeInput, etTitleIn, etTitleOut), etPrice);

    NSMutableAttributedString *etAttributeString = [[NSMutableAttributedString alloc] initWithString:etContent  attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:30]}];

    [etAttributeString addAttribute:NSForegroundColorAttributeName
                              value:select(type&SBBillTypeInput, [UIColor greenColor], [UIColor redColor])
                              range:NSMakeRange(select(type&SBBillTypeInput, [etTitleIn length], [etTitleOut length]) + 1, [etPrice length])];

    [select(type&SBBillTypeInput, [self evlbTotalInput], [self evlbTotalOutput]) setAttributedText:etAttributeString];
}

- (void)_efUpdateUserBill:(SBUserBill*)userBill highestExpend:(BOOL)highestExpend{

    NSString *etName = fmts(@"%@：%@  ", select(highestExpend, NSLocalizedString(@"label.richer", @"Richer"), NSLocalizedString(@"label.pauper", @"Pauper")), ntoe([[userBill user] name]));
    NSString *etPrice = fmts(@"%.1f", [userBill price]);

    [[self evlbMostPoorPerson] setHidden:!userBill];
    [[self evlbHighestExpendPerson] setHidden:!userBill];

    [[self evlbMostPoorPersonPrice] setHidden:!userBill];
    [[self evlbHighestExpendPersonPrice] setHidden:!userBill];

    [select(highestExpend, [self evlbHighestExpendPerson], [self evlbMostPoorPerson]) setText:etName];
    [select(highestExpend, [self evlbHighestExpendPersonPrice], [self evlbMostPoorPersonPrice]) setText:etPrice];
}

- (void)_efBeginTimer;{

    [self evTimerAutoScroll];
}

- (void)_efEndTimer;{

    if ([self evTimerAutoScroll]) {
        [[self evTimerAutoScroll] invalidate];
        [self setEvTimerAutoScroll:nil];
    }
}

#pragma mark - accessory

- (UIBarButtonItem*)evbbiDefaultBack{
    return nil;
}

- (NSTimer*)evTimerAutoScroll{

    if (!_evTimerAutoScroll) {

        _evTimerAutoScroll = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(didTriggerTimer:) userInfo:nil repeats:YES];
    }
    return _evTimerAutoScroll;
}

- (UILabel *)evlbTotalInput{

    if (!_evlbTotalInput) {

        _evlbTotalInput = [UILabel emptyFrameView];
    }
    return _evlbTotalInput;
}

- (UILabel *)evlbTotalOutput{

    if (!_evlbTotalOutput) {

        _evlbTotalOutput = [UILabel emptyFrameView];
    }
    return _evlbTotalOutput;
}

- (UILabel *)evlbHighestExpendPerson{

    if (!_evlbHighestExpendPerson) {

        _evlbHighestExpendPerson = [UILabel emptyFrameView];
        [_evlbHighestExpendPerson setTextColor:[UIColor whiteColor]];
        [_evlbHighestExpendPerson setFont:[UIFont systemFontOfSize:25]];
    }
    return _evlbHighestExpendPerson;
}

- (UILabel*)evlbHighestExpendPersonPrice{

    if (!_evlbHighestExpendPersonPrice) {

        _evlbHighestExpendPersonPrice = [UILabel emptyFrameView];
        [_evlbHighestExpendPersonPrice setTextColor:[UIColor whiteColor]];
        [_evlbHighestExpendPersonPrice setFont:[UIFont systemFontOfSize:20]];
    }
    return _evlbHighestExpendPersonPrice;
}

- (UILabel *)evlbMostPoorPerson{

    if (!_evlbMostPoorPerson) {

        _evlbMostPoorPerson = [UILabel emptyFrameView];
        [_evlbMostPoorPerson setTextColor:[UIColor whiteColor]];
        [_evlbMostPoorPerson setFont:[UIFont systemFontOfSize:25]];
    }
    return _evlbMostPoorPerson;
}

- (UILabel*)evlbMostPoorPersonPrice{

    if (!_evlbMostPoorPersonPrice) {

        _evlbMostPoorPersonPrice = [UILabel emptyFrameView];
        [_evlbMostPoorPersonPrice setTextColor:[UIColor whiteColor]];
        [_evlbMostPoorPersonPrice setFont:[UIFont systemFontOfSize:20]];
    }
    return _evlbMostPoorPersonPrice;
}

- (UIToolbar *)evtlbBottomBar{

    if (!_evtlbBottomBar) {

        UIBarButtonItem *etbbiInput = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didClickInput:)];

        UIBarButtonItem *etbbiPay = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(didClickPay:)];

        UIBarButtonItem *etbbiSetting = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(didClickSetting:)];

        UIBarButtonItem *etbbiFlexibleSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

        UIBarButtonItem *etbbiFlexibleSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

        _evtlbBottomBar = [UIToolbar emptyFrameView];
        [_evtlbBottomBar setTintColor:[UIColor whiteColor]];
        [_evtlbBottomBar setShadowImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny
         ];
        [_evtlbBottomBar setBackgroundImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        [_evtlbBottomBar setItems:@[etbbiPay, etbbiFlexibleSpace1, etbbiSetting, etbbiFlexibleSpace2, etbbiInput]];
    }
    return _evtlbBottomBar;
}

- (UITableView*)evtbvRecentBill{
    if (!_evtbvRecentBill) {

        _evtbvRecentBill = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_evtbvRecentBill setDelegate:self];
        [_evtbvRecentBill setDataSource:self];
        [_evtbvRecentBill setBackgroundColor:[UIColor clearColor]];
        [_evtbvRecentBill setSeparatorColor:[UIColor clearColor]];
        [_evtbvRecentBill setShowsVerticalScrollIndicator:NO];
        [_evtbvRecentBill setScrollEnabled:NO];
    }
    return _evtbvRecentBill;
}

- (NSArray*)evRecentBills{
    if (!_evRecentBills) {

        _evRecentBills = @[];
    }
    return _evRecentBills;;
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self evRecentBills] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString* idRecentBillCell = @"idRecentBillCell";
    UITableViewCell *etCell = [tableView dequeueReusableCellWithIdentifier:idRecentBillCell];
    if (!etCell) {
        etCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idRecentBillCell];
    }
    [etCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [etCell setBackgroundColor:[UIColor clearColor]];
    [[etCell contentView] setBackgroundColor:[UIColor clearColor]];
    [[etCell detailTextLabel] setTextColor:[UIColor whiteColor]];

    SBBill *etBill = [[self evRecentBills] objectAtIndex:[indexPath row]];

    NSMutableAttributedString *etAttributeString = [[NSMutableAttributedString alloc] initWithString:fmts(@"%@  %.1f",[SBBill stringByType:[[etBill type] integerValue]], [[etBill price] floatValue]) attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    
    [etAttributeString addAttribute:NSForegroundColorAttributeName
                              value:select([etBill type], [UIColor greenColor], [UIColor redColor])
                              range:NSMakeRange([[SBBill stringByType:[[etBill type] integerValue]] length], [fmts(@"  %.1f",[[etBill price] floatValue]) length])];

    [[etCell textLabel] setAttributedText:etAttributeString];

    if ([[etBill type] integerValue] == SBBillTypeInput) {

        [[etCell detailTextLabel] setText:fmts(@"%@ %@", ntoe([[etBill user] name]), ntoe([etBill mark]))];
    }
    else{

        [[etCell detailTextLabel] setText:fmts(@"%@ %@", ntoe([[etBill billKind] name]), ntoe([etBill mark]))];
    }

    return etCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    SBBillSelectorVC *etBillSelectorVC = [[SBBillSelectorVC alloc] init];

    SBBaseNavigationController *etNav = [[SBBaseNavigationController alloc] initWithRootViewController:etBillSelectorVC];

    [self presentViewController:etNav animated:YES completion:nil];
}

#pragma mark - actions

- (IBAction)didClickInput:(id)sender{

    SBInputVC *etInputVC = [SBInputVC viewControllerFromStoryboard:@"Static"];
    [etInputVC setEvEditType:SBEditTypeAdd];
    SBBaseNavigationController *etNav = [[SBBaseNavigationController alloc] initWithRootViewController:etInputVC];

    [self presentViewController:etNav animated:YES completion:nil];
}

- (IBAction)didClickPay:(id)sender{

    SBPayVC *etPayVC = [SBPayVC viewControllerFromStoryboard:@"Static"];
    [etPayVC setEvEditType:SBEditTypeAdd];

    SBBaseNavigationController *etNav = [[SBBaseNavigationController alloc] initWithRootViewController:etPayVC];

    [self presentViewController:etNav animated:YES completion:nil];
}

- (IBAction)didClickSetting:(id)sender{

    SBSettingVC *etSettingVC = [[SBSettingVC alloc] init];

    SBBaseNavigationController *etNav = [[SBBaseNavigationController alloc] initWithRootViewController:etSettingVC];

    [self presentViewController:etNav animated:YES completion:nil];
}

- (IBAction)didClickShare:(id)sender{

    SBShareInfo *etShareInfo = [SBShareInfo model];
    [etShareInfo setImg:[UIImage imageNamed:@"AppIconShare"]];
    [etShareInfo setTitle:[NSBundle bundleDisplayName]];
    [etShareInfo setDes:egAppShareTitle];
    
    [SBShareManager efShareInfo:etShareInfo];
}

- (IBAction)didTriggerTimer:(id)sender{

    NSIndexPath *etIndxPath = [[[self evtbvRecentBill] indexPathsForVisibleRows] lastObject];

    if (etIndxPath) {

        NSInteger etRow = ([etIndxPath row] + 1) % [[self evRecentBills] count];

        [[self evtbvRecentBill] scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:etRow inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}

@end
