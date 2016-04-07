//
//  SBBaseModel.m
//  SimpleBill
//
//  Created by Marike Jave on 15/4/7.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBBaseModel.h"
#import "SBCoreDataManager.h"

@implementation SBBaseModel

@dynamic id;
@dynamic time;

+ (Class)superEndClass;{
    return [SBBaseModel class];
}

+ (instancetype)new;{

    return [self createObject];
}

+ (instancetype)createObject;{

    SBBaseModel *obj = [[SBCoreDataManager sharedInstance] createObjectWithTable:NSStringFromClass([self class])];

    [obj setId:[[NSUUID UUID] UUIDString]];
    [obj setTime:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]];

    return obj;
}

- (BOOL)isEqual:(id)object{
    BOOL state = [super isEqual:object];
    if (!state) {

        state = [object isKindOfClass:[self class]] && [[object id] isEqualToString:[self id]];
    }
    return state;
}

- (id)initWithAttributes:(NSDictionary *)attributes;{

    self = [self init];
    if (self) {

        NSArray *etSelectorNames = [RunTime getAllIvarNameList:[self class]];

        for (NSString *etSelectorName in etSelectorNames) {

            if ([attributes objectForKey:attributes]) {

                NSString *etPrefix = [[etSelectorName substringToIndex:1] uppercaseString];
                NSString *etSuffix = [etSelectorName substringFromIndex:1];

                SEL etSetter = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:",etPrefix, etSuffix]);

                if ([self respondsToSelector:etSetter]) {

                    [self performSelector:etSetter withObject:[attributes objectForKey:attributes]];
                }
            }
        }
    }
    return self;
}
//
//- (NSString*)id
//{
//    [self willAccessValueForKey:@"id"];
//    id value = [self primitiveValueForKey:@"id"];
//    [self didAccessValueForKey:@"id"];
//    return value;
//}
//
//- (void)setId:(NSString*)id
//{
//    [self willChangeValueForKey:@"id"];
//    [self setPrimitiveValue:id forKey:@"id"];
//    [self didChangeValueForKey:@"id"];
//}
//
//- (NSNumber*)time
//{
//    [self willAccessValueForKey:@"time"];
//    id value = [self primitiveValueForKey:@"time"];
//    [self didAccessValueForKey:@"time"];
//    return value;
//}
//
//- (void)setTime:(NSNumber*)time
//{
//    [self willChangeValueForKey:@"time"];
//    [self setPrimitiveValue:time forKey:@"time"];
//    [self didChangeValueForKey:@"time"];
//}

@end
