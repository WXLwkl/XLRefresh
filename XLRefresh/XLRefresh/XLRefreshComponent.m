//
//  XLRefreshComponent.m
//  XLRefresh
//
//  Created by xingl on 2018/3/27.
//  Copyright © 2018年 xingl. All rights reserved.
//

#import "XLRefreshComponent.h"

NSString *const XLRefreshKeyPathContentOffset = @"contentOffset";
NSString *const XLRefreshKeyPathContentSize = @"contentSize";


@implementation XLRefreshComponent

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepare];
        // 默认是普通状态
        self.refreshState = XLRefreshStateIdle;

    }
    return self;
}
- (void)prepare {
    // 基本属性
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor yellowColor];
}
- (void)layoutSubviews {
    [self placeSubviews];
    
    [super layoutSubviews];
}

- (void)placeSubviews{}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    // 旧的父控件移除监听
    [self removeObservers];
    
    if (newSuperview) {
        
        // 设置宽度
        self.xl_width = newSuperview.xl_width;
        // 设置位置
        self.xl_x = -_scrollView.xl_insetL;
        
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 设置永远支持垂直弹簧效果
        _scrollView.alwaysBounceVertical = YES;
        // 记录UIScrollView最开始的contentInset
        _scrollViewOriginalInset = _scrollView.xl_inset;
        // 添加监听
        [self addObservers];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.refreshState == XLRefreshStateWillRefresh) {
        // 预防view还没有显示就调用beginRefreshing
        self.refreshState = XLRefreshStateRefreshing;
    }
}

#pragma mark - KVO监听
- (void)addObservers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:XLRefreshKeyPathContentOffset options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:XLRefreshKeyPathContentSize options:options context:nil];
}

- (void)removeObservers {
    [self.superview removeObserver:self forKeyPath:XLRefreshKeyPathContentOffset];
    [self.superview removeObserver:self forKeyPath:XLRefreshKeyPathContentSize];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    // 不能交互
    if (!self.userInteractionEnabled) return;
    
    // 这个就算看不见也需要处理
    if ([keyPath isEqualToString:XLRefreshKeyPathContentSize]) {
        [self scrollViewContentSizeDidChange:change];
    }
    // 看不见
    if (self.hidden) return;
    if ([keyPath isEqualToString:XLRefreshKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    }
    
}
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{}
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{}

#pragma mark 设置回调对象和回调方法
- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action {
    self.refreshingTarget = target;
    self.refreshingAction = action;
}

- (void)setRefreshState:(XLRefreshState)refreshState {
    _refreshState = refreshState;
    // 加入主队列的目的是等setRefreshState:方法调用完毕、设置完文字后再去布局子控件
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsLayout];
    });
}

- (void)beginRefreshing {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
    }];
    
    self.pullingPercent = 1.0;
    
    // 只要正在刷新，就完全显示
    if (self.window) {
        self.refreshState = XLRefreshStateRefreshing;
    } else {
        // 预防正在刷新中时，调用本方法使得header inset回置失败
        if (self.refreshState != XLRefreshStateRefreshing) {
            self.refreshState = XLRefreshStateWillRefresh;
            // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
            [self setNeedsDisplay];
        }
    }
}
#pragma mark 结束刷新状态
- (void)endRefreshing {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.refreshState = XLRefreshStateIdle;
    });
}
#pragma mark 是否正在刷新
- (BOOL)isRefreshing {
    return self.refreshState == XLRefreshStateRefreshing || self.refreshState == XLRefreshStateWillRefresh;
}

#pragma mark - 内部方法
- (void)executeRefreshingCallback {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
        if ([self.refreshingTarget respondsToSelector:self.refreshingAction]) {
            
            
            /*
             SEL selector = NSSelectorFromString(@"someMethod");
             IMP imp = [_controller methodForSelector:selector];
             void (*func)(id, SEL) = (voidvoid *)imp;
             func(_controller, selector);
             */
            ((void (*)(id, SEL))[self.refreshingTarget methodForSelector:self.refreshingAction])(self.refreshingTarget, self.refreshingAction);
        }
        
    });
}

@end
