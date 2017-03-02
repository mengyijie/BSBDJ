//
//  MYJTagTextField.h
//  Confused
//
//  Created by mengyijie on 16/5/2.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYJTagTextField : UITextField
/** 点击删除键需要执行的操作 */
@property (nonatomic, copy) void (^deleteBackwardOperation)();
@end
