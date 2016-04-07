//
//  TimePickerView.h
//  XLFCommonKit
//
//  Created by Marike Jave on 14-7-11.
//  Copyright (c) 2014年 Marike Jave. All rights reserved.
//
#import <UIKit/UIKit.h>
@protocol TimePickerSuspendDelegate <NSObject>
- (void)epDidPickTime:(NSDate*)date userInfo:(id)userInfo;
@end
@interface XLFTimePickerSuspend : NSObject
@property (assign , nonatomic) id<TimePickerSuspendDelegate> evDelegate;
@property (assign , nonatomic) id evUserInfo;
@property (assign , nonatomic, setter = show:) BOOL isShow;
+ (XLFTimePickerSuspend*)sharedInstance;
+ (void)resetDate:(NSDate*)date minDate:(NSDate*)minDate maxDate:(NSDate*)maxDate mode:(UIDatePickerMode)mode;
+ (void)showWithDelegate:(id<TimePickerSuspendDelegate>)delegate userInfo:(id)userInfo;

@end
