//
//  SBBarChartView.m
//  Nudge
//
//  Created by Terry Worona on 9/3/13.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import <XLFCommonKit/XLFCommonKit.h>
#import "SBBarChartView.h"

// Numerics
CGFloat const kSBBarChartViewBarBasePaddingMutliplier = 50.0f;
CGFloat const kSBBarChartViewUndefinedMaxHeight = -1.0f;
CGFloat const kSBBarChartViewStateAnimationDuration = 0.05f;
CGFloat const kSBBarChartViewPopOffset = 10.0f; // used to offset bars for 'pop' animations
NSInteger const kSBBarChartViewUndefinedBarIndex = -1;

// Colors (SBChartView)
static UIColor *kSBBarChartViewDefaultBarColor = nil;

@interface SBBarChartView ()

@property (nonatomic, strong) NSDictionary *chartDataDictionary; // key = column, value = height
@property (nonatomic, strong) NSArray *barViews;
@property (nonatomic, assign) CGFloat barPadding;
@property (nonatomic, assign) CGFloat cachedMaxHeight;
@property (nonatomic, strong) SBChartSelectionView *selectionView;
@property (nonatomic, assign) BOOL selectionViewVisible;

// View quick accessors
- (CGFloat)availableHeight;
- (CGFloat)normalizedHeightForRawHeight:(NSNumber*)rawHeight;
- (CGFloat)maxHeight;
- (CGFloat)minHeight;
- (CGFloat)barWidth;

// Touch helpers
- (NSInteger)barViewIndexForPoint:(CGPoint)point;
- (UIView *)barViewForPoint:(CGPoint)point;
- (UIView *)barViewAtIndex:(NSInteger)nIndex;

// Setters
- (void)setSelectionViewVisible:(BOOL)selectionViewVisible animated:(BOOL)animated;

@end

@implementation SBBarChartView

#pragma mark - Alloc/Init

+ (void)initialize
{
	if (self == [SBBarChartView class])
	{
		kSBBarChartViewDefaultBarColor = [UIColor blackColor];
	}
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.clipsToBounds = YES;
        _showsSelection = YES;
        _cachedMaxHeight = kSBBarChartViewUndefinedMaxHeight;
        _selectedIndex = NSNotFound;
    }
    return self;
}

#pragma mark - Memory Management

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - Data

- (void)reloadData
{
    /*
     * The data collection holds all position information:
     * constructed via datasource and delegate functions
     */
    dispatch_block_t createDataDictionaries = ^{
        
        // Grab the count
        NSAssert([self.dataSource respondsToSelector:@selector(numberOfBarsInBarChartView:)], @"SBBarChartView // datasource must implement - (NSInteger)numberOfBarsInBarChartView:(SBBarChartView *)barChartView");
        NSInteger dataCount = [self.dataSource numberOfBarsInBarChartView:self];
        
        // Build up the data collection
        NSAssert([self.delegate respondsToSelector:@selector(barChartView:heightForBarViewAtAtIndex:)], @"SBBarChartView // delegate must implement - (NSInteger)barChartView:(SBBarChartView *)barChartView heightForBarViewAtAtIndex:(NSInteger)index");
        NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
        for (NSInteger index=0; index<dataCount; index++)
        {
            [dataDictionary setObject:[NSNumber numberWithInt:(int)[self.delegate barChartView:self heightForBarViewAtAtIndex:index]] forKey:[NSNumber numberWithInt:(int)index]];
        }
        self.chartDataDictionary = [NSDictionary dictionaryWithDictionary:dataDictionary];
	};
    
    /*
     * Determines the padding between bars as a function of # of bars
     */
    dispatch_block_t createBarPadding = ^{
        if ([self.dataSource respondsToSelector:@selector(barPaddingForBarChartView:)])
        {
            self.barPadding = [self.dataSource barPaddingForBarChartView:self];
        }
        else
        {
            NSInteger totalBars = [[self.chartDataDictionary allKeys] count];
            self.barPadding = (1/(float)totalBars) * kSBBarChartViewBarBasePaddingMutliplier;
        }
    };

    /*
     * Creates a new bar graph view using the previously calculated data model
     */
    dispatch_block_t createBars = ^{
        
        // Remove old bars
        for (UIView *barView in self.barViews)
        {
            [barView removeFromSuperview];
        }
        
        CGFloat xOffset = 0;
        NSInteger index = 0;
        NSMutableArray *mutableBarViews = [NSMutableArray array];
        for (NSNumber *key in [[self.chartDataDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)])
        {
            UIView *barView = [[UIView alloc] init];
            if ([self.dataSource respondsToSelector:@selector(barColorForBarChartView:atIndex:)])
            {
                barView.backgroundColor = [self.dataSource barColorForBarChartView:self atIndex:index];
            }
            else
            {
                barView.backgroundColor = kSBBarChartViewDefaultBarColor;
            }
            CGFloat height = [self normalizedHeightForRawHeight:[self.chartDataDictionary objectForKey:key]];
            barView.frame = CGRectMake(xOffset, self.bounds.size.height - height - self.footerView.frame.size.height + self.headerPadding, [self barWidth], height + kSBBarChartViewPopOffset - self.headerPadding);
            
            barView.layer.shadowColor = [UIColor blackColor].CGColor;
            barView.layer.shadowOffset = CGSizeMake(0, 0);
            barView.layer.shadowOpacity = 0.4;
            barView.layer.shadowRadius = 1.0;
            
            [mutableBarViews addObject:barView];
            [self insertSubview:barView belowSubview:self.footerView];
            xOffset += ([self barWidth] + self.barPadding);
            index++;
        }
        self.barViews = [NSArray arrayWithArray:mutableBarViews];
    };
    
    /*
     * Creates a vertical selection view for touch events
     */
    dispatch_block_t createSelectionView = ^{
        if (self.selectionView)
        {
            [self.selectionView removeFromSuperview];
            self.selectionView = nil;
        }
        
        self.selectionView = [[SBChartSelectionView alloc] initWithFrame:CGRectMake(0, 0, [self barWidth], self.bounds.size.height)];
        self.selectionView.alpha = 0.0;
        if ([self.dataSource respondsToSelector:@selector(selectionBarColorForBarChartView:)])
        {
            self.selectionView.bgColor = [self.dataSource selectionBarColorForBarChartView:self];
        }
        [self insertSubview:self.selectionView belowSubview:self.footerView];
    };
    
    createDataDictionaries();
    createBarPadding();
    createBars();
    createSelectionView();
    
    // Position header and footer    
    self.headerView.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.headerView.frame.size.height);
    self.footerView.frame = CGRectMake(self.bounds.origin.x, self.bounds.size.height - self.footerView.frame.size.height, self.bounds.size.width, self.footerView.frame.size.height);
}

#pragma mark - View Quick Accessors

- (CGFloat)availableHeight
{
    return self.bounds.size.height - self.headerView.frame.size.height - self.footerView.frame.size.height - self.headerPadding;
}

- (CGFloat)normalizedHeightForRawHeight:(NSNumber*)rawHeight
{
    CGFloat minHeight = [self minHeight];
    CGFloat maxHeight = [self maxHeight];
    CGFloat value = [rawHeight floatValue];
    
    if ((maxHeight - minHeight) <= 0)
    {
        return 0;
    }
    
    return ceil(((value - minHeight) / (maxHeight - minHeight)) * [self availableHeight]);
}

- (CGFloat)maxHeight
{
    if (self.cachedMaxHeight == kSBBarChartViewUndefinedMaxHeight)
    {
        // max height is max value across all goals and values
        NSArray *chartValues = [[[self.chartDataDictionary allValues] arrayByAddingObjectsFromArray:[self.chartDataDictionary allValues]] sortedArrayUsingSelector:@selector(compare:)];
        self.cachedMaxHeight =  [[chartValues lastObject] floatValue];
    }
    return self.cachedMaxHeight;
}

- (CGFloat)minHeight
{
    return 0;
}

- (CGFloat)barWidth
{
    NSInteger barCount = [[self.chartDataDictionary allKeys] count];
    if (barCount > 0)
    {
        CGFloat totalPadding = (barCount - 1) * self.barPadding;
        CGFloat availableWidth = self.bounds.size.width - totalPadding;
        return availableWidth / barCount;
    }
    return 0;
}

#pragma mark - Setters

- (void)setState:(SBChartViewState)state animated:(BOOL)animated callback:(void (^)())callback
{
    [super setState:state animated:animated callback:callback];
    
    dispatch_block_t callbackCopy = [callback copy];
    
    if (animated)
    {
        CGFloat popOffset = self.bounds.size.height - self.footerView.frame.size.height;
        
        NSInteger index = 0;
        for (UIView *barView in self.barViews)
        {
            [UIView animateWithDuration:kSBBarChartViewStateAnimationDuration delay:(kSBBarChartViewStateAnimationDuration * 0.5) * index options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                barView.frame = CGRectMake(barView.frame.origin.x, popOffset - barView.frame.size.height, barView.frame.size.width, barView.frame.size.height);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:kSBBarChartViewStateAnimationDuration delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    if (state == SBChartViewStateExpanded)
                    {
                        barView.frame = CGRectMake(barView.frame.origin.x, popOffset - barView.frame.size.height + kSBBarChartViewPopOffset, barView.frame.size.width, barView.frame.size.height);
                    }
                    else if (state == SBChartViewStateCollapsed)
                    {
                        barView.frame = CGRectMake(barView.frame.origin.x, self.bounds.size.height, barView.frame.size.width, barView.frame.size.height);
                    }
                } completion:^(BOOL finished) {
                    if (index == [self.barViews count] - 1)
                    {
                        if (callbackCopy)
                        {
                            callbackCopy();
                        }
                    }
                }];
            }];
            index++;
        }
    }
    else
    {
        for (UIView *barView in self.barViews)
        {
            if (state == SBChartViewStateExpanded)
            {
                barView.frame = CGRectMake(barView.frame.origin.x, (self.bounds.size.height + kSBBarChartViewPopOffset) - (barView.frame.size.height + self.footerView.frame.size.height), barView.frame.size.width, barView.frame.size.height);
            }
            else if (state == SBChartViewStateCollapsed)
            {
                barView.frame = CGRectMake(barView.frame.origin.x, self.bounds.size.height, barView.frame.size.width, barView.frame.size.height);
            }
        }
        if (callbackCopy)
        {
            callbackCopy();
        }
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{

    if (_selectedIndex != selectedIndex) {

        _selectedIndex = selectedIndex;

        UIView *barView = [self barViewAtIndex:selectedIndex];

        if (!barView){

            [self setSelectionViewVisible:NO animated:YES];
        }
        else{
            CGRect barViewFrame = barView.frame;
            CGRect selectionViewFrame = self.selectionView.frame;
            selectionViewFrame.origin.x = barViewFrame.origin.x;
            self.selectionView.frame = selectionViewFrame;

            [self setSelectionViewVisible:YES animated:YES];

            if ([self.delegate respondsToSelector:@selector(barChartView:didSelectBarAtIndex:)]){

                [self.delegate barChartView:self didSelectBarAtIndex:selectedIndex];
            }
        }
    }
    else{

        _selectedIndex = NSNotFound;

        [self setSelectionViewVisible:NO animated:YES];

        if ([self.delegate respondsToSelector:@selector(barChartView:didUnselectBarAtIndex:)]){

            [self.delegate barChartView:self didUnselectBarAtIndex:selectedIndex];
        }
    }
}

- (void)selectDefaultIndex:(NSInteger)defaultIndex;{

    [self setSelectedIndex:NSNotFound];
    [self setSelectedIndex:defaultIndex];
}

#pragma mark - Touch Helpers

- (NSInteger)barViewIndexForPoint:(CGPoint)point
{
    NSUInteger index = 0;
    NSUInteger selectedIndex = kSBBarChartViewUndefinedBarIndex;
    
    if (point.x < 0 || point.x > self.bounds.size.width)
    {
        return selectedIndex;
    }
    
    CGFloat padding = ceil(self.barPadding * 0.5);
    for (UIView *barView in self.barViews)
    {
        CGFloat minX = CGRectGetMinX(barView.frame) - padding;
        CGFloat maxX = CGRectGetMaxX(barView.frame) + padding;
        if ((point.x >= minX) && (point.x <= maxX))
        {
            selectedIndex = index;
            break;
        }
        index++;
    }
    return selectedIndex;
}

- (UIView *)barViewForPoint:(CGPoint)point
{
    UIView *barView = nil;
    NSInteger selectedIndex = [self barViewIndexForPoint:point];
    if (selectedIndex >= 0)
    {
        barView = [self.barViews objectAtIndex:selectedIndex];
    }
    return barView;
}

- (UIView *)barViewAtIndex:(NSInteger)nIndex
{
    UIView *barView = nil;
    if (nIndex >= 0 && nIndex < [[self barViews] count])
    {
        barView = [self.barViews objectAtIndex:nIndex];
    }
    return barView;
}


#pragma mark - Setters

- (void)setSelectionViewVisible:(BOOL)selectionViewVisible animated:(BOOL)animated
{
    _selectionViewVisible = selectionViewVisible;
    
    if (animated)
    {
        [UIView animateWithDuration:kSBChartViewDefaultAnimationDuration delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.selectionView.alpha = _selectionViewVisible ? 1.0 : 0.0;
        } completion:nil];
    }
    else
    {
        self.selectionView.alpha = _selectionViewVisible ? 1.0 : 0.0;
    }
}

- (void)setSelectionViewVisible:(BOOL)selectionViewVisible
{
    [self setSelectionViewVisible:selectionViewVisible animated:NO];
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.showsSelection || self.state == SBChartViewStateCollapsed)
    {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    NSInteger nIndex = [self barViewIndexForPoint:touchPoint];
    UIView *barView = [self barViewAtIndex:nIndex];
    if (barView == nil){

        [self setSelectionViewVisible:NO animated:YES];
        return;
    }

    CGRect barViewFrame = barView.frame;
    CGRect selectionViewFrame = self.selectionView.frame;
    selectionViewFrame.origin.x = barViewFrame.origin.x;

    self.selectionView.frame = selectionViewFrame;
    [self setSelectionViewVisible:YES animated:YES];

    if ([self.delegate respondsToSelector:@selector(barChartView:willSelectBarAtIndex:)]){
        [self.delegate barChartView:self willSelectBarAtIndex:nIndex];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.showsSelection || self.state == SBChartViewStateCollapsed){

        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    NSInteger nIndex = [self barViewIndexForPoint:touchPoint];
    UIView *barView = [self barViewAtIndex:nIndex];
    if (barView == nil){
        [self setSelectionViewVisible:NO animated:YES];
        return;
    }
    CGRect barViewFrame = barView.frame;
    CGRect selectionViewFrame = self.selectionView.frame;
    selectionViewFrame.origin.x = barViewFrame.origin.x;
    self.selectionView.frame = selectionViewFrame;
    [self setSelectionViewVisible:YES animated:YES];

    if ([self.delegate respondsToSelector:@selector(barChartView:willSelectBarAtIndex:)]){
        [self.delegate barChartView:self willSelectBarAtIndex:nIndex];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.showsSelection || self.state == SBChartViewStateCollapsed){
        return;
    }

    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    NSInteger nIndex = [self barViewIndexForPoint:touchPoint];
    UIView *barView = [self barViewAtIndex:nIndex];
    if (!barView) {
        nIndex = [self selectedIndex];
    }

    [self setSelectedIndex:nIndex];
}

@end
