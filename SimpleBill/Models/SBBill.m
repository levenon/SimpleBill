//
//  SBBill.m
//  SimpleBill
//
//  Created by Marike Jave on 15/4/7.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBBill.h"
#import "SBBillKindManager.h"
#import "SBPayWayManager.h"
#import "SBUserManager.h"

@interface SBBill ()

@end

@implementation SBBill

@dynamic billKind;
@dynamic payWay;
@dynamic user;
@dynamic type;
@dynamic mark;
@dynamic price;
@dynamic lock;

//@synthesize billKindId;
//@synthesize payWayId;
//@synthesize userId;

//- (NSString*)label
//{
//    [self willAccessValueForKey:@"label"];
//    id value = [self primitiveValueForKey:@"label"];
//    [self didAccessValueForKey:@"label"];
//    return value;
//}
//
//- (void)setLabel:(NSString *)label{
//
//    [self willChangeValueForKey:@"label"];
//    [self setPrimitiveValue:label forKey:@"label"];
//    [self didChangeValueForKey:@"label"];
//}
//
//- (NSNumber*)price{
//
//    [self willAccessValueForKey:@"price"];
//    id value = [self primitiveValueForKey:@"price"];
//    [self didAccessValueForKey:@"price"];
//    return value;
//}
//
//- (void)setPrice:(NSNumber*)price{
//
//    [self willChangeValueForKey:@"price"];
//    [self setPrimitiveValue:price forKey:@"price"];
//    [self didChangeValueForKey:@"price"];
//}
//
//- (NSNumber*)type{
//
//    [self willAccessValueForKey:@"type"];
//    id value = [self primitiveValueForKey:@"type"];
//    [self didAccessValueForKey:@"type"];
//    return value;
//}
//
//- (void)setType:(NSNumber*)type{
//
//    [self willChangeValueForKey:@"type"];
//    [self setPrimitiveValue:type forKey:@"type"];
//    [self didChangeValueForKey:@"type"];
//}
//
//- (SBBillKind *)billKind{
//
//    [self willAccessValueForKey:@"billKind"];
//    id value = [self primitiveValueForKey:@"billKind"];
//    [self didAccessValueForKey:@"billKind"];
//
//    return value;
//}
//
//- (void)setBillKind:(SBBillKind *)billKind{
//
//    [self willChangeValueForKey:@"billKind"];
//    [self setPrimitiveValue:billKind forKey:@"billKind"];
//    [self didChangeValueForKey:@"billKind"];
//}
//
//- (SBPayWay *)payWay{
//
//    [self willAccessValueForKey:@"payWay"];
//    id value = [self primitiveValueForKey:@"payWay"];
//    [self didAccessValueForKey:@"payWay"];
//
//    return value;
//}
//
//- (void)setPayWay:(SBPayWay *)payWay{
//
//    [self willChangeValueForKey:@"payWay"];
//    [self setPrimitiveValue:payWay forKey:@"payWay"];
//    [self didChangeValueForKey:@"payWay"];
//}
//
//- (SBUser *)user{
//
//    [self willAccessValueForKey:@"user"];
//    id value = [self primitiveValueForKey:@"user"];
//    [self didAccessValueForKey:@"user"];
//
//    return value;
//}
//
//- (void)setUser:(SBUser *)user{
//
//    [self willChangeValueForKey:@"user"];
//    [self setPrimitiveValue:user forKey:@"user"];
//    [self didChangeValueForKey:@"user"];
//}

+ (NSString*)stringByType:(SBBillType)type{

    switch (type) {
        case SBBillTypeInput:
            return NSLocalizedString(@"label.income", @"Income");
            break;

        case SBBillTypeOutput:
            return NSLocalizedString(@"label.expend", @"Expend");
            break;
            
        default:
            return NSLocalizedString(@"label.unknwon", @"Unknown");
            break;
    }
}

@end
