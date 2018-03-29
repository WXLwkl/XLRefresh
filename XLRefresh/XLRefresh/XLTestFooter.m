//
//  XLRefreshBackFooter.m
//  XLRefresh
//
//  Created by xingl on 2018/3/28.
//  Copyright © 2018年 xingl. All rights reserved.
//

#import "XLTestFooter.h"

@interface XLTestFooter ()

@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIImageView *logo;
@property (weak, nonatomic) UIActivityIndicatorView *loading;

@end

@implementation XLTestFooter

- (void)prepare {
    [super prepare];
    
    // 设置控件的高度
    self.xl_height = 50;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    // logo
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:logo];
    self.logo = logo;
    
    // loading
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:loading];
    self.loading = loading;
}

- (void)placeSubviews {
    [super placeSubviews];
    
    self.label.frame = self.bounds;
    
    self.logo.bounds = CGRectMake(0, 0, self.bounds.size.width, 100);
    self.logo.center = CGPointMake(self.xl_width * 0.5,self.logo.xl_height + 5);
    
    self.loading.center = CGPointMake(self.xl_width - 30, self.xl_height * 0.5);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];

    // 想让控件显示的cell的下面
    //    self.y = self.scrollView.xl_contentH;
}

- (void)setRefreshState:(XLRefreshState)refreshState {
    
    XLRefreshCheckState
    
    switch (refreshState) {
        case XLRefreshStateIdle:
            [self.loading stopAnimating];
            self.label.text = @"赶紧下拉吖";
            break;
        case XLRefreshStatePulling:
            [self.loading stopAnimating];
            self.label.text = @"赶紧放开我吧";
            break;
        case XLRefreshStateRefreshing:
            self.label.text = @"拼命给大爷加载中...";
            [self.loading startAnimating];
            break;
        case XLRefreshStateNoMoreData:
            [self.loading stopAnimating];
            self.label.text = @"木有数据了";
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
    // 1.0 0.5 0.0
    // 0.5 0.0 0.5
    CGFloat red = 1.0 - pullingPercent * 0.5;
    CGFloat green = 0.5 - 0.5 * pullingPercent;
    CGFloat blue = 0.5 * pullingPercent;
    self.label.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
