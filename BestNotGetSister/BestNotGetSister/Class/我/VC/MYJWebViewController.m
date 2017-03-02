//
//  MYJWebViewController.m
//  Confused
//
//  Created by mengyijie on 16/5/8.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "MYJWebViewController.h"
#import "MYJSquare.h"
@interface MYJWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardItem;
@end

@implementation MYJWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.square.name;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.square.url]]];
    
    self.webView.backgroundColor = MYJCommonBgColor;
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back {
    [self.webView goBack];
}

- (IBAction)forward {
    [self.webView goForward];
}

- (IBAction)refresh {
    [self.webView reload];
}

#pragma mark - <UIWebViewDelegate>
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.backItem.enabled = webView.canGoBack;
    self.forwardItem.enabled = webView.canGoForward;
}


@end
