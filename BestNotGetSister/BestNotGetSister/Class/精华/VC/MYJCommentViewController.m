//
//  MYJCommentViewController.m
//  Confused
//
//  Created by 孟义杰 on 16/2/22.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJCommentViewController.h"
#import "MYJTopicCell.h"
#import "MYJTopic.h"
#import "MYJComment.h"
#import "MYJUser.h"
#import "MYJCommentCell.h"
#import "MYJCommentHeaderView.h"
#import <MJRefresh.h>
#import <AFNetworking.h>
#import <MJExtension.h>
@interface MYJCommentViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
/**请求管理者*/
@property (nonatomic,weak)AFHTTPSessionManager *manager;
/**暂时存储：最热评论*/
@property (nonatomic,strong) MYJComment *topComment;
/**最热评论*/
@property (nonatomic,strong)NSArray *hotComments;
/**最新评论（所有的评论数据）*/
@property (nonatomic,strong)NSMutableArray *latestComments;

@property (weak,nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
-(MYJComment *)selectedComment;
@end

@implementation MYJCommentViewController

#pragma mark --懒加载
-(AFHTTPSessionManager *)manager
{
    if(!_manager)
    {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

static NSString * const MYJCommentCellId = @"comment";
static NSString * const MYJHeaderId = @"header";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"comment_nav_item_share_icon" highImage:@"comment_nav_item_share_icon_click" target:nil action:nil];
    _textField.delegate = self;
    //通知监听键盘的升降
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self setupTable];
    [self setupRefresh];
    
}
#pragma mark --steupTable
-(void)setupTable
{
    self.tableView.backgroundColor = MYJCommonBgColor;
    //去掉cell的线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MYJCommentCell class]) bundle:nil] forCellReuseIdentifier:MYJCommentCellId];
    [self.tableView registerClass:[MYJCommentHeaderView class] forHeaderFooterViewReuseIdentifier:MYJHeaderId];
    //估计行高
    self.tableView.estimatedRowHeight = 100;
    //自适应
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //处理模型
    if(self.topic.topComment)
    {
        self.topComment = self.topic.topComment;
        self.topic.topComment = nil;
        self.topic.cellHeight = 0;
    }
    
    //cell
    MYJTopicCell *cell = [MYJTopicCell viewFromXib];
    cell.topic = self.topic;
    cell.frame = CGRectMake(0, 0, MYJScreenW, self.topic.cellHeight);
    //设置header
    UIView *header = [[UIView alloc]init];
    header.height = cell.height + 2*MYJCommonMargin;
    [header addSubview:cell];
    
    self.tableView.tableHeaderView = header;
}

#pragma mark --setupRefresh
-(void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];

    
}

-(void)dealloc
{
    //通知要手动移除的
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 恢复帖子的最热评论数据
    if (self.topComment) {
        self.topic.topComment = self.topComment;
        self.topic.cellHeight = 0;
    }

}

#pragma mark - 加载评论数据
- (void)loadNewComments
{
    // 取消之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.id;
    params[@"hot"] = @1;
    
    // 发送请求
    MYJWeakSelf;
    [self.manager GET:MYJRequestURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            // 意味着没有评论数据
            
            // 结束刷新
            [weakSelf.tableView.mj_header endRefreshing];
            
            // 返回
            return;
        }
        
        // 最热评论
        weakSelf.hotComments = [MYJComment objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        
        // 最新评论
        weakSelf.latestComments = [MYJComment objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
        
        // 判断评论数据是否已经加载完全
        if (self.latestComments.count >= [responseObject[@"total"] intValue]) {
            // 已经完全加载完毕
            //            [weakSelf.tableView.footer noticeNoMoreData];
            weakSelf.tableView.mj_footer.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreComments
{
    // 取消之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.id;
    params[@"lastcid"] = [self.latestComments.lastObject id];
    
    // 发送请求
    MYJWeakSelf;
    [self.manager GET:MYJRequestURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
       
        // 最新评论
        NSArray *newComments = [MYJComment objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.latestComments addObjectsFromArray:newComments];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 判断评论数据是否已经加载完全
        if (self.latestComments.count >= [responseObject[@"total"] intValue]) {
            // 已经完全加载完毕
            //            [weakSelf.tableView.footer noticeNoMoreData];
            weakSelf.tableView.mj_footer.hidden = YES;
        } else { // 应该还会有下一页数据
            // 结束刷新(恢复到普通状态，仍旧可以继续刷新)
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 结束刷新
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark --键盘监听
-(void)keyboardWillChangeFrame:(NSNotification *)note
{
    //工具条平移的距离 ＝＝ 屏幕高度 －键盘最终的Y值
    self.bottomSpace.constant = MYJScreenH - [note.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue].origin.y;
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark --点击空白控制键盘升落
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textField resignFirstResponder];
}

#pragma mark -- 点击return 键盘降落
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];//rerurn 键
    return YES;
    
}


#pragma mark --UItableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.hotComments.count) return 2;
    if(self.latestComments.count) return 1;
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section ==0 && self.hotComments.count)
    {
        return self.hotComments.count;
    }
    return self.latestComments.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYJCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:MYJCommentCellId];
    //获得对应的评论数据
    NSArray *comments = self.latestComments;
    if(indexPath.section == 0 && self.hotComments.count)
    {
        comments = self.hotComments;
    }
    //传递模型给cell
    cell.comment = comments[indexPath.row];
    return cell;
}

#pragma mark --UITableViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

//头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MYJCommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MYJHeaderId];
    //覆盖文字
    if(section == 0 && self.hotComments.count)
    {
        header.text = @"最热评论";
    }else{
        header.text = @"最新评论";
    }
    return header;
}
//选中cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取出cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    //设置菜单内容
    menu.menuItems = @[[[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)],
                       [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(reply:)],
                       [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(warn:)]
                       ];
    //显示位置
    CGRect rect = CGRectMake(0, cell.height*0.5, cell.width, 1);
    [menu setTargetRect:rect inView:cell];
    //显示出来
    [menu setMenuVisible:YES animated:YES];
}

#pragma mark --获得当前选中的评论
-(MYJComment *)selectedComment
{
    //获得被选中的cell的行号
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    NSInteger row = indexPath.row;
    //获得评论数据
    NSArray *comments = self.latestComments;
    if(indexPath.section == 0 &&self.hotComments.count )
    {
        comments = self.hotComments;
    }
    return comments[row];
}

#pragma mark --UIMenuController处理
//成为第一响应者
-(BOOL)canBecomeFirstResponder
{
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(!self.isFirstResponder){// 文本框弹出键盘, 文本框才是第一响应者
        if(action ==@selector(ding:)
           ||action ==@selector(reply:)
           ||action ==@selector(warn:))
            return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

#warning mark---应该在下面的方法里请求接口上传评论数据，再刷新显示

#pragma mark --顶 回复 举报 的响应方法
- (void)ding:(UIMenuController *)menu
{
    MYJLog(@"ding - %@ %@",
           self.selectedComment.user.username,
           self.selectedComment.content);
}

- (void)reply:(UIMenuController *)menu
{
    MYJLog(@"reply - %@ %@",
           self.selectedComment.user.username,
           self.selectedComment.content);
}

- (void)warn:(UIMenuController *)menu
{
    MYJLog(@"warn - %@ %@",
           self.selectedComment.user.username,
           self.selectedComment.content);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
