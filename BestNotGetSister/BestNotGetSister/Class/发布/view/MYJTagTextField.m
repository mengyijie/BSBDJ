//
//  MYJTagTextField.m
//  Confused
//
//  Created by mengyijie on 16/5/2.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJTagTextField.h"

@implementation MYJTagTextField

/**
 * 监听键盘内部的删除键点击
 */
- (void)deleteBackward
{
    // 执行需要做的操作
    !self.deleteBackwardOperation ? : self.deleteBackwardOperation();
    
    [super deleteBackward];
}

@end
