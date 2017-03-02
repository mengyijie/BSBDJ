//
//  MYJTabBar.m
//  Confused
//
//  Created by 孟义杰 on 16/2/17.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJTabBar.h"
#import "MYJPublishViewController.h"

@interface MYJTabBar ()
@property (nonatomic, weak) UIButton *publishBtn;
@end
@implementation MYJTabBar

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        //设置背景图片
        self.backgroundImage = [UIImage imageNamed:@"tabbar-light"];
        
        //添加发布按钮
        UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishBtn setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        
        [publishBtn setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [publishBtn sizeToFit];
        [publishBtn addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:publishBtn];
        self.publishBtn = publishBtn;
    }
    return self;
}

-(void)publishClick
{
    MYJPublishViewController *vc = [[MYJPublishViewController alloc]init];
    [self.window.rootViewController presentViewController:vc animated:NO completion:nil];
}


#pragma mark -布局子控件
-(void)layoutSubviews
{
    [super layoutSubviews];
    //tabbar的尺寸
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    //设置发布按钮的位置
    self.publishBtn.center = CGPointMake(width * 0.5, height *0.5);
    //按钮索引
    int index = 0;
    //按钮的尺寸
    CGFloat tabbarBtnW = width / 5;
    CGFloat tabbarBtnH = height;
    CGFloat tabbarBtnY = 0;
    
    //设置4个按钮的frame
    for (UIView *tabbarBtn in self.subviews ) {
        if(![NSStringFromClass(tabbarBtn.class) isEqualToString:@"UITabBarButton"])
            continue;
        //计算按钮的x值
        CGFloat tabbarBtnX = index *tabbarBtnW;
        if(index >=2)
        {
            tabbarBtnX +=tabbarBtnW;
        }
        tabbarBtn.frame = CGRectMake(tabbarBtnX, tabbarBtnY, tabbarBtnW, tabbarBtnH);
        index ++;
    }
}

@end
