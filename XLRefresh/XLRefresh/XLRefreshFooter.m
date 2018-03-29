//
//  XLRefreshFooter.m
//  XLRefresh
//
//  Created by xingl on 2018/3/28.
//  Copyright © 2018年 xingl. All rights reserved.
//

#import "XLRefreshFooter.h"

@interface XLRefreshFooter ()

@property (assign, nonatomic) NSInteger lastRefreshCount;
@property (assign, nonatomic) CGFloat lastBottomDelta;

@end

@implementation XLRefreshFooter

+ (instancetype)footerWithRefreshingBlock:(XLRefreshComponentRefreshingBlock)refreshingBlock {
    XLRefreshFooter *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    XLRefreshFooter *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
}

#pragma mark - 重写父类的方法
- (void)prepare {
    [super prepare];
    // 设置自己的高度
    self.xl_height = 44.0;
}

#pragma mark - 实现父类的方法
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    // 如果正在刷新，直接返回
    if (self.refreshState == XLRefreshStateRefreshing) return;
    
    self.scrollViewOriginalInset = self.scrollView.xl_inset;
    
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.xl_offsetY;
    // 尾部控件刚好出现的offsetY
    CGFloat happenOffsetY = [self happenOffsetY];
    
    // 如果是向下滚动到看不见尾部控件，直接返回
    if (currentOffsetY <= happenOffsetY) return;
    
    CGFloat pullingPercent = (currentOffsetY - happenOffsetY) / self.xl_height;
    
    // 如果已全部加载，仅设置pullingPercent，然后返回
    if (self.refreshState == XLRefreshStateNoMoreData) {
        self.pullingPercent = pullingPercent;
        return;
    }
    
    if (self.scrollView.isDragging) {
        self.pullingPercent = pullingPercent;
        
        // 普通 和 即将刷新 的临界点
        CGFloat normal2pullingOffsetY = happenOffsetY + self.xl_height;
        if (self.refreshState == XLRefreshStateIdle && currentOffsetY > normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.refreshState = XLRefreshStatePulling;
        } else if (self.refreshState == XLRefreshStatePulling && currentOffsetY <= normal2pullingOffsetY) {
            // 转为普通状态
            self.refreshState = XLRefreshStateIdle;
        }
    } else if (self.refreshState == XLRefreshStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
        [self beginRefreshing];
    } else if (pullingPercent < 1) {
        self.pullingPercent = pullingPercent;
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
    
    //内容的高度
    CGFloat contentHeight = self.scrollView.xl_contentH + self.ignoredScrollViewContentInsetBottom;
    // 表格的高度
    CGFloat scrollHeight = self.scrollView.xl_height - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom + self.ignoredScrollViewContentInsetBottom;
    
    //设置位置和尺寸
    self.xl_y = MAX(contentHeight, scrollHeight);
}

- (void)setRefreshState:(XLRefreshState)refreshState {
    
    XLRefreshCheckState
    
    // 根据状态来设置属性
    if (refreshState == XLRefreshStateNoMoreData || refreshState == XLRefreshStateIdle) {
        // 刷新完毕
        if (XLRefreshStateRefreshing == oldState) {
            [UIView animateWithDuration:0.4 animations:^{
                self.scrollView.xl_insetB -= self.lastBottomDelta;
            } completion:^(BOOL finished) {
                self.pullingPercent = 0.0;
            }];
        }
        
        CGFloat deltaH = [self heightForContentBreakView];
        //刚刷新完毕
        if (XLRefreshStateRefreshing == oldState && deltaH > 0 && self.scrollView.xl_totalDataCount != self.lastRefreshCount) {
            self.scrollView.xl_offsetY = self.scrollView.xl_offsetY;
        }
    } else if (refreshState == XLRefreshStateRefreshing) {
        // 记录刷新前的数量
        self.lastRefreshCount = self.scrollView.xl_totalDataCount;
        
        [UIView animateWithDuration:0.25 animations:^{
            CGFloat bottom = self.xl_height + self.scrollViewOriginalInset.bottom;
            CGFloat deltaH = [self heightForContentBreakView];
            if (deltaH < 0) {
                bottom -= deltaH;
            }
            self.lastBottomDelta = bottom - self.scrollView.xl_insetB;
            self.scrollView.xl_insetB = bottom;
            self.scrollView.xl_offsetY = [self happenOffsetY] + self.xl_height;
        } completion:^(BOOL finished) {
            [self executeRefreshingCallback];
        }];
    }
}


#pragma mark 获得scrollView的内容 超出 view 的高度
- (CGFloat)heightForContentBreakView {
    CGFloat h = self.scrollView.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top;
    return self.scrollView.contentSize.height - h;
}

- (CGFloat)happenOffsetY {
    CGFloat deltaH = [self heightForContentBreakView];
    if (deltaH > 0) {
        return deltaH - self.scrollViewOriginalInset.top;
    } else {
        return - self.scrollViewOriginalInset.top;
    }
}

#pragma mark - 公共方法
- (void)endRefreshingWithNoMoreData {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.refreshState = XLRefreshStateNoMoreData;
    });
}

- (void)resetNoMoreData {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.refreshState = XLRefreshStateIdle;
    });
}



@end
