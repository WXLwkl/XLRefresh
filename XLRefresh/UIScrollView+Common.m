//
//  UIScrollView+Common.m
//  OC_APP
//
//  Created by xingl on 2018/3/27.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "UIScrollView+Common.h"

@implementation UIScrollView (Common)

- (UIEdgeInsets)xl_inset {
    if (@available(iOS 11.0 ,*)) {
        return self.adjustedContentInset;
    }
    return self.contentInset;
}

- (void)setXl_insetT:(CGFloat)xl_insetT {
    UIEdgeInsets inset = self.contentInset;
    inset.top = xl_insetT;
    if (@available(iOS 11.0 ,*)) {
        inset.top -= (self.adjustedContentInset.top - self.contentInset.top);
    }
    self.contentInset = inset;
}
- (CGFloat)xl_insetT {
    return self.xl_inset.top;
}

- (void)setXl_insetB:(CGFloat)xl_insetB {
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = xl_insetB;
    if (@available(iOS 11.0 ,*)) {
        inset.bottom -= (self.adjustedContentInset.bottom - self.contentInset.bottom);
    }
    self.contentInset = inset;
}
- (CGFloat)xl_insetB {
    return self.xl_inset.bottom;
}

- (void)setXl_insetL:(CGFloat)xl_insetL {
    UIEdgeInsets inset = self.contentInset;
    inset.left = xl_insetL;
    if (@available(iOS 11.0 ,*)) {
        inset.left -= (self.adjustedContentInset.left - self.contentInset.left);
    }
    self.contentInset = inset;
}
- (CGFloat)xl_insetL {
    return self.xl_inset.left;
}

- (void)setXl_insetR:(CGFloat)xl_insetR {
    UIEdgeInsets inset = self.contentInset;
    inset.right = xl_insetR;
    if (@available(iOS 11.0 ,*)) {
        inset.right -= (self.adjustedContentInset.right - self.contentInset.right);
    }
    self.contentInset = inset;
}

- (CGFloat)xl_insetR {
    return self.xl_inset.right;
}


- (void)setXl_offsetX:(CGFloat)xl_offsetX {
    CGPoint offset = self.contentOffset;
    offset.x = xl_offsetX;
    self.contentOffset = offset;
}
- (CGFloat)xl_offsetX {
    return self.contentOffset.x;
}

- (void)setXl_offsetY:(CGFloat)xl_offsetY {
    CGPoint offset = self.contentOffset;
    offset.y = xl_offsetY;
    self.contentOffset = offset;
}
- (CGFloat)xl_offsetY {
    return self.contentOffset.y;
}

- (void)setXl_contentW:(CGFloat)xl_contentW {
    CGSize size = self.contentSize;
    size.width = xl_contentW;
    self.contentSize = size;
}
- (CGFloat)xl_contentW {
    return self.contentSize.width;
}

- (void)setXl_contentH:(CGFloat)xl_contentH {
    CGSize size = self.contentSize;
    size.height = xl_contentH;
    self.contentSize = size;
}
- (CGFloat)xl_contentH {
    return self.contentSize.height;
}

@end
