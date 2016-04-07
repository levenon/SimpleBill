//
//  SBEditBillKindVC.m
//  SimpleBill
//
//  Created by Marike Jave on 15/4/5.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import <XLFCommonKit/XLFCommonKit.h>
#import <XLFMasonryKit/XLFMasonryKit.h>

#import "SBEditBillKindVC.h"

#import "SBBillKindManager.h"

#import "SBCoreDataManager.h"

#import "SBBillKind.h"


@interface SBEditBillKindVC ()

@property(nonatomic, strong) XLFFormTextField *evtxfName;

@end

@implementation SBEditBillKindVC

- (void)loadView{
    [super loadView];

    [self setTitle:select([self evEditType] == SBEditTypeAdd, NSLocalizedString(@"label.add", @"Add"), select([self evEditType] == SBEditTypeEdit, NSLocalizedString(@"label.edit", @"Edit"), NSLocalizedString(@"label.category.info", @"Category Info"))) ];

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

        [MBProgressHUD showWithStatus:NSLocalizedString(@"label.category.name.can.not.be.empty", @"Category name can't be empty!")];
        return NO;
    }

    SBBillKind* etBillKind = [self evBillKind];

    if ([self evEditType] == SBEditTypeAdd) {
        etBillKind = [SBBillKind createObject];
    }

    [etBillKind setName:etName];

    if(![[SBCoreDataManager sharedInstance] saveContext] && [self evEditType] == SBEditTypeAdd){

        BOOL etRemove = [[SBCoreDataManager sharedInstance] deleteWithObject:etBillKind];
        NSAssert(etRemove, NSLocalizedString(@"label.clear.failed", @"Clear Failed!"));
        return NO;
    }

    if ([self evDelegate] && [[self evDelegate] respondsToSelector:@selector(epEditBillKindVC:billKind:)]) {

        [[self evDelegate] epEditBillKindVC:self billKind:etBillKind];
    }
    return YES;
}

#pragma mark - accessory

- (XLFFormTextField *)evtxfName{

    if (!_evtxfName) {

        _evtxfName = [[XLFFormTextField alloc] initWithFrame:CGRectZero style:XLFFormTextFieldStyleUnderline];
        [_evtxfName setPlaceholder:NSLocalizedString(@"label.category.name", @"Category name")];
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

- (void)setEvBillKind:(SBBillKind *)evBillKind{

    if (_evBillKind != evBillKind) {

        _evBillKind = evBillKind;

    }
    [[self evtxfName] setText:ntodefault([evBillKind name], NSLocalizedString(@"label.none", @"None"))];
}

#pragma mark - actions 

- (IBAction)didClickSave:(id)sender{

    [[self evtxfName] resignFirstResponder];
    if ([self efSave]) {
        [self efBack];
    }
}

@end
