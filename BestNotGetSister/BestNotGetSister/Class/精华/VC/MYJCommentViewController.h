//
//  MYJCommentViewController.h
//  Confused
//
//  Created by 孟义杰 on 16/2/22.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MYJTopic;
@interface MYJCommentViewController : UIViewController
/**帖子模型*/
@property (nonatomic, strong)MYJTopic *topic;
@end
