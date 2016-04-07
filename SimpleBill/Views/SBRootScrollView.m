//
//  SBRootScrollView
//  GraduationProject
//
//  Created by Marike Jave on 14-12-17.
//  Copyright (c) 2014年 MarikeJave. All rights reserved.
//

#import "SBRootScrollView.h"

@implementation SBRootScrollView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;{

    if ([self evTouchDelegate] && [[self evTouchDelegate] respondsToSelector:@selector(epShouldBeginScroll:location:)]) {
        return [[self evTouchDelegate] epShouldBeginScroll:self location:[gestureRecognizer locationInView:self]];
    }
    return YES;
}

@end
