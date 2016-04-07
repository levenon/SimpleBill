//
//  NSDate+Categories
//  XLFCommonKit
//
//  Created by Marike Jave on 14-8-28.
//  Copyright (c) 2014年 Marike Jave. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Categories)

- (NSString *)normalizeDateString;

+ (NSDate *)clockDate:(NSInteger)clock;

//放回有好字符串描述
//比如  最后一天，上一周等
+ (NSString *)dateConvertToFriendlyStringWithDate:(NSDate *)date;

- (NSString *)dateConvertToFriendlyString;

+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)format;

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;

- (NSString *)dateStringWithFormat:(NSString *)format;

@end

@interface NSDate (TimeInterval)

+ (NSDateComponents *)componetsWithTimeInterval:(NSTimeInterval)timeInterval;
+ (NSString *)timeDescriptionOfTimeInterval:(NSTimeInterval)timeInterval;

@end

