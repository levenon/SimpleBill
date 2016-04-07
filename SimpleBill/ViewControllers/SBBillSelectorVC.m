//
//  SBBillSelectorVC
//  SimpleBill
//
//  Created by Marike Jave on 15/4/17.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import <XLFCommonKit/XLFCommonKit.h>
#import <XLFMasonryKit/XLFMasonryKit.h>

#import "SBBillSelectorVC.h"

#import "SBBillManager.h"

#import "SBConstants.h"

#import "SBBillKind.h"

#import "SBInputVC.h"

#import "SBPayVC.h"

#import "SBUser.h"

@interface SBBillSelectorVC ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *evtbvBill;

@property(nonatomic, strong) NSMutableArray* evBillSections;

@end

@implementation SBBillSelectorVC

- (void)loadView{
    [super loadView];

    [self setTitle:[self evTitle]];

    [[self view] addSubview:[self evtbvBill]];

//    if (![self evUser] && [self evTimeRange].length) {
//
//        [self efSetBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(didClickSearch:)] type:XLFNavButtonTypeRight];
//    }

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

    [self efRefresh];
}

#pragma mark - accessory

- (NSString*)evTitle;{

    NSMutableString *etTitle = [NSMutableString string];

    if ([self evUser]) {

        [etTitle appendString:ntoe([[self evUser] name])];
    }

    if ([self evTimeRange].length) {

        NSDateComponents *etFrom = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:[NSDate dateWithTimeIntervalSince1970:[self evTimeRange].location]];

        NSDateComponents *etTo = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:[NSDate dateWithTimeIntervalSince1970:NSMaxRange([self evTimeRange])]];
        
        if ([etTo year] >= [etFrom year]) {

            NSInteger etYearOffset = [etTo year] - [etFrom year];

            if (etYearOffset) {
                [etTitle appendFormat:NSLocalizedString(@"label.year.month.year.month", @"%ld/%ld-%ld/%ld "), [etFrom year], [etFrom month], [etTo year], [etTo month] - 1];
            }
            else if ([etTo month] > [etFrom month]) {

                NSDateComponents *etNow = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:[NSDate date]];
                NSInteger etMonthOffset = [etTo month] - [etFrom month] - 1;

                if ([etNow year] != [etFrom year]) {
                    [etTitle appendFormat:NSLocalizedString(@"label.year", @"%ld "), [etFrom year]];
                }

                if (etMonthOffset) {

                    [etTitle appendFormat:NSLocalizedString(@"label.month.month", @"%ld-%ld "), [etFrom month], [etTo month] - 1];
                }
                else {
                    NSDateFormatter *etFormatter = [[NSDateFormatter alloc] init];
                    [etFormatter setDateFormat:@"MMM"];

                    [etTitle appendFormat:@" %@ ",[etFormatter stringFromDate:[[NSCalendar currentCalendar] dateFromComponents:etFrom]]];
                }
            }
        }
    }

    if (![etTitle length]) {

        [etTitle appendString:NSLocalizedString(@"label.all", @"All ")];
    }

    [etTitle appendString:NSLocalizedString(@"label.bills",@"Bills")];

    return etTitle;
}

- (NSMutableArray*)evBillSections{
    if (!_evBillSections) {

        _evBillSections = [NSMutableArray array];
    }
    return _evBillSections;;
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

- (void)efRefresh;{

    [[self evBillSections] removeAllObjects];

    NSArray *etBills = [[SBBillManager sharedInstance] efBillsInRange:[self evTimeRange] user:[[self evUser] id] billType:[self evType]];

    NSSortDescriptor *etSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
    etBills = [etBills sortedArrayUsingDescriptors:@[etSortDescriptor]];

    [[self evBillSections] addObjectsFromArray:[self _efBillSectionsFromBills:etBills]];

    [[self evtbvBill] reloadData];
}

- (void)_efInstalledConstraints;{

    WeakSelf(ws);
 
    [[self evtbvBill] mas_makeConstraints:^(MASConstraintMaker *make) {

        make.edges.equalTo(ws.view).insets(UIEdgeInsetsZero);
    }];
}

- (NSArray*)_efBillSectionsFromBills:(NSArray*)bills{

    NSMutableArray *etMutBillSection = nil;
    NSMutableArray *etMutBillSections = [NSMutableArray array];

    for (NSInteger nIndex = 0; nIndex < [bills count]; nIndex++) {

        SBBill *etPreviousBill = nil;

        if (nIndex) {
            etPreviousBill = [bills objectAtIndex:nIndex - 1];
        }

        SBBill *etBill = [bills objectAtIndex:nIndex];

        if (etPreviousBill) {

            NSDateComponents *etdcPrevious = [NSDateComponents components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:[NSDate dateWithTimeIntervalSince1970:[[etPreviousBill time] doubleValue]]];

            NSTimeInterval etTime = [NSDate timeIntervalFromDateComponents:etdcPrevious];

            if ([[etBill time] doubleValue] < etTime) {

                [etMutBillSections addObject:etMutBillSection];
                etMutBillSection = [NSMutableArray array];
            }
        }
        else{

            etMutBillSection = [NSMutableArray array];
        }
        [etMutBillSection addObject:etBill];
    }

    if (etMutBillSection && [etMutBillSection count]) {

        [etMutBillSections addObject:etMutBillSection];
    }
    
    return etMutBillSections;
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return [[self evBillSections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[self evBillSections] objectAtIndex:section] count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{

    SBBill *etBill = [[[self evBillSections] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    return [self evEditEnable] && ![[etBill lock] boolValue];
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

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    SBBill *etBill = [[[self evBillSections] objectAtIndex:section] firstObject];

    return [NSDate stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[etBill time] doubleValue]] format:@"yyyy-MM-dd"];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString* idBillCell = @"idBillCell";
    UITableViewCell *etCell = [tableView dequeueReusableCellWithIdentifier:idBillCell];
    if (!etCell) {
        etCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idBillCell];
        [etCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }

    SBBill *etBill = [[[self evBillSections] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];

    [[etCell textLabel] setText:fmts(@"%@ %@",[SBBill stringByType:[[etBill type] integerValue]], ntoe([[etBill billKind] name]))];
    [[etCell detailTextLabel] setText:fmts(@"%.1f%@", [[etBill price] floatValue], kSBStringLabelUnit)];

    return etCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    SBBill *etBill = [[[self evBillSections] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];

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

#pragma mark - UITableViewRowAction

- (void (^)(UITableViewRowAction *action, NSIndexPath *indexPath))efRowActionForDelete;{

    WeakSelf(ws);
    return ^(UITableViewRowAction *action, NSIndexPath *indexPath){

        NSArray *etBills = [[ws evBillSections] objectAtIndex:[indexPath section]];
        SBBill *etBill = [etBills objectAtIndex:[indexPath row]];

        if ([[SBBillManager sharedInstance] efRemoveBill:etBill]) {

            [[ws evtbvBill] beginUpdates];

            NSMutableArray *etMutBills = [NSMutableArray arrayWithArray:etBills];
            [etMutBills removeObject:etBill];

            if ([etMutBills count]) {

                [[ws evBillSections] replaceObjectAtIndex:[indexPath section] withObject:etMutBills];
                [[ws evtbvBill] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else{

                [[ws evBillSections] removeObjectAtIndex:[indexPath section]];
                [[ws evtbvBill] deleteSections:[NSIndexSet indexSetWithIndex:[indexPath section]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }

            [[ws evtbvBill] endUpdates];
        }
    };
}

- (void (^)(UITableViewRowAction *action, NSIndexPath *indexPath))efRowActionForEdit;{

    WeakSelf(ws);
    return ^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [[ws evtbvBill] reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

        NSArray *etBills = [[ws evBillSections] objectAtIndex:[indexPath section]];
        SBBill *etBill = [etBills objectAtIndex:[indexPath row]];

        if ([[etBill type] integerValue] == SBBillTypeInput) {

            SBInputVC *etInputVC = [SBInputVC viewControllerFromStoryboard:@"Static"];
            [etInputVC setEvBill:etBill];
            [etInputVC setEvEditType:SBEditTypeEdit];

            [[ws navigationController] pushViewController:etInputVC animated:YES];
        }
        else if ([[etBill type] integerValue] == SBBillTypeOutput){

            SBPayVC *etPayVC = [SBPayVC viewControllerFromStoryboard:@"Static"];
            [etPayVC setEvBill:etBill];
            [etPayVC setEvEditType:SBEditTypeEdit];

            [[ws navigationController] pushViewController:etPayVC animated:YES];
        }
    };
}

#pragma mark - actions 

- (IBAction)didClickSearch:(id)sender{

    
}

@end
