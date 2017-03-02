//
//  MYJTag.h
//  Confused
//
//  Created by mengyijie on 16/2/28.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYJTag : NSObject
/** 图片 */
@property (nonatomic, copy) NSString *image_list;
/** 订阅数 */
@property (nonatomic, assign) NSInteger sub_number;
/** 名字 */
@property (nonatomic, copy) NSString *theme_name;
@end
