//
//  SBInputVC.h
//  SimpleBill
//
//  Created by Marike Jave on 15/4/5.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBBaseTableViewController.h"

#import "SBConstants.h"

@class SBBill;

@interface SBInputVC : SBBaseTableViewController

@property(nonatomic, strong) SBBill *evBill;

@property(nonatomic, assign) SBEditType evEditType;

@end
