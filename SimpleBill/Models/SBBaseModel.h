//
//  SBBaseModel.h
//  SimpleBill
//
//  Created by Marike Jave on 15/4/7.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import <XLFBaseModelKit/XLFBaseModelKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SBBaseModel : NSManagedObject

+ (instancetype)new;
+ (instancetype)createObject;

@property(nonatomic, copy  ) NSString* id;
@property(nonatomic, assign) NSNumber* time;    // 创建时间

@end
