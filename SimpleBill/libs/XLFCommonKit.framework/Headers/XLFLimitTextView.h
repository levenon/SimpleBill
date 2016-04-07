//
//  XLFLimitTextView.h
//  XLFCommonKit
//
//  Created by Marike Jave on 14-1-22.
//  Copyright (c) 2014年 Marike Jave. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "XLFTextInputLimitManager.h"

@interface XLFLimitTextView : UITextView<XLFTextInput>

@property (nonatomic, assign) XLFTextLimitType textLimitType;      // Default is TextLimitTypeNone.
@property (nonatomic, assign) NSInteger textLimitSize;          // If textLimitType is not TextLimitTypeNone, default is NSIntegerMax, or is 0.

@end
