//
//  MYJCommentHeaderView.m
//  Confused
//
//  Created by 孟义杰 on 16/2/23.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJCommentHeaderView.h"

@interface MYJCommentHeaderView ()
/**内部的label*/
@property (nonatomic,weak)UILabel *label;
@end

@implementation MYJCommentHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        self.contentView.backgroundColor = MYJCommonBgColor;
        //label
        UILabel *label = [[UILabel alloc]init];
        label.x = MYJCommonSmallMargin;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
        label.textColor = MYJGrayColor(120);
        label.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:label];
        self.label = label;
    }
    return self;
}

-(void)setText:(NSString *)text
{
    _text = [text copy];
    self.label.text = text;
}

@end
