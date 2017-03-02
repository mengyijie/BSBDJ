//
//  MYJSettingViewController.m
//  Confused
//
//  Created by mengyijie on 16/5/8.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJSettingViewController.h"
#import "MYJClearCacheCell.h"
#import "MYJThirdCell.h"
#import <SDImageCache.h>
@interface MYJSettingViewController ()

@end

@implementation MYJSettingViewController

static NSString * const MYJClearCacheCellId = @"clearCache";
static NSString * const MYJOtherCellId = @"other";
static NSString * const MYJThirdCellId = @"third";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = MYJCommonBgColor;
    
    [self.tableView registerClass:[MYJClearCacheCell class] forCellReuseIdentifier:MYJClearCacheCellId];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MYJOtherCellId];
    [self.tableView registerClass:[MYJThirdCell class] forCellReuseIdentifier:MYJThirdCellId];
    //设置内边距(-25代表：所有内容向上移动25)
    self.tableView.contentInset = UIEdgeInsetsMake(MYJCommonMargin-35, 0, 0, 0);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        MYJClearCacheCell *cell = [tableView dequeueReusableCellWithIdentifier:MYJClearCacheCellId];
        [cell updateStatus];
        return cell;
    }else if(indexPath.section ==1 && indexPath.row ==2)
    {
        return [tableView dequeueReusableCellWithIdentifier:MYJThirdCellId];
    }else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MYJOtherCellId];
        cell.textLabel.text = [NSString stringWithFormat:@"%zd-%zd",indexPath.section,indexPath.row];
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        MYJClearCacheCell *cell = (MYJClearCacheCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell clearCache];
    }
}
@end
