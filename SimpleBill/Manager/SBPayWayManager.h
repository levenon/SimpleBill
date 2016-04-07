//
//  SBPayWayManager.h
//  SimpleBill
//
//  Created by Marike Jave on 15/4/12.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBPayWay.h"

@interface SBPayWayManager : NSObject

@property(nonatomic, strong, readonly) NSArray *evPayWays; // 默认的账单类型

+ (id)sharedInstance;

- (SBPayWay*)efInsertPayWay;

- (BOOL)efRemovePayWay:(SBPayWay*)payWay;
- (SBPayWay*)efPayWayById:(NSString*)payWayId;

- (void)efRemoveAllPayWay;

@end
