//
//  MYJTopic.h
//  Confused
//
//  Created by 孟义杰 on 16/2/18.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MYJComment;

typedef enum {
    /**全部*/
    MYJTopicTypeAll = 1,
    
    /**图片*/
    MYJTopicTypePicture = 10,
    
    /**段子（文字）*/
    MYJTopicTypeWord = 29,
    
    /**声音*/
    MYJTopicTypeVoice = 31,
    
    /**视频*/
    MYJTopicTypeVideo = 41
    
}MYJTopicType;
@interface MYJTopic : NSObject

/** id */
@property (nonatomic, copy) NSString *id;
//@property (nonatomic, copy) NSString *ID;// id
// 用户 -- 发帖者
/** 用户的名字 */
@property (nonatomic, copy) NSString *name;
/** 用户的头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 帖子的文字内容 */
@property (nonatomic, copy) NSString *text;
/** 帖子审核通过的时间 */
@property (nonatomic, copy) NSString *created_at;
/** 顶数量 */
@property (nonatomic, assign) NSInteger ding;
/** 踩数量 */
@property (nonatomic, assign) NSInteger cai;
/** 转发\分享数量 */
@property (nonatomic, assign) NSInteger repost;
/** 评论数量 */
@property (nonatomic, assign) NSInteger comment;
/** 类型 */
@property (nonatomic, assign) MYJTopicType type;
/** 图片的宽度 */
@property (nonatomic, assign) CGFloat width;
/** 图片的高度 */
@property (nonatomic, assign) CGFloat height;

/** 小图 */
@property (nonatomic, copy) NSString *image0; // image0
/** 大图 */
@property (nonatomic, copy) NSString *image1; // image1
/** 中图 */
@property (nonatomic, copy) NSString *image2; // image2

/** 是否为动态图 */
@property (nonatomic, assign) BOOL is_gif;

/** 视频的时长 */
@property (nonatomic, assign) NSInteger videotime;
/** 音频的时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 播放数量 */
@property (nonatomic, assign) NSInteger playcount;
/**视频加载时候的静态显示的图片地址*/
@property (nonatomic,copy)NSString *cdn_img;
/**音频播放的地址*/
@property (nonatomic, copy)NSString *voiceuri;
/**视频播放的地址*/
@property (nonatomic, copy)NSString *videouri;

/** 最热评论 */
@property (nonatomic, strong) MYJComment *topComment;

/***** 额外增加的属性 ******/
/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
/** 中间内容的frame */
@property (nonatomic, assign) CGRect contentFrame;
/** 是否大图片 */
@property (nonatomic, assign, getter=isBigPicture) BOOL bigPicture;

@end
