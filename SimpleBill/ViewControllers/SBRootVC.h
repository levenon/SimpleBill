//
//  SBRootVC
//  SimpleBill
//
//  Created by Marike Jave on 15/4/4.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBBaseModalViewController.h"

@protocol SBRootVCDelegate <NSObject>

- (BOOL)epEnableScrollAtLocation:(CGPoint)location;

@end

@interface SBRootVC : SBBaseModalViewController


@end

