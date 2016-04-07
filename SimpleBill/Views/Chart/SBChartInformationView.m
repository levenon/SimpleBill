//
//  SBChartInformationView.m
//  SimpleBill
//
//  Created by Terry Worona on 11/11/13.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBChartInformationView.h"
#import "SBConstants.h"

// Numerics
CGFloat const kSBChartValueViewPadding = 10.0f;
CGFloat const kSBChartValueViewSeparatorSize = 1.0f;
CGFloat const kSBChartValueViewTitleHeight = 50.0f;
CGFloat const kSBChartValueViewTitleWidth = 75.0f;

// Colors (SBChartInformationView)
static UIColor *kSBChartViewSeparatorColor = nil;
static UIColor *kSBChartViewTitleColor = nil;
static UIColor *kSBChartViewShadowColor = nil;

// Colors (SBChartInformationView)
static UIColor *kSBChartInformationViewSubValueColor = nil;
static UIColor *kSBChartInformationViewValueColor = nil;
static UIColor *kSBChartInformationViewUnitColor = nil;
static UIColor *kSBChartInformationViewShadowColor = nil;

@interface SBChartValueView : UIView

@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UILabel *subValueLabel;

@property (nonatomic, copy  ) NSString *subValure;
@end

@interface SBChartInformationView ()

@property (nonatomic, strong) SBChartValueView *valueView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *separatorView;

// Position
- (CGRect)valueViewRect;
- (CGRect)titleViewRectForHidden:(BOOL)hidden;
- (CGRect)separatorViewRectForHidden:(BOOL)hidden;

@end

@implementation SBChartInformationView

#pragma mark - Alloc/Init

+ (void)initialize
{
	if (self == [SBChartInformationView class])
	{
		kSBChartViewSeparatorColor = [UIColor whiteColor];
        kSBChartViewTitleColor = [UIColor whiteColor];
        kSBChartViewShadowColor = [UIColor blackColor];
	}
}

- (id)initWithFrame:(CGRect)frame layout:(SBChartInformationViewLayout)layout
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.clipsToBounds = YES;
        _layout = layout;

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kSBFontInformationTitle;
        _titleLabel.numberOfLines = 1;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = kSBChartViewTitleColor;
        _titleLabel.shadowColor = kSBChartViewShadowColor;
        _titleLabel.shadowOffset = CGSizeMake(0, 1);
        _titleLabel.textAlignment = _layout == SBChartInformationViewLayoutHorizontal ? NSTextAlignmentLeft : NSTextAlignmentCenter;
        [self addSubview:_titleLabel];

        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = kSBChartViewSeparatorColor;
        [self addSubview:_separatorView];

        _valueView = [[SBChartValueView alloc] initWithFrame:[self valueViewRect]];
        [self addSubview:_valueView];
        
        [self setHidden:YES animated:NO];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame layout:SBChartInformationViewLayoutHorizontal];
}

#pragma mark - Position

- (CGRect)valueViewRect
{
    CGRect valueRect = CGRectZero;
    valueRect.origin.x = (self.layout == SBChartInformationViewLayoutHorizontal) ? kSBChartValueViewPadding : (kSBChartValueViewPadding * 3) + kSBChartValueViewTitleWidth;
    valueRect.origin.y = (self.layout == SBChartInformationViewLayoutHorizontal) ? kSBChartValueViewPadding + kSBChartValueViewTitleHeight : kSBChartValueViewPadding;
    valueRect.size.width = (self.layout == SBChartInformationViewLayoutHorizontal) ? self.bounds.size.width - (kSBChartValueViewPadding * 2) : self.bounds.size.width - valueRect.origin.x - kSBChartValueViewPadding;
    valueRect.size.height = (self.layout == SBChartInformationViewLayoutHorizontal) ? self.bounds.size.height - valueRect.origin.y - kSBChartValueViewPadding : self.bounds.size.height - (kSBChartValueViewPadding * 2);
    return valueRect;
}

- (CGRect)titleViewRectForHidden:(BOOL)hidden
{
    CGRect titleRect = CGRectZero;
    titleRect.origin.x = kSBChartValueViewPadding;
    titleRect.origin.y = hidden ? -kSBChartValueViewTitleHeight : kSBChartValueViewPadding;
    titleRect.size.width = (self.layout == SBChartInformationViewLayoutHorizontal) ? self.bounds.size.width - (kSBChartValueViewPadding * 2) : kSBChartValueViewTitleWidth;
    titleRect.size.height = (self.layout == SBChartInformationViewLayoutHorizontal) ? kSBChartValueViewTitleHeight : self.bounds.size.height - (kSBChartValueViewPadding * 2);
    return titleRect;
}

- (CGRect)separatorViewRectForHidden:(BOOL)hidden
{
    CGRect separatorRect = CGRectZero;
    separatorRect.origin.x = (self.layout == SBChartInformationViewLayoutHorizontal) ? kSBChartValueViewPadding : (kSBChartValueViewPadding * 2) + kSBChartValueViewTitleWidth;
    separatorRect.origin.y = (self.layout == SBChartInformationViewLayoutHorizontal) ? kSBChartValueViewTitleHeight : kSBChartValueViewPadding;
    separatorRect.size.width = (self.layout == SBChartInformationViewLayoutHorizontal) ? self.bounds.size.width - (kSBChartValueViewPadding * 2) : kSBChartValueViewSeparatorSize;
    separatorRect.size.height = (self.layout == SBChartInformationViewLayoutHorizontal) ? kSBChartValueViewSeparatorSize : self.bounds.size.height - (kSBChartValueViewPadding * 2);
    if (hidden)
    {
        if (self.layout == SBChartInformationViewLayoutHorizontal)
        {
            separatorRect.origin.x -= self.bounds.size.width;
        }
        else
        {
            separatorRect.origin.y = self.bounds.size.height;
        }
    }
    return separatorRect;
}

#pragma mark - Setters

- (void)setTitleText:(NSString *)titleText
{
    self.titleLabel.text = titleText;
    self.separatorView.hidden = !(titleText != nil);
}

- (void)setValueText:(NSString *)valueText unitText:(NSString *)unitText
{
    self.valueView.valueLabel.text = valueText;
    self.valueView.unitLabel.text = unitText;
    [self.valueView setNeedsLayout];
}

- (void)setSubValueText:(NSString *)subValueText
{
    subValueText = subValueText;
    self.valueView.subValueLabel.text = subValueText;
    [self.valueView setNeedsLayout];
}

- (void)setTitleTextColor:(UIColor *)titleTextColor
{
    self.titleLabel.textColor = titleTextColor;
    [self.valueView setNeedsDisplay];
}

- (void)setValueAndUnitTextColor:(UIColor *)valueAndUnitColor
{
    self.valueView.valueLabel.textColor = valueAndUnitColor;
    self.valueView.unitLabel.textColor = valueAndUnitColor;
    [self.valueView setNeedsDisplay];
}

- (void)setSubValueTextColor:(UIColor *)subValueTextColor;{
    self.valueView.subValueLabel.textColor = subValueTextColor;
    [self.valueView setNeedsDisplay];
}

- (void)setTextShadowColor:(UIColor *)shadowColor
{
    self.valueView.valueLabel.shadowColor = shadowColor;
    self.valueView.unitLabel.shadowColor = shadowColor;
    self.titleLabel.shadowColor = shadowColor;
    [self.valueView setNeedsDisplay];
}

- (void)setSeparatorColor:(UIColor *)separatorColor
{
    self.separatorView.backgroundColor = separatorColor;
    [self setNeedsDisplay];
}

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated
{
    if (animated)
    {
        if (hidden)
        {
            [UIView animateWithDuration:kSBNumericDefaultAnimationDuration * 0.5 animations:^{
                self.titleLabel.alpha = 0.0;
                self.separatorView.alpha = 0.0;
                self.valueView.subValueLabel.alpha = 0.0;
                self.valueView.valueLabel.alpha = 0.0;
                self.valueView.unitLabel.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.titleLabel.frame = [self titleViewRectForHidden:YES];
                self.separatorView.frame = [self separatorViewRectForHidden:YES];
            }];
        }
        else
        {
            [UIView animateWithDuration:kSBNumericDefaultAnimationDuration animations:^{
                self.titleLabel.frame = [self titleViewRectForHidden:NO];
                self.titleLabel.alpha = hidden ? 0.0 : 1.0;
                self.separatorView.frame = [self separatorViewRectForHidden:NO];
                self.separatorView.alpha = hidden ? 0.0 : 1.0;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:kSBNumericDefaultAnimationDuration animations:^{
                    self.valueView.valueLabel.alpha = hidden ? 0.0 : 1.0;
                    self.valueView.unitLabel.alpha = hidden ? 0.0 : 1.0;
                    self.valueView.subValueLabel.alpha = hidden ? 0.0 : 1.0;
                }];
            }];
        }
    }
    else
    {
        self.titleLabel.frame = [self titleViewRectForHidden:hidden];
        self.titleLabel.alpha = hidden ? 0.0 : 1.0;
        self.separatorView.frame = [self separatorViewRectForHidden:hidden];
        self.separatorView.alpha = hidden ? 0.0 : 1.0;
        self.valueView.valueLabel.alpha = hidden ? 0.0 : 1.0;
        self.valueView.unitLabel.alpha = hidden ? 0.0 : 1.0;
        self.valueView.subValueLabel.alpha = hidden ? 0.0 : 1.0;
    }
}

- (void)setHidden:(BOOL)hidden
{
    [self setHidden:hidden animated:NO];
}

@end

@implementation SBChartValueView

#pragma mark - Alloc/Init

+ (void)initialize
{
	if (self == [SBChartValueView class])
    {
        kSBChartInformationViewSubValueColor = [UIColor lightGrayColor];
        kSBChartInformationViewValueColor = [UIColor whiteColor];
        kSBChartInformationViewUnitColor = [UIColor whiteColor];
        kSBChartInformationViewShadowColor = [UIColor blackColor];
	}
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.font = kSBFontInformationValue;
        _valueLabel.textColor = kSBChartInformationViewValueColor;
        _valueLabel.shadowColor = kSBChartInformationViewShadowColor;
        _valueLabel.shadowOffset = CGSizeMake(0, 1);
        _valueLabel.backgroundColor = [UIColor clearColor];
        _valueLabel.textAlignment = NSTextAlignmentLeft;
        _valueLabel.adjustsFontSizeToFitWidth = YES;
        _valueLabel.numberOfLines = 1;
        [self addSubview:_valueLabel];
        
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.font = kSBFontInformationUnit;
        _unitLabel.textColor = kSBChartInformationViewUnitColor;
        _unitLabel.shadowColor = kSBChartInformationViewShadowColor;
        _unitLabel.shadowOffset = CGSizeMake(0, 1);
        _unitLabel.backgroundColor = [UIColor clearColor];
        _unitLabel.textAlignment = NSTextAlignmentLeft;
//        _unitLabel.adjustsFontSizeToFitWidth = YES;
        _unitLabel.numberOfLines = 1;
        [self addSubview:_unitLabel];

        _subValueLabel = [[UILabel alloc] init];
        _subValueLabel.font = kSBFontInformationSubValue;
        _subValueLabel.textColor = kSBChartInformationViewSubValueColor;
        _subValueLabel.shadowColor = kSBChartInformationViewShadowColor;
        _subValueLabel.shadowOffset = CGSizeMake(0, 1);
        _subValueLabel.backgroundColor = [UIColor clearColor];
        _subValueLabel.textAlignment = NSTextAlignmentLeft;
//        _subValueLabel.adjustsFontSizeToFitWidth = YES;
        _subValueLabel.numberOfLines = NSIntegerMax;
        [self addSubview:_subValueLabel];
    }
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews
{

    CGFloat xOffset = kSBChartValueViewPadding;
    CGSize unitLabelSize = [self.unitLabel.text sizeWithFont:[[self unitLabel] font]];
    CGSize valueLabelSize = [self.valueLabel.text sizeWithFont:[[self valueLabel] font]];
    CGSize subValueLabelSize = [self.subValueLabel.text sizeWithFont:self.subValueLabel.font constrainedToSize:CGSizeMake(SCREEN_WIDTH - kSBChartValueViewPadding * 2, NSIntegerMax)];

    self.valueLabel.frame = CGRectMake(xOffset, ceil(self.bounds.size.height * 0.5) - ceil(valueLabelSize.height * 0.5) - select([[[self subValueLabel] text] length], 60, 0), valueLabelSize.width, valueLabelSize.height);

    self.unitLabel.frame = CGRectMake(self.valueLabel.right, self.valueLabel.top + 8, unitLabelSize.width, unitLabelSize.height);

    self.subValueLabel.frame = CGRectMake(xOffset, self.valueLabel.bottom + 25, subValueLabelSize.width, subValueLabelSize.height);

}

@end
