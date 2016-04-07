//
//  SBLineChartViewController.m
//  SimpleBill
//
//  Created by Terry Worona on 11/5/13.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBLineChartViewController.h"
#import "SBConstants.h"

// Views
#import "SBChartHeaderView.h"
#import "SBLineChartFooterView.h"

// Numerics
CGFloat const kSBLineChartViewControllerChartHeight = 250.0f;
CGFloat const kSBLineChartViewControllerChartHeaderHeight = 75.0f;
CGFloat const kSBLineChartViewControllerChartHeaderPadding = 20.0f;
CGFloat const kSBLineChartViewControllerChartFooterHeight = 20.0f;
NSInteger const kSBLineChartViewControllerNumChartPoints = 12;

// Strings
NSString * const kSBLineChartViewControllerNavButtonViewKey = @"view";

@interface SBLineChartViewController () <SBLineChartViewDelegate, SBLineChartViewDataSource>{
    NSArray *_evMonthOutputs;
}

@property (nonatomic, strong) SBLineChartView *lineChartView;
@property (nonatomic, assign) SBChartHeaderView *headerView;
@property (nonatomic, strong) SBChartInformationView *informationView;
@property (nonatomic, strong) NSArray *evMonthOutputs;
@property (nonatomic, strong) NSArray *evMonthlySymbols;
@property (nonatomic, assign) float evMaxValue;

@end

@implementation SBLineChartViewController

#pragma mark - Alloc/Init

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


#pragma mark - View Lifecycle

- (void)loadView
{
    [super loadView];

    [[self view] setBackgroundColor:kSBColorControllerBackground];
    self.lineChartView = [[SBLineChartView alloc] initWithFrame:CGRectMake(kSBNumericDefaultPadding, kSBNumericDefaultPadding + 25, self.view.bounds.size.width - (kSBNumericDefaultPadding * 2), (self.view.bounds.size.height - 25)/2. - kSBNumericDefaultPadding * 2)];
    self.lineChartView.delegate = self;
    self.lineChartView.dataSource = self;
    self.lineChartView.headerPadding = kSBLineChartViewControllerChartHeaderPadding;
    self.lineChartView.backgroundColor = kSBColorLineChartBackground;
    
    SBChartHeaderView *headerView = [[SBChartHeaderView alloc] initWithFrame:CGRectMake(kSBNumericDefaultPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kSBLineChartViewControllerChartHeaderHeight * 0.5), self.view.bounds.size.width - (kSBNumericDefaultPadding * 2), kSBLineChartViewControllerChartHeaderHeight)];
    headerView.titleLabel.text = [kSBStringLabelAverageMonthlyBill uppercaseString];
    headerView.titleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    headerView.titleLabel.shadowOffset = CGSizeMake(0, 1);
    headerView.subtitleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    headerView.subtitleLabel.shadowOffset = CGSizeMake(0, 1);
    headerView.separatorColor = kSBColorLineChartHeaderSeparatorColor;
    self.lineChartView.headerView = headerView;
    self.headerView = headerView;
    
    SBLineChartFooterView *footerView = [[SBLineChartFooterView alloc] initWithFrame:CGRectMake(kSBNumericDefaultPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kSBLineChartViewControllerChartFooterHeight * 0.5), self.view.bounds.size.width - (kSBNumericDefaultPadding * 2), kSBLineChartViewControllerChartFooterHeight)];
    footerView.backgroundColor = [UIColor clearColor];
    footerView.leftLabel.text = kSBStringLabeJanuary;
    footerView.leftLabel.textColor = [UIColor whiteColor];
    footerView.rightLabel.text = kSBStringLabelDecember;
    footerView.rightLabel.textColor = [UIColor whiteColor];
    footerView.sectionCount = kSBLineChartViewControllerNumChartPoints;
    self.lineChartView.footerView = footerView;
    
    [self.view addSubview:self.lineChartView];
    
    self.informationView = [[SBChartInformationView alloc] initWithFrame:CGRectMake(0, self.lineChartView.bottom, self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.lineChartView.frame)) layout:SBChartInformationViewLayoutVertical];

    [self.view addSubview:self.informationView];
    
    [self.lineChartView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    __weak typeof(self.lineChartView) etvWeakLineChart = [self lineChartView];
    [self.lineChartView setState:SBChartViewStateExpanded animated:YES callback:^{

        [etvWeakLineChart selectDefaultIndex:[[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:[NSDate date]] month] - 1];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self efRefresh];

    [self.lineChartView setState:SBChartViewStateCollapsed];
}

#pragma mark - private

- (void)efRefresh;{

    [self setEvUserOutputs:[[SBBillManager sharedInstance] evMonthOutputs]];

    self.headerView.subtitleLabel.text = [NSString stringWithFormat:@"%@  %@", kSBStringLabelDateDue, [[NSDate date] dateStringWithFormat:@"dd-MM-yyyy"]];

    [[self lineChartView] reloadData];
}

- (float)_efFindMaxValue:(NSArray*)monthOutputs;{

    CGFloat etMaxValue = 0.f;

    for (NSNumber *etPrice in monthOutputs) {

        etMaxValue = MAX(etMaxValue, [etPrice floatValue]);
    }
    return etMaxValue;
}

#pragma mark - accessory 

- (NSArray *)evMonthOutputs{
    if (!_evMonthOutputs) {

        _evMonthOutputs = @[];
    }
    return _evMonthOutputs;
}

- (NSArray*)evMonthlySymbols;{

    if (!_evMonthlySymbols) {
        _evMonthlySymbols = [[[NSDateFormatter alloc] init] monthSymbols];
    }
    return _evMonthlySymbols;
}

- (void)setEvUserOutputs:(NSArray *)evMonthOutputs{

    if (_evMonthOutputs != evMonthOutputs) {

        _evMonthOutputs = evMonthOutputs;

        [self setEvMaxValue:[self _efFindMaxValue:evMonthOutputs]];
    }
}

#pragma mark - SBLineChartViewDelegate

- (NSInteger)lineChartView:(SBLineChartView *)lineChartView heightForIndex:(NSInteger)index
{
    NSNumber *etMonthOutput = [self.evMonthOutputs objectAtIndex:(index + 1)%[[self evMonthOutputs] count]];

    return [etMonthOutput floatValue] / [self evMaxValue] * 100;
}

- (void)lineChartView:(SBLineChartView *)lineChartView willSelectChartAtIndex:(NSInteger)index
{
    NSNumber *etMonthOutput = [self.evMonthOutputs objectAtIndex:(index + 1)%[[self evMonthOutputs] count]];

    [self.informationView setValueText:[NSString stringWithFormat:@"%.1f", [etMonthOutput floatValue]] unitText:kSBStringLabelUnit];
    [self.informationView setTitleText:[[self evMonthlySymbols] objectAtIndex:index]];
}

- (void)lineChartView:(SBLineChartView *)lineChartView didSelectChartAtIndex:(NSInteger)index
{
    NSNumber *etMonthOutput = [self.evMonthOutputs objectAtIndex:(index + 1)%[[self evMonthOutputs] count]];

    [self.informationView setValueText:[NSString stringWithFormat:@"%.1f", [etMonthOutput floatValue]] unitText:kSBStringLabelUnit];
    [self.informationView setTitleText:[[self evMonthlySymbols] objectAtIndex:index]];

    [self.informationView setHidden:YES animated:NO];
    [self.informationView setHidden:NO animated:YES];
}

- (void)lineChartView:(SBLineChartView *)lineChartView didUnselectChartAtIndex:(NSInteger)index
{
    [self.informationView setValueText:nil unitText:nil];
    [self.informationView setTitleText:kSBStringLabelUnselectMonth];
    [self.informationView setHidden:NO animated:YES];
}

#pragma mark - SBLineChartViewDataSource

- (NSInteger)numberOfPointsInLineChartView:(SBLineChartView *)lineChartView
{
    return [[self evMonthOutputs] count];
}

- (UIColor *)lineColorForLineChartView:(SBLineChartView *)lineChartView
{
    return kSBColorLineChartLineColor;
}

- (UIColor *)selectionColorForLineChartView:(SBLineChartView *)lineChartView
{
    return [UIColor whiteColor];
}

@end
