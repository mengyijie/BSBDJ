//
//  MYJTopicViewController.m
//  Confused
//
//  Created by 孟义杰 on 16/2/18.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJTopicViewController.h"
#import <AFNetworking.h>
#import "MYJTopic.h"
#import "MYJTopicCell.h"
#import "MYJNewViewController.h"
#import "MYJCommentViewController.h"
#import "MYJMyFooter.h"
#import <MJExtension.h>
#import <MJRefresh.h>
@interface MYJTopicViewController ()
/** 请求管理者*/
@property (nonatomic, weak)AFHTTPSessionManager *manager;
/** 所有帖子的数据*/
@property (nonatomic, strong)NSMutableArray *topics;
/** 用来加载下一页数据*/
@property (nonatomic, copy)NSString *maxtime;

@end

@implementation MYJTopicViewController
/**
 * 实现这个方法仅仅是为了消除警告（因为子类的type方法最终会覆盖父类的这个方法）
 */
-(MYJTopicType)type{ return 0;}


static NSString *const MYJTopicCellId = @"topic";

#pragma mark --懒加载  
-(AFHTTPSessionManager *)manager
{
    if(!_manager)
    {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTable];
    [self setupRefresh];
}

#pragma mark --setupRefresh
-(void)setupRefresh
{
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    //自动改变透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    //马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    //上拉刷新
    self.tableView.mj_footer = [MYJMyFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

-(NSString *)aParam
{
    //[a isKindOfClass:c] 判断a是否为c类型或者c的子类类型
    if([self.parentViewController isKindOfClass:[MYJNewViewController class]])
        return @"newlist";
    return @"list";
}

#pragma mark --加载最新的帖子数据
-(void)loadNewTopics
{
    //取消之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    //请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] =self.aParam;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    //发送请求
    MYJWeakSelf;
    [self.manager GET:MYJRequestURL parameters:params success:^(NSURLSessionDataTask *  task, id responseObject) {
        //字典数组－》模型数组
        weakSelf.topics = [MYJTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        //存储maxtime
        weakSelf.maxtime = responseObject[@"info"][@"maxtime"];
        
       
        
        //刷新表格
        [weakSelf.tableView reloadData];
        //结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
}


#pragma mark --加载更多数据
-(void)loadMoreTopics
{
    //取消之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    //请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.aParam;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    params[@"maxtime"] = self.maxtime;
    
    //发送请求
    MYJWeakSelf;
    [self.manager GET:MYJRequestURL parameters:params success:^(NSURLSessionDataTask *  task, id   responseObject) {
        // 字典数组 -> 模型数组
        NSArray *moreTopics = [MYJTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [weakSelf.topics addObjectsFromArray:moreTopics];
        
        // 存储maxtime
        weakSelf.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 结束刷新
        [weakSelf.tableView.footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 结束刷新
        [weakSelf.tableView.footer endRefreshing];
    }];
    
}

#pragma mark --创建tableview

-(void)setupTable
{
    self.tableView.backgroundColor = MYJCommonBgColor;
    //上左下右
    self.tableView.contentInset = UIEdgeInsetsMake(MYJTitlesViewH+MYJNavBarMaxY, 0, MYJTabBarH, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    //去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MYJTopicCell class]) bundle:nil] forCellReuseIdentifier:MYJTopicCellId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.topics.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYJTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:MYJTopicCellId];
    cell.topic = self.topics[indexPath.row];
    return cell;
}
#pragma mark --tableView 代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  设置cell的高 和中间内容的frame
    MYJTopic *topic = self.topics[indexPath.row];
    return topic.cellHeight;
}
//选中cell跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYJCommentViewController *comment = [[MYJCommentViewController alloc]init];
    comment.topic = self.topics[indexPath.row];
    [self.navigationController pushViewController:comment animated:YES];
}

@end
