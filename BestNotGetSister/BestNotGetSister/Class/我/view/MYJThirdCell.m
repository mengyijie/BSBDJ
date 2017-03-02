//
//  MYJThirdCell.m
//  Confused
//
//  Created by mengyijie on 16/5/8.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJThirdCell.h"

@implementation MYJThirdCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.textLabel.text = @"是否开启定位";
       // self.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:[[UISwitch alloc] initWithFrame:CGRectMake(self.width, 5, 30, self.height)]];

    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
