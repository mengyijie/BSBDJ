//
//  MYJTopicContentView.m
//  Confused
//
//  Created by 孟义杰 on 16/2/22.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJTopicContentView.h"
#import "MYJSeeBigPictureViewController.h"
@interface MYJTopicContentView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//video播放按钮
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
//voice播放按钮
@property (weak, nonatomic) IBOutlet UIButton *playVoice;

@property(nonatomic,strong)NSNotificationCenter *notificationCenter;

@end
@implementation MYJTopicContentView

-(void)awakeFromNib
{
    //清空自动伸缩属性
    self.autoresizingMask = UIViewAutoresizingNone;
    //imageView要手动打开手势交互
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick)]];
}

-(void)imageClick
{
    if(self.imageView.image == nil)
        return;
    MYJSeeBigPictureViewController *seeBig = [[MYJSeeBigPictureViewController alloc]init];
    seeBig.topic = self.topic;
    [self.window.rootViewController presentViewController:seeBig animated:YES completion:nil];
}

#pragma mark -懒加载

-(MPMoviePlayerController *)player
{
    if(!_player)
    {
        if(self.topic.type == MYJTopicTypeVoice)
        {
            NSURL *url = [NSURL URLWithString:self.topic.voiceuri];
            _player=[[MPMoviePlayerController alloc]initWithContentURL:url];
            
        }else if(self.topic.type ==MYJTopicTypeVideo)
        {
            NSURL *url = [NSURL URLWithString:self.topic.videouri];
            _player=[[MPMoviePlayerController alloc]initWithContentURL:url];
        }
        _player.view.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _player.view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:_player.view];
        
    }
    return _player;
}


- (IBAction)playVideo:(UIButton *)sender {
    [self addNotification];
    [self.player play];
}

- (IBAction)playVoice:(UIButton *)sender {
    [self addNotification];
    [self.player play];

}

-(void)addNotification{
    
    self.notificationCenter=[NSNotificationCenter defaultCenter];
    
    
    [self.notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.player];
    
    if ([self.player respondsToSelector:@selector(loadState)])
    {
        [self.player prepareToPlay];
    }
    else
    {
        [self.player play];
    }
    [self.notificationCenter addObserver:self selector:@selector(mediaPlayerPlayFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.player];
}

/**
 *  播放状态改变，注意播放完成时的状态是暂停
 *
 *  @param notification 通知对象
 */

-(void)mediaPlayerPlaybackStateChange:(NSNotification *)notification{
    
    if ([self.player loadState]!=MPMovieLoadStateUnknown)
    {
        
        switch (self.player.playbackState) {
            case MPMoviePlaybackStatePlaying:
                self.player.view.hidden = NO;
                //  NSLog(@"正在播放...");
                break;
            case MPMoviePlaybackStatePaused:
                // NSLog(@"暂停播放.");
                break;
            case MPMoviePlaybackStateStopped:
                NSLog(@"停止播放.");
//                [self.player.view removeFromSuperview];
                self.player.view.hidden = YES;
                break;
            default:
                // NSLog(@"播放状态:%li",self.moviePlayer.playbackState);
                break;
        }
    }
}

/**
 *  播放完成
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlayFinished:(NSNotification *)notification
{
//    [self.player.view removeFromSuperview];
    self.player.view.hidden = YES;
}



-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
