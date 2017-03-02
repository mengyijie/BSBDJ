//
//  MYJPublishButton.m
//  Confused
//
//  Created by mengyijie on 16/4/11.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJPublishButton.h"

@implementation MYJPublishButton

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.y = 0;
    self.imageView.centerX = self.width * 0.5;
    self.titleLabel.width = self.width;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.x = 0;
    self.titleLabel.height = self.height - self.titleLabel.y;
}

@end
