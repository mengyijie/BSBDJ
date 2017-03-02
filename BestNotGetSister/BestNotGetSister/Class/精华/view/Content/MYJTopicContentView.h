//
//  MYJTopicContentView.h
//  Confused
//
//  Created by 孟义杰 on 16/2/22.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MYJTopic.h"
@interface MYJTopicContentView : UIView
{
    __weak UIImageView *_imageView;
}
/**帖子模型*/
@property(nonatomic,strong)MYJTopic *topic;
@property (strong,nonatomic)MPMoviePlayerController *player;
@end
