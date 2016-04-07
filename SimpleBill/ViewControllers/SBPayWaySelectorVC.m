//
//  SBPayWaySelectorVC.m
//  SimpleBill
//
//  Created by Marike Jave on 15/4/5.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import <XLFCommonKit/XLFCommonKit.h>
#import <XLFMasonryKit/XLFMasonryKit.h>

#import "SBPayWaySelectorVC.h"

#import "SBEditPayWayVC.h"

#import "SBPayWayManager.h"

#import "SBPayWay.h"

@interface SBPayWaySelectorVC ()<UITableViewDelegate, UITableViewDataSource, SBEditPayWayVCDelegate>

@property(nonatomic, strong) UITableView *evtbvPayWay;

@property(nonatomic, strong) NSMutableArray *evPayWays;

@end

@implementation SBPayWaySelectorVC

- (void)loadView{
    [super loadView];

    [self setTitle:select([self evDelegate], NSLocalizedString(@"label.select.pay.way", @"Select Peyment"), NSLocalizedString(@"label.all.pay.way", @"All Payment")) ];

    [self efSetBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didClickAdd:)] type:XLFNavButtonTypeRight];

    [[self view] addSubview:[self evtbvPayWay]];

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

    [[self evtbvPayWay] mas_makeConstraints:^(MASConstraintMaker *make) {

        make.edges.equalTo(ws.view).insets(UIEdgeInsetsZero);
    }];
}

- (void)efRefresh;{

    [[self evPayWays] removeAllObjects];
    [[self evPayWays] addObjectsFromArray:[[SBPayWayManager sharedInstance] evPayWays]];

    [[self evtbvPayWay] reloadData];
}

#pragma mark - accessory

- (NSMutableArray*)evPayWays{

    if (!_evPayWays) {

        _evPayWays = [NSMutableArray array];
    }
    return _evPayWays;
}

- (UITableView *)evtbvPayWay{

    if (!_evtbvPayWay) {

        _evtbvPayWay = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_evtbvPayWay setDelegate:self];
        [_evtbvPayWay setDataSource:self];
    }
    return _evtbvPayWay;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [[self evPayWays] count];
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

    static NSString *idPayWayCell = @"idPayWayCell";

    UITableViewCell *etCell = [tableView dequeueReusableCellWithIdentifier:idPayWayCell];

    if (!etCell) {

        etCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idPayWayCell];
    }
    SBPayWay *etPayWay = [[self evPayWays] objectAtIndex:[indexPath row]];

    [[etCell textLabel] setText:[etPayWay name]];
    [[etCell detailTextLabel] setText:fmts(NSLocalizedString(@"label.times", @"%lu Times"), [[etPayWay bills] count])];

    return etCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SBPayWay *etPayWay = [[self evPayWays] objectAtIndex:[indexPath row]];
    if ([self evDelegate] && [[self evDelegate] respondsToSelector:@selector(epPayWaySelector:payWay:)]) {

        [[self evDelegate] epPayWaySelector:self payWay:etPayWay];
        [[self navigationController] popViewControllerAnimated:YES];
    }
    else{

        SBEditPayWayVC *etEditPayWayVC = [[SBEditPayWayVC alloc] init];

        [etEditPayWayVC setEvDelegate:self];
        [etEditPayWayVC setEvPayWay:etPayWay];
        [etEditPayWayVC setEvEditType:SBEditTypeOnlyPreview];

        [[self navigationController] pushViewController:etEditPayWayVC animated:YES];
    }
}

#pragma mark - actions

- (IBAction)didClickAdd:(id)sender{

    SBEditPayWayVC *etAddPayWayVC = [[SBEditPayWayVC alloc] init];

    [etAddPayWayVC setEvDelegate:self];
    [etAddPayWayVC setEvEditType:SBEditTypeAdd];

    [[self navigationController] pushViewController:etAddPayWayVC animated:YES];
}

#pragma mark - UITableViewRowAction

- (void (^)(UITableViewRowAction *action, NSIndexPath *indexPath))efRowActionForDelete;{

    WeakSelf(ws);
    return ^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [[ws evtbvPayWay] reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

        SBPayWay *etPayWay = [[ws evPayWays] objectAtIndex:[indexPath row]];

        if ([[SBPayWayManager sharedInstance] efRemovePayWay:etPayWay]) {

            [[ws evtbvPayWay] beginUpdates];

            [[ws evPayWays] removeObjectAtIndex:[indexPath row]];
            [[ws evtbvPayWay] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

            [[ws evtbvPayWay] endUpdates];
        }
    };
}

- (void (^)(UITableViewRowAction *action, NSIndexPath *indexPath))efRowActionForEdit;{

    WeakSelf(ws);
    return ^(UITableViewRowAction *action, NSIndexPath *indexPath){

        SBPayWay *etPayWay = [[ws evPayWays] objectAtIndex:[indexPath row]];
        SBEditPayWayVC *etEditPayWayVC = [[SBEditPayWayVC alloc] init];

        [etEditPayWayVC setEvPayWay:etPayWay];
        [etEditPayWayVC setEvDelegate:ws];
        [etEditPayWayVC setEvEditType:SBEditTypeEdit];

        [[ws navigationController] pushViewController:etEditPayWayVC animated:YES];
    };
}

#pragma mark - SBEditPayWayVCDelegate

- (void)epEditPayWayVC:(SBEditPayWayVC*)selector payWay:(SBPayWay*)payWay;{

    if ([selector evEditType] == SBEditTypeAdd) {

        [[self evtbvPayWay] beginUpdates];

        [[self evPayWays] addObject:payWay];
        [[self evtbvPayWay] insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[[self evPayWays] count] - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];

        [[self evtbvPayWay] endUpdates];
    }
    else{

        NSInteger etIndex = [[self evPayWays] indexOfObject:payWay];
        if (etIndex != NSNotFound) {
            
            [[self evtbvPayWay] reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:etIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

@end
