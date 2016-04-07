//
//  SBBillKindSelectorVC.m
//  SimpleBill
//
//  Created by Marike Jave on 15/4/5.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import <XLFCommonKit/XLFCommonKit.h>
#import <XLFMasonryKit/XLFMasonryKit.h>

#import "SBBillKindSelectorVC.h"

#import "SBEditBillKindVC.h"

#import "SBBillKindManager.h"

#import "SBBillKind.h"

@interface SBBillKindSelectorVC ()<UITableViewDelegate, UITableViewDataSource, SBEditBillKindVCDelegate>

@property(nonatomic, strong) UITableView *evtbvBillKind;

@property(nonatomic, strong) NSMutableArray *evBillKinds;

@end

@implementation SBBillKindSelectorVC

- (void)loadView{
    [super loadView];

    [self setTitle:select([self evDelegate], NSLocalizedString(@"label.select.category", @"Select Category"), NSLocalizedString(@"label.all.category",@"All Categories"))];

    [self efSetBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didClickAdd:)] type:XLFNavButtonTypeRight];

    [[self view] addSubview:[self evtbvBillKind]];

    [self _efInstalledConstraints];

    [self efRefresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (void)_efInstalledConstraints;{

    WeakSelf(ws);

    [[self evtbvBillKind] mas_makeConstraints:^(MASConstraintMaker *make) {

        make.edges.equalTo(ws.view).insets(UIEdgeInsetsZero);
    }];
}

- (void)efRefresh;{

    [[self evBillKinds] removeAllObjects];
    [[self evBillKinds] addObjectsFromArray:[[SBBillKindManager sharedInstance] evBillKinds]];

    [[self evtbvBillKind] reloadData];
}

#pragma mark - accessory 

- (NSMutableArray*)evBillKinds{

    if (!_evBillKinds) {

        _evBillKinds = [NSMutableArray array];
    }
    return _evBillKinds;
}

- (UITableView *)evtbvBillKind{

    if (!_evtbvBillKind) {

        _evtbvBillKind = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_evtbvBillKind setDelegate:self];
        [_evtbvBillKind setDataSource:self];
    }
    return _evtbvBillKind;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [[self evBillKinds] count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self evEditEnable];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;{

}

- (NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{

//    UITableViewRowAction *ettbvraDelete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:NSLocalizedString(@"label.delete", @"Delete") handler:[self efRowActionForDelete]];

    UITableViewRowAction *ettbvraEdit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"label.edit", @"Edit") handler:[self efRowActionForEdit]];

//    [ettbvraDelete setBackgroundColor:[UIColor redColor]];
    [ettbvraEdit setBackgroundColor:[UIColor lightGrayColor]];

    return @[ettbvraEdit];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *idBillKindCell = @"idBillKindCell";

    UITableViewCell *etCell = [tableView dequeueReusableCellWithIdentifier:idBillKindCell];

    if (!etCell) {

        etCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idBillKindCell];
    }
    SBBillKind *etBillKind = [[self evBillKinds] objectAtIndex:[indexPath row]];

    [[etCell textLabel] setText:[etBillKind name]];
    [[etCell detailTextLabel] setText:fmts(NSLocalizedString(@"label.times", @"%lu Times"), [[etBillKind bills] count])];

    return etCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SBBillKind *etBillKind = [[self evBillKinds] objectAtIndex:[indexPath row]];
    if ([self evDelegate] && [[self evDelegate] respondsToSelector:@selector(epBillKindSelector:billKind:)]) {

        [[self evDelegate] epBillKindSelector:self billKind:etBillKind];
        [[self navigationController] popViewControllerAnimated:YES];
    }
    else{

        SBEditBillKindVC *etEditBillKindVC = [[SBEditBillKindVC alloc] init];

        [etEditBillKindVC setEvDelegate:self];
        [etEditBillKindVC setEvBillKind:etBillKind];
        [etEditBillKindVC setEvEditType:SBEditTypeOnlyPreview];

        [[self navigationController] pushViewController:etEditBillKindVC animated:YES];
    }
}

#pragma mark - actions 

- (IBAction)didClickAdd:(id)sender{

    SBEditBillKindVC *etAddBillKindVC = [[SBEditBillKindVC alloc] init];

    [etAddBillKindVC setEvDelegate:self];
    [etAddBillKindVC setEvEditType:SBEditTypeAdd];

    [[self navigationController] pushViewController:etAddBillKindVC animated:YES];
}

#pragma mark - UITableViewRowAction

- (void (^)(UITableViewRowAction *action, NSIndexPath *indexPath))efRowActionForDelete;{

    WeakSelf(ws);
    return ^(UITableViewRowAction *action, NSIndexPath *indexPath){

        SBBillKind *etBillKind = [[ws evBillKinds] objectAtIndex:[indexPath row]];

        if ([[SBBillKindManager sharedInstance] efRemoveBillKind:etBillKind]) {

            [[ws evtbvBillKind] beginUpdates];

            [[ws evBillKinds] removeObjectAtIndex:[indexPath row]];
            [[ws evtbvBillKind] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

            [[ws evtbvBillKind] endUpdates];
        }
    };
}

- (void (^)(UITableViewRowAction *action, NSIndexPath *indexPath))efRowActionForEdit;{

    WeakSelf(ws);
    return ^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [[ws evtbvBillKind] reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

        SBBillKind *etBillKind = [[ws evBillKinds] objectAtIndex:[indexPath row]];
        SBEditBillKindVC *etEditBillKindVC = [[SBEditBillKindVC alloc] init];

        [etEditBillKindVC setEvBillKind:etBillKind];
        [etEditBillKindVC setEvDelegate:ws];
        [etEditBillKindVC setEvEditType:SBEditTypeEdit];

        [[ws navigationController] pushViewController:etEditBillKindVC animated:YES];
    };
}

#pragma mark - SBEditBillKindVCDelegate

- (void)epEditBillKindVC:(SBEditBillKindVC*)selector billKind:(SBBillKind*)billKind;{

    if ([selector evEditType] == SBEditTypeAdd) {

        [[self evtbvBillKind] beginUpdates];

        [[self evBillKinds] addObject:billKind];
        [[self evtbvBillKind] insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[[self evBillKinds] count] - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];

        [[self evtbvBillKind] endUpdates];
    }
    else{

        NSInteger etIndex = [[self evBillKinds] indexOfObject:billKind];
        if (etIndex != NSNotFound) {

            [[self evtbvBillKind] reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:etIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

@end
