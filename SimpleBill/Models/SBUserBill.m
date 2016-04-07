//
//  SBUserBill.m
//  SimpleBill
//
//  Created by Marike Jave on 15/4/20.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBUserBill.h"

@implementation SBUserBill

- (BOOL)isEqual:(SBUserBill*)object{
    return [super isEqual:object] || ([object isKindOfClass:[self class]] && [[[object user] id] isEqualToString:[[self user] id]]);
}

@end
