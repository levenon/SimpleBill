//
//  SBBillManager.m
//  SimpleBill
//
//  Created by Marike Jave on 15/4/7.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import <XLFCommonKit/XLFCommonKit.h>
#import <XLFBaseViewControllerKit/XLFBaseViewControllerKit.h>

#import "SBBillManager.h"

#import "SBUserManager.h"

#import "SBCoreDataManager.h"

#import "SBMonthBill.h"

#import "SBUserMonthBill.h"
#import "SBUserBill.h"

NSString *const kBillDidChangedNotification = @"kBillDidChangedNotification";

@interface SBBillManager ()

@end

@implementation SBBillManager

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

- (instancetype)init{
    self = [super init];
    if (self) {

//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didNotificationActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

#pragma mark - public

- (NSArray *)evBills{

    return [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class]) condition:nil sortByKey:@"time" ascending:YES];
}

- (NSArray *)evCurrentMonthBills{

    NSDateComponents *etDateComponents = [NSDateComponents nowDateComponents:NSCalendarUnitYear|NSCalendarUnitMonth];
    NSTimeInterval etFrom = [NSDate timeIntervalFromDateComponents:etDateComponents];

    [etDateComponents setMonth:[etDateComponents month] + 1];

    NSTimeInterval etTo = [NSDate timeIntervalFromDateComponents:etDateComponents];

    NSString *etCondition = [self _efTimeBillConditionInRange:NSMakeRange(etFrom, etTo-etFrom)];

    return [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class]) condition:etCondition];
}

- (SBUserBill *)evHighestExpendUserBill{

    NSString *etCondition = [self _efBillsConditionToNow:1 userId:nil billType:SBBillTypeOutput];
    NSArray *etBills = [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class]) condition:etCondition];

    NSMutableArray *etUserBills = [NSMutableArray array];

    for (SBBill *etBill in etBills) {

        SBUserBill *etUserBill = [SBUserBill new];
        [etUserBill setUser:[etBill user]];

        if (![etUserBills containsObject:etUserBill]) {
            [etUserBills addObject:etUserBill];
        }
        etUserBill = [etUserBills objectAtIndex:[etUserBills indexOfObject:etUserBill]];

        [etUserBill setPrice:[[etBill price] floatValue] + [etUserBill price]];
    }

    SBUserBill *etUserBillResult = nil;
    for (SBUserBill *etUserBill in etUserBills) {

        if ([etUserBill price] > [etUserBillResult price]) {
            etUserBillResult = etUserBill;
        }
    }

    return etUserBillResult;
}

- (SBUserBill *)evMostPoorUserBill{

    NSString *etCondition = [self _efBillsConditionToNow:1 userId:nil billType:SBBillTypeOutput];
    NSArray *etBills = [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class]) condition:etCondition];

    NSMutableArray *etUserBills = [NSMutableArray array];

    for (SBBill *etBill in etBills) {

        SBUserBill *etUserBill = [SBUserBill new];
        [etUserBill setUser:[etBill user]];

        if (![etUserBills containsObject:etUserBill]) {
            [etUserBills addObject:etUserBill];
        }
        etUserBill = [etUserBills objectAtIndex:[etUserBills indexOfObject:etUserBill]];

        [etUserBill setPrice:[[etBill price] floatValue] + [etUserBill price]];
    }

    SBUserBill *etUserBillResult = nil;

    for (SBUserBill *etUserBill in etUserBills) {

        if (!etUserBillResult) {
            etUserBillResult = etUserBill;
        }
        if ([etUserBill price] < [etUserBillResult price]) {
            etUserBillResult = etUserBill;
        }
    }

    return etUserBillResult;
}

- (SBMonthBill*)evCurrentMonthInput{

    NSString *etLastMonthCondition = [self _efBillsConditionToNow:-1 userId:nil billType:SBBillTypeInput];
    NSString *etCurrentMonthCondition = [self _efBillsConditionToNow:1 userId:nil billType:SBBillTypeInput];

    NSArray *etLastMonthBills = [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class]) condition:etLastMonthCondition];
    NSArray *etCurrentMonthBills = [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class]) condition:etCurrentMonthCondition];

    float etLastMonthInput = [[etLastMonthBills valueForKeyPath:@"@sum.price"] floatValue];
    float etCurrentMonthInput = [[etCurrentMonthBills valueForKeyPath:@"@sum.price"] floatValue];

    SBMonthBill *etMonthBill = [SBMonthBill new];

    [etMonthBill setPrice:etCurrentMonthInput];
    [etMonthBill setState:SBMonthBillState(etLastMonthInput, etCurrentMonthInput)];

    return etMonthBill;
}

- (SBMonthBill*)evCurrentMonthOutput{

    NSString *etLastMonthCondition = [self _efBillsConditionToNow:-1 userId:nil billType:SBBillTypeOutput];
    NSString *etCurrentMonthRequest = [self _efBillsConditionToNow:1 userId:nil billType:SBBillTypeOutput];

    NSArray *etLastMonthBills = [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class]) condition:etLastMonthCondition];
    NSArray *etCurrentMonthBills = [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class]) condition:etCurrentMonthRequest];

    float etLastMonthInput = [[etLastMonthBills valueForKeyPath:@"@sum.price"] floatValue];
    float etCurrentMonthInput = [[etCurrentMonthBills valueForKeyPath:@"@sum.price"] floatValue];

    SBMonthBill *etMonthBill = [SBMonthBill new];

    [etMonthBill setPrice:etCurrentMonthInput];
    [etMonthBill setState:SBMonthBillState(etLastMonthInput, etCurrentMonthInput)];

    return etMonthBill;
}

- (SBMonthBill*)efMonthBillAtYear:(NSInteger)year month:(NSInteger)month userId:(NSString*)userId billType:(SBBillType)billType;{

    NSDateComponents *etDateComponents = [[NSDateComponents alloc] init];
    [etDateComponents setYear:year];
    [etDateComponents setMonth:month];

    return [self _efMontBillToDateComponents:etDateComponents userId:userId billType:billType];
}

- (NSArray*)efBillsAtYear:(NSInteger)year month:(NSInteger)month userId:(NSString*)userId billType:(SBBillType)billType;{

    NSDateComponents *etDateComponents = [[NSDateComponents alloc] init];
    [etDateComponents setYear:year];
    [etDateComponents setMonth:month];

    NSString *etMonthCondition = [self _efBillsConditionToDateComponents:etDateComponents monthOffset:1 userId:userId billType:billType];

    return [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class]) condition:etMonthCondition];
}

- (SBBill*)efInsertBill;{

    return [SBBill createObject];
}

- (BOOL)efRemoveBill:(SBBill*)bill;{

    NSAssert(bill, @"Can not add nil of %@",[SBBill class]);

    return [[SBCoreDataManager sharedInstance] deleteWithObject:bill];
}

- (void)efRemoveAllBill;{

    NSArray *objects = [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class])];

    for (NSManagedObject* object in objects) {

        [[SBCoreDataManager sharedInstance] deleteWithObject:object];
    }
}

- (BOOL)efExistBillById:(NSString*)billId;{

    return [[[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class]) condition:fmts(@"id=%@", billId)] count] && YES;
}


- (NSArray *)evMonthOutputs{

    NSMutableArray *etMonthOutputs = [NSMutableArray array];

    // 当前年
    NSDateComponents *etDateComponents = [NSDateComponents nowDateComponents:NSCalendarUnitYear|NSCalendarUnitMonth];

    for (NSInteger nIndex = 0; nIndex < 12; nIndex++) {

        [etDateComponents setMonth:nIndex];

        // 每月订单条件
        NSString *etMonthCondition = [self _efBillsConditionToDateComponents:etDateComponents monthOffset:1 userId:nil billType:SBBillTypeOutput];

        // 每月所有订单
        NSArray *etMonthBills = [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class]) condition:etMonthCondition];

        // 每月消费总价
        NSNumber* etMonthOutput = [etMonthBills valueForKeyPath:@"@sum.price"];

        [etMonthOutputs addObject:etMonthOutput];
    }
    return etMonthOutputs;
}

- (NSArray *)evUserOutputs{

    // 当前年月
    NSDateComponents *etNowDateComponents = [NSDateComponents nowDateComponents:NSCalendarUnitYear|NSCalendarUnitMonth];

    NSMutableArray *etMonthOutputs = [NSMutableArray array];
    // 所有用户
    NSArray *etUsers = [[SBUserManager sharedInstance] evUsers];

    for (SBUser *etUser in etUsers) {

        // 用户月订单
        SBUserMonthBill *etUserMonthBill = [SBUserMonthBill new];
        [etUserMonthBill setUser:etUser];

        // 当月订单支出条件
        NSString *etCurrentMonthOutputCondition = [self _efBillsConditionToDateComponents:etNowDateComponents monthOffset:1 userId:[etUser id] billType:SBBillTypeOutput];
        // 当月订单收入条件
        NSString *etCurrentMonthInputCondition = [self _efBillsConditionToDateComponents:etNowDateComponents monthOffset:1 userId:[etUser id] billType:SBBillTypeInput|SBBillTypeOutput];

        // 上月订单支出条件
        NSString *etLastMonthOutputCondition = [self _efBillsConditionToDateComponents:etNowDateComponents monthOffset:-1 userId:[etUser id] billType:SBBillTypeOutput];
        // 上月订单收入条件
        NSString *etLastMonthInputCondition = [self _efBillsConditionToDateComponents:etNowDateComponents monthOffset:-1 userId:[etUser id] billType:SBBillTypeInput|SBBillTypeOutput];
        
        NSDateComponents *etLastDateComponents = [NSDateComponents nowDateComponents:NSCalendarUnitYear|NSCalendarUnitMonth];
        [etLastDateComponents monthOffset:-1];

        // 上上月订单支出条件
        NSString *etLastLastMonthOutputCondition = [self _efBillsConditionToDateComponents:etLastDateComponents monthOffset:-1 userId:[etUser id] billType:SBBillTypeOutput];
        // 上上月订单收入条件
        NSString *etLastLastMonthInputCondition = [self _efBillsConditionToDateComponents:etLastDateComponents monthOffset:-1 userId:[etUser id] billType:SBBillTypeInput|SBBillTypeOutput];

        // 当月所有支出订单
        NSArray *etCurrentMonthOutputBills = [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class]) condition:etCurrentMonthOutputCondition];
        // 当月所有收入订单
        NSArray *etCurrentMonthInputBills = [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class]) condition:etCurrentMonthInputCondition];

        // 上月所有支出订单
        NSArray *etLastMonthOutputBills = [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class]) condition:etLastMonthOutputCondition];
        // 上月所有收入订单
        NSArray *etLastMonthInputBills = [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class]) condition:etLastMonthInputCondition];
        
        // 上上月所有支出订单
        NSArray *etLastLastMonthOutputBills = [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class]) condition:etLastLastMonthOutputCondition];
        // 上上月所有收入订单
        NSArray *etLastLastMonthInputBills = [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class]) condition:etLastLastMonthInputCondition];

        // 当月消费总额
        NSNumber* etCurrentMonthOutput = [etCurrentMonthOutputBills valueForKeyPath:@"@sum.price"];
        // 当月收入总额
        NSNumber* etCurrentMonthInput = [etCurrentMonthInputBills valueForKeyPath:@"@sum.price"];
        // 上月消费总额
        NSNumber* etLastMonthOutput = [etLastMonthOutputBills valueForKeyPath:@"@sum.price"];
        // 上月收入总额
        NSNumber* etLastMonthInput = [etLastMonthInputBills valueForKeyPath:@"@sum.price"];
        // 上上月消费总额
        NSNumber* etLastLastMonthOutput = [etLastLastMonthOutputBills valueForKeyPath:@"@sum.price"];
        // 上上月收入总额
        NSNumber* etLastLastMonthInput = [etLastLastMonthInputBills valueForKeyPath:@"@sum.price"];

        if ([[etUser isManager] boolValue]) {

            // 当月非管理员的全部收入
            float etCurrentMonthAllInputAsNotManager = [self _efAllInputAsNotManagerToDateComponents:etNowDateComponents monthOffset:1];

            // 上月非管理员的全部收入
            float etLastMonthAllInputAsNotManager = [self _efAllInputAsNotManagerToDateComponents:etNowDateComponents monthOffset:-1];

            [etUserMonthBill setCurrentMonthInput:[etCurrentMonthInput integerValue] - etCurrentMonthAllInputAsNotManager];
            [etUserMonthBill setLastMonthInput:[etLastMonthInput integerValue] - etLastMonthAllInputAsNotManager];
            [etUserMonthBill setLastLastMonthInput:[etLastLastMonthInput integerValue] - etLastMonthAllInputAsNotManager];
        }
        else{
            [etUserMonthBill setCurrentMonthInput:[etCurrentMonthInput integerValue]];
            [etUserMonthBill setLastMonthInput:[etLastMonthInput integerValue]];
            [etUserMonthBill setLastLastMonthInput:[etLastLastMonthInput integerValue]];
        }

        [etUserMonthBill setCurrentMonthOutput:[etCurrentMonthOutput integerValue]];
        [etUserMonthBill setLastMonthOutput:[etLastMonthOutput integerValue]];
        [etUserMonthBill setLastLastMonthOutput:[etLastLastMonthOutput integerValue]];

        [etMonthOutputs addObject:etUserMonthBill];
    }

    return etMonthOutputs;
}

- (float)_efAllInputAsNotManagerToDateComponents:(NSDateComponents*)dateComponents monthOffset:(NSInteger)monthOffset;{

    NSString *etCondition = [self _efBillsConditionToDateComponents:dateComponents monthOffset:monthOffset userId:nil billType:SBBillTypeInput];

    etCondition = [etCondition stringByAppendingString:@" AND user.isManager!=1"];

    NSArray *etInputBills = [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class]) condition:etCondition];

    return [[etInputBills valueForKeyPath:@"@sum.price"] floatValue];
}

- (NSArray *)efBillsInRange:(NSRange)range user:(NSString*)userId billType:(SBBillType)billType;{

    NSString *etCondition = [self _efTimeBillConditionInRange:range userId:userId billType:billType];

    NSArray *etBills = [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class]) condition:etCondition sortByKey:@"time" ascending:YES];
    
    return etBills;
}

- (CGFloat)evCurrentMonthUserAverage{

    NSString *etCondition = [self _efBillsConditionToNow:1 userId:nil billType:SBBillTypeOutput];

    NSArray *etCurrentMonthBills = [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class]) condition:etCondition];

    float etCurrentMonthInput = [[etCurrentMonthBills valueForKeyPath:@"@sum.price"] floatValue];

    float etAllWeight = [[[[SBUserManager sharedInstance] evUsers] valueForKeyPath:@"@sum.weight"] floatValue];

    return etCurrentMonthInput/etAllWeight;
}

- (CGFloat)evLastMonthUserAverage{

    NSString *etCondition = [self _efBillsConditionToNow:-1 userId:nil billType:SBBillTypeOutput];

    NSTimeInterval etBefore = [NSDate timeIntervalFromDateComponents:[NSDateComponents nowDateComponents:NSCalendarUnitYear|NSCalendarUnitMonth]];

    etCondition = [etCondition stringByAppendingFormat:@" AND user.time<%f", etBefore];

    NSArray *etLastMonthBills = [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class]) condition:etCondition];

    float etLastMonthInput = [[etLastMonthBills valueForKeyPath:@"@sum.price"] floatValue];

    float etAllWeight = [[[[SBUserManager sharedInstance] efUsersBeforeTime:etBefore] valueForKeyPath:@"@sum.weight"] floatValue];

    return etLastMonthInput/etAllWeight;
}

- (CGFloat)evLastLastMonthUserAverage{
    
    NSDateComponents *etDateComponents = [NSDateComponents nowDateComponents:NSCalendarUnitYear|NSCalendarUnitMonth];
    [etDateComponents setMonth:[etDateComponents month] - 1];
    
    NSString *etCondition = [self _efBillsConditionToDateComponents:etDateComponents monthOffset:-1 userId:nil billType:SBBillTypeOutput];
    
    NSTimeInterval etBefore = [NSDate timeIntervalFromDateComponents:[NSDateComponents nowDateComponents:NSCalendarUnitYear|NSCalendarUnitMonth]];
    
    etCondition = [etCondition stringByAppendingFormat:@" AND user.time<%f", etBefore];
    
    NSArray *etLastLastMonthBills = [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class]) condition:etCondition];
    
    float etLastLastMonthInput = [[etLastLastMonthBills valueForKeyPath:@"@sum.price"] floatValue];
    
    float etAllWeight = [[[[SBUserManager sharedInstance] efUsersBeforeTime:etBefore] valueForKeyPath:@"@sum.weight"] floatValue];
    
    return etLastLastMonthInput/etAllWeight;
}

#pragma mark - private

- (SBMonthBill *)_efMontBillToDateComponents:(NSDateComponents *)dateComponents userId:(NSString*)userId billType:(SBBillType)billType;{

    NSString *etLastMonthCondition = [self _efBillsConditionToDateComponents:dateComponents monthOffset:-1 userId:userId billType:billType];

    [dateComponents setMonth:[dateComponents month] + 1];
    NSString *etCurrentMonthCondition = [self _efBillsConditionToDateComponents:dateComponents monthOffset:1 userId:userId billType:billType];

    NSArray *etLastMonthBills = [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class]) condition:etLastMonthCondition];
    NSArray *etCurrentMonthBills = [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class]) condition:etCurrentMonthCondition];

    float etLastMonth = [[etLastMonthBills valueForKeyPath:@"@sum.price"] floatValue];
    float etCurrentMonth = [[etCurrentMonthBills valueForKeyPath:@"@sum.price"] floatValue];

    SBMonthBill *etMonthBill = [SBMonthBill new];

    [etMonthBill setPrice:etCurrentMonth];
    [etMonthBill setState:SBMonthBillState(etLastMonth, etCurrentMonth)];

    return etMonthBill;
}


- (NSString *)_efBillsConditionToNow:(NSInteger)monthOffset userId:(NSString*)userId billType:(SBBillType)billType;{

    NSDateComponents *etDateComponents = [NSDateComponents nowDateComponents:NSCalendarUnitYear|NSCalendarUnitMonth];

    return [self _efBillsConditionToDateComponents:etDateComponents monthOffset:monthOffset userId:userId billType:billType];
}

- (NSString *)_efBillsConditionToNow:(NSInteger)monthOffset;{

    NSAssert(monthOffset != 0, @"monthOffset can not be 0!");

    NSDateComponents *etDateComponents = [NSDateComponents nowDateComponents:NSCalendarUnitYear|NSCalendarUnitMonth];

    return [self _efBillsConditionToDateComponents:etDateComponents monthOffset:monthOffset];
}

- (NSString *)_efBillsConditionToDateComponents:(NSDateComponents *)dateComponents monthOffset:(NSInteger)monthOffset userId:(NSString*)userId billType:(SBBillType)billType;{

    NSDateComponents *etDateComponents = [[NSDateComponents alloc] init];
    [etDateComponents clone:dateComponents];

    NSTimeInterval from = [NSDate timeIntervalFromDateComponents:etDateComponents];
    [etDateComponents monthOffset:monthOffset];

    NSTimeInterval to = [NSDate timeIntervalFromDateComponents:etDateComponents];

    if (from > to) {
        from = from + to;
        to = from - to;
        from = from - to;
    }

    return [self _efTimeBillConditionInRange:NSMakeRange(from, to-from) userId:userId billType:billType];
}

- (NSString *)_efBillsConditionToDateComponents:(NSDateComponents *)dateComponents monthOffset:(NSInteger)monthOffset;{

    NSDateComponents *etDateComponents = [[NSDateComponents alloc] init];
    [etDateComponents clone:dateComponents];

    NSTimeInterval from = [NSDate timeIntervalFromDateComponents:etDateComponents];
    [etDateComponents monthOffset:monthOffset];

    NSTimeInterval to = [NSDate timeIntervalFromDateComponents:etDateComponents];

    if (from > to) {
        from = from + to;
        to = from - to;
        from = from - to;
    }

    return [self _efTimeBillConditionInRange:NSMakeRange(from, to-from)];
}

- (NSString *)_efTimeBillConditionInRange:(NSRange)range;{

    return [self _efTimeBillConditionInRange:range billType:SBBillTypeUnknown];
}

- (NSString *)_efTimeBillConditionInRange:(NSRange)range billType:(SBBillType)billType;{

    return [self _efTimeBillConditionInRange:range userId:nil billType:billType];
}

- (NSString *)_efTimeBillConditionInRange:(NSRange)range userId:(NSString*)userId billType:(SBBillType)billType;{

    NSMutableString *etCondition = [NSMutableString string];

    if (range.length) {
        [etCondition appendFormat:@" time>%lu AND time<=%lu ", range.location, NSMaxRange(range)];
    }

    if (billType != SBBillTypeUnknown && [etCondition length]) {
        [etCondition appendString:@" AND "];
    }

    if (billType & SBBillTypeInput && billType & SBBillTypeOutput) {

        if ([etCondition length]) {
            [etCondition appendFormat:@" ( type=%ld OR type=%ld )", SBBillTypeInput, SBBillTypeOutput];
        }
        else{
            [etCondition appendFormat:@" type=%ld OR type=%ld ", SBBillTypeInput, SBBillTypeOutput];
        }
    }
    else if(billType & SBBillTypeInput || billType & SBBillTypeOutput){

        [etCondition appendFormat:@" type=%ld ", billType];
    }

    if ([userId length]) {

        if ([etCondition length]) {
            [etCondition appendString:@" AND "];
        }
        [etCondition appendFormat:@" user.id='%@' ", userId];
    }

    return etCondition;
}

- (IBAction)didNotificationActive:(id)sender{

//    [self performSelectorInBackground:@selector(needsCalculateLastMonthBalance) withObject:nil];

    [self efClearUnreasonableBill];

    [self efNeedsCalculateLastMonthBalance];

    [[self evVisibleViewController] efRefresh];
}

- (void)efClearUnreasonableBill;{

    NSString *etFutureCondition = fmts(@"time>%f",[NSDate timeIntervalFromDateComponents:[NSDateComponents nowDateComponents:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitNanosecond]]);

    NSArray *etFutureBills = [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class]) condition:etFutureCondition];

    if ([etFutureBills count]) {

        for (SBBill *etBill in etFutureBills) {

            [self efRemoveBill:etBill];
            NSLog(@"删除不合理的账单:%@",etBill);
        }

        if (![[SBCoreDataManager sharedInstance] saveContext]) {
            NSLog(@"coredata 结余账单 保存失败");
        };
    }
}

- (void)efNeedsCalculateLastMonthBalance{

    NSArray *etUsers = [[SBUserManager sharedInstance] evUsers];
    for (SBUser *etUser in etUsers) {

        NSString *etCurrentMonthInputCondition = [self _efBillsConditionToNow:1 userId:[etUser id] billType:SBBillTypeInput];
        etCurrentMonthInputCondition = [etCurrentMonthInputCondition stringByAppendingString:@" AND lock=1"];

        NSArray *etCurrentMonthInputBills = [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class]) condition:etCurrentMonthInputCondition];

        if ([etCurrentMonthInputBills count]>1) {

            for (SBBill *etBill in etCurrentMonthInputBills) {

                [self efRemoveBill:etBill];
                NSLog(@"账单数据有误，上月结余账单数量大于1，清楚所有错误账单，即将生成新的结余账单");
            }

            if (![[SBCoreDataManager sharedInstance] saveContext]) {
                NSLog(@"coredata 结余账单 保存失败");
            };
        }
    }
    
    for (SBUser *etUser in etUsers) {

        NSString *etLastMonthConditionInput = [self _efBillsConditionToNow:-1
                                                                    userId:[etUser id]
                                                                  billType:SBBillTypeInput];
        NSString *etLastMonthConditionOutput = [self _efBillsConditionToNow:-1
                                                                     userId:[etUser id]
                                                                   billType:SBBillTypeOutput];

        NSArray *etLastMonthInputBills = [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class]) condition:etLastMonthConditionInput];
        NSArray *etLastMonthOutputBills = [[SBCoreDataManager sharedInstance] queryObjectsWithTable:NSStringFromClass([SBBill class]) condition:etLastMonthConditionOutput];

        float etLastMonthInput = [[etLastMonthInputBills valueForKeyPath:@"@sum.price"] floatValue];
        float etLastMonthOutput = [[etLastMonthOutputBills valueForKeyPath:@"@sum.price"] floatValue];

        if (etLastMonthInput > etLastMonthOutput) {

            // 上月有结余
            SBBill *etBill = [self efInsertBill];
            [etBill setPrice:[NSNumber numberWithFloat:etLastMonthInput - etLastMonthOutput]];
            [etBill setType:[NSNumber numberWithInteger:SBBillTypeInput]];
            [etBill setMark:NSLocalizedString(@"label.last.month.balance", @"The balance from last month")];
            [etBill setLock:@YES];
            [etBill setUser:etUser];

            if (![[SBCoreDataManager sharedInstance] saveContext]) {
                
                [self efRemoveBill:etBill];
                NSLog(@"coredata 结余账单 保存失败");
            };
        }
    }
}

@end

@implementation NSDateComponents (copy)

- (void)clone:(NSDateComponents*)dateComponents;{

    [self setCalendar:[dateComponents calendar]];
    [self setTimeZone:[dateComponents timeZone]];
    [self setEra:[dateComponents era]];
    [self setYear:[dateComponents year]];
    [self setMonth:[dateComponents month]];
    [self setDay:[dateComponents day]];
    [self setHour:[dateComponents hour]];
    [self setMinute:[dateComponents minute]];
    [self setSecond:[dateComponents second]];
    [self setNanosecond:[dateComponents nanosecond]];
    [self setWeekday:[dateComponents weekday]];
    [self setWeekdayOrdinal:[dateComponents weekdayOrdinal]];
    [self setQuarter:[dateComponents quarter]];
    [self setWeekOfMonth:[dateComponents weekOfMonth]];
    [self setWeekOfYear:[dateComponents weekOfYear]];
    [self setYearForWeekOfYear:[dateComponents yearForWeekOfYear]];
    [self setLeapMonth:[dateComponents isLeapMonth]];
}

- (void)monthOffset:(NSInteger)month;{

    NSInteger etMonth = month + [self month];

    if (etMonth <= 0 || etMonth > 12) {

        NSInteger etYearOffset = labs(etMonth) / 12;
        NSInteger etMonthOffset = labs(etMonth) % 12;

        if (etMonth<=0) {

            [self setYear:[self year] - etYearOffset - 1];
            [self setMonth:12 - etMonthOffset];
        }
        else {

            [self setYear:[self year] + etYearOffset];
            [self setMonth:etMonthOffset];
        }
    }
    else{

        [self setMonth:etMonth];
    }
}

+ (NSDateComponents*)nowDateComponents:(NSCalendarUnit)unitFlags;{

    return [self components:unitFlags fromDate:[NSDate date]]
    ;
}

+ (NSDateComponents*)components:(NSCalendarUnit)unitFlags fromDate:(NSDate*)date;{

    return [[NSCalendar currentCalendar] components:unitFlags fromDate:date];
}

@end

@implementation NSDate (DateComponents)

+ (NSTimeInterval)timeIntervalFromDateComponents:(NSDateComponents*)dateComponents;{

    return [[[NSCalendar currentCalendar] dateFromComponents:dateComponents] timeIntervalSince1970];
}

@end
