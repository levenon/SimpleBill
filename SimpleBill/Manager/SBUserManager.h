//
//  SBUserManager.h
//  SimpleBill
//
//  Created by Marike Jave on 15/4/7.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

@class SBUser;

@interface SBUserManager : NSObject

@property (nonatomic, strong, readonly) NSArray *evUsers;

- (NSArray *)efUsersBeforeTime:(NSTimeInterval)timeInterval;

+ (id)sharedInstance;

- (SBUser*)efInsertUser;
- (BOOL)efRemoveUser:(SBUser*)user;
- (SBUser*)efUserById:(NSString*)userId;

- (void)efRemoveAllUser;

- (SBUser*)efManager;

@end
