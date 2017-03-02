//
//  MYJTagCell.m
//  Confused
//
//  Created by 孟义杰 on 16/2/22.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJTagCell.h"
#import "MYJTag.h"
#import <UIImageView+WebCache.h>

@interface MYJTagCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageListView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNumberLabel;
@end

@implementation MYJTagCell

/**
 * 重写这个方法的目的：拦截cell的frame设置
 */
- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 1;
    
    [super setFrame:frame];
}

- (void)setTagModel:(MYJTag *)tagModel
{
    _tagModel = tagModel;
    
    // 设置头像
    [self.imageListView setHeader:tagModel.image_list];
    
    self.themeNameLabel.text = tagModel.theme_name;
    
    // 订阅数
    if (tagModel.sub_number >= 10000) {
        self.subNumberLabel.text = [NSString stringWithFormat:@"%.1f万人订阅", tagModel.sub_number / 10000.0];
    } else {
        self.subNumberLabel.text = [NSString stringWithFormat:@"%zd人订阅", tagModel.sub_number];
    }
}

@end
