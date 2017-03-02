//
//  MYJUserCell.m
//  Confused
//
//  Created by 孟义杰 on 16/3/16.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJUserCell.h"
#import "MYJFollowUser.h"

@interface MYJUserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;
@end

@implementation MYJUserCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setUser:(MYJFollowUser *)user
{
    _user = user;
    
    [self.headerImageView setHeader:user.header];
    self.screenNameLabel.text = user.screen_name;
    
    if (user.fans_count >= 10000) {
        self.fansCountLabel.text = [NSString stringWithFormat:@"%.1f万人关注", user.fans_count / 10000.0];
    } else {
        self.fansCountLabel.text = [NSString stringWithFormat:@"%zd人关注", user.fans_count];
    }
}

@end
