//
//  MYJLoginRegisterTextField.m
//  Confused
//
//  Created by 孟义杰 on 16/3/7.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJLoginRegisterTextField.h"

// 默认的占位文字颜色
#define MYJPlaceholderDefaultColor [UIColor grayColor]
// 聚焦的占位文字颜色
#define MYJPlaceholderFocusColor [UIColor whiteColor]

@interface MYJLoginRegisterTextField()

@end

@implementation MYJLoginRegisterTextField

- (void)awakeFromNib
{
    // 文本框的光标颜色
    self.tintColor = MYJPlaceholderFocusColor;
    // 文字颜色
    self.textColor = MYJPlaceholderFocusColor;
    // 设置占位文字颜色
    self.placeholderColor = MYJPlaceholderDefaultColor;
}

/**
 * 文本框聚焦时调用（弹出当前文本框对应的键盘时调用）
 */
- (BOOL)becomeFirstResponder
{
    self.placeholderColor = MYJPlaceholderFocusColor;
    return [super becomeFirstResponder];
}

/**
 * 文本框失去焦点时调用（隐藏当前文本框对应的键盘时调用）
 */
- (BOOL)resignFirstResponder
{
    self.placeholderColor = MYJPlaceholderDefaultColor;
    return [super resignFirstResponder];
}

@end