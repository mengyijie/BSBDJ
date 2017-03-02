//
//  MYJTabBarController.m
//  Confused
//
//  Created by 孟义杰 on 16/2/17.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJTabBarController.h"
#import "MYJNavigationController.h"
#import "MYJEssenceViewController.h"
#import "MYJNewViewController.h"
#import "MYJTabBar.h"
#import "MYJFriendTrendsViewController.h"
#import "MYJMeViewController.h"
@interface MYJTabBarController ()

@end

@implementation MYJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置item属性
    [self setupItem];
    
    //添加所有的子控制器
    [self setupChildVcs];
    // 处理TabBar
    [self setupTabBar];

}

#pragma mark --setupTabBar
- (void)setupTabBar
{
    [self setValue:[[MYJTabBar alloc] init] forKeyPath:@"tabBar"];
}


#pragma mark --添加所有的子控制器
-(void)setupChildVcs
{
    [self setupChildVc:[[MYJEssenceViewController alloc]init]title:@"精华" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
    [self setupChildVc:[[MYJNewViewController alloc] init] title:@"新帖" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];
    
    [self setupChildVc:[[MYJFriendTrendsViewController alloc] init] title:@"关注" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
    
    [self setupChildVc:[[MYJMeViewController alloc] initWithStyle:UITableViewStyleGrouped] title:@"我" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
}

/**
 * 添加一个子控制器
 * @param title 文字
 * @param image 图片
 * @param selectedImage 选中时的图片
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    //包装导航控制器
    MYJNavigationController *nav = [[MYJNavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
    
    //设置子控制器的tabbarItem
    nav.tabBarItem.title = title;
    nav.tabBarItem.image = [UIImage imageNamed:image];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
}

#pragma mark --设置item属性
-(void)setupItem
{
    // UIControlStateNormal状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    // 文字颜色
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    // 文字大小
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    
    // UIControlStateSelected状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    // 文字颜色
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
    
    // 统一给所有的UITabBarItem设置文字属性
    // 只有后面带有UI_APPEARANCE_SELECTOR的属性或方法, 才可以通过appearance对象来统一设置
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
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
