//
//  XLFSubTitleButton.h
//  XLFCommonKit
//
//  Created by Marike Jave on 14-9-29.
//  Copyright (c) 2014年 Marike Jave. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface XLFSubTitleButton : UIButton
@property(nonatomic,readonly,copy  ) NSString *evCurrentSubTitle;             // normal/highlighted/selected/disabled. can return nil
@property(nonatomic,readonly,strong) UIColor  *evCurrentSubTitleColor;        // normal/highlighted/selected/disabled. always returns non-nil. default is white(1,1)
// return title and image views. will always create them if necessary. always returns nil for system buttons
@property(nonatomic,readonly,strong) UILabel     *evSubTitleLabel ;
@property(nonatomic,readonly,strong) UIColor *evCurrentBorderColor;
@property(nonatomic,assign) CGFloat evCornerRadius;
- (void)setBorderColor:(UIColor *)borderColor forState:(UIControlState)state;
- (void)setSubTitle:(NSString *)title forState:(UIControlState)state;                     // default is nil. subtitle is assumed to be single line
- (void)setSubTitleColor:(UIColor *)color forState:(UIControlState)state; // default if nil. use opaque white
- (NSString *)subTitleForState:(UIControlState)state;          // these getters only take a single state value
- (UIColor *)subTitleColorForState:(UIControlState)state;
- (UIColor *)borderColorForState:(UIControlState)state;
- (CGRect)subTitleRectForContentRect:(CGRect)contentRect;

@end
