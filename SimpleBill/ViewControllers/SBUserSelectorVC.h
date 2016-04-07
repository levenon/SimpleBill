//
//  SBUserSelectorVC.h
//  SimpleBill
//
//  Created by Marike Jave on 15/4/5.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBBaseModalViewController.h"

@class SBUserSelectorVC;
@class SBUser;

@protocol SBUserSelectorVCDelegate <NSObject>

- (void)epUserSelector:(SBUserSelectorVC*)selector user:(SBUser*)user;

@end

@interface SBUserSelectorVC : SBBaseModalViewController

@property(nonatomic, assign) id<SBUserSelectorVCDelegate> evDelegate;

@property(nonatomic, assign) BOOL evEditEnable;

@end
