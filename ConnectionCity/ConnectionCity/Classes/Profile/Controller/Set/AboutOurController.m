//
//  AboutOurController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/8.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AboutOurController.h"
#import "AgreementController.h"

@interface AboutOurController ()

@end

@implementation AboutOurController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于连程";
}
- (IBAction)BtnClick:(UIButton *)sender {
    NSArray * arr = @[privacyAgreement,connectRule,useAgreement,userBehaviorStandard,serviceAgreement,about];
    if (sender.tag==1) {
        [YTAlertUtil showTempInfo:@"火热开发中..."];
    }else{
        AgreementController *agreementVC = [[AgreementController alloc]init];
        agreementVC.alias = arr[sender.tag-2];
        [self.navigationController pushViewController:agreementVC animated:YES];
    }
}
@end
