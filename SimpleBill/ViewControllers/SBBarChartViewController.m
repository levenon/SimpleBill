//
//  SBBarChartViewController.m
//  SimpleBill
//
//  Created by Terry Worona on 11/5/13.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBBarChartViewController.h"

#import "SBConstants.h"

#import "SBChartHeaderView.h"
#import "SBBarChartFooterView.h"


// Numerics
//CGFloat const kSBBarChartViewControllerChartHeight = 250.0f;
CGFloat const kSBBarChartViewControllerChartHeaderHeight = 80.0f;
CGFloat const kSBBarChartViewControllerChartHeaderPadding = 10.0f;
CGFloat const kSBBarChartViewControllerChartFooterHeight = 25.0f;
CGFloat const kSBBarChartViewControllerChartFooterPadding = 5.0f;
CGFloat const kSBBarChartViewControllerBarPadding = 1;
NSInteger const kSBBarChartViewControllerNumBars = 12;
NSInteger const kSBBarChartViewControllerMaxBarHeight = 100; // max random value
NSInteger const kSBBarChartViewControllerMinBarHeight = 20;

// Strings
NSString * const kSBBarChartViewControllerNavButtonViewKey = @"view";

@interface SBBarChartViewController () <SBBarChartViewDelegate, SBBarChartViewDataSource>{
    NSArray *_evUserMonthBills;
}

@property (nonatomic, strong) SBBarChartView *barChartView;
@property (nonatomic, assign) SBChartHeaderView *headerView;
@property (nonatomic, strong) SBChartInformationView *informationView;
@property (nonatomic, assign) SBBarChartFooterView *footerView;

@property (nonatomic, strong) NSArray *evUserMonthBills;
@property (nonatomic, assign) float evMaxValue;

@end

@implementation SBBarChartViewController

#pragma mark - Alloc/Init

- (id)init
{
    self = [super init];
    if (self){
        
    }
    return self;
}


#pragma mark - accessory

- (NSArray*)evUserMonthBills;{

    if (!_evUserMonthBills) {
        _evUserMonthBills = @[];
    }
    return _evUserMonthBills;
}

- (void)setEvUserMonthBills:(NSArray *)evUserMonthBills{

    if (_evUserMonthBills != evUserMonthBills ) {
        _evUserMonthBills = evUserMonthBills;

        [self setEvMaxValue:[self _efFindMaxValue:evUserMonthBills]];
    }
}

#pragma mark - View Lifecycle

- (void)loadView
{
    [super loadView];

    [[self view] setBackgroundColor:kSBColorControllerBackground];
    self.barChartView = [[SBBarChartView alloc] initWithFrame:CGRectMake(kSBNumericDefaultPadding, kSBNumericDefaultPadding + 25, self.view.bounds.size.width - (kSBNumericDefaultPadding * 2), (self.view.bounds.size.height - 25)/2. - kSBNumericDefaultPadding * 2)];
    self.barChartView.delegate = self;
    self.barChartView.dataSource = self;
    self.barChartView.headerPadding = kSBBarChartViewControllerChartHeaderPadding;
    self.barChartView.backgroundColor = kSBColorBarChartBackground;

    SBChartHeaderView *headerView = [[SBChartHeaderView alloc] initWithFrame:CGRectMake(kSBNumericDefaultPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kSBBarChartViewControllerChartHeaderHeight * 0.5), self.view.bounds.size.width - (kSBNumericDefaultPadding * 2), kSBBarChartViewControllerChartHeaderHeight)];
    headerView.titleLabel.text = [kSBStringLabelAverageUserBill uppercaseString];
    headerView.separatorColor = kSBColorBarChartHeaderSeparatorColor;
    self.barChartView.headerView = headerView;
    self.headerView = headerView;

    SBBarChartFooterView *footerView = [[SBBarChartFooterView alloc] initWithFrame:CGRectMake(kSBNumericDefaultPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kSBBarChartViewControllerChartFooterHeight * 0.5), self.view.bounds.size.width - (kSBNumericDefaultPadding * 2), kSBBarChartViewControllerChartFooterHeight)];
    footerView.padding = kSBBarChartViewControllerChartFooterPadding;
    footerView.leftLabel.textColor = [UIColor whiteColor];
    footerView.rightLabel.textColor = [UIColor whiteColor];
    self.barChartView.footerView = footerView;
    self.footerView = footerView;
    
    self.informationView = [[SBChartInformationView alloc] initWithFrame:CGRectMake(0, self.barChartView.bottom, self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.barChartView.frame))];
    [self.view addSubview:self.informationView];

    [self.view addSubview:self.barChartView];
    [self.barChartView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self efRefresh];
//    [[self barChartView] setState:SBChartViewStateCollapsed];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    __weak typeof(self.barChartView) etvWeakBarChart = [self barChartView];
    WeakSelf(ws);

    [self.barChartView setState:SBChartViewStateExpanded animated:YES callback:^{

        [etvWeakBarChart selectDefaultIndex:[ws _efFindMaxValueIndex:[ws evUserMonthBills]]*3 + 1];
    }];
}

#pragma mark - private

- (void)efRefresh;{

    [self setEvUserMonthBills:[[SBBillManager sharedInstance] evUserOutputs]];
    SBUserMonthBill *etFirst = [[self evUserMonthBills] firstObject];
    SBUserMonthBill *etLast = [[self evUserMonthBills] lastObject];

    self.footerView.leftLabel.text = [[etFirst user] name];
    self.footerView.rightLabel.text = [[etLast user] name];
    self.headerView.subtitleLabel.text = [NSString stringWithFormat:@"%@", [[NSDate date] dateStringWithFormat:@"MM-yyyy"]];

    [[self barChartView] reloadData];
}

- (float)_efFindMaxValue:(NSArray*)monthOutputs;{

    CGFloat etMaxValue = 0.f;

    for (SBUserMonthBill *etUserMonthBill in monthOutputs) {

        etMaxValue = MAX(etMaxValue, [etUserMonthBill currentMonthOutput]);
        etMaxValue = MAX(etMaxValue, [etUserMonthBill lastMonthOutput]);
        etMaxValue = MAX(etMaxValue, [etUserMonthBill lastLastMonthOutput]);
    }
    if (etMaxValue<10) {
        return 100;
    }
    return etMaxValue;
}

- (NSInteger)_efFindMaxValueIndex:(NSArray*)monthOutputs;{

    __block CGFloat etMaxValue = 0.f;
    __block NSInteger etMaxValueIndex = 0;

    [monthOutputs enumerateObjectsUsingBlock:^(SBUserMonthBill *etUserMonthBill , NSUInteger nIndex, BOOL *stop) {

        if ([etUserMonthBill currentMonthOutput] > etMaxValue) {

            etMaxValue = [etUserMonthBill currentMonthOutput];
            etMaxValueIndex = nIndex;
        }
    }];

    return etMaxValueIndex;
}


#pragma mark - SBBarChartViewDelegate

- (NSInteger)barChartView:(SBBarChartView *)barChartView heightForBarViewAtAtIndex:(NSInteger)nIndex
{
    SBUserMonthBill *etUserMonthBill = [self.evUserMonthBills objectAtIndex:nIndex/3];
    CGFloat etUserOutput = [@[@([etUserMonthBill lastLastMonthOutput]), @([etUserMonthBill lastMonthOutput]), @([etUserMonthBill currentMonthOutput])][nIndex%3] floatValue];
    
    CGFloat etValue = etUserOutput / [self evMaxValue] * 100;
   
    etValue = MIN(etValue, 100);
    etValue = MAX(etValue, 0);

    if (etValue < 10 && etValue>0) {
        etValue = 10.f;
    }

    return etValue;
}

#pragma mark - SBBarChartViewDataSource

- (NSInteger)numberOfBarsInBarChartView:(SBBarChartView *)barChartView
{
    return [[self evUserMonthBills] count] * 3;
}

- (NSInteger)barPaddingForBarChartView:(SBBarChartView *)barChartView
{
    return kSBBarChartViewControllerBarPadding;
}

- (UIColor *)barColorForBarChartView:(SBBarChartView *)barChartView atIndex:(NSInteger)index
{
    switch (index%3) {
        case 0:
            return kSBColorBarChartBarYellow;
            break;
        case 1:
            return kSBColorBarChartBarBlue;
            break;
        default:
            return kSBColorBarChartBarGreen;
            break;
    }
}

- (UIColor *)selectionBarColorForBarChartView:(SBBarChartView *)barChartView
{
    return [UIColor whiteColor];
}

- (void)barChartView:(SBBarChartView *)barChartView willSelectBarAtIndex:(NSInteger)index
{
    [self configInformationViewAtIndex:index];
}

- (void)barChartView:(SBBarChartView *)barChartView didSelectBarAtIndex:(NSInteger)index
{
    [self configInformationViewAtIndex:index];

    [self.informationView setHidden:YES animated:NO];
    [self.informationView setHidden:NO animated:YES];
}

- (void)barChartView:(SBBarChartView *)barChartView didUnselectBarAtIndex:(NSInteger)index
{
    [self.informationView setValueText:nil unitText:nil];
    [self.informationView setSubValueText:nil];
    [self.informationView setTitleText:kSBStringLabelUnselectUser];
    [self.informationView setHidden:NO animated:YES];
}

- (void)configInformationViewAtIndex:(NSInteger)nIndex;{

    NSTimeInterval etBefore = [NSDate timeIntervalFromDateComponents:[NSDateComponents nowDateComponents:NSCalendarUnitYear|NSCalendarUnitMonth]];

    SBUserMonthBill *etUserMonthBill = [self.evUserMonthBills objectAtIndex:nIndex/3];
    SBBillManager *etBillManager = [SBBillManager sharedInstance];
    
    if (nIndex%3 || ( !(nIndex%3) && [[[etUserMonthBill user] time] doubleValue] < etBefore)) {
        
        CGFloat etUserOutput = [@[@([etUserMonthBill lastLastMonthOutput]), @([etUserMonthBill lastMonthOutput]), @([etUserMonthBill currentMonthOutput])][nIndex%3] floatValue];
        CGFloat etUserInput = [@[@([etUserMonthBill lastLastMonthInput]), @([etUserMonthBill lastMonthInput]), @([etUserMonthBill currentMonthInput])][nIndex%3] floatValue];
        CGFloat etUserAverage = [@[@([etBillManager evLastLastMonthUserAverage]), @([etBillManager evLastMonthUserAverage]), @([etUserMonthBill currentMonthInput])][nIndex%3] floatValue];
        
        NSInteger etUserWeight = [[[etUserMonthBill user] weight] integerValue];
        
        [self.informationView setValueText:fmts(@"%.1f", etUserOutput) unitText:kSBStringLabelUnit];
        
        NSString *etSubValue = fmts(NSLocalizedString(@"label.average.weight.input.remain", @"Average：%.1f \nWeight ：%ld \nIncome ：%.1f \nRemain ：%.1f"), etUserAverage, etUserWeight, etUserInput, etUserInput - etUserAverage * etUserWeight);
        [self.informationView setSubValueText:etSubValue];
    }
    else{

        [self.informationView setValueText:@"0.00" unitText:kSBStringLabelUnit];
        [self.informationView setSubValueText:NSLocalizedString(@"label.member.unjoin", @"Member didn't join before")];
    }
    
    NSString *etUserMonthTitle = fmts(@"%@ %@",[[etUserMonthBill user] name] , @[NSLocalizedString(@"label.last.last.month", @"Last Last Month"), NSLocalizedString(@"label.last.month", @"Last Month"), NSLocalizedString(@"label.this.month", @"This Month")][nIndex%3]);

    [self.informationView setTitleText:etUserMonthTitle];
}

@end
