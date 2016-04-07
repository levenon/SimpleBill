//
//  SBUserManager.m
//  SimpleBill
//
//  Created by Marike Jave on 15/4/7.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import <XLFCommonKit/XLFCommonKit.h>

#import "SBUserManager.h"
#import "SBBillManager.h"
#import "SBCoreDataManager.h"

#import "SBUser.h"

@interface SBUserManager ()

@end

@implementation SBUserManager


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

- (NSArray *)evUsers{

    return [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBUser class])];
}

- (NSArray *)efUsersBeforeTime:(NSTimeInterval)timeInterval{

    return [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBUser class]) condition:fmts(@"time < %f", timeInterval)];
}

#pragma mark - public

- (SBUser*)efInsertUser;{

    return [SBUser createObject];
}

- (BOOL)efRemoveUser:(SBUser*)user;{

    NSAssert(user, @"Can not add nil of %@",[SBUser class]);

    NSArray *etBills = [[SBBillManager sharedInstance] efBillsInRange:NSMakeRange(0, 0) user:[user id] billType:SBBillTypeInput|SBBillTypeOutput];
    if([[SBCoreDataManager sharedInstance] deleteWithObjects:etBills]) {

        return [[SBCoreDataManager sharedInstance] deleteWithObject:user];
    }
    return NO;
}

- (SBUser*)efUserById:(NSString*)userId;{

    NSAssert(userId, @"userId can not be nil");

    return [[[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBUser class]) condition:fmts(@"id=%@", userId)] lastObject];
}

- (void)efRemoveAllUser;{

    NSArray *objects = [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBUser class])];

    for (NSManagedObject* object in objects) {

        [[SBCoreDataManager sharedInstance] deleteWithObject:object];
    }
}

- (SBUser*)efManager;{

    return [[[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBUser class]) condition:@"isManager=1"] lastObject];
}

@end
