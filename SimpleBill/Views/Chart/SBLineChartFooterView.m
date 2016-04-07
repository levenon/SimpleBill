//
//  SBLineChartFooterView.m
//  SimpleBill
//
//  Created by Terry Worona on 11/8/13.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBLineChartFooterView.h"
#import "SBConstants.h"

// Numerics
CGFloat const kSBLineChartFooterViewSeparatorWidth = 0.5f;
CGFloat const kSBLineChartFooterViewSeparatorHeight = 3.0f;
CGFloat const kSBLineChartFooterViewSeparatorSectionPadding = 1.0f;

// Colors
static UIColor *kSBLineChartFooterViewDefaultSeparatorColor = nil;

@interface SBLineChartFooterView ()

@property (nonatomic, strong) UIView *topSeparatorView;

@end

@implementation SBLineChartFooterView

#pragma mark - Alloc/Init

+ (void)initialize
{
	if (self == [SBLineChartFooterView class])
	{
		kSBLineChartFooterViewDefaultSeparatorColor = [UIColor whiteColor];
	}
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
        
        _footerSeparatorColor = kSBLineChartFooterViewDefaultSeparatorColor;
        
        _topSeparatorView = [[UIView alloc] init];
        _topSeparatorView.backgroundColor = _footerSeparatorColor;
        [self addSubview:_topSeparatorView];
        
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.adjustsFontSizeToFitWidth = YES;
        _leftLabel.font = kSBFontFooterSubLabel;
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.textColor = [UIColor whiteColor];
        _leftLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_leftLabel];
        
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.adjustsFontSizeToFitWidth = YES;
        _rightLabel.font = kSBFontFooterSubLabel;
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.textColor = [UIColor whiteColor];
        _rightLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_rightLabel];
    }
    return self;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.footerSeparatorColor.CGColor);
    CGContextSetLineWidth(context, 0.5);
    CGContextSetShouldAntialias(context, YES);

    CGFloat xOffset = 0;
    CGFloat yOffset = kSBLineChartFooterViewSeparatorWidth;
    CGFloat stepLength = ceil((self.bounds.size.width) / (self.sectionCount - 1));
    
    for (int i=0; i<self.sectionCount; i++)
    {
        CGContextSaveGState(context);
        {
            CGContextMoveToPoint(context, xOffset + (kSBLineChartFooterViewSeparatorWidth * 0.5), yOffset);
            CGContextAddLineToPoint(context, xOffset + (kSBLineChartFooterViewSeparatorWidth * 0.5), yOffset + kSBLineChartFooterViewSeparatorHeight);
            CGContextStrokePath(context);
            xOffset += stepLength;
        }
        CGContextRestoreGState(context);
    }
    
    if (self.sectionCount > 1)
    {
        CGContextSaveGState(context);
        {
            CGContextMoveToPoint(context, self.bounds.size.width - (kSBLineChartFooterViewSeparatorWidth * 0.5), yOffset);
            CGContextAddLineToPoint(context, self.bounds.size.width - (kSBLineChartFooterViewSeparatorWidth * 0.5), yOffset + kSBLineChartFooterViewSeparatorHeight);
            CGContextStrokePath(context);
        }
        CGContextRestoreGState(context);
    }
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _topSeparatorView.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, kSBLineChartFooterViewSeparatorWidth);
    
    CGFloat xOffset = 0;
    CGFloat yOffset = kSBLineChartFooterViewSeparatorSectionPadding;
    CGFloat width = ceil(self.bounds.size.width * 0.5);
    
    self.leftLabel.frame = CGRectMake(xOffset, yOffset, width, self.bounds.size.height);
    self.rightLabel.frame = CGRectMake(CGRectGetMaxX(_leftLabel.frame), yOffset, width, self.bounds.size.height);
}

#pragma mark - Setters

- (void)setSectionCount:(NSInteger)sectionCount
{
    _sectionCount = sectionCount;
    [self setNeedsDisplay];
}

- (void)setFooterSeparatorColor:(UIColor *)footerSeparatorColor
{
    _footerSeparatorColor = footerSeparatorColor;
    _topSeparatorView.backgroundColor = _footerSeparatorColor;
    [self setNeedsDisplay];
}

@end
