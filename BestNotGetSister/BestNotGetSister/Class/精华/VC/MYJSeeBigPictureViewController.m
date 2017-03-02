//
//  MYJSeeBigPictureViewController.m
//  Confused
//
//  Created by 孟义杰 on 16/2/23.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJSeeBigPictureViewController.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>
#import "MYJTopic.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface MYJSeeBigPictureViewController ()<UIScrollViewDelegate>
/**图片*/
@property(nonatomic,weak)UIImageView *imageView;
/**相册库*/
@property(nonatomic,strong)ALAssetsLibrary *library;

@end

@implementation MYJSeeBigPictureViewController

-(ALAssetsLibrary *)library
{
    if(_library)
    {
        _library = [[ALAssetsLibrary alloc]init];
    }
    return _library;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //滚动控件
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = [UIScreen mainScreen].bounds;
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.delegate = self;
    [self.view insertSubview:scrollView atIndex:0];
    
    //图片
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.image1]];
    [scrollView addSubview:imageView];
    self.imageView = imageView;
    
    //图片的尺寸
    imageView.x = 0;
    imageView.width = MYJScreenW;
    imageView.height = self.topic.height * imageView.width / self.topic.width;
    if(imageView.height > MYJScreenH)//图片过长
    {
        imageView.y = 0;
        scrollView.contentSize = CGSizeMake(0, imageView.height);
    }else{//居中显示
        imageView.centerY = MYJScreenH * 0.5;
    }
    
    //伸缩
    CGFloat maxScale = self.topic.height / imageView.height;
    if(maxScale > 1.0)
    {
        scrollView.maximumZoomScale = maxScale;
    }
}

- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

static NSString * const MYJGroupNameKey = @"MYJGroupNameKey";
static NSString * const MYJDefaultGroupName = @"我的百思不得姐";

-(NSString *)groupName
{
    //先从沙盒中取得名字
    NSString *groupName = [[NSUserDefaults standardUserDefaults]stringForKey:MYJGroupNameKey];
    if(groupName == nil){//沙盒中没有存储任何文件夹得名字
        groupName = MYJDefaultGroupName;
        //存储名字到沙盒
        [[NSUserDefaults standardUserDefaults] setObject:groupName forKey:MYJGroupNameKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return groupName;
}

- (IBAction)save:(UIButton *)sender {
    //获得文件夹的名字
    __block NSString *groupName = [self groupName];
    MYJWeakSelf;
    //图片库
    __weak ALAssetsLibrary *weakLibrary = self.library;
    //创建文件夹
    [weakLibrary addAssetsGroupAlbumWithName:groupName resultBlock:^(ALAssetsGroup *group) {
        if(group){//新创建的文件夹
            //添加图片到文件夹中
            [weakSelf addImageToGroup:group];
        }else//文件夹已经存在
        {
            [weakLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                NSString *name = [group valueForKey:ALAssetsGroupPropertyName];
                if([name isEqualToString:groupName])//是自己创建的文件夹
                {
                    //添加图片到文件夹中
                    [weakSelf addImageToGroup:group];
                    *stop = YES;//停止遍历
                    
                }else if([name isEqualToString:@"Camera Roll"]){
                    //文件夹被用户强制删除了
                    groupName = [groupName stringByAppendingString:@" "];
                    //存储新的名字
                    [[NSUserDefaults standardUserDefaults]setObject:groupName forKey:MYJGroupNameKey];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    // 创建新的文件夹
                    [weakLibrary addAssetsGroupAlbumWithName:groupName resultBlock:^(ALAssetsGroup *group) {
                        [weakSelf addImageToGroup:group];
                    } failureBlock:^(NSError *error) {
                    }];
                }
            } failureBlock:^(NSError *error) {
                
            }];
        }
    } failureBlock:^(NSError *error) {
    }];
}

#pragma mark --添加一张图片到某个文件夹中
-(void)addImageToGroup:(ALAssetsGroup *)group
{
    __weak ALAssetsLibrary *weakLibrary = self.library;
    //需要保存的图片
    CGImageRef image = self.imageView.image.CGImage;
    //添加图片到【相机胶卷】
    [weakLibrary writeImageToSavedPhotosAlbum:image metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        [weakLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            //添加一张图片到自定义的文件夹中
            [group addAsset:asset];
            [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
        } failureBlock:nil];
    }];
}

-(void)getAllPhotos
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    //遍历所以得文件夹，一个ALAssetsGroup对象就代表一个文件夹
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        //遍历文件夹内的所有多媒体文件，一个ALAsset对象就代表一张图片
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            MYJLog(@"%@",[UIImage imageWithCGImage:result.thumbnail]);
        }];
    } failureBlock:nil];
}

#pragma mark--UIScrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
