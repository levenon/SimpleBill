//
//  SBBillKind.h
//  SimpleBill
//
//  Created by Marike Jave on 15/4/7.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBBaseModel.h"

@interface SBBillKind : SBBaseModel

@property(nonatomic, copy  ) NSString *name;        // 账单类型名称

@property(nonatomic, strong) NSArray* bills;        // 账单

@property(nonatomic, strong) NSArray* subBillKinds; // 子类别

@property(nonatomic, strong) SBBillKind* parentBillKind; // 父类别

@end

