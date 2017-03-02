//
//  MYJComment.h
//  Confused
//
//  Created by 孟义杰 on 16/2/18.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MYJUser;

@interface MYJComment : NSObject

/**id*/
//@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *id;
/**文字内容*/
@property (nonatomic,copy) NSString *content;

/**用户*/
@property (nonatomic,strong) MYJUser *user;

/**点赞数*/
@property (nonatomic,assign) NSInteger like_count;

/**语音文件的路径*/
@property (nonatomic,copy) NSString *voiceuri;

/**语音文件的时长*/
@property (nonatomic,assign) NSInteger voicetime;

@end
