//
//  SBRootScrollView
//  GraduationProject
//
//  Created by Marike Jave on 14-12-17.
//  Copyright (c) 2014年 MarikeJave. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBRootScrollView;

@protocol SBRootScrollViewTouchDelegate <NSObject>

- (BOOL)epShouldBeginScroll:(SBRootScrollView*)scrollView location:(CGPoint)location;

@end


@interface SBRootScrollView : UIScrollView

@property (assign, nonatomic) IBOutlet id<SBRootScrollViewTouchDelegate> evTouchDelegate;

@end
