//
//  SBPersonBillVC.m
//  SimpleBill
//
//  Created by Marike Jave on 15/4/5.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBPersonBillVC.h"

#import "SBBillSelectorVC.h"

#import "SBBaseNavigationController.h"

@interface SBPersonBillVC ()

@property(nonatomic, strong) UIButton* evbtnDetail;

@end

@implementation SBPersonBillVC

- (void)loadView{
    [super loadView];

    [[self view] addSubview:[self evbtnDetail]];
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

#pragma mark - accessory

- (UIButton *)evbtnDetail{
    if (!_evbtnDetail) {

        _evbtnDetail = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [_evbtnDetail setFrame:CGRectMake(CGRectGetWidth([[self view] bounds]) - 50, CGRectGetHeight([[self view] bounds]) - 50, 40, 40)];
        [_evbtnDetail setTintColor:[UIColor whiteColor]];
        [_evbtnDetail addTarget:self action:@selector(didClickDetail:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _evbtnDetail;
}

#pragma mark - actions

- (IBAction)didClickDetail:(id)sender{

    NSInteger etSelectUserIndex = [[self barChartView] selectedIndex]/2;
    if (etSelectUserIndex >= [[self evUserMonthBills] count]) {
        return;
    }

    BOOL etCurrentMonth = [[self barChartView] selectedIndex]%2;

    SBUserMonthBill *etUserMonthBill = [[self evUserMonthBills] objectAtIndex:etSelectUserIndex];

    NSDateComponents *etDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:[NSDate date]];

    if (!etCurrentMonth) {
        [etDateComponents monthOffset:-1];
    }

    NSTimeInterval from = [[[NSCalendar currentCalendar] dateFromComponents:etDateComponents] timeIntervalSince1970];
    [etDateComponents monthOffset:1];

    NSTimeInterval to = [[[NSCalendar currentCalendar] dateFromComponents:etDateComponents] timeIntervalSince1970];

    SBBillSelectorVC *etBillSelectorVC = [[SBBillSelectorVC alloc] init];
    [etBillSelectorVC setEvTimeRange:NSMakeRange(from, to - from)];
    [etBillSelectorVC setEvUser:[etUserMonthBill user]];

    SBBaseNavigationController *etNav = [[SBBaseNavigationController alloc] initWithRootViewController:etBillSelectorVC];

    [self presentViewController:etNav animated:YES completion:nil];
}

#pragma mark - SBRootVCDelegate

- (BOOL)epEnableScrollAtLocation:(CGPoint)location;{

    return !CGRectContainsPoint([[self barChartView] frame], location);
}

@end
