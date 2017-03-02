//
//  MYJTagButton.m
//  Confused
//
//  Created by mengyijie on 16/5/2.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJTagButton.h"

@implementation MYJTagButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = MYJTagBgColor;
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

-(void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    //自动计算
    [self sizeToFit];
    //微调
    self.height = MYJTagH;
    self.width += 3*MYJCommonSmallMargin;
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.x = MYJCommonSmallMargin;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + MYJCommonSmallMargin;
}

@end
