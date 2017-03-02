//
//  MYJUser.h
//  Confused
//
//  Created by 孟义杰 on 16/2/18.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYJUser : NSObject
/**用户名*/
@property (nonatomic,copy) NSString *username;
/**性别*/
@property (nonatomic,copy) NSString *sex;
/**头像*/
@property (nonatomic,copy) NSString *profile_image;
@end
