//
//  MYJPostWordViewController.m
//  Confused
//
//  Created by mengyijie on 16/5/2.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJPostWordViewController.h"
#import "MYJPlaceholderTextView.h"
#import "MYJPostWordToolbar.h"
@interface MYJPostWordViewController ()<UITextViewDelegate,UIAlertViewDelegate>
/** 文本框 */
@property (nonatomic, weak) MYJPlaceholderTextView *textView;
/** 工具条 */
@property (nonatomic, weak) MYJPostWordToolbar *toolbar;

@end

@implementation MYJPostWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupTextView];
    
    [self setupToolbar];
}

- (void)setupToolbar
{
    MYJPostWordToolbar *toolbar = [MYJPostWordToolbar viewFromXib];
    toolbar.x = 0;
    toolbar.y = self.view.height - toolbar.height;
    toolbar.width = self.view.width;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupNav
{
    self.title = @"发表文字";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(post)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    // 强制更新(能马上刷新现在的状态)
    [self.navigationController.navigationBar layoutIfNeeded];
}

- (void)setupTextView
{
    MYJPlaceholderTextView *textView = [[MYJPlaceholderTextView alloc] init];
    textView.frame = self.view.bounds;
    // 不管内容有多少，竖直方向上永远可以拖拽
    textView.alwaysBounceVertical = YES;
    textView.delegate = self;
    textView.placeholder = @"把好玩的图片，好笑的段子或糗事发到这里，接受千万网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理。";
    [self.view addSubview:textView];
    self.textView = textView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.textView becomeFirstResponder];
}

#pragma mark - 监听
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        // 工具条平移的距离 == 键盘最终的Y值 - 屏幕高度
        CGFloat ty = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y - MYJScreenH;
        self.toolbar.transform = CGAffineTransformMakeTranslation(0, ty);
    }];
}

- (void)post
{
    MYJLogFunc;//点击发表的响应方法
    //MYJLog(@"-----发表段子------");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您已发帖成功！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
    [alertView show];
   // [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <UITextViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
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
