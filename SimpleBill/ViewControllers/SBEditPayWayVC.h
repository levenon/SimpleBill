//
//  SBEditPayWayVC.h
//  SimpleBill
//
//  Created by Marike Jave on 15/4/14.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBBaseModalViewController.h"
#import "SBConstants.h"

@class SBEditPayWayVC;
@class SBPayWay;

@protocol SBEditPayWayVCDelegate <NSObject>

- (void)epEditPayWayVC:(SBEditPayWayVC*)selector payWay:(SBPayWay*)payWay;

@end

@interface SBEditPayWayVC : SBBaseModalViewController

@property(nonatomic, assign) id<SBEditPayWayVCDelegate> evDelegate;

@property(nonatomic, strong) SBPayWay *evPayWay;

@property(nonatomic, assign) SBEditType evEditType;

@property(nonatomic, strong, readonly) XLFFormTextField *evtxfName;

- (BOOL)efSave;

@end