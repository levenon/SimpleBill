//
//  SBConstants.h
//  SimpleBill
//
//  Created by Marike Jave on 15/4/7.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBStringConstants.h"
#import "SBUIConstants.h"
#import "SBColorConstants.h"
#import "SBFontConstants.h"
#import "SBEnumConstants.h"

extern NSString * const egAppId;

// Appkey

extern NSString * const egUMengAppKey;
extern NSString * const egUMengAppSecret;

//extern NSString * const egShareSDKAppKey;
//extern NSString * const egShareSDKAppSecret;

extern NSString * const egRedirectUrl;

extern NSString * const egWechatAppKey;
extern NSString * const egWechatAppSecret;

extern NSString * const egSinaAppKey;
extern NSString * const egSinaSecretKey;

extern NSString * const egTencentWeiboAppKey;
extern NSString * const egTencentWeiboSecretKey;

extern NSString * const egQQZoneAppId;
extern NSString * const egQQZoneAppKey;

extern NSString * const egQQAppId;
extern NSString * const egQQAppKey;

extern NSString * const egRenrenAppId;
extern NSString * const egRenrenAppKey;
extern NSString * const egRenrenAppSecret;

extern NSString * const egDoubanAppKey;
extern NSString * const egDoubanAppSecret;

//extern NSString * const egFacebookAppKey;
//extern NSString * const egFacebookAppSecret;

extern NSString * const egYiXinAppKey;
extern NSString * const egYiXinAppSecret;

//extern NSString * const egLaiWangAppKey;
//extern NSString * const egLaiWangAppSecret;

#define egItunesAppUrl          [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", egAppId]
#define egAppDownloadUrl        @"http://114.215.96.34/simplebill/download.html"
#define egAppShareTitle         NSLocalizedString(@"label.application.description", @"Simple Bill - The most simple bill application in the history!")


