//
//  UIScrollView+XLRefresh.m
//  XLRefresh
//
//  Created by xingl on 2018/3/29.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "UIScrollView+XLRefresh.h"
#import "XLRefreshHeader.h"
#import "XLRefreshFooter.h"
#import <objc/runtime.h>

@implementation NSObject (XLRefresh)

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2 {
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2 {
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}

@end

@implementation UIScrollView (XLRefresh)

#pragma mark - header
static const char XLRefreshHeaderKey = '\0';
- (void)setXl_header:(XLRefreshHeader *)xl_header {
    if (xl_header != self.xl_header) {
        // 删除旧的，添加新的
        [self.xl_header removeFromSuperview];
        [self insertSubview:xl_header atIndex:0];
        
        //存储新的
        [self willChangeValueForKey:@"xl_header"]; // KVO
        objc_setAssociatedObject(self, &XLRefreshHeaderKey, xl_header, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"xl_header"]; // KVO
    }
}

- (XLRefreshHeader *)xl_header {
    return objc_getAssociatedObject(self, &XLRefreshHeaderKey);
}

#pragma mark - footer
static const char XLRefreshFooterKey = '\0';
- (void)setXl_footer:(XLRefreshFooter *)xl_footer {
    if (xl_footer != self.xl_footer) {
        [self.xl_footer removeFromSuperview];
        [self insertSubview:xl_footer atIndex:0];
        
        [self willChangeValueForKey:@"xl_footer"];
        objc_setAssociatedObject(self, &XLRefreshFooterKey, xl_footer, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"xl_footer"];
    }
}

- (XLRefreshFooter *)xl_footer {
    return objc_getAssociatedObject(self, &XLRefreshFooterKey);
}

#pragma mark - other

- (NSInteger)xl_totalDataCount {
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        
        for (NSInteger section = 0; section < tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        for (NSInteger section = 0; section < collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

static const char XLRefreshReloadDataBlockKey = '\0';
- (void)setXl_reloadDataBlock:(void (^)(NSInteger))xl_reloadDataBlock {
    [self willChangeValueForKey:@"xl_reloadDataBlock"];
    objc_setAssociatedObject(self, &XLRefreshFooterKey, xl_reloadDataBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"xl_reloadDataBlock"];
}

- (void (^)(NSInteger))xl_reloadDataBlock {
    return objc_getAssociatedObject(self, &XLRefreshReloadDataBlockKey);
}

- (void)executeReloadDataBlock {
    !self.xl_reloadDataBlock ? : self.xl_reloadDataBlock(self.xl_totalDataCount);
}
@end

@implementation UITableView (XLRefresh)

+ (void)load {
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(xl_reloadData)];
}
- (void)xl_reloadData {
    [self xl_reloadData];
    [self executeReloadDataBlock];
}
@end

@implementation UICollectionView (XLRefresh)

+ (void)load {
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(xl_reloadData)];
}

- (void)xl_reloadData {
    [self xl_reloadData];
    [self executeReloadDataBlock];
}
@end

