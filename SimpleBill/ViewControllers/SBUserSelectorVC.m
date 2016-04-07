//
//  SBUserSelectorVC.m
//  SimpleBill
//
//  Created by Marike Jave on 15/4/5.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import <XLFCommonKit/XLFCommonKit.h>
#import <XLFMasonryKit/XLFMasonryKit.h>

#import "SBUserSelectorVC.h"

#import "SBEditUserVC.h"

#import "SBUserManager.h"

#import "SBUser.h"

#import "SBBillSelectorVC.h"

@interface SBUserSelectorVC ()<UITableViewDelegate, UITableViewDataSource, SBEditUserVCDelegate>

@property(nonatomic, strong) UITableView *evtbvUser;

@property(nonatomic, strong) NSMutableArray *evUsers;

@end

@implementation SBUserSelectorVC

- (void)loadView{
    [super loadView];

    [self setTitle:select([self evDelegate], NSLocalizedString(@"label.select.member", @"Select Member"), NSLocalizedString(@"label.all.member", @"All Member")) ];

    [self efSetBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didClickAdd:)] type:XLFNavButtonTypeRight];

    [[self view] addSubview:[self evtbvUser]];

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

    [[self evtbvUser] mas_makeConstraints:^(MASConstraintMaker *make) {

        make.edges.equalTo(ws.view).insets(UIEdgeInsetsZero);
    }];
}

- (void)efRefresh;{

    [[self evUsers] removeAllObjects];
    [[self evUsers] addObjectsFromArray:[[SBUserManager sharedInstance] evUsers]];

    [[self evtbvUser] reloadData];
}

#pragma mark - accessory

- (NSMutableArray*)evUsers{

    if (!_evUsers) {

        _evUsers = [NSMutableArray array];
    }
    return _evUsers;
}

- (UITableView *)evtbvUser{

    if (!_evtbvUser) {

        _evtbvUser = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_evtbvUser setDelegate:self];
        [_evtbvUser setDataSource:self];
    }
    return _evtbvUser;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [[self evUsers] count];
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

    static NSString *idUserCell = @"idUserCell";

    UITableViewCell *etCell = [tableView dequeueReusableCellWithIdentifier:idUserCell];

    if (!etCell) {

        etCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idUserCell];
    }
    SBUser *etUser = [[self evUsers] objectAtIndex:[indexPath row]];

    [[etCell textLabel] setText:[etUser name]];
    [[etCell detailTextLabel] setText:fmts(@"%ld", select([self evDelegate], [[etUser weight] integerValue], [[etUser bills] count]))];
    [[etCell imageView] setImage:select([[etUser isManager] boolValue], [UIImage imageNamed:@"cert"], nil)];

    return etCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SBUser *etUser = [[self evUsers] objectAtIndex:[indexPath row]];

    if ([self evDelegate] && [[self evDelegate] respondsToSelector:@selector(epUserSelector:user:)]) {

        [[self evDelegate] epUserSelector:self user:etUser];

        [[self navigationController] popViewControllerAnimated:YES];
    }
    else{

        SBBillSelectorVC *etBillSelectorVC = [[SBBillSelectorVC alloc] init];

        [etBillSelectorVC setEvUser:etUser];

        [[self navigationController] pushViewController:etBillSelectorVC animated:YES];
    }
}

#pragma mark - actions

- (IBAction)didClickAdd:(id)sender{

    SBEditUserVC *etAddUserVC = [[SBEditUserVC alloc] init];

    [etAddUserVC setEvDelegate:self];
    [etAddUserVC setEvEditType:SBEditTypeAdd];

    [[self navigationController] pushViewController:etAddUserVC animated:YES];
}

#pragma mark - UITableViewRowAction

- (void (^)(UITableViewRowAction *action, NSIndexPath *indexPath))efRowActionForDelete;{

    WeakSelf(ws);
    return ^(UITableViewRowAction *action, NSIndexPath *indexPath){

        SBUser *etUser = [[ws evUsers] objectAtIndex:[indexPath row]];

        if ([[SBUserManager sharedInstance] efRemoveUser:etUser]) {

            [[ws evtbvUser] beginUpdates];

            [[ws evUsers] removeObjectAtIndex:[indexPath row]];
            [[ws evtbvUser] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

            [[ws evtbvUser] endUpdates];
        }
    };
}

- (void (^)(UITableViewRowAction *action, NSIndexPath *indexPath))efRowActionForEdit;{

    WeakSelf(ws);
    return ^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [[ws evtbvUser] reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

        SBUser *etUser = [[ws evUsers] objectAtIndex:[indexPath row]];
        SBEditUserVC *etEditUserVC = [[SBEditUserVC alloc] init];

        [etEditUserVC setEvUser:etUser];
        [etEditUserVC setEvDelegate:ws];
        [etEditUserVC setEvEditType:SBEditTypeEdit];

        [[ws navigationController] pushViewController:etEditUserVC animated:YES];
    };
}

#pragma mark - SBEditUserVCDelegate

- (void)epEditUserVC:(SBEditUserVC*)selector user:(SBUser*)user;{

    if ([selector evEditType] == SBEditTypeAdd) {

        [[self evtbvUser] beginUpdates];

        [[self evUsers] addObject:user];
        [[self evtbvUser] insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[[self evUsers] count] - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];

        [[self evtbvUser] endUpdates];
    }
    else{

        NSInteger etIndex = [[self evUsers] indexOfObject:user];
        if (etIndex != NSNotFound) {
            
            [[self evtbvUser] reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:etIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

@end
