//
//  XLRefreshHeader.h
//  XLRefresh
//
//  Created by xingl on 2018/3/27.
//  Copyright © 2018年 xingl. All rights reserved.
//


#import "XLRefreshComponent.h"

@interface XLRefreshHeader : XLRefreshComponent

/** 构造器 Block */
+ (instancetype)headerWithRefreshingBlock:(XLRefreshComponentRefreshingBlock)refreshingBlock;
/** 构造器 Action */
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

/** 忽略多少scrollView的contentInset的top */
@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetTop;

@end
