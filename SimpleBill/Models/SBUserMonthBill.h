//
//  SBUserMonthBill.h
//  SimpleBill
//
//  Created by Marike Jave on 15/4/17.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SBUser.h"

@interface SBUserMonthBill : NSObject

@property(nonatomic, strong) SBUser *user;

@property(nonatomic, assign) float currentMonthOutput;
@property(nonatomic, assign) float currentMonthInput;

@property(nonatomic, assign) float lastMonthOutput;
@property(nonatomic, assign) float lastMonthInput;

@property(nonatomic, assign) float lastLastMonthOutput;
@property(nonatomic, assign) float lastLastMonthInput;

@end
