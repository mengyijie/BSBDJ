//
//  UIView+XMGExtension.h
// 百思不得姐
//
//  Created by xiaomage on 15/9/2.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XMGExtension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

/** 从xib中创建一个控件 */
+ (instancetype)viewFromXib;
@end
