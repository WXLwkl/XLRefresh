//
//  UIScrollView+Common.h
//  OC_APP
//
//  Created by xingl on 2018/3/27.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Common)

@property (readonly, nonatomic) UIEdgeInsets xl_inset;

@property (nonatomic, assign) CGFloat xl_insetT;
@property (nonatomic, assign) CGFloat xl_insetB;
@property (nonatomic, assign) CGFloat xl_insetL;
@property (nonatomic, assign) CGFloat xl_insetR;

@property (nonatomic, assign) CGFloat xl_offsetX;
@property (nonatomic, assign) CGFloat xl_offsetY;

@property (assign, nonatomic) CGFloat xl_contentW;
@property (assign, nonatomic) CGFloat xl_contentH;

@end
