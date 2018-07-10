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
            
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
