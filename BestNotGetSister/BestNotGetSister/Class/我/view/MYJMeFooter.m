//
//  MYJMeFooter.m
//  Confused
//
//  Created by mengyijie on 16/5/8.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJMeFooter.h"
#import <AFNetworking.h>
#import "MYJSquare.h"
#import <MJExtension.h>
#import "MYJSquareButton.h"
#import "MYJWebViewController.h"
@implementation MYJMeFooter

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 请求参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";
        
        // 发送请求
        MYJWeakSelf;
        [[AFHTTPSessionManager manager] GET:MYJRequestURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
             [weakSelf createSquares:[MYJSquare objectArrayWithKeyValuesArray:responseObject[@"square_list"]]];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    return self;
}

/**
 * 创建方块
 */
- (void)createSquares:(NSArray *)squares
{
    // 每行的列数
    int colsCount = 4;
    
    // 按钮尺寸
    CGFloat buttonW = self.width / colsCount;
    CGFloat buttonH = buttonW;
    
    // 遍历所有的模型
    NSMutableArray *btnArray = [NSMutableArray array];
    for(NSUInteger i = 0; i<squares.count; i++ ){
        // 创建按钮
        MYJSquareButton *button = [MYJSquareButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        // 设置模型数据
        button.square = squares[i];
        if ([button.square.url hasPrefix:@"http"] != NO){
            [btnArray addObject:button];
        }
    }
    
    NSUInteger count = btnArray.count;
    for (NSUInteger i = 0; i < count; i++) {
        MYJSquareButton *button = btnArray[i];
        [self addSubview:button];
        // frame
        CGFloat buttonX = (i % colsCount) * buttonW;
        CGFloat buttonY = (i / colsCount) * buttonH;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        // 设置footer的高度
        self.height = CGRectGetMaxY(button.frame);
    }
    // 重新设置footerView
    UITableView *tableView = (UITableView *)self.superview;
    tableView.tableFooterView = self;
}

- (void)buttonClick:(MYJSquareButton *)button
{
    if ([button.square.url hasPrefix:@"http"] == NO) return;
    
    MYJWebViewController *webVc = [[MYJWebViewController alloc] init];
    webVc.square = button.square;
    
    // 取出当前选中的导航控制器
    UITabBarController *rootVc = (UITabBarController *)self.window.rootViewController;
    UINavigationController *nav = (UINavigationController *)rootVc.selectedViewController;
    [nav pushViewController:webVc animated:YES];
}



@end
