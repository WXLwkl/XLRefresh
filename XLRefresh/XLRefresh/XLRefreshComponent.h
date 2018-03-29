//
//  XLRefreshComponent.h
//  XLRefresh
//
//  Created by xingl on 2018/3/27.
//  Copyright © 2018年 xingl. All rights reserved.
//

// 状态检查
#define XLRefreshCheckState \
XLRefreshState oldState = self.refreshState; \
if (refreshState == oldState) return; \
[super setRefreshState:refreshState];

#import <UIKit/UIKit.h>

#import "UIView+Frame.h"
#import "UIScrollView+XLRefresh.h"
#import "UIScrollView+Common.h"


/** 刷新控件的状态 */
typedef NS_ENUM(NSInteger, XLRefreshState) {
    /** 普通闲置状态 */
    XLRefreshStateIdle = 1,
    /** 松开就可以进行刷新的状态 */
    XLRefreshStatePulling,
    /** 正在刷新中的状态 */
    XLRefreshStateRefreshing,
    /** 即将刷新的状态 */
    XLRefreshStateWillRefresh,
    /** 所有数据加载完毕，没有更多的数据了 */
    XLRefreshStateNoMoreData
};

//刷新的回调
typedef void (^XLRefreshComponentRefreshingBlock)(void);

@interface XLRefreshComponent : UIView

/** 父控件 */
@property (strong, nonatomic, readonly) UIScrollView *scrollView;

@property (nonatomic, copy) XLRefreshComponentRefreshingBlock refreshingBlock;

/** 设置回调对象和回调方法 */
- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action;

/** 回调对象 */
@property (weak, nonatomic) id refreshingTarget;
/** 回调方法 */
@property (assign, nonatomic) SEL refreshingAction;
/** 触发回调（交给子类去调用） */
- (void)executeRefreshingCallback;

/** 记录scrollView刚开始的inset */
@property (assign, nonatomic) UIEdgeInsets scrollViewOriginalInset;

/** 刷新状态 */
@property (assign, nonatomic) XLRefreshState refreshState;
/** 是否正在刷新 */
@property (assign, nonatomic, readonly, getter=isRefreshing) BOOL refreshing;

/** 拉拽的百分比(交给子类重写) */
@property (assign, nonatomic) CGFloat pullingPercent;

/** 进入刷新状态 */
- (void)beginRefreshing;
/** 结束刷新状态 */
- (void)endRefreshing;

#pragma mark - 交给子类们去实现
/** 初始化 */
- (void)prepare;
/** 摆放子控件frame */
- (void)placeSubviews;
/** 当scrollView的contentOffset发生改变的时候调用 */
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change;
/** 当scrollView的contentSize发生改变的时候调用 */
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change;

@end
