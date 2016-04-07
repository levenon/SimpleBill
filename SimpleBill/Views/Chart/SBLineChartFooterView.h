//
//  SBLineChartFooterView.h
//  SimpleBill
//
//  Created by Terry Worona on 11/8/13.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBLineChartFooterView : UIView

@property (nonatomic, strong) UIColor *footerSeparatorColor; // footer separator (default = white)
@property (nonatomic, assign) NSInteger sectionCount; // # of notches (default = 2 on each edge)
@property (nonatomic, readonly) UILabel *leftLabel;
@property (nonatomic, readonly) UILabel *rightLabel;

@end
