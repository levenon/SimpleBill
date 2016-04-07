//
//  SBBaseNavigationController.m
//  SimpleBill
//
//  Created by Marike Jave on 15/4/5.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBBaseNavigationController.h"
#import "SBConstants.h"

@interface SBBaseNavigationController ()

@end

@implementation SBBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [[self navigationBar] setBarTintColor:kSBColorNavigationBarTint];
    [[self navigationBar] setTintColor:kSBColorNavigationTint];

    [[self navigationBar] setTitleTextAttributes:@{ NSForegroundColorAttributeName:  kSBColorNavigationTint,
                                                               NSFontAttributeName:  [UIFont systemFontOfSize:20]}];
}

@end
