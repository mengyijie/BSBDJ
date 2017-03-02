//
//  MYJTitleButton.m
//  Confused
//
//  Created by 孟义杰 on 16/2/18.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJTitleButton.h"

@implementation MYJTitleButton

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

-(void)setHighlighted:(BOOL)highlighted
{}
@end
