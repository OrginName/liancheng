//
//  AgreementController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AgreementController.h"
#import "AgreementMo.h"

@interface AgreementController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation AgreementController
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.alias.length==0) {
        self.title = @"详情";
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }else
    [self pageInfo];
}
- (void)pageInfo{
    WeakSelf
    [YSNetworkTool POST:pageInfo params:@{@"alias": self.alias} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        AgreementMo *mo = [AgreementMo mj_objectWithKeyValues:responseObject[kData]];
        weakSelf.navigationItem.title = mo.title;
        [weakSelf.webView loadHTMLString:mo.content baseURL:nil];
    } failure:nil];
}
@end
