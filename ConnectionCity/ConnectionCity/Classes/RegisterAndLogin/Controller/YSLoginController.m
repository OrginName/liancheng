//
//  YSLoginController.m
//  NeckPillow
//
//  Created by YanShuang Jiang on 2018/4/22.
//  Copyright © 2018年 DKMedical. All rights reserved.
//

#import "YSLoginController.h"
#import "YSRegisterController.h"

@interface YSLoginController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation YSLoginController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event response
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)loginBtnClick:(id)sender {
    if ([YSTools dx_isNullOrNilWithObject:_phoneTF.text] || [YSTools dx_isNullOrNilWithObject:_passwordTF.text]) {
        [YTAlertUtil showTempInfo:@"请将信息填写完整"];
        return;
    }
    if (![YSTools isRightPhoneNumberFormat:_phoneTF.text]) {
        [YTAlertUtil showTempInfo:@"请填写正确的手机号码"];
        return;
    }
    WeakSelf
    [YSNetworkTool POST:loginURL params:@{@"phone":_phoneTF.text,@"password":_passwordTF.text} progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (![YSTools dx_isNullOrNilWithObject:responseObject]) {
            YSAccount *account = [YSAccount mj_objectWithKeyValues:responseObject];
            [YSAccountTool saveAccount:account];
            [YTAlertUtil showTempInfo:@"登录成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [YTAlertUtil showTempInfo:@"用户名或密码错误"];
        }
    } failure:nil];
    
}
- (IBAction)offlineScanEntryBtnClick:(id)sender {
    
}
- (IBAction)registerBtnClick:(id)sender {
    YSRegisterController *registerVC = [[YSRegisterController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
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
