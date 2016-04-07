//
//  SBVieSBRootVCwController
//  SimpleBill
//
//  Created by Marike Jave on 15/4/4.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import <XLFCommonKit/XLFCommonKit.h>

#import <math.h>

#import "SBBaseNavigationController.h"

#import "SBRootVC.h"

#import "SBExpenditureBillVC.h"

#import "SBExpentitureTimelineVC.h"

#import "SBPersonBillVC.h"

#import "SBConstants.h"

#import "SBRootScrollView.h"

@interface SBRootVC ()<UIScrollViewDelegate, SBRootScrollViewTouchDelegate>

@property(nonatomic, strong) NSArray *evControllers;

@property(nonatomic, strong) SBRootScrollView* evsrvContent;

@property(nonatomic, assign) NSInteger evCurrentIndex;

@end

@implementation SBRootVC

- (void)loadView{
    [super loadView];

    [[self view] setBackgroundColor:kSBColorControllerBackground];
    [[self view] addSubview:[self evsrvContent]];
    [[self evsrvContent] setFrame:[[self view] bounds]];

    [[self evsrvContent] setContentOffset:CGPointMake(CGRectGetWidth([[self evsrvContent] bounds]), 0)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

//    [self setEvCurrentIndex:1 animate:NO];

    [self _efLoadChildViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - accessory

- (UIViewController*)evLeftVC{

    SBExpentitureTimelineVC *etExpentitureTimelineVC = [[SBExpentitureTimelineVC alloc] init];
//    SBBaseNavigationController *etNavExpentitureTimelineVC = [[SBBaseNavigationController alloc] initWithRootViewController:etExpentitureTimelineVC];
//    UIBarButtonItem *etbbiNext = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BarArrowRight"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickScrollNext:)];
//
//    [etExpentitureTimelineVC efAddBarButtonItem:etbbiNext type:XLFNavButtonTypeRight];

    return etExpentitureTimelineVC;
}

- (UIViewController*)evCenterVC{

    SBExpenditureBillVC *etExpenditureBillVC = [[SBExpenditureBillVC alloc] init];
    SBBaseNavigationController *etNavExpenditureBillVC = [[SBBaseNavigationController alloc] initWithRootViewController:etExpenditureBillVC];
    [[etNavExpenditureBillVC navigationBar] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [[etNavExpenditureBillVC navigationBar] setShadowImage:[UIImage new]];

    return etNavExpenditureBillVC;
}

- (UIViewController*)evRightVC{

    SBPersonBillVC *etPersonBillVC = [[SBPersonBillVC alloc] init];
//    SBBaseNavigationController *etNavPersonBillVC = [[SBBaseNavigationController alloc] initWithRootViewController:etPersonBillVC];
//    UIBarButtonItem *etbbiPrevious = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BarArrowLeft"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickScrollPrevious:)];

//    [etPersonBillVC efAddBarButtonItem:etbbiPrevious type:XLFNavButtonTypeLeft];

    return etPersonBillVC;
}

- (NSArray *)evControllers{

    if (!_evControllers) {

        _evControllers = @[[self evLeftVC], [self evCenterVC], [self evRightVC]];
    }
    return _evControllers;
}

- (SBRootScrollView *)evsrvContent{
    if (!_evsrvContent) {

        _evsrvContent = [SBRootScrollView emptyFrameView];
        [_evsrvContent setPagingEnabled:YES];
        [_evsrvContent setContentSize:CGSizeMake(SCREEN_WIDTH * 3, 0)];
        [_evsrvContent setShowsHorizontalScrollIndicator:NO];
        [_evsrvContent setDelegate:self];
        [_evsrvContent setEvTouchDelegate:self];
    }
    return _evsrvContent;
}

- (void)_efLoadChildViewControllers;{

    [[self evControllers] enumerateObjectsUsingBlock:^(UIViewController* vc, NSUInteger idx, BOOL *stop) {

        UIView *etvItemContent = [[UIView alloc] initWithFrame:CGRectMakeXYS(CGRectGetWidth([[self evsrvContent] bounds]) * idx, 0, CGRectGetSize([[self evsrvContent] bounds]))];

        [etvItemContent addSubview:[vc view]];
        [[self evsrvContent] addSubview:etvItemContent];
        [[vc view] setFrame:[etvItemContent bounds]];
        [self addChildViewController:vc];
    }];
}

- (void)setEvCurrentIndex:(NSInteger)evCurrentIndex animate:(BOOL)animate;{

    if (_evCurrentIndex != evCurrentIndex) {

        UIViewController *etCurrentVC = [[self evControllers] objectAtIndex:evCurrentIndex];

        [etCurrentVC willMoveToParentViewController:self];
        UIView *etvItemContent = [[UIView alloc] initWithFrame:CGRectMakeXYS(CGRectGetWidth([[self evsrvContent] bounds]) * evCurrentIndex, 0, CGRectGetSize([[self evsrvContent] bounds]))];
        [etvItemContent addSubview:[etCurrentVC view]];
        [[self evsrvContent] addSubview:etvItemContent];
        [[etCurrentVC view] setFrame:[etvItemContent bounds]];

        [self addChildViewController:etCurrentVC];
        [etCurrentVC didMoveToParentViewController:self];

        etCurrentVC = [[self evControllers] objectAtIndex:_evCurrentIndex];

        void (^etblcTransform)() = ^(){

            [[self evsrvContent] setContentOffset:CGPointMake(CGRectGetWidth([[self evsrvContent] bounds]) * evCurrentIndex, 0)];
        };

        void (^etblcComplete)() = ^(){

            [etCurrentVC willMoveToParentViewController:nil];

            [[[etCurrentVC view] superview] removeFromSuperview];
            [[etCurrentVC view] removeFromSuperview];
            [etCurrentVC removeFromParentViewController];

            [etCurrentVC didMoveToParentViewController:nil];
        };

        if (animate) {

            [UIView animateWithDuration:0.3 animations:^{

                etblcTransform();
            } completion:^(BOOL finished) {

                etblcComplete();
            }];
        }
        else{

            etblcTransform();
            etblcComplete();
        }

        _evCurrentIndex = evCurrentIndex;
    }
}

#pragma mark - actions

- (IBAction)didClickScrollNext:(id)sender{

    [self setEvCurrentIndex:[self evCurrentIndex] + 1 animate:YES];
}

- (IBAction)didClickScrollPrevious:(id)sender{

    [self setEvCurrentIndex:[self evCurrentIndex] - 1 animate:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;{

    NSInteger nIndex = ceil([scrollView contentOffset].x / CGRectGetWidth([scrollView bounds]));
    nIndex = MIN(nIndex, 2);
    nIndex = MAX(0, nIndex);
    if (nIndex != [self evCurrentIndex]) {

        UIViewController *etLastChildVC = [[self evControllers] objectAtIndex:[self evCurrentIndex]];
        UIViewController *etCurrentChildVC = [[self evControllers] objectAtIndex:nIndex];

        [etCurrentChildVC viewWillAppear:YES];
        [etLastChildVC viewWillDisappear:YES];

        [etLastChildVC viewDidDisappear:YES];
        [etCurrentChildVC viewDidAppear:YES];

        [self setEvCurrentIndex:nIndex];
    }
}

#pragma mark - SBRootScrollViewTouchDelegate

- (BOOL)epShouldBeginScroll:(SBRootScrollView*)scrollView location:(CGPoint)location;{

    for (UIViewController<SBRootVCDelegate> *etViewController in [self evControllers]) {

        if (CGRectContainsPoint([[[etViewController view] superview] frame], location)) {

            if ([etViewController respondsToSelector:@selector(epEnableScrollAtLocation:)]) {
                return [etViewController epEnableScrollAtLocation:[[etViewController view] convertPoint:location fromView:scrollView]];
            }
        }
    }

    return YES;
}


- (UIViewController*)evVisibleViewController{

    return [[[self evControllers] objectAtIndex:[self evCurrentIndex]] evVisibleViewController];
}

@end
