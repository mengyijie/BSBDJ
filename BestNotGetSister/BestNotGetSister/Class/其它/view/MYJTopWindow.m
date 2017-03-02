//
//  MYJTopWindow.m
//  Confused
//
//  Created by 孟义杰 on 16/2/18.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJTopWindow.h"
#import "MYJTopWindowViewController.h"
@implementation MYJTopWindow

static UIWindow *_window;

+(void)initialize
{
    _window= [[self alloc]init];
}

+(void)show
{
    _window.hidden = NO;
    _window.backgroundColor = [UIColor clearColor];
}

+(void)hide
{
    _window.hidden = YES;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.windowLevel = UIWindowLevelAlert;
        self.rootViewController = [[MYJTopWindowViewController alloc]init];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    frame = [UIApplication sharedApplication].statusBarFrame;
    [super setFrame:frame];
}

@end
