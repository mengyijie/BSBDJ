//
//  MYJQuickLoginButton.m
//  Confused
//
//  Created by 孟义杰 on 16/3/16.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJQuickLoginButton.h"

@implementation MYJQuickLoginButton

-(void)awakeFromNib
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //调整图片的位置和尺寸
    self.imageView.y = 0;
    self.imageView.centerX = self.width * 0.5;
    
    //调整文字的位置和尺寸
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
}

@end
