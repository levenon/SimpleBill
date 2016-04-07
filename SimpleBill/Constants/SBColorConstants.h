//
//  SBColorConstants.h
//  SimpleBill
//
//  Created by Terry Worona on 11/7/13.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#define UIColorFromHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

#pragma mark - Navigation

#define kSBColorNavigationBarTint UIColorFromHex(0x000000)
#define kSBColorNavigationTint UIColorFromHex(0xFFFFFF)
#define kSBColorControllerBackground UIColorFromHex(0x313131)

#pragma mark - Bar Chart

#define kSBColorBarChartBackground UIColorFromHex(0x3c3c3c)
#define kSBColorBarChartBarYellow UIColorFromHex(0x00ff00)
#define kSBColorBarChartBarBlue UIColorFromHex(0x08bcef)
#define kSBColorBarChartBarGreen UIColorFromHex(0x34b234)
#define kSBColorBarChartHeaderSeparatorColor UIColorFromHex(0x686868)

#pragma mark - Line Char

#define kSBColorLineChartBackground UIColorFromHex(0x3c3c3c)
#define kSBColorLineChartHeader UIColorFromHex(0x08bcef)
#define kSBColorLineChartHeaderSeparatorColor UIColorFromHex(0x686868)
#define kSBColorLineChartLineColor [UIColor greenColor]
