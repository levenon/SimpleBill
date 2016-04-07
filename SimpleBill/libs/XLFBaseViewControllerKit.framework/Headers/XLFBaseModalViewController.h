//
//  XLFBaseModalViewController
//  XLFCommonKit
//
//  Created by Marike Jave on 14-9-11.
//  Copyright (c) 2014年 Marike Jave. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "XLFBaseViewControllerDelegate.h"

@interface XLFBaseModalViewController : UIViewController<XLFBaseViewControllerDelegate>

@property (nonatomic,strong         ) UIImage   *evBackgroundImage;//默认背景图片,注意使用该方法，整个App的背景将会都将会被改变
@property (nonatomic,strong         ) UIImage   *evNavBackgroundImage;//默认导航背景图片,注意使用该方法，整个App的背景将会都将会被改变
@property(strong, nonatomic, readonly) UIBarButtonItem*    evbbiDefaultBack;

/**
 *  主题化，刷新支持
 */
- (void)efUpdateViewForTheme;

#pragma mark - 导航

/**
 *   设置背景
 *
 *  @param backgroudImage 视图背景图片
 *  @param isGlobal       是否是全局的，如果是则整个App的背景图片将会被替换
 */
- (void)efSetBackgroudImage:(UIImage*)backgroudImage
                  isGlobal:(BOOL)isGlobal;
- (void)efSetBackgroudColor:(UIColor*)backgroudColor
                  isGlobal:(BOOL)isGlobal;

/**
 *  设置导航
 *
 *  @param backgroundImageName  背景
 *  @param backgroundImage      导航背景图片
 *  @param tintColor tint 颜色
 *  @param titleFont  标题字体
 *  @param titleColor 标题颜色
 */
- (void)efSetNavBarBackgroundImage:(UIImage *)backgroundImage
                        tintColor:(UIColor*)tintColor
                        titleFont:(UIFont*)titleFont
                       titleColor:(UIColor*)titleColor;
- (void)efSetNavBarBackgroundImage:(UIImage *)image;
#pragma mark - 下一级控制器的返回按钮
// 当进入同一导航控制器的下一个视图控制器时，左边的bar item会显示这个
// Bar button item to use for the back button in the child navigation item.
@property (nonatomic,strong,readonly) UIBarButtonItem *evBackBarButtonItem;
- (void)efSetBackButtonTitle:(NSString*)title;
- (void)efSetBackButtonImage:(UIImage*)image;
- (void)efSetBackButton:(UIBarButtonItem*)backButton;
// 隐藏当前返回按钮
@property (nonatomic,assign) BOOL      evHiddenBackButton;//是否隐藏返回按钮，默认不隐藏
// If YES, this navigation item will hide the back button when it's on top of the stack.
- (void)efSetHidesBackButton:(BOOL)hidesBackButton animated:(BOOL)animated;
/* By default, the leftItemsSupplementBackButton property is NO. In this case,
 the back button is not drawn and the left item or items replace it. If you
 would like the left items to appear in addition to the back button (as opposed to instead of it)
 set leftItemsSupplementBackButton to YES.
 */
@property(nonatomic) BOOL evLeftItemsSupplementBackButton;
@property (nonatomic,strong,readonly) UIBarButtonItem   *evLeftBarItem;
@property (nonatomic,strong,readonly) UIBarButtonItem   *evRightBarItem;
@property (nonatomic,strong,readonly) NSArray   *evLeftBarItems;
@property (nonatomic,strong,readonly) NSArray   *evRightBarItems;
- (UIBarButtonItem*)efSetBarButtonItemWithTitle:(NSString*)title
                            forBack:(BOOL)forBack
                               type:(XLFNavButtonType)type;
- (UIBarButtonItem*)efSetBarButtonItemWithImage:(UIImage*)image
                            forBack:(BOOL)forBack
                               type:(XLFNavButtonType)type;
- (void)efSetBarButtonItem:(UIBarButtonItem*)barButtonItem
                      type:(XLFNavButtonType)type;
- (void)efSetBarButtonItems:(NSArray*)barButtonItems
                       type:(XLFNavButtonType)type;
- (void)efAddBarButtonItem:(UIBarButtonItem*)barButtonItem
                      type:(XLFNavButtonType)type;
- (void)efInsertBarButtonItem:(UIBarButtonItem*)barButtonItem
                      atIndex:(NSUInteger)nIndex
                         type:(XLFNavButtonType)type;
- (void)efInsertBarButtonItem:(UIBarButtonItem*)barButtonItem
                        after:(UIBarButtonItem*)afterBarButtonItem
                         type:(XLFNavButtonType)type;
- (void)efRemoveBarButtonItems:(UIBarButtonItem*)barButtonItem
                          type:(XLFNavButtonType)type;
- (void)efRemoveBarButtonItemsAtIndex:(NSInteger)nIndex
                                 type:(XLFNavButtonType)type;

- (IBAction)didClickNavBackButton:(id)sender;


#pragma mark - 屏幕尺寸，为了解决3.5 英寸 和  4.英寸屏幕问题
#pragma mark   注意，必须在[super viewDidLoad] 之后调用有效
/**
 *  获取正文内容尺寸
 *  @param  isIncludeTabBar  是否包含tabBar导航，如果包含tabbar（值为YES），
 则对应的内容尺寸需要减去tabBar所占用的高度
 *  @return 返回正文内容尺寸
 */
- (CGRect)efGetContentFrameIncludeTabBar:(BOOL)isIncludeTabBar __deprecated ;
/**
 *  系统会自动处理获取正确的尺寸
 *  @return 返回正文内容尺寸
 */
- (CGRect)efGetContentFrame __deprecated;


@end

