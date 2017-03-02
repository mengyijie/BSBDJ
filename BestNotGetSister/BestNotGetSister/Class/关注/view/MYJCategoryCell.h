//
//  MYJCategoryCell.h
//  Confused
//
//  Created by 孟义杰 on 16/3/16.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYJFollowCategory;
@interface MYJCategoryCell : UITableViewCell
/** 类别模型 */
@property (nonatomic, strong) MYJFollowCategory *category;
@end
