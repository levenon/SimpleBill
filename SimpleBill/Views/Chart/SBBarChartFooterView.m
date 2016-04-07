//
//  SBChartFooterView.m
//  SimpleBill
//
//  Created by Marike Jave on 15/4/7.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBBarChartFooterView.h"
#import "SBConstants.h"

// Numerics
CGFloat const kSBBarChartFooterPolygonViewDefaultPadding = 4.0f;
CGFloat const kSBBarChartFooterPolygonViewArrowHeight = 8.0f;
CGFloat const kSBBarChartFooterPolygonViewArrowWidth = 16.0f;

// Colors
static UIColor *kSBBarChartFooterPolygonViewDefaultBackgroundColor = nil;

@protocol SBBarChartFooterPolygonViewDelegate;

@interface SBBarChartFooterPolygonView : UIView

@property (nonatomic, weak) id<SBBarChartFooterPolygonViewDelegate> delegate;

@end

@protocol SBBarChartFooterPolygonViewDelegate <NSObject>

- (UIColor *)backgroundColorForChartFooterPolygonView:(SBBarChartFooterPolygonView *)chartFooterPolygonView;
- (CGFloat)paddingForChartFooterPolygonView:(SBBarChartFooterPolygonView *)chartFooterPolygonView;

@end

@interface SBBarChartFooterView () <SBBarChartFooterPolygonViewDelegate>

@property (nonatomic, strong) SBBarChartFooterPolygonView *polygonView;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;

@end

@implementation SBBarChartFooterView

#pragma mark - Alloc/Init

+ (void)initialize
{
	if (self == [SBBarChartFooterView class])
	{
		kSBBarChartFooterPolygonViewDefaultBackgroundColor = kSBColorControllerBackground;
	}
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = kSBBarChartFooterPolygonViewDefaultBackgroundColor;
        self.clipsToBounds = NO;
        
        _footerBackgroundColor = kSBBarChartFooterPolygonViewDefaultBackgroundColor;
        _padding = kSBBarChartFooterPolygonViewDefaultPadding;
        
        _polygonView = [[SBBarChartFooterPolygonView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y - kSBBarChartFooterPolygonViewArrowHeight, self.bounds.size.width, self.bounds.size.height + kSBBarChartFooterPolygonViewArrowHeight)];
        _polygonView.delegate = self;
        [self addSubview:_polygonView];
        
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.adjustsFontSizeToFitWidth = YES;
        _leftLabel.font = kSBFontFooterLabel;
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.shadowColor = [UIColor blackColor];
        _leftLabel.shadowOffset = CGSizeMake(0, 1);
        _leftLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_leftLabel];
        
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.adjustsFontSizeToFitWidth = YES;
        _rightLabel.font = kSBFontFooterLabel;
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.shadowColor = [UIColor blackColor];
        _rightLabel.shadowOffset = CGSizeMake(0, 1);
        _rightLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_rightLabel];
    }
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat xOffset = self.padding;
    CGFloat yOffset = 0;
    CGFloat width = ceil(self.bounds.size.width * 0.5) - self.padding;
    
    self.leftLabel.frame = CGRectMake(xOffset, yOffset, width, self.bounds.size.height);
    self.rightLabel.frame = CGRectMake(CGRectGetMaxX(_leftLabel.frame), yOffset, width, self.bounds.size.height);
}

#pragma mark - SBBarChartFooterPolygonViewDelegate

- (UIColor *)backgroundColorForChartFooterPolygonView:(SBBarChartFooterPolygonView *)chartFooterPolygonView
{
    return self.footerBackgroundColor;
}

- (CGFloat)paddingForChartFooterPolygonView:(SBBarChartFooterPolygonView *)chartFooterPolygonView
{
    return self.padding;
}

@end

@implementation SBBarChartFooterPolygonView

#pragma mark - Alloc/Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Background gradient
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSAssert([self.delegate respondsToSelector:@selector(backgroundColorForChartFooterPolygonView:)], @"SBChartFooterPolygonView // delegate must implement - (UIColor *)backgroundColorForChartFooterPolygonView");
    NSAssert([self.delegate respondsToSelector:@selector(paddingForChartFooterPolygonView:)], @"SBChartFooterPolygonView // delegate must implement - (CGFloat)paddingForChartFooterPolygonView");

    UIColor *bgColor = [self.delegate backgroundColorForChartFooterPolygonView:self];
    
    NSArray *colors = @[(__bridge id)bgColor.CGColor, (__bridge id)bgColor.CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    // Polygon shape
    CGFloat xOffset = self.bounds.origin.x;
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat padding = [self.delegate paddingForChartFooterPolygonView:self];
    NSArray *polygonPoints = @[[NSValue valueWithCGPoint:CGPointMake(xOffset, height)],
                               [NSValue valueWithCGPoint:CGPointMake(xOffset, kSBBarChartFooterPolygonViewArrowHeight)],
                               [NSValue valueWithCGPoint:CGPointMake(xOffset + padding, kSBBarChartFooterPolygonViewArrowHeight)],
                               [NSValue valueWithCGPoint:CGPointMake(xOffset + padding + ceil(kSBBarChartFooterPolygonViewArrowWidth * 0.5), 0)],
                               [NSValue valueWithCGPoint:CGPointMake(xOffset + padding + kSBBarChartFooterPolygonViewArrowWidth, kSBBarChartFooterPolygonViewArrowHeight)],
                               [NSValue valueWithCGPoint:CGPointMake(width - padding - kSBBarChartFooterPolygonViewArrowWidth, kSBBarChartFooterPolygonViewArrowHeight)],
                               [NSValue valueWithCGPoint:CGPointMake(width - padding - ceil(kSBBarChartFooterPolygonViewArrowWidth * 0.5), 0.0)],
                               [NSValue valueWithCGPoint:CGPointMake(width - padding, kSBBarChartFooterPolygonViewArrowHeight)],
                               [NSValue valueWithCGPoint:CGPointMake(width, kSBBarChartFooterPolygonViewArrowHeight)],
                               [NSValue valueWithCGPoint:CGPointMake(width, height)],
                               [NSValue valueWithCGPoint:CGPointMake(xOffset, height)]];
    
    // Draw polygon
    NSValue *pointValue = polygonPoints[0];
    CGContextSaveGState(context);
    {
        NSInteger index = 0;
        for (pointValue in polygonPoints)
        {
            CGPoint point = [pointValue CGPointValue];
            if (index == 0)
            {
                CGContextMoveToPoint(context, point.x, point.y);
            }
            else
            {
                CGContextAddLineToPoint(context, point.x, point.y);
            }
            index++;
        }
        CGContextClip(context);
        CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect)), CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect)), 0);
    }
    CGContextRestoreGState(context);
	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorSpace);
}

@end
