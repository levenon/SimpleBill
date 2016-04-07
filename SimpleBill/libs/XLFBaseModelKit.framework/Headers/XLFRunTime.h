//
//  RunTime.h
//  Test
//
//  Created by ZhuJianyin on 14-3-31.
//  Copyright (c) 2014年 com.zjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XLFBaseModelInterface;

@interface RunTime : NSObject

+(NSArray *)getIvarList:(Class)instance;
+(NSArray *)getIvarNameList:(Class)instance;
+(NSArray *)getAllIvarNameList:(Class<XLFBaseModelInterface>)instance; // 包括父类成员变量
+(NSArray *)getAllIvarList:(Class<XLFBaseModelInterface>)instance;     // 包括父类成员变量
+(id)getIvarValue:(id<XLFBaseModelInterface>)instance ivarName:(NSString *)ivarName;
+(void)setIvarValue:(id<XLFBaseModelInterface>)instance ivarName:(NSString *)ivarName value:(id)value;
+(NSString *)getIvarType:(id<XLFBaseModelInterface>)instance ivarName:(NSString *)ivarName;

+(NSInteger)sizeOfObject:(id)object;
+(NSData *)archivedDataWithRootObject:(id)object;

+(id)initWithCoder:(NSCoder *)aDecoder withInstance:(id<XLFBaseModelInterface>)instance;
+(void)encodeWithCoder:(NSCoder *)aCoder withInstance:(id<XLFBaseModelInterface>)instance;
+(void)setAttributes:(NSDictionary*)attributes withInstance:(id<XLFBaseModelInterface>)instance;
+(NSDictionary *)attributeWithInstance:(id<XLFBaseModelInterface>)instance;

+ (void)removeObjectForKey:(NSString*)aKey withInstance:(id<XLFBaseModelInterface>)instance;
+ (void)setObject:(id)anObject forKey:(NSString*)aKey withInstance:(id<XLFBaseModelInterface>)instance;
+ (id)objectForKey:(NSString*)aKey withInstance:(id<XLFBaseModelInterface>)instance;

@end
