//
//  MYJMeViewController.m
//  Confused
//
//  Created by 孟义杰 on 16/2/17.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJMeViewController.h"
#import "MYJSettingViewController.h"
#import "MYJMeCell.h"
#import "MYJMeFooter.h"
#import "MYJLoginRegisterViewController.h"
@interface MYJMeViewController ()

@end

@implementation MYJMeViewController

static NSString * const MYJMeCellId = @"me";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupTable];
}

-(void)setupNav
{
    self.navigationItem.title = @"我的";
    //导航栏右边的内容
   // UIBarButtonItem *moonItem = [UIBarButtonItem itemWithImage:@"mine-moon-icon" highImage:@"mine-moon-icon-click" target:self action:@selector(moonClick)];
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self action:@selector(settingClick)];
    self.navigationItem.rightBarButtonItems = @[settingItem];

}

-(void)setupTable
{
    self.tableView.backgroundColor = MYJCommonBgColor;
    [self.tableView registerClass:[MYJMeCell class] forCellReuseIdentifier:MYJMeCellId];
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = MYJCommonMargin;
    // 设置内边距(-25代表：所有内容往上移动25)
    self.tableView.contentInset = UIEdgeInsetsMake(MYJCommonMargin - 35, 0, -20, 0);
    // 设置footer
    self.tableView.tableFooterView = [[MYJMeFooter alloc] init];
}


-(void)moonClick
{
    MYJLogFunc;
}

-(void)settingClick
{
    MYJSettingViewController *setting = [[MYJSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:setting animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MYJMeCell *cell  = [tableView dequeueReusableCellWithIdentifier:MYJMeCellId];
    if (indexPath.section == 0) {
        cell.textLabel.text = @"登录/注册";
        cell.imageView.image = [UIImage imageNamed:@"setup-head-default"];
    } else {
        cell.textLabel.text = @"离线下载";
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        MYJLoginRegisterViewController *loginRegister = [[MYJLoginRegisterViewController alloc] init];
        [self presentViewController:loginRegister animated:YES completion:nil];
    }
}

@end
