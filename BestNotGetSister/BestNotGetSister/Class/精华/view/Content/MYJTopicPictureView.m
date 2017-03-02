//
//  MYJTopicPictureView.m
//  Confused
//
//  Created by 孟义杰 on 16/2/23.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJTopicPictureView.h"
#import "MYJTopic.h"
#import <DALabeledCircularProgressView.h>
#import <UIImageView+WebCache.h>
@interface MYJTopicPictureView ()
@property (weak, nonatomic) IBOutlet UIImageView *gifView;

@property (weak, nonatomic) IBOutlet UIButton *seeBigPictureButton;
@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;
@end
@implementation MYJTopicPictureView
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.progressView.roundedCorners = 5;
    self.progressView.progressLabel.textColor = [UIColor whiteColor];
}

-(void)setTopic:(MYJTopic *)topic
{
    [super setTopic:topic];
    //下载图片
    MYJWeakSelf;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:topic.image1] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //每下载一点图片数据，就会调用一次block
        weakSelf.progressView.hidden = NO;
        weakSelf.progressView.progress = 1.0* receivedSize / expectedSize;
        weakSelf.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%",weakSelf.progressView.progress*100];
        
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        //当图片下载完毕后，就会调用这个block
        weakSelf.progressView.hidden = YES;
        
    }];
    //gif
    self.gifView.hidden = !topic.is_gif;
    //see big
    self.seeBigPictureButton.hidden = !topic.isBigPicture;
    if(topic.isBigPicture)
    {
        _imageView.contentMode = UIViewContentModeTop;
        _imageView.clipsToBounds = YES;
    }else{
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView.clipsToBounds = NO;
    }
}

@end
