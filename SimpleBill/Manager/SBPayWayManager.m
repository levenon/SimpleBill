//
//  SBPayWayManager.m
//  SimplePayWay
//
//  Created by Marike Jave on 15/4/12.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import <XLFCommonKit/XLFCommonKit.h>

#import "SBPayWayManager.h"

#import "SBCoreDataManager.h"

@interface SBPayWayManager ()

@end

@implementation SBPayWayManager

#pragma mark - init

+ (id)sharedInstance;{
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

+ (void)load;{
    [super load];
    [[self class] sharedInstance];
}

#pragma mark - accessory

- (NSArray *)evPayWays{

    return [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBPayWay class])];
}

#pragma mark - public

- (SBPayWay*)efInsertPayWay;{

    return [SBPayWay createObject];
}

- (BOOL)efRemovePayWay:(SBPayWay*)payWay;{

    NSAssert(payWay, @"Can not add nil of %@",[SBPayWay class]);

    return [[SBCoreDataManager sharedInstance] deleteWithObject:payWay];
}

- (SBPayWay*)efPayWayById:(NSString*)payWayId;{

    NSAssert(payWayId, @"payWayId can not be nil");

    return [[[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBPayWay class]) condition:fmts(@"id=%@",payWayId)] lastObject];
}

- (void)efRemoveAllPayWay;{

    NSArray *etPayWays = [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBPayWay class])];

    for (NSManagedObject* etPayWay in etPayWays) {
        [[SBCoreDataManager sharedInstance] deleteWithObject:etPayWay];
    }
}

@end
