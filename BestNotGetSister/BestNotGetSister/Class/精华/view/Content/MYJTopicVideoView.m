//
//  MYJTopicVideoView.m
//  Confused
//
//  Created by 孟义杰 on 16/2/22.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJTopicVideoView.h"
#import "MYJTopic.h"
#import <UIImageView+AFNetworking.h>
@interface MYJTopicVideoView ()
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;

@end
@implementation MYJTopicVideoView

#warning mark--他这个功能没有实现，我来加上
- (IBAction)playButton:(UIButton *)sender {
}

-(void)setTopic:(MYJTopic *)topic
{
    [super setTopic:topic];
    [_imageView setImageWithURL:[NSURL URLWithString:topic.image1]];
    self.playCountLabel.text = [NSString stringWithFormat:@"%zd播放",topic.playcount];
    
    NSInteger minute = topic.videotime / 60;
    NSInteger second = topic.videotime % 60;
    // %02zd ：显示这个数字需要占据2位空间，不足的空间用0替补
    self.videoTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", minute, second];
}

@end
