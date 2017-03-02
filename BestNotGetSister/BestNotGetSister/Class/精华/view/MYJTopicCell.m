//
//  MYJTopicCell.m
//  Confused
//
//  Created by 孟义杰 on 16/2/22.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJTopicCell.h"
#import "MYJTopic.h"
#import "MYJTopicPictureView.h"
#import "MYJTopicVideoView.h"
#import "MYJTopicVoiceView.h"
#import "MYJComment.h"
#import "MYJUser.h"
#import "UMSocial.h"
@interface MYJTopicCell ()<UIAlertViewDelegate,UMSocialDataDelegate,UMSocialUIDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *text_label;

@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

/** 最热评论-整体 */
@property (weak, nonatomic) IBOutlet UIView *topCmtView;
/** 最热评论-文字内容 */
@property (weak, nonatomic) IBOutlet UILabel *topCmtLabel;

/**图片*/
@property (nonatomic, weak)MYJTopicPictureView *pictureView;

/**视频*/
@property (nonatomic, weak)MYJTopicVideoView *videoView;

/**声音*/
@property (nonatomic, weak)MYJTopicVoiceView *voiceView;

@end
@implementation MYJTopicCell

#pragma mark --懒加载
-(MYJTopicPictureView *)pictureView
{
    if(!_pictureView)
    {
        MYJTopicPictureView *pictureView = [MYJTopicPictureView viewFromXib];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

-(MYJTopicVideoView *)videoView
{
    if(!_videoView)
    {
        MYJTopicVideoView *videoView = [MYJTopicVideoView viewFromXib];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}

-(MYJTopicVoiceView *)voiceView
{
    if(!_voiceView)
    {
        MYJTopicVoiceView *voiceView = [MYJTopicVoiceView viewFromXib];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}


- (void)awakeFromNib {
    // Initialization code
    //设置cell的背景图片
    self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}


/**调用比较频繁*/
-(void)setTopic:(MYJTopic *)topic
{
    _topic = topic;
    
    [self.profileImageView setHeader:topic.profile_image];
    self.nameLabel.text = topic.name;
    self.createdAtLabel.text = topic.created_at;
    self.text_label.text = topic.text;
    
    //设置底部工具条的数字
    [self setupButtonTitle:self.dingButton number:topic.ding placeholder:@"顶"];
    [self setupButtonTitle:self.caiButton number:topic.cai placeholder:@"踩"];
    [self setupButtonTitle:self.repostButton number:topic.repost placeholder:@"分享"];
    [self setupButtonTitle:self.commentButton number:topic.comment placeholder:@"评论"];
    
    //根据帖子的类型决定中间的内容
#warning mark --视频和声音还不能播放 要在对应的类里去实现一下
    if(topic.type == MYJTopicTypePicture){//图片
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = NO;
        self.pictureView.frame = topic.contentFrame;
        self.pictureView.topic = topic;
    }else if(topic.type == MYJTopicTypeVideo){//视频
        self.pictureView. hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = NO;
        self.videoView.frame = topic.contentFrame;
        self.videoView.topic = topic;
    }else if(topic.type == MYJTopicTypeVoice){//声音
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
        self.voiceView.hidden = NO;
        self.voiceView.frame = topic.contentFrame;
        self.voiceView.topic = topic;
    }else if(topic.type == MYJTopicTypeWord){//文字
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
    }
    //最热评论
    if(topic.topComment){
        self.topCmtView.hidden = NO;
        NSString *username = topic.topComment.user.username;
        NSString *content = topic.topComment.content;
        self.topCmtLabel.text = [NSString stringWithFormat:@"%@ : %@",username,content];
    }else{
        self.topCmtView.hidden = YES;
    }
}

#pragma mark --设置底部工具条的数字

- (void)setupButtonTitle:(UIButton *)button number:(NSInteger)number placeholder:(NSString *)placeholder
{
    if (number >= 10000) {
        [button setTitle:[NSString stringWithFormat:@"%.1f万", number / 10000.0] forState:UIControlStateNormal];
    } else if (number > 0) {
        [button setTitle:[NSString stringWithFormat:@"%zd", number] forState:UIControlStateNormal];
    } else {
        [button setTitle:placeholder forState:UIControlStateNormal];
    }
}

-(void)setFrame:(CGRect)frame
{
    frame.origin.y += MYJCommonMargin;
    frame.size.height -= MYJCommonMargin;
   // NSLog(@"1-----%f",frame.size.height);
    [super setFrame:frame];
}
- (IBAction)moreClick:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"搜藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MYJLog(@"收藏");
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        MYJLog(@"举报");
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        MYJLog(@"取消");
    }]];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)shareBtn:(UIButton *)sender {
    [UMSocialSnsService presentSnsIconSheetView:[UIApplication sharedApplication].keyWindow.rootViewController
                                         appKey:UMAPPkey
                                      shareText:@"我在使用百思不得姐，赶快来吧！"
                                     shareImage:nil
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]
                                       delegate:self];
}
- (IBAction)caiBtn:(UIButton *)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您踩了该内容！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
    [alertView show];
}
- (IBAction)dingBtn:(UIButton *)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您赞了该内容！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
    [alertView show];
}

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData {
    
}
@end
