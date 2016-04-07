//
//  XLFBaseGlobal.h
//  XLFCommonKit
//
//  Created by Marike Jave on 15/3/18.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum  {

    XLFNavButtonTypeLeft,
    XLFNavButtonTypeRight,

} XLFNavButtonType;

typedef void (^NavButtonClickBlock)(XLFNavButtonType navButtonType, NSInteger currentTabIndex);

#define UIViewAutoresizingFlexibleAll   (UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin)


extern UIColor* const   egfBackgroudColor();
extern UIImage* const   egfNavBackgroundImage();
extern UIImage* const   egfNavLeftBackgroundImage();
extern UIImage* const   egfNavRightBackgroundImage();
extern UIImage* const   egfNavBackIconImage();
extern NSString* const  egfNavBackTitle();
extern NSString* const  egfBackIgnoreVCClassName();

void egfRegisterGlobalBackgroundColor(UIColor* color);
void egfRegisterGlobalBackgroundImage(UIImage* image);
void egfRegisterGlobalNavBackgroundImage(UIImage* image);
void egfRegisterGlobalNavLeftBackgroundImage(UIImage* image);
void egfRegisterGlobalNavRightBackgroundImage(UIImage* image);
void egfRegisterGlobalNavBackIconImage(UIImage* image);
void egfRegisterGlobalNavBackTitle(NSString* title);
void egfRegisterGlobalBackIgnoreVCClassName(NSString* clsName);

