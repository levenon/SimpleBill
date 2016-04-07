//
//  SBMonthBill.h
//  SimpleBill
//
//  Created by Marike Jave on 15/4/13.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBBaseModel.h"

typedef NS_ENUM(NSInteger, SBMonthBillState) {

    SBMonthBillStateDown,           // 比上月金额低
    SBMonthBillStateUp,             // 比上月金额高
    SBMonthBillStateDefault         // 默认，和上月没有变化
};

#define SBMonthBillState(previousPrice,nextPrice)   (nextPrice>previousPrice?SBMonthBillStateUp:(nextPrice<previousPrice?SBMonthBillStateDown:SBMonthBillStateDefault))

@interface SBMonthBill : NSObject

@property(assign, nonatomic) float price;

@property(assign, nonatomic) SBMonthBillState state;

@end
