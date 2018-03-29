//
//  UIScrollView+XLRefresh.h
//  XLRefresh
//
//  Created by xingl on 2018/3/29.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLRefreshHeader, XLRefreshFooter;

@interface UIScrollView (XLRefresh)

@property (nonatomic, strong) XLRefreshHeader *xl_header;
@property (nonatomic, strong) XLRefreshFooter *xl_footer;

- (NSInteger)xl_totalDataCount;
@property (nonatomic, copy) void(^xl_reloadDataBlock)(NSInteger totalDataCount);
@end

