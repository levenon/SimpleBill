//
//  SBSettingVC.h
//  SimpleBill
//
//  Created by Marike Jave on 15/4/12.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBBaseModalViewController.h"

@protocol SBSelectorInterface <NSObject>

@property(nonatomic, assign) BOOL evEditEnable;

@end

@interface SBSettingVC : SBBaseModalViewController

@end
