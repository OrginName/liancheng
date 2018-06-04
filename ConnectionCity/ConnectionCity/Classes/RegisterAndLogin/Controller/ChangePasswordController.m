//
//  ChangePasswordController.m
//  NeckPillow
//
//  Created by YanShuang Jiang on 2018/4/22.
//  Copyright © 2018年 DKMedical. All rights reserved.
//

#import "ChangePasswordController.h"

@interface ChangePasswordController ()
@property (weak, nonatomic) IBOutlet UITextField *currentPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *nwePasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTF;

@end

@implementation ChangePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Event response
- (IBAction)commitBtnClick:(id)sender {
    if ([YSTools dx_isNullOrNilWithObject:_currentPasswordTF.text] || [YSTools dx_isNullOrNilWithObject:_nwePasswordTF.text] || [YSTools dx_isNullOrNilWithObject:_confirmPasswordTF.text]) {
        [YTAlertUtil showTempInfo:@"请将信息填写完整"];
        return;
    }
    if ([_currentPasswordTF.text isEqualToString:_nwePasswordTF.text]) {
        [YTAlertUtil showTempInfo:@"新旧密码不能相同"];
        return;
    }
    if (![_nwePasswordTF.text isEqualToString:_confirmPasswordTF.text]) {
        [YTAlertUtil showTempInfo:@"确认密码输入不正确"];
        return;
    }
    WeakSelf
    NSString *userid = [NSString stringWithFormat:@"%lu",(unsigned long)kAccount.userid];
//    [YSNetworkTool POSTData:updatepassword params:@{@"userid":userid ,@"newPassword":_nwePasswordTF.text,@"oldpPassword":_currentPasswordTF.text} progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        if ([responseObject isEqualToString:@"OK"]) {
//            [YTAlertUtil showTempInfo:@"修改成功"];
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//        }else{
//            [YTAlertUtil showTempInfo:responseObject];
//        }
//    } failure:nil];
}
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
