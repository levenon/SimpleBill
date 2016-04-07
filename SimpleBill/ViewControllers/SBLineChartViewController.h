//
//  SBLineChartViewController.h
//  SimpleBill
//
//  Created by Terry Worona on 11/5/13.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBBaseModalViewController.h"

#import "SBLineChartView.h"
#import "SBChartInformationView.h"

#import "SBBillManager.h"

@interface SBLineChartViewController : SBBaseModalViewController

@property (nonatomic, strong, readonly) SBLineChartView *lineChartView;
@property (nonatomic, strong, readonly) SBChartInformationView *informationView;

@property (nonatomic, strong, readonly) NSArray *evMonthOutputs;
@property (nonatomic, strong, readonly) NSArray *evMonthlySymbols;
@property (nonatomic, assign, readonly) float evMaxValue;

@end
