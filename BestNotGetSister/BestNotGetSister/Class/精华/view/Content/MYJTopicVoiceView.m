//
//  MYJTopicVoiceView.m
//  Confused
//
//  Created by 孟义杰 on 16/2/22.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJTopicVoiceView.h"
#import "MYJTopic.h"
#import <UIImageView+WebCache.h>
@interface MYJTopicVoiceView ()
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;

@end

@implementation MYJTopicVoiceView
#warning mark--他没有实现 我来实现
- (IBAction)playButton:(UIButton *)sender {
}


- (void)setTopic:(MYJTopic *)topic
{
    [super setTopic:topic];
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:topic.image1]];
    self.playCountLabel.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
    
    NSInteger minute = topic.voicetime / 60;
    NSInteger second = topic.voicetime % 60;
    // %02zd ：显示这个数字需要占据2位空间，不足的空间用0替补
    self.videoTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", minute, second];
}


@end
