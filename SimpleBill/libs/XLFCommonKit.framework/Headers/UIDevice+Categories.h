//
//  UIDevice+Categories.h
//  XLFCommonKit
//
//  Created by Marike Jave on 14-10-27.
//  Copyright (c) 2014年 Marike Jave. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  根据设备类型 返回相应的值
 *  全拼  select by device model
 */
#define sbdm(deviceModelType,vIphone4,vIphone5,vIphone6,vIphone6p)    \
        deviceModelType & UIDeviceModelPhone4All ? vIphone4 : ( deviceModelType & UIDeviceModelPhone5All ? vIphone5 : ( deviceModelType & UIDeviceModelPhone6 ? vIphone6 : vIphone6p ) )

/**
 *  是否iPhone6 plus
 */
#define IS_iPhone6p                                          [[[UIDevice deviceModel] lowercaseString]  hasPrefix:@"iphone6p"]

/**
 *  是否iPhone6
 */
#define IS_iPhone6                                          [[[UIDevice deviceModel] lowercaseString]  hasPrefix:@"iphone6"]

/**
 *  是否iPhone5
 */
//#define IS_iPhone5                                          ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,    1136),[[UIScreen mainScreen] currentMode].size) : NO)
#define IS_iPhone5                                          (([UIDevice deviceModelType]&UIDeviceModelPhone5All)&&YES)
/**
 *  是否iPhone4
 */
#define IS_iPhone4                                          [[[UIDevice deviceModel] lowercaseString]  hasPrefix:@"iphone4"]

/**
 *  是否iPod
 */
#define IS_IPOD                                             [[[UIDevice deviceModel] lowercaseString]  hasPrefix:@"ipod"]
typedef NS_ENUM(int64_t, UIDeviceModel){
    
    UIDeviceModelUnknown        = 0,

    UIDeviceModelSimulator      = 1<<0,
    
    UIDeviceModelPhone          = 1<<1,
    UIDeviceModelPhone1G        = 1<<2,
    UIDeviceModelPhone3G        = 1<<3,
    UIDeviceModelPhone3GS       = 1<<4,

    UIDeviceModelPhone4         = 1<<5,
    UIDeviceModelPhone4S        = 1<<6,
    UIDeviceModelPhone4All      = UIDeviceModelPhone4 | UIDeviceModelPhone4S,
    
    UIDeviceModelPhone5         = 1<<7,
    UIDeviceModelPhone5C        = 1<<8,
    UIDeviceModelPhone5S        = 1<<9,
    UIDeviceModelPhone5All      = UIDeviceModelPhone5 | UIDeviceModelPhone5C | UIDeviceModelPhone5S,
    
    UIDeviceModelPhone6         = 1<<10,
    UIDeviceModelPhone6Plus     = 1<<11,

    UIDeviceModelPod            = 1<<12,
    UIDeviceModelPod1           = 1<<13,
    UIDeviceModelPod2           = 1<<14,
    UIDeviceModelPod3           = 1<<15,
    UIDeviceModelPod4           = 1<<16,
    UIDeviceModelPod5           = 1<<17,

    UIDeviceModelPad            = 1<<18,
    UIDeviceModelPad3G          = 1<<19,
    UIDeviceModelPadWifi        = 1<<20,
    UIDeviceModelPad2           = 1<<21,
    UIDeviceModelPadMini1G      = 1<<22,
    UIDeviceModelPad3           = 1<<23,
    UIDeviceModelPad4           = 1<<24,
    UIDeviceModelPadAir         = 1<<25,
    UIDeviceModelPadAirMiniRetina=1<<26,
    UIDeviceModelPadAir2        = 1<<27,
    UIDeviceModelPadPro         = 1<<28,

    UIDeviceModelWatch          = 1<<29,
};

@interface UIDevice(Categories)

/**
 *  获取设备标识号
 *  @return 设备标识号
 */
+(NSString *)deviceIdentifier;
/**
 *  获取设备用户名
 *  @return 设备用户名
 */
+(NSString *)deviceName;
/**
 *  获取设备类别
 *
 *  @return 设备类别
 */
+(NSString *)deviceModel;
/**
 *  获取设备类型
 *
 *  @return 设备类型
 */
+(UIDeviceModel)deviceModelType;
/**
 *  获取设备类别版本
 *
 *  @return 设备类别版本
 */
+(NSString *)deviceLocalizedModel;
/**
 *  获取设备操作系统名称
 *
 *  @return 设备操作系统名称
 */
+(NSString *)deviceSystemName;
/**
 *  获取设备操作系统版本
 *
 *  @return 获取设备操作系统版本
 */
+(NSString *)deviceSystemVersion;

@end
