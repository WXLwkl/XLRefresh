//
//  XLRefreshHeader.m
//  XLRefresh
//
//  Created by xingl on 2018/3/27.
//  Copyright © 2018年 xingl. All rights reserved.
//


#import "XLRefreshHeader.h"

@interface XLRefreshHeader()

@property (assign, nonatomic) CGFloat insetTDelta;
@end

@implementation XLRefreshHeader

#pragma mark - 构造方法
+ (instancetype)headerWithRefreshingBlock:(XLRefreshComponentRefreshingBlock)refreshingBlock {
    XLRefreshHeader *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    XLRefreshHeader *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
}

#pragma mark - 覆盖父类的方法
- (void)prepare {
    [super prepare];
    // 设置高度
    self.xl_height = 54;
}
- (void)placeSubviews {
    [super placeSubviews];
    
    // 设置y值(当自己的高度发生改变了，肯定要重新调整Y值，所以放到placeSubviews方法中设置y值)
    self.xl_y = - self.xl_height - self.ignoredScrollViewContentInsetTop;
}


- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    
    // 在刷新的refreshing状态
    if (self.refreshState == XLRefreshStateRefreshing) {
        // 暂时保留
        if (self.window == nil) return;
        
        // sectionheader停留解决
        CGFloat insetT = - self.scrollView.xl_offsetY > self.scrollViewOriginalInset.top ? - self.scrollView.xl_offsetY : self.scrollViewOriginalInset.top;
        insetT = insetT > self.xl_height + self.scrollViewOriginalInset.top ? self.xl_height + self.scrollViewOriginalInset.top : insetT;
        self.scrollView.xl_insetT = insetT;
        
        self.insetTDelta = self.scrollViewOriginalInset.top - insetT;
        return;
    }
    
    // 跳转到下一个控制器时，contentInset可能会变
    self.scrollViewOriginalInset = self.scrollView.xl_inset;
    NSLog(@"-->[%@]", NSStringFromUIEdgeInsets(self.scrollViewOriginalInset));
    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.xl_offsetY;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    
    // 如果是向上滚动到看不见头部控件，直接返回
    // >= -> >
    if (offsetY > happenOffsetY) return;
    
    // 普通 和 即将刷新 的临界点
    CGFloat normal2pullingOffsetY = happenOffsetY - self.xl_height;
    CGFloat pullingPercent = (happenOffsetY - offsetY) / self.xl_height;
    
    if (self.scrollView.isDragging) { // 如果正在拖拽
        self.pullingPercent = pullingPercent;
        if (self.refreshState == XLRefreshStateIdle && offsetY < normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.refreshState = XLRefreshStatePulling;
        } else if (self.refreshState == XLRefreshStatePulling && offsetY >= normal2pullingOffsetY) {
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

- (void)setRefreshState:(XLRefreshState)refreshState {
    
    XLRefreshCheckState
    // 根据状态
    if (refreshState == XLRefreshStateIdle) {
        if (oldState != XLRefreshStateRefreshing) return;
        
        // 恢复inset和offset   XLRefreshSlowAnimationDuration
        [UIView animateWithDuration:0.4 animations:^{
            self.scrollView.xl_insetT += self.insetTDelta;
            
            // 自动调整透明度
            //            if (self.isAutomaticallyChangeAlpha) self.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.pullingPercent = 0.0;
        }];
    } else if (refreshState == XLRefreshStateRefreshing) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            XLRefreshFastAnimationDuration
            [UIView animateWithDuration:0.25 animations:^{
                CGFloat top = self.scrollViewOriginalInset.top + self.xl_height;
                // 增加滚动区域top
                self.scrollView.xl_insetT = top;
                // 设置滚动位置
                CGPoint offset = self.scrollView.contentOffset;
                offset.y = -top;
                [self.scrollView setContentOffset:offset animated:NO];
            } completion:^(BOOL finished) {
                [self executeRefreshingCallback];
            }];
        });
    }
}

#pragma mark - 私有方法
- (void)setIgnoredScrollViewContentInsetTop:(CGFloat)ignoredScrollViewContentInsetTop {
    _ignoredScrollViewContentInsetTop = ignoredScrollViewContentInsetTop;
    
    self.xl_y = - self.xl_height - _ignoredScrollViewContentInsetTop;
}

@end
