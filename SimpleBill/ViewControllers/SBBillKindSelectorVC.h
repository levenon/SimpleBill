//
//  SBBillKindSelectorVC.h
//  SimpleBill
//
//  Created by Marike Jave on 15/4/5.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBBaseModalViewController.h"

@class SBBillKindSelectorVC;
@class SBBillKind;

@protocol SBBillKindSelectorVCDelegate <NSObject>

- (void)epBillKindSelector:(SBBillKindSelectorVC*)selector billKind:(SBBillKind*)billKind;

@end

@interface SBBillKindSelectorVC : SBBaseModalViewController

@property(nonatomic, assign) id<SBBillKindSelectorVCDelegate> evDelegate;

@property(nonatomic, assign) BOOL evEditEnable;

@end
