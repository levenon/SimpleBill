//
//  XLFTextInputLimitManager.h
//  XLFCommonKit
//
//  Created by Marike Jave on 14-1-22.
//  Copyright (c) 2014年 Marike Jave. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, XLFTextLimitType) {

    XLFTextLimitTypeNone,  // 无限制
    XLFTextLimitTypeByte,  // 字节数限制
    XLFTextLimitTypeLength,    // 字符个数限制
};

extern NSString *const XLFKeyboardDidReturnNotifacation;

@protocol XLFTextInput <UITextInput>

@property(nonatomic, copy) NSString *text;

@property (nonatomic, assign) XLFTextLimitType textLimitType;      // Default is TextLimitTypeNone.
@property (nonatomic, assign) NSInteger textLimitSize;          // If textLimitType is not TextLimitTypeNone, default is NSIntegerMax, or is 0.

@end

@interface XLFTextInputLimitManager : NSObject

@property (nonatomic, strong) id delegate;

@property (nonatomic, assign) id<XLFTextInput> textInput;

@end
