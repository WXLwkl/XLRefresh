//
//  XLRefreshFooter.h
//  XLRefresh
//
//  Created by xingl on 2018/3/28.
//  Copyright © 2018年 xingl. All rights reserved.
//

#import "XLRefreshComponent.h"

@interface XLRefreshFooter : XLRefreshComponent

/** 构造器 Block */
+ (instancetype)footerWithRefreshingBlock:(XLRefreshComponentRefreshingBlock)refreshingBlock;
/** 构造器 Action */
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

/** 提示没有更多的数据 */
- (void)endRefreshingWithNoMoreData;

/** 重置没有更多的数据（消除没有更多数据的状态） */
- (void)resetNoMoreData;

/** 忽略多少scrollView的contentInset的bottom */
@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetBottom;


@end
