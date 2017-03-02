//
//  MYJTopic.m
//  Confused
//
//  Created by 孟义杰 on 16/2/18.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJTopic.h"
#import "MYJComment.h"
#import "MYJUser.h"

@implementation MYJTopic

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    if ([key isEqualToString:@"id"]) {
 //       self.ID = value;
    }
}

/** 帖子审核通过的时间 */
-(NSString *)created_at
{
    //日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    //NSString->NSDate
    NSDate *createAtDate = [fmt dateFromString:_created_at];
    //比较一下发帖时间和手机当前时间的差值
    NSDateComponents *cmps = [createAtDate intervalToNow];
    
    if(createAtDate.isThisYear){
        if(createAtDate.isToday){ //今天
            if(cmps.hour >= 1){//时间差距超过1小时
                return [NSString stringWithFormat:@"%zd小时前",cmps.hour];
            }else if(cmps.minute >=1){ //时间大于1分钟小于1小时
                return [NSString stringWithFormat:@"%zd分钟前",cmps.minute];
            }else{
                return @"刚刚";
            }
        }else if(createAtDate.isYesterday){ //昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:createAtDate];
        }else{ //今年其它时间
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:createAtDate];
        }
    }else { //非今年
        return _created_at;
    }
}

/** cell的高度 */
-(CGFloat)cellHeight
{
    if(_cellHeight == 0)
    {
        //cell的高度
        _cellHeight = MYJTopicTextY;
        
        //计算文字的高度
        CGFloat textW = MYJScreenW - 2 * MYJCommonMargin;
        CGFloat textH = [self.text boundingRectWithSize:CGSizeMake(textW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
        _cellHeight += textH + MYJCommonMargin;
        
        //中间内容的高度
        if(self.type != MYJTopicTypeWord)
        {
            CGFloat contentW = textW;
            
            //图片的高度 ＊ 内容的宽度 / 图片的宽度
            CGFloat contentH = self.height * contentW / self.width;
            if(contentH > MYJScreenH){
                //一旦图片的显示高度超过一个屏幕，就让图片的高度为200；
                contentH = 200;
                self.bigPicture = YES;
            }
            CGFloat contentX = MYJCommonMargin;
            CGFloat contentY = _cellHeight;
            self.contentFrame = CGRectMake(contentX, contentY, contentW, contentH);
            
            _cellHeight += contentH + MYJCommonMargin;
        }
        
        //最热评论
        if(self.topComment)
        {
            NSString *username = self.topComment.user.username;
            NSString *content = self.topComment.content;
            NSString *cmtText = [NSString stringWithFormat:@"%@ : %@",username,content];
            
            //评论内容的高度
            CGFloat cmtTextH = [cmtText boundingRectWithSize:CGSizeMake(textW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
            
            _cellHeight += MYJTopicTopCmtTopH + cmtTextH +MYJCommonMargin;
        }
        
        //工具条的高度
        _cellHeight += MYJTopicToolbarH +MYJCommonMargin;
    }
    return _cellHeight;
}


@end
