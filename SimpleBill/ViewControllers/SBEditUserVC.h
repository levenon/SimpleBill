//
//  SBEditUserVC.h
//  SimpleBill
//
//  Created by Marike Jave on 15/4/14.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBBaseModalViewController.h"
#import "SBConstants.h"

@class SBEditUserVC;
@class SBUser;

@protocol SBEditUserVCDelegate <NSObject>

- (void)epEditUserVC:(SBEditUserVC*)selector user:(SBUser*)user;

@end

@interface SBEditUserVC : SBBaseModalViewController

@property(nonatomic, strong) SBUser *evUser;

@property(nonatomic, assign) SBEditType evEditType;

@property(nonatomic, assign) id<SBEditUserVCDelegate> evDelegate;

@property(nonatomic, strong, readonly) XLFFormTextField *evtxfName;

@property(nonatomic, strong, readonly) XLFFormTextField *evtxfWeight;

- (BOOL)efSave;

@end