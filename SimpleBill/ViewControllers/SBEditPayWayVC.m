
//
//  SBEditPayWayVC.m
//  SimpleBill
//
//  Created by Marike Jave on 15/4/14.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import <XLFCommonKit/XLFCommonKit.h>
#import <XLFMasonryKit/XLFMasonryKit.h>

#import "SBEditPayWayVC.h"

#import "SBPayWayManager.h"

#import "SBCoreDataManager.h"

#import "SBPayWay.h"


@interface SBEditPayWayVC ()

@property(nonatomic, strong) XLFFormTextField *evtxfName;

@end

@implementation SBEditPayWayVC

- (void)loadView{
    [super loadView];

    [self setTitle:select([self evEditType] == SBEditTypeAdd, NSLocalizedString(@"label.add", @"Add"), select([self evEditType] == SBEditTypeEdit, NSLocalizedString(@"label.edit", @"Edit"), NSLocalizedString(@"label.pay.way", @" Payment"))) ];

    if ([self evEditType] != SBEditTypeOnlyPreview) {

        [self efSetBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didClickSave:)] type:XLFNavButtonTypeRight];
    }

    [[self view] addSubview:[self evtxfName]];

    [self _efInstalledConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
}

#pragma mark - public

- (BOOL)efSave;{

    NSString *etName = [[self evtxfName] text];

    if (![etName length]) {

        [MBProgressHUD showWithStatus:NSLocalizedString(@"label.name.can.not.be.empty", @"Name can't be empty!")];
        return NO;
    }

    SBPayWay* etPayWay = [self evPayWay];
    
    if ([self evEditType] == SBEditTypeAdd) {

        etPayWay = [SBPayWay createObject];
    }

    [etPayWay setName:etName];

    if (![[SBCoreDataManager sharedInstance] saveContext] && [self evEditType] == SBEditTypeAdd) {

        BOOL etRemove = [[SBPayWayManager sharedInstance] efRemovePayWay:etPayWay];
        NSAssert(etRemove, NSLocalizedString(@"label.clear.failed", @"Clear Failed!"));
        return NO;
    }
    
    if ([self evDelegate] && [[self evDelegate] respondsToSelector:@selector(epEditPayWayVC:payWay:)]) {

        [[self evDelegate] epEditPayWayVC:self payWay:etPayWay];
    }

    return YES;
}

#pragma mark - accessory

- (XLFFormTextField *)evtxfName{

    if (!_evtxfName) {

        _evtxfName = [[XLFFormTextField alloc] initWithFrame:CGRectZero style:XLFFormTextFieldStyleUnderline];
        [_evtxfName setPlaceholder:@"支付方式"];
        [_evtxfName setEvLineColor:[UIColor lightGrayColor]];
        [_evtxfName setFont:[UIFont systemFontOfSize:16]];
    }
    return _evtxfName;
}

- (void)setEvEditType:(SBEditType )evEditType{

    if (_evEditType != evEditType) {
        _evEditType = evEditType;
    }
    [[self evtxfName] setEnabled:evEditType!=SBEditTypeOnlyPreview];
}

- (void)setEvPayWay:(SBPayWay *)evPayWay{

    if (_evPayWay != evPayWay) {

        _evPayWay = evPayWay;
    }
    [[self evtxfName] setText:ntodefault([evPayWay name], NSLocalizedString(@"label.none", @"None"))];
}

#pragma mark - actions

- (IBAction)didClickSave:(id)sender{

    [[self evtxfName] resignFirstResponder];
    if ([self efSave]) {
        [self efBack];
    }
}

@end
