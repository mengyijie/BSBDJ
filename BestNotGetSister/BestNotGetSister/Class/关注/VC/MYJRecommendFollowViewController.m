//
//  MYJRecommendFollowViewController.m
//  Confused
//
//  Created by 孟义杰 on 16/3/16.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJRecommendFollowViewController.h"
#import <AFNetworking.h>
#import "MYJCategoryCell.h"
#import "MYJUserCell.h"
#import "MYJFollowCategory.h"
#import "MYJFollowUser.h"
#import <MJRefresh.h>
#import <SVProgressHUD.h>
#import <MJExtension.h>
@interface MYJRecommendFollowViewController ()<UITableViewDataSource, UITableViewDelegate>
/** 左边👈 ←的类别表格 */
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
/** 右边👉 →的用户表格 */
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
/** 请求管理者 */
@property (nonatomic, weak) AFHTTPSessionManager *manager;
/** 左边👈 ←的类别数据 */
@property (nonatomic, strong) NSArray *categories;
@end


static NSString * const MYJCategoryCellId = @"category";
static NSString * const MYJUserCellId = @"user";


@implementation MYJRecommendFollowViewController

#pragma mark - 懒加载
- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTable];
    
    [self setupRefresh];
    
    [self loadCategories];

}
- (void)setupTable
{
    self.title = @"推荐关注";
    self.view.backgroundColor = MYJCommonBgColor;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIEdgeInsets inset = UIEdgeInsetsMake(MYJNavBarMaxY, 0, 0, 0);
    self.categoryTableView.contentInset = inset;
    self.categoryTableView.scrollIndicatorInsets = inset;
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MYJCategoryCell class]) bundle:nil] forCellReuseIdentifier:MYJCategoryCellId];
    self.categoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.userTableView.rowHeight = 70;
    self.userTableView.contentInset = inset;
    self.userTableView.scrollIndicatorInsets = inset;
    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MYJUserCell class]) bundle:nil] forCellReuseIdentifier:MYJUserCellId];
    self.userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setupRefresh
{
    self.userTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    
    self.userTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
}

#pragma mark -加载数据
- (void)loadCategories
{
    // 弹框
    [SVProgressHUD show];
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"category";
    params[@"c"] = @"subscribe";
    
    // 发送请求
    MYJWeakSelf;
    [self.manager GET:MYJRequestURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        
        // 字典数组 -> 模型数组
        weakSelf.categories = [MYJFollowCategory objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 刷新表格
        [weakSelf.categoryTableView reloadData];
        
        // 选中左边的第0行
        [weakSelf.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
        // 让右边表格进入下拉刷新
        [weakSelf.userTableView.mj_header beginRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)loadNewUsers
{
    // 取消之前的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    // 左边选中的类别的ID
    MYJFollowCategory *selectedCategory = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
    params[@"category_id"] = selectedCategory.id;
    
    // 发送请求
    MYJWeakSelf;
    [self.manager GET:MYJRequestURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // 重置页码为1
        selectedCategory.page = 1;
        
        // 存储总数
        selectedCategory.total = [responseObject[@"total"] integerValue];
        
        // 存储用户数据
        selectedCategory.users = [MYJFollowUser objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 刷新右边表格
        [weakSelf.userTableView reloadData];
        
        // 结束刷新
        [weakSelf.userTableView.header endRefreshing];
        
        if (selectedCategory.users.count >= selectedCategory.total) {
            // 这组的所有用户数据已经加载完毕
            weakSelf.userTableView.footer.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 结束刷新
        [weakSelf.userTableView.header endRefreshing];
    }];
}

- (void)loadMoreUsers
{
    // 取消之前的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    // 左边选中的类别的ID
    MYJFollowCategory *selectedCategory = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
    params[@"category_id"] = selectedCategory.id;
    // 页码
    NSInteger page = selectedCategory.page + 1;
    params[@"page"] = @(page);
    
    // 发送请求
    MYJWeakSelf;
    [self.manager GET:MYJRequestURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // 设置当前的最新页码
        selectedCategory.page = page;
        
        // 存储总数
        selectedCategory.total = [responseObject[@"total"] integerValue];
        
        // 追加新的用户数据到以前的数组中
        NSArray *newUsers = [MYJFollowUser objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [selectedCategory.users addObjectsFromArray:newUsers];
        
        // 刷新右边表格
        [weakSelf.userTableView reloadData];
        
        if (selectedCategory.users.count >= selectedCategory.total) {
            // 这组的所有用户数据已经加载完毕
            weakSelf.userTableView.mj_footer.hidden = YES;
        } else { // 还可能会有下一页用户数据
            // 结束刷新
            [weakSelf.userTableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 结束刷新
        [weakSelf.userTableView.mj_footer endRefreshing];
    }];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.categoryTableView) { // 左边的类别表格 👈 ←
        return self.categories.count;
    } else { // 右边的用户表格 👉 →
        // 左边选中的类别
        MYJFollowCategory *selectedCategory = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
        return selectedCategory.users.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.categoryTableView) { // 左边的类别表格 👈 ←
        MYJCategoryCell *cell =  [tableView dequeueReusableCellWithIdentifier:MYJCategoryCellId];
        
        cell.category = self.categories[indexPath.row];
        
        return cell;
    } else { // 右边的用户表格 👉 →
        MYJUserCell *cell = [tableView dequeueReusableCellWithIdentifier:MYJUserCellId];
        
        // 左边选中的类别
        MYJFollowCategory *selectedCategory = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
        cell.user = selectedCategory.users[indexPath.row];
        
        return cell;
    }
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.categoryTableView) { // 左边的类别表格 👈 ←
        MYJFollowCategory *selectedCategory = self.categories[indexPath.row];
        
        // 刷新右边的用户表格 👉 →
        // （MJRefresh的默认做法：表格有数据，就会自动显示footer，表格没有数据，就会自动隐藏footer）
        [self.userTableView reloadData];
        
        // 判断footer是否应该显示
        if (selectedCategory.users.count >= selectedCategory.total) {
            // 这组的所有用户数据已经加载完毕
            self.userTableView.mj_footer.hidden = YES;
        }
        
        // 判断是否有过用户数据
        if (selectedCategory.users.count == 0) { // 从未有过用户数据
            // 加载右边的用户数据
            [self.userTableView.mj_header beginRefreshing];
        }
    } else { // 右边的用户表格 👉 →
        MYJLog(@"点击了👉→的%zd行", indexPath.row);
    }
}


@end
