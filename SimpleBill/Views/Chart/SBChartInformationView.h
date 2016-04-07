//
//  SBChartInformationView.h
//  SimpleBill
//
//  Created by Terry Worona on 11/11/13.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SBChartInformationViewLayout){
	SBChartInformationViewLayoutHorizontal, // default
    SBChartInformationViewLayoutVertical
};

@interface SBChartInformationView : UIView

/*
 * View must be initialized with a layout type (default = horizontal)
 */
- (id)initWithFrame:(CGRect)frame layout:(SBChartInformationViewLayout)layout;

@property (nonatomic, assign, readonly) SBChartInformationViewLayout layout; // read-only (must be set in init..)

// Content
- (void)setTitleText:(NSString *)titleText;
- (void)setValueText:(NSString *)valueText unitText:(NSString *)unitText;
- (void)setSubValueText:(NSString *)subValueText;

// Color
- (void)setTitleTextColor:(UIColor *)titleTextColor;
- (void)setValueAndUnitTextColor:(UIColor *)valueAndUnitColor;
- (void)setSubValueTextColor:(UIColor *)subValueTextColor;
- (void)setTextShadowColor:(UIColor *)shadowColor;
- (void)setSeparatorColor:(UIColor *)separatorColor;

// Visibility
- (void)setHidden:(BOOL)hidden animated:(BOOL)animated;

@end
