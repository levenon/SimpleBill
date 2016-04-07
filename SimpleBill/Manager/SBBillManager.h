//
//  SBBillManager.h
//  SimpleBill
//
//  Created by Marike Jave on 15/4/7.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBBill.h"

@class SBUserBill;
@class SBMonthBill;
@class SBUserMonthBill;

extern NSString *const kBillDidChangedNotification;

@interface SBBillManager : NSObject

@property (nonatomic, strong, readonly) NSArray *evBills;

@property (nonatomic, strong, readonly) NSArray *evMonthOutputs;    // 每月消费统计

@property (nonatomic, strong, readonly) IBOutletCollection(SBUserMonthBill) NSArray *evUserOutputs;     // 每人每月消费统计

@property (nonatomic, assign, readonly) CGFloat evCurrentMonthUserAverage;

@property (nonatomic, assign, readonly) CGFloat evLastMonthUserAverage;

@property (nonatomic, assign, readonly) CGFloat evLastLastMonthUserAverage;

@property (nonatomic, strong, readonly) NSArray *evCurrentMonthBills;

@property (nonatomic, strong, readonly) SBUserBill *evHighestExpendUserBill;

@property (nonatomic, strong, readonly) SBUserBill *evMostPoorUserBill;

@property (nonatomic, strong, readonly) SBMonthBill *evCurrentMonthInput;

@property (nonatomic, strong, readonly) SBMonthBill *evCurrentMonthOutput;

+ (id)sharedInstance;

- (SBBill*)efInsertBill;
- (BOOL)efRemoveBill:(SBBill*)bill;

- (void)efRemoveAllBill;

- (BOOL)efExistBillById:(NSString*)billId;

- (SBMonthBill *)efMonthBillAtYear:(NSInteger)year month:(NSInteger)month userId:(NSString*)userId billType:(SBBillType)billType;

- (NSArray*)efBillsAtYear:(NSInteger)year month:(NSInteger)month userId:(NSString*)userId billType:(SBBillType)billType;
- (NSArray *)efBillsInRange:(NSRange)range user:(NSString*)userId billType:(SBBillType)billType;


@end

@interface NSDateComponents (copy)
- (void)clone:(NSDateComponents*)dateComponents;
- (void)monthOffset:(NSInteger)month;
+ (NSDateComponents*)nowDateComponents:(NSCalendarUnit)unitFlags;
+ (NSDateComponents*)components:(NSCalendarUnit)unitFlags fromDate:(NSDate*)date;
@end


@interface NSDate (DateComponents)
+ (NSTimeInterval)timeIntervalFromDateComponents:(NSDateComponents*)dateComponents;
@end