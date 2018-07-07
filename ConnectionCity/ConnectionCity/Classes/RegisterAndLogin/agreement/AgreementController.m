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
    [self pageInfo];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pageInfo{
    WeakSelf
    [YSNetworkTool POST:pageInfo params:@{@"alias": self.alias} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        AgreementMo *mo = [AgreementMo mj_objectWithKeyValues:responseObject[kData]];
        weakSelf.navigationItem.title = mo.title;
        [weakSelf.webView loadHTMLString:mo.content baseURL:nil];
    } failure:nil];
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
