//
//  SBUser.h
//  SimpleBill
//
//  Created by Marike Jave on 15/4/7.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBBaseModel.h"

@interface SBUser : SBBaseModel

@property(nonatomic, copy  ) NSString *name;    // 姓名

@property(nonatomic, strong) NSNumber* weight;  // 权重

@property(nonatomic, strong) NSArray* bills;    // 账单

@property(nonatomic, strong) NSNumber* isManager;  // 是否记账人

@end
