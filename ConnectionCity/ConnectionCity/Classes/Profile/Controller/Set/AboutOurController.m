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
    switch (sender.tag) {
        case 1://检查更新
            {
                [YTAlertUtil showTempInfo:@"暂无更新"];
            }
            break;
        case 2://许可协议
        {
            AgreementController *agreementVC = [[AgreementController alloc]init];
            agreementVC.alias = useAgreement;
            [self.navigationController pushViewController:agreementVC animated:YES];
        }
            break;
        case 3://隐私条款
        {
            AgreementController *agreementVC = [[AgreementController alloc]init];
            agreementVC.alias = privacyAgreement;
            [self.navigationController pushViewController:agreementVC animated:YES];
        }
            break;
        case 4://联系我们
        {
            AgreementController *agreementVC = [[AgreementController alloc]init];
            agreementVC.alias = about;
            [self.navigationController pushViewController:agreementVC animated:YES];
        }
            break;
        default:
            break;
    }
}
@end
