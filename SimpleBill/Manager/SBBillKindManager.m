//
//  SBBillKindManager.m
//  SimpleBill
//
//  Created by Marike Jave on 15/4/7.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import <XLFCommonKit/XLFCommonKit.h>
#import "SBBillKindManager.h"
#import "SBCoreDataManager.h"

@interface SBBillKindManager ()

@end

@implementation SBBillKindManager

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
//
//#pragma mark - accessory
//
//- (NSArray *)evDefaultBillKinds{
//
//    NSMutableArray *etDefaultBillKinds = [NSMutableArray array];
//
//    SBBillKind *etBillKind = [SBBillKind modelWithAttributes:@{@"id":[[NSUUID UUID] UUIDString],@"name":@"生活"}];
//    [etDefaultBillKinds addObject:etBillKind];
//
//    etBillKind = [SBBillKind modelWithAttributes:@{@"id":[[NSUUID UUID] UUIDString],@"name":@"其他"}];
//    [etDefaultBillKinds addObject:etBillKind];
//
//    etBillKind = [SBBillKind modelWithAttributes:@{@"id":[[NSUUID UUID] UUIDString],@"name":@"餐饮"}];
//    [etDefaultBillKinds addObject:etBillKind];
//
//    etBillKind = [SBBillKind modelWithAttributes:@{@"id":[[NSUUID UUID] UUIDString],@"name":@"餐具"}];
//    [etDefaultBillKinds addObject:etBillKind];
//
//    etBillKind = [SBBillKind modelWithAttributes:@{@"id":[[NSUUID UUID] UUIDString],@"name":@"米油盐酱醋"}];
//    [etDefaultBillKinds addObject:etBillKind];
//
//    etBillKind = [SBBillKind modelWithAttributes:@{@"id":[[NSUUID UUID] UUIDString],@"name":@"酒水饮料"}];
//    [etDefaultBillKinds addObject:etBillKind];
//
//    etBillKind = [SBBillKind modelWithAttributes:@{@"id":[[NSUUID UUID] UUIDString],@"name":@"缴费"}];
//    [etDefaultBillKinds addObject:etBillKind];
//
//    etBillKind = [SBBillKind modelWithAttributes:@{@"id":[[NSUUID UUID] UUIDString],@"name":@"额外支出"}];
//    [etDefaultBillKinds addObject:etBillKind];
//
//    etBillKind = [SBBillKind modelWithAttributes:@{@"id":[[NSUUID UUID] UUIDString],@"name":@"生活"}];
//    [etDefaultBillKinds addObject:etBillKind];
//
//    etBillKind = [SBBillKind modelWithAttributes:@{@"id":[[NSUUID UUID] UUIDString],@"name":@"餐饮"}];
//    [etDefaultBillKinds addObject:etBillKind];
//
//    etBillKind = [SBBillKind modelWithAttributes:@{@"id":[[NSUUID UUID] UUIDString],@"name":@"餐具"}];
//    [etDefaultBillKinds addObject:etBillKind];
//
//    etBillKind = [SBBillKind modelWithAttributes:@{@"id":[[NSUUID UUID] UUIDString],@"name":@"米油盐酱醋"}];
//    [etDefaultBillKinds addObject:etBillKind];
//
//    etBillKind = [SBBillKind modelWithAttributes:@{@"id":[[NSUUID UUID] UUIDString],@"name":@"酒水饮料"}];
//    [etDefaultBillKinds addObject:etBillKind];
//
//    etBillKind = [SBBillKind modelWithAttributes:@{@"id":[[NSUUID UUID] UUIDString],@"name":@"缴费"}];
//    [etDefaultBillKinds addObject:etBillKind];
//
//    etBillKind = [SBBillKind modelWithAttributes:@{@"id":[[NSUUID UUID] UUIDString],@"name":@"额外支出"}];
//    [etDefaultBillKinds addObject:etBillKind];
//
//    return etDefaultBillKinds;
//}

- (NSArray *)evBillKinds{

    return [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBillKind class])];
}

#pragma mark - public

- (SBBillKind*)efInsertBillKind;{

    return [SBBillKind createObject];
}

- (BOOL)efRemoveBillKind:(SBBillKind*)billKind;{

    NSAssert(billKind, @"Can not add nil of %@",[SBBillKind class]);

    return [[SBCoreDataManager sharedInstance] deleteWithObject:billKind];
}

- (SBBillKind*)efBillKindById:(NSString*)billKindId;{

    NSAssert(billKindId, @"billKindId can not be nil");

    return [[[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBillKind class]) condition:fmts(@"id=%@", billKindId)] lastObject];
}

- (void)efRemoveAllBillKind;{

    NSArray *objects = [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBillKind class])];

    for (NSManagedObject* object in objects) {

        [[SBCoreDataManager sharedInstance] deleteWithObject:object];
    }
}


@end
