//
//  MYJFriendTrendsViewController.m
//  Confused
//
//  Created by 孟义杰 on 16/2/17.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJFriendTrendsViewController.h"
#import "MYJLoginRegisterViewController.h"
#import "MYJRecommendFollowViewController.h"
@interface MYJFriendTrendsViewController ()

@end

@implementation MYJFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MYJCommonBgColor;
    self.navigationItem.title = @"我的关注";
    
    // 导航栏左边的内容
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" highImage:@"friendsRecommentIcon-click" target:self action:@selector(friendsRecommendClick)];
}


- (void)friendsRecommendClick{
    MYJRecommendFollowViewController *follow = [[MYJRecommendFollowViewController alloc] init];
    [self.navigationController pushViewController:follow animated:YES];

}

- (IBAction)loginRegister:(UIButton *)sender {

    MYJLoginRegisterViewController *loginRegister = [[MYJLoginRegisterViewController alloc] init];
    [self presentViewController:loginRegister animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
