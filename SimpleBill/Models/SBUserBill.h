//
//  SBUserBill.h
//  SimpleBill
//
//  Created by Marike Jave on 15/4/20.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SBUser.h"

@interface SBUserBill : NSObject

@property(nonatomic, strong) SBUser *user;

@property(nonatomic, assign) float price;

@end
