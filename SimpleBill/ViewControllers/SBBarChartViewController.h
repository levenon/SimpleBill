//
//  SBBarChartViewController.h
//  SimpleBill
//
//  Created by Terry Worona on 11/5/13.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBBaseModalViewController.h"

// Views
#import "SBBarChartView.h"
#import "SBChartInformationView.h"

#import "SBUserMonthBill.h"
#import "SBBillManager.h"

@interface SBBarChartViewController : SBBaseModalViewController

@property (nonatomic, strong, readonly) SBBarChartView *barChartView;
@property (nonatomic, strong, readonly) SBChartInformationView *informationView;

@property (nonatomic, strong, readonly) NSArray *evUserMonthBills;
@property (nonatomic, assign, readonly) float evMaxValue;

@end
