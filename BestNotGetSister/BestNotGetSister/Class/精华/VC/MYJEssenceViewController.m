//
//  MYJEssenceViewController.m
//  Confused
//
//  Created by 孟义杰 on 16/2/17.
//  Copyright © 2016年 孟义杰. All rights reserved.
//  精华页开始

#import "MYJEssenceViewController.h"
#import "MYJTitleButton.h"
#import "MYJTagViewController.h"
#import "MYJAllViewController.h"
#import "MYJPictureViewController.h"
#import "MYJVideoViewController.h"
#import "MYJVoiceViewController.h"
#import "MYJWordViewController.h"
@interface MYJEssenceViewController ()<UIScrollViewDelegate>

/** 这个scrollview的作用：存放所有子控制器的view*/
@property (nonatomic,weak) UIScrollView *scrollView;

/**标题栏*/
@property (nonatomic,weak) UIView *titlesView;

/**当前被选中的按钮*/
@property (nonatomic,weak)MYJTitleButton *selectedTitleButton;

/**标题底部的指示器*/
@property (nonatomic,weak) UIView *titleBottomView;

/**存放所有的标签按钮*/
@property (nonatomic,strong) NSMutableArray *titleButtons;

@end

@implementation MYJEssenceViewController


#pragma mark -- 懒加载
-(NSMutableArray *)titleButtons
{
    if(!_titleButtons)
    {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}

#pragma mark --初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupChildVcs];
    [self setupScrollView];
    [self setupTitlesView];
    
}

#pragma mark --setupScrollView
-(void)setupScrollView
{
    //关闭自动偏移
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = self.view.bounds;
    scrollView.backgroundColor = MYJCommonBgColor;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.width, 0);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    //默认显示第0个控制器
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

#pragma mark --setupTitlesView

-(void)setupTitlesView{
    
    //标签栏整体
    UIView *titlesView = [[UIView alloc]init];
    titlesView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
    titlesView.frame = CGRectMake(0, MYJNavBarMaxY, self.view.width, MYJTitlesViewH);
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    //标签内部的标签按钮
    NSUInteger count = self.childViewControllers.count;
    CGFloat titleButtonH = titlesView.height;
    CGFloat titleButtonW = titlesView.width / count;
    for(int i = 0; i < count; i++){
        //创建
        MYJTitleButton *titleButton = [MYJTitleButton buttonWithType:UIButtonTypeCustom];
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:titleButton];
        [self.titleButtons addObject:titleButton];
        
        //文字
        NSString *title = [self.childViewControllers[i] title];
        [titleButton setTitle:title forState:UIControlStateNormal];
        
        //frame
        titleButton.y = 0;
        titleButton.height = titleButtonH;
        titleButton.width = titleButtonW;
        titleButton.x = i * titleButton.width;
    }
    //标签栏底部的指示器控件
    UIView *titleBottomView = [[UIView alloc]init];
    titleBottomView.backgroundColor = [self.titleButtons.lastObject titleColorForState:UIControlStateSelected];
    titleBottomView.height = 1;
    titleBottomView.y = titlesView.height - titleBottomView.height;
    [titlesView addSubview:titleBottomView];
    self.titleBottomView = titleBottomView;
    
    //默认点击最前面的按钮
    MYJTitleButton *firstTitleButton = self.titleButtons.firstObject;
    //根据label里的文字来自动适应尺寸
    [firstTitleButton.titleLabel sizeToFit];
    titleBottomView.width = firstTitleButton.titleLabel.width;
    titleBottomView.centerX = firstTitleButton.centerX;
    [self titleClick:firstTitleButton];
}

#pragma mark --监听点击了哪个title
-(void)titleClick:(MYJTitleButton *)titleButton
{
    //控制按钮状态
    self.selectedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.selectedTitleButton = titleButton;
    
    //底部控件的位置和尺寸
    [UIView animateWithDuration:0.25 animations:^{
        self.titleBottomView.width = titleButton.titleLabel.width;
        self.titleBottomView.centerX = titleButton.centerX;
    }];
    
    //让scrollView滚动到对应的位置
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = self.view.width *[self.titleButtons indexOfObject:titleButton];
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark --setupChildVcs
-(void)setupChildVcs
{
    MYJAllViewController *all = [[MYJAllViewController alloc]init];
    all.title = @"全部";
    [self addChildViewController:all];
    
    MYJPictureViewController *picture = [[MYJPictureViewController alloc]init];
    picture.title = @"图片";
    [self addChildViewController:picture];
    
    MYJVideoViewController *video = [[MYJVideoViewController alloc]init];
    video.title = @"精彩视频";
    [self addChildViewController:video];
    
    MYJVoiceViewController *voice = [[MYJVoiceViewController alloc]init];
    voice.title = @"声音";
    [self addChildViewController:voice];
    
    MYJWordViewController *word = [[MYJWordViewController alloc]init];
    word.title = @"内涵段子";
    [self addChildViewController:word];
}

#pragma mark --setupNav
-(void)setupNav
{
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    //导航栏左边的内容
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
}

#pragma mark --左上角按钮点击
-(void)tagClick
{
    MYJTagViewController *tag = [[MYJTagViewController alloc]init];
    [self.navigationController pushViewController:tag animated:YES];
}


#pragma mark - <UIScrollViewDelegate>

/**
 * 当滚动动画完毕的时候调用（通过代码setContentOffset:animated:让scrollView滚动完毕后，就会调用这个方法）
 * 如果执行完setContentOffset:animated:后，scrollView的偏移量并没有发生改变的话，就不会调用scrollViewDidEndScrollingAnimation:方法
 */

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //取出对应的子控制器
    int index = scrollView.contentOffset.x / scrollView.width;
    UIViewController *willShowChildVC = self.childViewControllers[index];
    //如果控制器的view已经被创建过，就直接返回
    if (willShowChildVC.isViewLoaded) {
        return;
    }
    
    //添加子控制器的view到scrollview身上
    willShowChildVC.view.frame = scrollView.bounds;
    [scrollView addSubview:willShowChildVC.view];
}

/**
 * 当减速完毕的时候调用（人为拖拽scrollView，手松开后scrollView慢慢减速完毕到静止）
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    //点击按钮
    int index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:self.titleButtons[index]];
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
