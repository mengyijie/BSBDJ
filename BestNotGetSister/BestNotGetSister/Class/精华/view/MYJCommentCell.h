//
//  MYJCommentCell.h
//  Confused
//
//  Created by 孟义杰 on 16/2/23.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MYJComment;
@interface MYJCommentCell : UITableViewCell
/**评论模型数据*/
@property (nonatomic, strong)MYJComment *comment;
@end
