//
//  MYJCategoryCell.m
//  Confused
//
//  Created by 孟义杰 on 16/3/16.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJCategoryCell.h"
#import "MYJFollowCategory.h"

@interface MYJCategoryCell ()
@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;

@end

@implementation MYJCategoryCell

- (void)awakeFromNib {
    // 清除文字背景色（这样就不会挡住分割线）
    self.textLabel.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.textLabel.textColor = selected ? [UIColor redColor] : [UIColor darkGrayColor];
    self.selectedIndicator.hidden = !selected;
}

-(void)setCategory:(MYJFollowCategory *)category
{
    _category = category;
    
    // 设置文字
    self.textLabel.text = category.name;
}

@end
