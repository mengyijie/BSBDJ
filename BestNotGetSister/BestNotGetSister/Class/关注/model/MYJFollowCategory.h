//
//  MYJFollowCategory.h
//  Confused
//
//  Created by 孟义杰 on 16/3/16.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYJFollowCategory : NSObject
/** id */
@property (nonatomic, copy) NSString *id;
/** 名字 */
@property (nonatomic, copy) NSString *name;

/** 这组的用户总数 */
@property (nonatomic, assign) NSInteger total;
/** 当前的页码 */
@property (nonatomic, assign) NSInteger page;
/** 这个类别对应的用户数据 */
@property (nonatomic, strong) NSMutableArray *users;

@end
