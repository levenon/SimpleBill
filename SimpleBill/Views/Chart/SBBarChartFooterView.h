//
//  SBBarChartFooterView.h
//  SimpleBill
//
//  Created by Marike Jave on 15/4/7.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBBarChartFooterView : UIView

@property (nonatomic, strong) UIColor *footerBackgroundColor; // footer background (default = black)
@property (nonatomic, assign) CGFloat padding; // label left & right padding (default = 4.0)
@property (nonatomic, readonly) UILabel *leftLabel;
@property (nonatomic, readonly) UILabel *rightLabel;

@end
