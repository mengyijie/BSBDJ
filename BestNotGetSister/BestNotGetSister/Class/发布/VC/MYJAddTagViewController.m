//
//  MYJAddTagViewController.m
//  Confused
//
//  Created by mengyijie on 16/5/2.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJAddTagViewController.h"
#import "MYJTagButton.h"
#import "MYJTagTextField.h"
#import <SVProgressHUD.h>
@interface MYJAddTagViewController ()<UITextFieldDelegate>
/**用来容纳所有按钮和文本框*/
@property (nonatomic,weak)UIView *contentView;
/**文本框*/
@property (nonatomic,weak)MYJTagTextField *textField;
/**提醒按钮*/
@property (nonatomic,weak)UIButton *tipButton;
/** 存放所有的标签按钮 */
@property (nonatomic, strong) NSMutableArray *tagButtons;
@end

@implementation MYJAddTagViewController

#pragma mark - 懒加载
-(NSMutableArray *)tagButtons
{
    if(!_tagButtons){
        _tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}

-(UIButton *)tipButton
{
    if(!_tipButton){
        //创建一个提醒按钮
        UIButton *tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tipButton addTarget:self action:@selector(tipClick) forControlEvents:UIControlEventTouchUpInside];
        tipButton.width = self.contentView.width;
        tipButton.height = MYJTagH;
        tipButton.x = 0;
        tipButton.titleLabel.font = [UIFont systemFontOfSize:14];
        tipButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        tipButton.contentEdgeInsets = UIEdgeInsetsMake(0, MYJCommonSmallMargin, 0, 0);
        [self.contentView addSubview:tipButton];
        _tipButton = tipButton;

    }
    return _tipButton;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNav];
    [self setupContentView];
    [self setupTextField];
    [self setupTags];
}

-(void)setupTags
{
    for (NSString *tag in self.tags) {
        self.textField.text = tag;
        [self tipClick];
    }
}

- (void)setupTextField
{
    MYJWeakSelf;
    
    MYJTagTextField *textField = [[MYJTagTextField alloc] init];
    [textField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
    textField.width = self.contentView.width;
    textField.height = MYJTagH;
    // 设置占位文字
    textField.placeholderColor = [UIColor grayColor];
    textField.placeholder = @"多个标签用逗号或者换行隔开";
    textField.delegate = self;
    [self.contentView addSubview:textField];
    [textField becomeFirstResponder];
    // 刷新的前提：这个控件已经被添加到父控件
    [textField layoutIfNeeded];
    self.textField = textField;
    
    // 设置点击删除键需要执行的操作
    textField.deleteBackwardOperation = ^{
        // 判断文本框是否有文字
        if (weakSelf.textField.hasText || weakSelf.tagButtons.count == 0) return;
        
        // 点击了最后一个标签按钮（删掉最后一个标签按钮）
        [weakSelf tagClick:weakSelf.tagButtons.lastObject];
    };
    
    // stackoverflow
}

#pragma mark - 监听
/**
 监听textField的文字改变
 */
- (void)textDidChange
{
    // 提醒按钮
    if (self.textField.hasText) {
        NSString *text = self.textField.text;
        NSString *lastChar = [text substringFromIndex:text.length - 1];
        if ([lastChar isEqualToString:@","]
            || [lastChar isEqualToString:@"，"]) { // 最后一个输入的字符是逗号
            // 去掉文本框最后一个逗号
            [self.textField deleteBackward];
            
            // 点击提醒按钮
            [self tipClick];
        } else { // 最后一个输入的字符不是逗号
            // 排布文本框
            [self setupTextFieldFrame];
            
            self.tipButton.hidden = NO;
            [self.tipButton setTitle:[NSString stringWithFormat:@"添加标签：%@", text] forState:UIControlStateNormal];
        }
    } else {
        self.tipButton.hidden = YES;
    }
}


- (void)setupContentView
{
    UIView *contentView = [[UIView alloc] init];
    contentView.x = MYJCommonSmallMargin;
    contentView.y = MYJNavBarMaxY + MYJCommonSmallMargin;
    contentView.width = self.view.width - 2 * contentView.x;
    contentView.height = self.view.height;
    [self.view addSubview:contentView];
    self.contentView = contentView;
}


-(void)setupNav
{
    self.title = @"添加标签";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)done
{
    // 将self.tagButtons中存放的所有对象的currentTitle属性值取出来，放到一个新的数组中，并返回
    NSArray *tags = [self.tagButtons valueForKeyPath:@"currentTitle"];
    !self.getTagsBlock ? : self.getTagsBlock(tags);
    
    // 2.关闭当前控制器
    [self dismissViewControllerAnimated:YES completion:nil];

}
#pragma mark - 提醒按钮的点击事件
- (void)tipClick
{
    if(self.textField.hasText == NO) return;
    if(self.tagButtons.count == 5)
    {
        [SVProgressHUD showErrorWithStatus:@"最多添加5个标签" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    //创建一个标签按钮
    MYJTagButton *newTagButton = [MYJTagButton buttonWithType:UIButtonTypeCustom];
    [newTagButton setTitle:self.textField.text forState:UIControlStateNormal];
    [newTagButton addTarget:self action:@selector(tagClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:newTagButton];
    //设置位置 - 参照最后一个标签按钮
     [self setupTagButtonFrame:newTagButton referenceTagButton:self.tagButtons.lastObject];
    // 添加到数组中
    [self.tagButtons addObject:newTagButton];
    
    // 排布文本框
    self.textField.text = nil;
    [self setupTextFieldFrame];
    
    // 隐藏提醒按钮
    self.tipButton.hidden = YES;

}


#pragma mark - 点击了标签按钮
- (void)tagClick:(MYJTagButton *)clickedTagButton
{
    //即将被删除的标签按钮的索引
    NSUInteger index = [self.tagButtons indexOfObject:clickedTagButton];
    //删除按钮
    [clickedTagButton removeFromSuperview];
    [self.tagButtons removeObject:clickedTagButton];
    //处理后面的标签按钮
    for(NSUInteger i = index; i< self.tagButtons.count; i++)
    {
        MYJTagButton *tagButton = self.tagButtons[i];
        //如果i不为0，就参照上一个标签按钮
        MYJTagButton *previousTagButton =(i==0)?nil:self.tagButtons[i-1];
        [self setupTagButtonFrame:tagButton referenceTagButton:previousTagButton];
    }
    // 排布文本框
    [self setupTextFieldFrame];
}
- (void)setupTextFieldFrame
{
    CGFloat textW = [self.textField.text sizeWithAttributes:@{NSFontAttributeName : self.textField.font}].width;
    textW = MAX(100, textW);
    
    MYJTagButton *lastTagButton = self.tagButtons.lastObject;
    if (lastTagButton == nil) {
        self.textField.x = 0;
        self.textField.y = 0;
    } else {
        CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + MYJCommonSmallMargin;
        CGFloat rightWidth = self.contentView.width - leftWidth;
        if (rightWidth >= textW) { // 跟新添加的标签按钮处在同一行
            self.textField.x = leftWidth;
            self.textField.y = lastTagButton.y;
        } else { // 换行
            self.textField.x = 0;
            self.textField.y = CGRectGetMaxY(lastTagButton.frame) + MYJCommonSmallMargin;
        }
    }
    
    // 排布提醒按钮
    self.tipButton.y = CGRectGetMaxY(self.textField.frame) + MYJCommonSmallMargin;
}

#pragma mark - 设置控件的frame
/**
 * 设置标签按钮的frame
 * @param tagButton 需要设置frame的标签按钮
 * @param referenceTagButton 计算tagButton的frame时参照的标签按钮
 */
- (void)setupTagButtonFrame:(MYJTagButton *)tagButton referenceTagButton:(MYJTagButton *)referenceTagButton
{
    // 没有参照按钮（tagButton是第一个标签按钮）
    if(referenceTagButton == nil)
    {
        tagButton.x = 0;
        tagButton.y = 0;
        return;
    }
    
    //tagButton不是第一个标签按钮
    CGFloat leftWidth = CGRectGetMaxX(referenceTagButton.frame) + MYJCommonSmallMargin;
    CGFloat rightWidth = self.contentView.width - leftWidth;
    if (rightWidth >= tagButton.width) { // 跟上一个标签按钮处在同一行
        tagButton.x = leftWidth;
        tagButton.y = referenceTagButton.y;
    } else { // 下一行
        tagButton.x = 0;
        tagButton.y = CGRectGetMaxY(referenceTagButton.frame) + MYJCommonSmallMargin;
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITextFieldDelegate>
/**
 点击右下角return按钮就会调用这个方法
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self tipClick];
    return YES;
}


@end
