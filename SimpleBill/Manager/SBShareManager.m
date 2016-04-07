//
//  GPShareManager.m
//  Gemini
//
//  Created by Marike Jave on 14-11-20.
//  Copyright (c) 2014年 Marike Jave. All rights reserved.
//

#import <XLFBaseViewControllerKit/XLFBaseViewControllerKit.h>
#import <XLFCommonKit/XLFCommonKit.h>

#import "UMSocial.h"
#import "UMSocialSnsService.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialYiXinHandler.h"
//#import "UMSocialTwitterHandler.h"
//#import "UMSocialFacebookHandler.h"

#import "SBShareManager.h"

#import "SBConstants.h"

@interface SBShareManager ()<UMSocialUIDelegate>

@end

@implementation SBShareManager

+ (SBShareManager *)sharedInstance;{

    static SBShareManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    
        instance = [[SBShareManager alloc] init];
    });
    return instance;
}

- (void)efConfigShareManager{

#ifdef DEBUG
    [UMSocialData openLog:YES];
#endif

    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:egUMengAppKey];

    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:egWechatAppKey appSecret:egWechatAppSecret url:egItunesAppUrl];
    //打开新浪微博的SSO开关
    [UMSocialSinaHandler openSSOWithRedirectURL:nil];

    [UMSocialQQHandler setQQWithAppId:egQQAppId appKey:egQQAppKey url:egItunesAppUrl];
    
    [UMSocialYixinHandler setYixinAppKey:egYiXinAppKey url:egItunesAppUrl];
//    [UMSocialLaiwangHandler setLaiwangAppId:egLaiWangAppKey appSecret:egLaiWangAppSecret appDescription:egAppShareTitle urlStirng:@"itms-apps://itunes.apple.com/app/id987210599"];

//    [UMSocialFacebookHandler setFacebookAppID:egFacebookAppKey shareFacebookWithURL:egItunesAppUrl];

//    [UMSocialTwitterHandler openTwitter];

    [UMSocialData defaultData].extConfig.wechatSessionData.url = egItunesAppUrl;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = egAppShareTitle;
    [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeApp;
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;

    [UMSocialData defaultData].extConfig.wechatTimelineData.url = egAppDownloadUrl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = egAppShareTitle;
    [UMSocialData defaultData].extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeApp;

    [UMSocialData defaultData].extConfig.qqData.url = egAppDownloadUrl;
    [UMSocialData defaultData].extConfig.qqData.title = egAppShareTitle;
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;

    [UMSocialData defaultData].extConfig.qzoneData.url = egAppDownloadUrl;
    [UMSocialData defaultData].extConfig.qzoneData.title =  egAppShareTitle;
    
    [UMSocialData defaultData].extConfig.tencentData.title = egAppShareTitle;

    [UMSocialData defaultData].extConfig.emailData.title = egAppShareTitle;
    [UMSocialData defaultData].extConfig.facebookData.title = egAppShareTitle;
    [UMSocialData defaultData].extConfig.facebookData.url = egItunesAppUrl;

    [UMSocialData defaultData].extConfig.yxsessionData.yxMessageType = UMSocialYXMessageTypeApp;
    [UMSocialData defaultData].extConfig.yxsessionData.url = egItunesAppUrl;

    [UMSocialData defaultData].extConfig.yxtimelineData.yxMessageType = UMSocialYXMessageTypeApp;
    [UMSocialData defaultData].extConfig.yxtimelineData.url = egItunesAppUrl;

    [UMSocialData defaultData].extConfig.lwsessionData.url = egItunesAppUrl;
    [UMSocialData defaultData].extConfig.lwtimelineData.url = egItunesAppUrl;

    [UMSocialData defaultData].extConfig.title = egAppShareTitle;
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
}

+ (void)efShareInfo:(SBShareInfo *)shareInfo{

    [[self sharedInstance] efShareInfo:shareInfo];
}

- (void)efShareInfo:(SBShareInfo *)shareInfo{

    [UMSocialSnsService presentSnsIconSheetView:[self evVisibleViewController]
                                         appKey:egUMengAppKey
                                      shareText:[shareInfo des]
                                     shareImage:[shareInfo img]
                                shareToSnsNames:@[UMShareToEmail,UMShareToSms,UMShareToDouban,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSina,UMShareToTencent,UMShareToYXSession,UMShareToYXTimeline]
                                       delegate:self];
}

+ (BOOL)efHandleOpenURL:(NSURL *)url;{

    return  [UMSocialSnsService handleOpenURL:url];
}

#pragma mark - UMSocialUIDelegate

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response;{

}

@end
