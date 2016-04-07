//
//  SBPayWaySelectorVC.h
//  SimpleBill
//
//  Created by Marike Jave on 15/4/14.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBBaseModalViewController.h"

@class SBPayWaySelectorVC;
@class SBPayWay;

@protocol SBPayWaySelectorVCDelegate <NSObject>

- (void)epPayWaySelector:(SBPayWaySelectorVC*)selector payWay:(SBPayWay*)payWay;

@end

@interface SBPayWaySelectorVC : SBBaseModalViewController

@property(nonatomic, assign) id<SBPayWaySelectorVCDelegate> evDelegate;

@property(nonatomic, assign) BOOL evEditEnable;

@end
