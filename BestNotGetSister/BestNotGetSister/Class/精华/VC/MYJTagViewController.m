//
//  MYJTagViewController.m
//  Confused
//
//  Created by 孟义杰 on 16/2/18.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJTagViewController.h"
#import "MYJTagCell.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import "MYJTag.h"
@interface MYJTagViewController ()
/**所有的标签数据*/
@property (nonatomic,strong)NSArray *tags;
/**请求管理者*/
@property (nonatomic,weak)AFHTTPSessionManager *manager;

@end
/**cell 的循环利用标识*/
static NSString * const MYJTagCellId = @"tag";

@implementation MYJTagViewController

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
    self.navigationItem.title = @"推荐标签";
    [self setupTable];
    [self loadTags];
    
}

-(void)loadTags
{
    // 弹框
    [SVProgressHUD show];
    // 加载标签数据
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"action"] = @"sub";
    params[@"c"] = @"topic";
    
    // 发送请求
    MYJWeakSelf;
    [self.manager GET:MYJRequestURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject == nil) {
            // 关闭弹框
            [SVProgressHUD showErrorWithStatus:@"加载标签数据失败"];
            return;
        }
        
        // responseObject：字典数组
        // weakSelf.tags：模型数组
        // responseObject -> weakSelf.tags
        weakSelf.tags = [MYJTag objectArrayWithKeyValuesArray:responseObject];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 关闭弹框
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 如果是取消了任务，就不算请求失败，就直接返回
        if (error.code == NSURLErrorCancelled) return;
        
        if (error.code == NSURLErrorTimedOut) {
            // 关闭弹框
            [SVProgressHUD showErrorWithStatus:@"加载标签数据超时，请稍后再试！"];
        } else {
            // 关闭弹框
            [SVProgressHUD showErrorWithStatus:@"加载标签数据失败"];
        }
    }];
}

-(void)setupTable
{
    self.tableView.backgroundColor = MYJCommonBgColor;
    // 设置行高
    self.tableView.rowHeight = 70;
    
    // 去掉系统自带的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MYJTagCell class]) bundle:nil] forCellReuseIdentifier:MYJTagCellId];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    // 停止请求
    [self.manager invalidateSessionCancelingTasks:YES];
    
    [SVProgressHUD dismiss];
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tags.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MYJTagCell *cell = [tableView dequeueReusableCellWithIdentifier:MYJTagCellId];
    
    cell.tagModel = self.tags[indexPath.row];
    
    return cell;
}

@end
