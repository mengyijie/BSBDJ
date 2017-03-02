//
//  MYJMeCell.m
//  Confused
//
//  Created by mengyijie on 16/5/8.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJMeCell.h"

@implementation MYJMeCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.textColor = [UIColor grayColor];
        self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if(self.imageView.image == nil)
    {
        return;
    }
    // 调整imageView
    self.imageView.y = MYJCommonMargin * 0.5;
    self.imageView.height = self.contentView.height - 2 * self.imageView.y;
    self.imageView.width = self.imageView.height;
    
    // 调整Label
    self.textLabel.x = CGRectGetMaxX(self.imageView.frame) + MYJCommonMargin;

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
