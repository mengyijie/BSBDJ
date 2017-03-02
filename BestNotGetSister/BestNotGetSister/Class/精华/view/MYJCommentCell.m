//
//  MYJCommentCell.m
//  Confused
//
//  Created by 孟义杰 on 16/2/23.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJCommentCell.h"
#import "MYJComment.h"
#import "MYJUser.h"
@interface MYJCommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@end
@implementation MYJCommentCell

- (void)awakeFromNib {
    self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}

-(void)setComment:(MYJComment *)comment
{
    _comment = comment;
    if(comment.voiceuri.length)
    {
        self.voiceButton.hidden = NO;
        [self.voiceButton setTitle:[NSString stringWithFormat:@"%zd",comment.voicetime] forState:UIControlStateNormal];
    }else{
        self.voiceButton.hidden = YES;
    }
    [self.profileImageView setHeader:comment.user.profile_image];
    self.contentLabel.text = comment.content;
    self.usernameLabel.text = comment.user.username;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%zd",comment.like_count];
    if([comment.user.sex isEqualToString:MYJUserSexMale])
    {
        self.sexView.image = [UIImage imageNamed:@"Profile_manIcon"];
    }else{
        self.sexView.image = [UIImage imageNamed:@"Profile_womanIcon"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
