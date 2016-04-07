//
//  SBPayWay.h
//  SimpleBill
//
//  Created by Marike Jave on 15/4/12.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBBaseModel.h"

@interface SBPayWay : SBBaseModel

@property(nonatomic, copy) NSString *name;

@property(nonatomic, strong) NSArray* bills;        // 账单

@end
