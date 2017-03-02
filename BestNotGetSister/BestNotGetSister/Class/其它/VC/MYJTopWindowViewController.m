//
//  MYJTopWindowViewController.m
//  Confused
//
//  Created by 孟义杰 on 16/2/18.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJTopWindowViewController.h"

@interface MYJTopWindowViewController ()

@end

@implementation MYJTopWindowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //取出所有的window
    NSArray *windows = [UIApplication sharedApplication].windows;
    //遍历程序中的所有控件
    for(UIWindow *window in windows)
    {
        [self searchSubviews:windows];
    }
}

#pragma mark --遍历superview内部的所有子控件
-(void)searchSubviews:(UIView*)superview
{
    for(UIScrollView *scrollView in superview.subviews)
    {
        [self searchSubviews:scrollView];
        
        //判断是否为scrollView
        if(![scrollView isKindOfClass:[UIScrollView class]]) continue;
        
        //计算出scrollview在window坐标系上的矩形框
        CGRect scrollViewRect = [scrollView convertRect:scrollView.bounds toView:scrollView.window];
        MYJLog(@"%f,%f",scrollViewRect.size.width,scrollViewRect.size.height);
        
        CGRect windowRect = scrollView.window.bounds;
        
        //判断scrollview的边框是否和window的边框交叉
        if(!CGRectIntersectsRect(scrollViewRect, windowRect)) continue;
        
        //让scrollView滚到最前面
        CGPoint offset = scrollView.contentOffset;
        //偏移量不一定是0
        offset.y = -scrollView.contentInset.top;
        [scrollView setContentOffset:offset animated:YES];
    }
}

-(BOOL)prefersStatusBarHidden
{
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
