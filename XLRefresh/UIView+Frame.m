//
//  UIView+Frame.m
//  OC_APP
//
//  Created by xingl on 2017/6/16.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat)xl_x {
    return self.frame.origin.x;
}

- (void)setXl_x:(CGFloat)value {
    CGRect frame = self.frame;
    frame.origin.x = value;
    self.frame = frame;
}

- (CGFloat)xl_y {
    return self.frame.origin.y;
}

- (void)setXl_y:(CGFloat)value {
    CGRect frame = self.frame;
    frame.origin.y = value;
    self.frame = frame;
}

- (CGFloat)xl_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setXl_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)xl_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setXl_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)xl_width {
    return self.frame.size.width;
}

- (void)setXl_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)xl_height {
    return self.frame.size.height;
}

- (void)setXl_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)xl_centerX {
    return self.center.x;
}

- (void)setXl_centerX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)xl_centerY {
    return self.center.y;
}

- (void)setXl_centerY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGPoint)xl_origin {
    return self.frame.origin;
}

- (void)setXl_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)xl_size {
    return self.frame.size;
}

- (void)setXl_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end
