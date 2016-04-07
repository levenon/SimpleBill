//
//  SBShareManager
//  Gemini
//
//  Created by Marike Jave on 14-11-20.
//  Copyright (c) 2014年 Marike Jave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBShareInfo.h"

@interface SBShareManager : NSObject

+ (SBShareManager *)sharedInstance;

+ (BOOL)efHandleOpenURL:(NSURL *)url;

- (void)efConfigShareManager;

+ (void)efShareInfo:(SBShareInfo *)shareInfo;

@end