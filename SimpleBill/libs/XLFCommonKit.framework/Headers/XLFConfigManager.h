//
//  XLFConfigManager.h
//  XLFCommonKit
//
//  Created by Marike Jave on 14-9-4.
//  Copyright (c) 2014年 Marike Jave. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark 配置文件路径
/**
 *  省市区数据库文件路径
 */
#define SANDBOX_DATABASE_PATH                               @"region"
/**
 *  颜色配置文件路径
 */
#define SANDBOX_COLOR_PATH                                  @"colors"
/**
 *  字体配置文件路径
 */
#define SANDBOX_FONT_PATH                                   @"fonts"
/**
 *  系统配置文件路径
 */
#define SANDBOX_CONFIG_PATH                                 @"config"
/**
 *  联系我们配置文件路径
 */
#define SANDBOX_CONTACTUS_PATH                              @"contactus"

/**
 *  取颜色
 *
 *  @param key
 *
 */
#define UIColorFromKey(key)                                 [[XLFConfigManager shareConfigManager] evColorForKey:key]
/**
 *  取字体大小
 *
 *  @param key
 *
 */
#define UIFontFromKey(key)                                  [[XLFConfigManager shareConfigManager] evFontForKey:key]

@interface XLFConfigManager : NSObject{
    
}
+ (id)shareConfigManager;
//配置文件
- (NSDictionary *)getConfigDic;
//联系方式
- (NSDictionary *)getContactInfoDic;
//取色系
- (UIColor *)evColorForKey:(NSString *)key;
//取字体大小
- (UIFont *)evFontForKey:(NSString *)key;
//取广告
- (NSDictionary *)getAdvertisement;
//取菜单
- (NSDictionary *)getMenu;
//取九宫格
- (NSDictionary *)getGrid;
//取应用id－－唯一标示应用
- (NSString *)getCid;
//取内网服务器地址
- (NSString *)getDebugAppUrl;
//取外网服务器地址
- (NSString *)getReleaseAppUrl;
//取内网服务器图片地址
- (NSString *)getDebugImageUrl;
//取外网服务器图片地址
- (NSString *)getReleaseImageUrl;
//取内网聊天服务器主机
- (NSString *)getDebugServerHost;
//取内网聊天服务器端口
- (NSString *)getDebugServerPort;
//取外网聊天服务器主机
- (NSString *)getReleaseServerHost;
//取外网聊天服务器端口
- (NSString *)getReleaseServerPort;
//取app版本
- (NSString *)getAppVersion;
//取版本
- (NSString *)getAppFileVersion;
//取联系我们信息
- (NSArray *)getContactUsInfo;

- (NSString *)getImageServerHost;

@end
