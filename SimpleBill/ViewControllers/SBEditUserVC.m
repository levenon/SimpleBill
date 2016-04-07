//
//  SBEditUserVC.m
//  SimpleBill
//
//  Created by Marike Jave on 15/4/14.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//


#import <XLFCommonKit/XLFCommonKit.h>
#import <XLFMasonryKit/XLFMasonryKit.h>

#import "SBEditUserVC.h"

#import "SBUserManager.h"

#import "SBCoreDataManager.h"

#import "SBUser.h"

@interface SBEditUserVC ()<UITextFieldDelegate>

@property(nonatomic, strong) XLFFormTextField *evtxfName;

@property(nonatomic, strong) XLFFormTextField *evtxfWeight;

@property(nonatomic, strong) UIButton *evbtnManager;

@end

@implementation SBEditUserVC


- (void)loadView{
    [super loadView];

    [self setTitle:select([self evEditType] == SBEditTypeAdd, NSLocalizedString(@"label.add", @"Edit"), select([self evEditType] == SBEditTypeEdit, NSLocalizedString(@"label.edit", @"Edit"), NSLocalizedString(@"label.member.info", @" Member Info"))) ];

    if ([self evEditType] != SBEditTypeOnlyPreview) {

        [self efSetBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didClickSave:)] type:XLFNavButtonTypeRight];
    }

    [[self view] addSubview:[self evtxfName]];
    [[self view] addSubview:[self evtxfWeight]];
    [[self view] addSubview:[self evbtnManager]];

    [self _efInstalledConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    SBUser *etManager = [[SBUserManager sharedInstance] efManager];
    [[self evbtnManager] setHidden:etManager && ([self evEditType] == SBEditTypeAdd || ([self evEditType] == SBEditTypeEdit && ![[etManager id] isEqualToString:[[self evUser] id]]))];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[self evtxfName] becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (void)_efInstalledConstraints;{

    WeakSelf(ws);

    [[self evtxfName] mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(ws.view.mas_top).offset(100);
        make.left.equalTo(ws.view.mas_left).offset(50);
        make.right.equalTo(ws.view.mas_right).offset(-50);
        make.height.equalTo(@50);
    }];

    [[self evtxfWeight] mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(ws.evtxfName.mas_bottom).offset(10);
        make.left.equalTo(ws.view.mas_left).offset(50);
        make.right.equalTo(ws.view.mas_right).offset(-50);
        make.height.equalTo(@50);
    }];

    [[self evbtnManager] mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(ws.evtxfWeight.mas_bottom).offset(10);
        make.left.equalTo(ws.view.mas_left).offset(50);
        make.right.equalTo(ws.view.mas_right).offset(-50);
        make.height.equalTo(@30);
    }];
}

#pragma mark - public

- (BOOL)efSave;{

    NSString *etName = [[self evtxfName] text];
    NSInteger etWeight = [[[self evtxfWeight] text] integerValue];
    BOOL etIsManager = [[self evbtnManager] isSelected];

    if (![etName length]) {

        [MBProgressHUD showWithStatus:NSLocalizedString(@"label.name.can.not.be.empty", @"Name can't be empty!")];
        return NO;
    }
    if (!etWeight) {

        [MBProgressHUD showWithStatus:NSLocalizedString(@"label.weigth.must.be.greater.than.zero", @"Weigth must be greater than 0")];
        return NO;
    }

    SBUser * etUser = [self evUser];

    if ([self evEditType] == SBEditTypeAdd) {

        etUser = [SBUser createObject];
    }

    [etUser setName:etName];
    [etUser setWeight:iton(etWeight)];
    [etUser setIsManager:[NSNumber numberWithBool:etIsManager]];

    if(![[SBCoreDataManager sharedInstance] saveContext] && [self evEditType] == SBEditTypeAdd){

        BOOL etRemove = [[SBCoreDataManager sharedInstance] deleteWithObject:etUser];
        NSAssert(etRemove, NSLocalizedString(@"label.clear.failed", @"Clear Failed"));
        return NO;
    }

    if ([self evDelegate] && [[self evDelegate] respondsToSelector:@selector(epEditUserVC:user:)]) {

        [[self evDelegate] epEditUserVC:self user:etUser];
    }

    return YES;
}

#pragma mark - accessory

- (XLFFormTextField *)evtxfName{

    if (!_evtxfName) {

        _evtxfName = [[XLFFormTextField alloc] initWithFrame:CGRectZero style:XLFFormTextFieldStyleUnderline];
        [_evtxfName setPlaceholder:NSLocalizedString(@"label.member.name", @"Member Name")];
        [_evtxfName setEvLineColor:[UIColor lightGrayColor]];
        [_evtxfName setFont:[UIFont systemFontOfSize:16]];

    }
    return _evtxfName;
}

- (XLFFormTextField*)evtxfWeight{

    if (!_evtxfWeight) {

        _evtxfWeight = [[XLFFormTextField alloc] initWithFrame:CGRectZero style:XLFFormTextFieldStyleUnderline];
        [_evtxfWeight setPlaceholder:NSLocalizedString(@"label.weight", @"Weight")];
        [_evtxfWeight setEvLineColor:[UIColor lightGrayColor]];
        [_evtxfWeight setKeyboardType:UIKeyboardTypeNumberPad];
        [_evtxfWeight setDelegate:self];
        [_evtxfWeight setFont:[UIFont systemFontOfSize:16]];
    }
    return _evtxfWeight;
}

- (UIButton*)evbtnManager{

    if (!_evbtnManager) {

        _evbtnManager = [UIButton emptyFrameView];
        [_evbtnManager setTitle:@"记账人" forState:UIControlStateNormal];
        [_evbtnManager setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_evbtnManager setImage:[UIImage imageNamed:@"checkbox_unchecked"] forState:UIControlStateNormal];
        [_evbtnManager setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateSelected];
        [_evbtnManager addTarget:self action:@selector(didClickManager:) forControlEvents:UIControlEventTouchUpInside];
        [_evbtnManager setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_evbtnManager setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
        [[_evbtnManager titleLabel] setFont:[UIFont systemFontOfSize:16]];
    }
    return _evbtnManager;
}

- (void)setEvEditType:(SBEditType )evEditType{

    if (_evEditType != evEditType) {
        _evEditType = evEditType;
    }
    [[self evtxfName] setEnabled:evEditType!=SBEditTypeOnlyPreview];
    [[self evtxfWeight] setEnabled:evEditType!=SBEditTypeOnlyPreview];
    [[self evbtnManager] setEnabled:evEditType!=SBEditTypeOnlyPreview];
}

- (void)setEvUser:(SBUser *)evUser{

    if (_evUser != evUser) {

        _evUser = evUser;
    }

    [[self evtxfName] setText:ntodefault([evUser name], NSLocalizedString(@"label.none", @"None"))];
    [[self evtxfWeight] setText:itos([[evUser weight] integerValue])];
    [[self evbtnManager] setSelected:[[evUser isManager] boolValue]];
}

#pragma mark - actions

- (IBAction)didClickSave:(id)sender{

    [[self evtxfName] resignFirstResponder];
    [[self evtxfWeight] resignFirstResponder];
    if ([self efSave]) {
        [self efBack];
    }
}

- (IBAction)didClickManager:(UIButton*)sender{

    [sender setSelected:![sender isSelected]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;{

    return [[[textField text] stringByReplacingCharactersInRange:range withString:string] isNumber];
}

@end
