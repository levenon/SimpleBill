//
//  XLFViewInterface
//  XLFCommonKit
//
//  Created by Marike Jave on 14-8-25.
//  Copyright (c) 2014年 Marike Jave. All rights reserved.
//

#define TableViewCellEvdgAlign  10

@protocol XLFTableViewCellDelegate <NSObject>

@optional
- (BOOL)epShouldDeleteTableViewCell:(id)tableViewCell;
- (void)epDidDeleteTableViewCell:(id)tableViewCell;
- (BOOL)epShouldExpendTableViewCell:(id)tableViewCell;
- (void)epDidExpendTableViewCell:(id)tableViewCell;
- (void)epDidRefreshTableViewCell:(id)tableViewCell userInfo:(id)userInfo;

@end

@protocol XLFTableViewCellInterface <NSObject>
+ (id)alloc;
+ (BOOL)conformsToProtocol:(Protocol *)aProtocol;

@optional
+ (CGFloat)epGetHeight:(id)model;
@property(nonatomic, strong) id evModel;

+ (CGFloat)epGetHeight:(id)model otherModel:(id)other;
@property(nonatomic, strong) id evOtherModel;

- (void)epCreateSubViews;
- (void)epConfigSubViews;
- (void)epConfigSubViewsDefault;
- (void)epRelayoutSubViews:(CGRect)bounds;
@property(nonatomic, assign) id evDelegate;

@end

@protocol XLFViewDelegate <NSObject>
@optional
- (BOOL)epShouldDelete:(id)view;
- (void)epDidDelete:(id)view;
- (void)epDidCallback:(id)view userInfo:(id)userInfo;
@end

@protocol XLFViewInterface <NSObject>

+(id)alloc;
@optional
@property(nonatomic, strong) id evModel;

@property(nonatomic, strong) id evOtherModel;

- (void)epCreateSubViews;
- (void)epConfigSubViews;
- (void)epConfigSubViewsDefault;
- (void)epRelayoutSubViews:(CGRect)bounds;

@property(nonatomic, assign) id evDelegate;

@end