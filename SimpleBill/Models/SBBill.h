//
//  SBBill.h
//  SimpleBill
//
//  Created by Marike Jave on 15/4/7.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBBaseModel.h"


typedef NS_ENUM(NSInteger, SBBillType) {
    SBBillTypeUnknown,              // 未知
    SBBillTypeInput = 1,            // 收入
    SBBillTypeOutput = 1<<1,        // 支出
};

@class SBBillKind;
@class SBPayWay;;
@class SBUser;

@interface SBBill : SBBaseModel

@property(nonatomic, copy  ) NSString *mark;        // 账单备注
@property(nonatomic, assign) NSNumber* price;       // 账单总价
@property(nonatomic, assign) NSNumber* lock;        // 账单锁定状态
@property(nonatomic, assign) NSNumber* type;        // 账单类型

//@property(nonatomic, copy  ) NSString *billKindId;        // 账单类别ID
//@property(nonatomic, copy  ) NSString *payWayId;          // 支付方式ID
//@property(nonatomic, copy  ) NSString *userId;            // 账单产生者ID

@property(nonatomic, strong) SBBillKind*  billKind;       // 账单类别
@property(nonatomic, strong) SBPayWay*    payWay;         // 支付方式
@property(nonatomic, strong) SBUser*      user;           // 账单产生者

+ (NSString*)stringByType:(SBBillType)type;     // 账单类型描述

@end
