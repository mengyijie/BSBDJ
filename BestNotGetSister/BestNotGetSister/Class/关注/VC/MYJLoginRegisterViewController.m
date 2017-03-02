//
//  MYJLoginRegisterViewController.m
//  Confused
//
//  Created by 孟义杰 on 16/3/7.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJLoginRegisterViewController.h"
#import "MYJLoginRegisterTextField.h"
#import "MYJTopWindow.h"
#import "UMSocial.h"
@interface MYJLoginRegisterViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSpace;
@end

@implementation MYJLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MYJTopWindow hide];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [MYJTopWindow show];
}

- (IBAction)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * 让状态栏样式为白色
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)loginOrRegister:(UIButton *)button {
    // 修改约束
    if (self.leftSpace.constant == 0) {
        self.leftSpace.constant = - self.view.width;
        button.selected = YES;
//        [button setTitle:@"已有帐号？" forState:UIControlStateNormal];
    } else {
        self.leftSpace.constant = 0;
        button.selected = NO;
//        [button setTitle:@"注册帐号" forState:UIControlStateNormal];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}
//QQ快速登录
- (IBAction)qqLoginBtn:(UIButton *)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
        }});

}
//新浪微博快速登录
- (IBAction)xlLoginBtn:(UIButton *)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            //登录成功 要跳转的界面 在此设置
        }});
}
//腾讯微博快速登录
- (IBAction)txLoginBtn:(UIButton *)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToTencent];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //          获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToTencent];
            NSLog(@"username is %@, uid is %@, token is %@ iconUrl is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
        }

    });
}
@end
