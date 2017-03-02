//
//  MYJPostWordToolbar.m
//  Confused
//
//  Created by mengyijie on 16/5/2.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJPostWordToolbar.h"
#import "MYJAddTagViewController.h"
#import "MYJNavigationController.h"

@interface MYJPostWordToolbar ()
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *topView;
/** 所有的标签label */
@property (nonatomic, strong) NSMutableArray *tagLabels;
/** 加号按钮 */
@property (nonatomic, weak) UIButton *addButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

@end
@implementation MYJPostWordToolbar
- (NSMutableArray *)tagLabels
{
    if (!_tagLabels) {
        _tagLabels = [NSMutableArray array];
    }
    return _tagLabels;
}

- (void)awakeFromNib
{
    // 加号按钮
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    [addButton sizeToFit];
    [addButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:addButton];
    self.addButton = addButton;
    
    // 默认传递2个标签
    [self createTagLabels:@[@"吐槽", @"糗事"]];
}

- (void)addClick
{
    MYJWeakSelf;
    MYJAddTagViewController *addTag = [[MYJAddTagViewController alloc] init];
    addTag.getTagsBlock = ^(NSArray *tags) {
        [weakSelf createTagLabels:tags];
    };
    addTag.tags = [self.tagLabels valueForKeyPath:@"text"];
    MYJNavigationController *nav = [[MYJNavigationController alloc] initWithRootViewController:addTag];
    
    // 拿到"窗口根控制器"曾经modal出来的“发表文字”所在的导航控制器
    UIViewController *vc = self.window.rootViewController.presentedViewController;
    [vc presentViewController:nav animated:YES completion:nil];
}

/**
 * 创建标签label
 */
- (void)createTagLabels:(NSArray *)tags
{
    // 移除所有的label
    // 让self.tagLabels数组中的所有对象执行removeFromSuperview方法
    [self.tagLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tagLabels removeAllObjects];
    
    // 所有的标签label
    for (int i = 0; i < tags.count; i++) {
        // 创建label
        UILabel *newTagLabel = [[UILabel alloc] init];
        newTagLabel.text = tags[i];
        newTagLabel.font = [UIFont systemFontOfSize:14];
        newTagLabel.backgroundColor = MYJTagBgColor;
        newTagLabel.textColor = [UIColor whiteColor];
        newTagLabel.textAlignment = NSTextAlignmentCenter;
        [self.topView addSubview:newTagLabel];
        [self.tagLabels addObject:newTagLabel];
        
        // 尺寸
        [newTagLabel sizeToFit];
        newTagLabel.height = MYJTagH;
        newTagLabel.width += 2 * MYJCommonSmallMargin;
    }
    
    // 重新布局子控件
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 所有的标签label
    for (int i = 0; i < self.tagLabels.count; i++) {
        // 创建label
        UILabel *newTagLabel = self.tagLabels[i];
        
        // 位置
        if (i == 0) {
            newTagLabel.x = 0;
            newTagLabel.y = 0;
        } else {
            // 上一个标签
            UILabel *previousTagLabel = self.tagLabels[i - 1];
            CGFloat leftWidth = CGRectGetMaxX(previousTagLabel.frame) + MYJCommonSmallMargin;
            CGFloat rightWidth = self.topView.width - leftWidth;
            if (rightWidth >= newTagLabel.width) {
                newTagLabel.x = leftWidth;
                newTagLabel.y = previousTagLabel.y;
            } else {
                newTagLabel.x = 0;
                newTagLabel.y = CGRectGetMaxY(previousTagLabel.frame) + MYJCommonSmallMargin;
            }
        }
    }
    
    // 加号按钮
    UILabel *lastTagLabel = self.tagLabels.lastObject;
    if (lastTagLabel) {
        CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + MYJCommonSmallMargin;
        CGFloat rightWidth = self.topView.width - leftWidth;
        if (rightWidth >= self.addButton.width) {
            self.addButton.x = leftWidth;
            self.addButton.y = lastTagLabel.y;
        } else {
            self.addButton.x = 0;
            self.addButton.y = CGRectGetMaxY(lastTagLabel.frame) + MYJCommonSmallMargin;
        }
    } else {
        self.addButton.x = 0;
        self.addButton.y = 0;
    }
    
    // 计算工具条的高度
    self.topViewHeight.constant = CGRectGetMaxY(self.addButton.frame);
    CGFloat oldHeight = self.height;
    self.height = self.topViewHeight.constant + self.bottomView.height + MYJCommonSmallMargin;
    self.y += oldHeight - self.height;
}



@end
