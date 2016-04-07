//
//  SBBillSelectorVC
//  SimpleBill
//
//  Created by Marike Jave on 15/4/17.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBBaseModalViewController.h"
#import "SBBill.h"

@class SBUser;

@interface SBBillSelectorVC : SBBaseModalViewController

@property(nonatomic, strong) SBUser *evUser;

@property(nonatomic, assign) NSRange evTimeRange;

@property(nonatomic, assign) SBBillType evType;

@property(nonatomic, assign) BOOL evEditEnable;

@end
