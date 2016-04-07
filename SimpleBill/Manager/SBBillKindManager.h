//
//  SBBillKindManager.h
//  SimpleBill
//
//  Created by Marike Jave on 15/4/7.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBBillKind.h"

@interface SBBillKindManager : NSObject

//@property(nonatomic, strong, readonly) NSArray *evDefaultBillKinds; // 默认的账单类型

@property(nonatomic, strong, readonly) NSArray *evBillKinds; // 所有的账单类型

+ (id)sharedInstance;

- (SBBillKind*)efInsertBillKind;
- (BOOL)efRemoveBillKind:(SBBillKind*)billKind;
- (SBBillKind*)efBillKindById:(NSString*)billKindId;

- (void)efRemoveAllBillKind;

@end
