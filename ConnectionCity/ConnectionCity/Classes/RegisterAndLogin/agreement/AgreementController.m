//
//  AgreementController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AgreementController.h"
#import "AgreementMo.h"

@interface AgreementController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation AgreementController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    if (self.alias.length==0) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }else{
        self.title = @"详情";
        [self pageInfo];
    }
}
-(void)setUI{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"return-f" title:@"" EdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
}
-(void)back{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)pageInfo{
    WeakSelf
    [YSNetworkTool POST:pageInfo params:@{@"alias": self.alias} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        AgreementMo *mo = [AgreementMo mj_objectWithKeyValues:responseObject[kData]];
        weakSelf.navigationItem.title = mo.title;
        [weakSelf.webView loadHTMLString:mo.content baseURL:nil];
    } failure:nil];
}
//- (void)webViewDidStartLoad:(UIWebView *)webView{
//    [YTAlertUtil showHUDWithTitle:@"正在加载"];
//}
//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    [YTAlertUtil hideHUD];
//}
@end
