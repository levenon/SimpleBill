//
//  SBSearchVC.m
//  SimpleBill
//
//  Created by Marike Jave on 15/4/22.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBSearchVC.h"
#import "SBBillManager.h"

@interface SBSearchVC ()

@property(nonatomic, strong) UISearchBar *evsbInput;

@property(nonatomic, strong) UITableView *evtbvBill;

@property(nonatomic, strong) NSMutableArray* evBills;

@end

@implementation SBSearchVC

- (void)loadView{
    [super loadView];

    [self setTitle:@""];

    [[self view] addSubview:[self evtbvBill]];

    [self _efInstalledConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self _efRefresh];
}

- (NSMutableArray*)evBills{
    if (!_evBills) {

        _evBills = [NSMutableArray array];
    }
    return _evBills;;
}

- (UITableView*)evtbvBill{
    if (!_evtbvBill) {

        _evtbvBill = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_evtbvBill setDelegate:self];
        [_evtbvBill setDataSource:self];
    }
    return _evtbvBill;
}

#pragma mark - private

- (void)_efRefresh;{

    [[self evBills] removeAllObjects];

    NSArray *etBills = [[SBBillManager sharedInstance] efBillsInRange:[self evTimeRange] user:[[self evUser] id] billType:[self evType]];

    [[self evBills] addObjectsFromArray:etBills];

    [[self evtbvBill] reloadData];
}

- (void)_efInstalledConstraints;{

    WeakSelf(ws);

    [[self evtbvBill] mas_makeConstraints:^(MASConstraintMaker *make) {

        make.edges.equalTo(ws.view).insets(UIEdgeInsetsZero);
    }];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self evBills] count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self evEditEnable];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;{

}

- (NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewRowAction *ettbvraDelete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:NSLocalizedString(@"label.delete", @"Delete") handler:[self efRowActionForDelete]];

    UITableViewRowAction *ettbvraEdit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"label.edit", @"Edit") handler:[self efRowActionForEdit]];

    [ettbvraDelete setBackgroundColor:[UIColor redColor]];
    [ettbvraEdit setBackgroundColor:[UIColor lightGrayColor]];

    return @[ettbvraDelete, ettbvraEdit];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString* idBillCell = @"idBillCell";
    UITableViewCell *etCell = [tableView dequeueReusableCellWithIdentifier:idBillCell];
    if (!etCell) {
        etCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idBillCell];
        [etCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }

    SBBill *etBill = [[self evBills] objectAtIndex:[indexPath row]];

    [[etCell textLabel] setText:fmts(@"%@ %@",[SBBill stringByType:[[etBill type] integerValue]], ntoe([[etBill billKind] name]))];
    [[etCell detailTextLabel] setText:fmts(@"%.1f%@", [[etBill price] floatValue], kSBStringLabelUnit)];

    return etCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    SBBill *etBill = [[self evBills] objectAtIndex:[indexPath row]];

    if ([[etBill type] integerValue] == SBBillTypeInput) {

        SBInputVC *etInputVC = [SBInputVC viewControllerFromStoryboard:@"Static"];
        [etInputVC setEvBill:etBill];
        [etInputVC setEvEditType:SBEditTypeOnlyPreview];

        [[self navigationController] pushViewController:etInputVC animated:YES];
    }
    else if ([[etBill type] integerValue] == SBBillTypeOutput){
        
        SBPayVC *etPayVC = [SBPayVC viewControllerFromStoryboard:@"Static"];
        [etPayVC setEvBill:etBill];
        [etPayVC setEvEditType:SBEditTypeOnlyPreview];
        
        [[self navigationController] pushViewController:etPayVC animated:YES];
    }
}

@end
