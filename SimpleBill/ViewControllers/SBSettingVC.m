//
//  SBSettingVC.m
//  SimpleBill
//
//  Created by Marike Jave on 15/4/12.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import <XLFCommonKit/XLFCommonKit.h>
#import <XLFMasonryKit/XLFMasonryKit.h>
#import "SBSettingVC.h"
#import "SBConstants.h"

#import "SBBillManager.h"
#import "SBUserManager.h"
#import "SBPayWayManager.h"
#import "SBBillKindManager.h"
#import "SBUserSelectorVC.h"
#import "SBBillSelectorVC.h"
#import "SBPayWaySelectorVC.h"
#import "SBBillKindSelectorVC.h"

@interface SBSettingVC ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSArray* evSettings;

@property(nonatomic, strong) UITableView* evtbvSetting;

@end

@implementation SBSettingVC


- (void)loadView{
    [super loadView];

    [self setTitle:NSLocalizedString(@"label.management", @"Management")];
    
    [[self view] addSubview:[self evtbvSetting]];

    [self _efInstalledConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [XLFAppManager efRegisterAppId:egAppId];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self efRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private 

- (void)_efInstalledConstraints;{

    WeakSelf(ws);

    [[self evtbvSetting] mas_makeConstraints:^(MASConstraintMaker *make) {

        make.edges.equalTo(ws.view).insets(UIEdgeInsetsZero);
    }];
}

- (void)efRefresh;{

    [self setEvSettings:[self _efCreateSettings]];

    [[self evtbvSetting] reloadData];
}

- (NSArray*)_efCreateSettings;{

    NSInteger etBillCount = [[[SBBillManager sharedInstance] evBills] count];
    NSInteger etUserCount = [[[SBUserManager sharedInstance] evUsers] count];
    NSInteger etPayWayCount = [[[SBPayWayManager sharedInstance] evPayWays] count];
    NSInteger etBillKindCount = [[[SBBillKindManager sharedInstance] evBillKinds] count];

    return @[@[@{@"title":NSLocalizedString(@"label.all.bills", @"All Bills"), @"detail":itos(etBillCount), @"destination":[SBBillSelectorVC class],@"editable":@YES},
               @{@"title":NSLocalizedString(@"label.member.composition", @"Member Composition"), @"detail":itos(etUserCount), @"destination":[SBUserSelectorVC class],@"editable":@YES},
               @{@"title":NSLocalizedString(@"label.expend.category", @"Expend Category"), @"detail":itos(etBillKindCount), @"destination":[SBBillKindSelectorVC class],@"editable":@YES},
               @{@"title":NSLocalizedString(@"label.pay.ways", @"Payments"), @"detail":itos(etPayWayCount), @"destination":[SBPayWaySelectorVC class],@"editable":@YES}],
             @[@{@"title":NSLocalizedString(@"label.go.to.praise", @"Go to praise"), @"selector":NSStringFromSelector(@selector(didClickCommentApp:))},
               @{@"title":NSLocalizedString(@"label.author", @"Author"), @"detail":@"Marike Jave"}]];
}

#pragma mark - accessory

- (NSArray*)evSettings{

    if (!_evSettings) {

        _evSettings = @[];
    }
    return _evSettings;
}

- (UITableView *)evtbvSetting{

    if (!_evtbvSetting) {

        _evtbvSetting = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_evtbvSetting setDelegate:self];
        [_evtbvSetting setDataSource:self];
    }
    return _evtbvSetting;
}


#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return [[self evSettings] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [[[self evSettings] objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *idSetteingCell = @"idSetteingCell";

    UITableViewCell *etCell = [tableView dequeueReusableCellWithIdentifier:idSetteingCell];

    if (!etCell) {

        etCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idSetteingCell];

        [etCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    NSDictionary *etItem = [[[self evSettings] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];

    [[etCell textLabel] setText:[etItem objectForKey:@"title"]];
    [[etCell detailTextLabel] setText:[etItem objectForKey:@"detail"]];

    if (![etItem objectForKey:@"destination"] && ![etItem objectForKey:@"selector"]) {
        [etCell setAccessoryType:UITableViewCellAccessoryNone];
    }

    return etCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary *etItem = [[[self evSettings] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];

    Class etClass = [etItem objectForKey:@"destination"];

    if (etClass) {

        UIViewController<SBSelectorInterface> *etDestinationVC = [[etClass alloc] init];

        [etDestinationVC setEvEditEnable:[[etItem objectForKey:@"editable"] boolValue]];

        [[self navigationController] pushViewController:etDestinationVC animated:YES];
    }
    else{

        NSString *etSelector = [etItem objectForKey:@"selector"];
        if ([etSelector length]) {

            [self performSelector:NSSelectorFromString(etSelector) withObject:nil];
        }
    }
}

#pragma mark - actions

- (IBAction)didClickCommentApp:(id)sender{

    [XLFAppManager efCommentApplication];
}

@end
