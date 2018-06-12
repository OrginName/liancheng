//
//  YSRegisterController.m
//  NeckPillow
//
//  Created by YanShuang Jiang on 2018/4/22.
//  Copyright © 2018年 DKMedical. All rights reserved.
//

#import "YSRegisterController.h"

@interface YSRegisterController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *nwePasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTF;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation YSRegisterController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup
- (void)initUI {
    self.registerBtn.layer.cornerRadius = 3;
}
#pragma mark - Event response
- (IBAction)getVerificationCodeBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (![YSTools isRightPhoneNumberFormat:_phoneTF.text]) {
        [YTAlertUtil showTempInfo:@"请填写正确的手机号码"];
        return;
    }
    //WeakSelf
    [YSNetworkTool POST:smsVerificationCode params:@{@"mobile": _phoneTF.text} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([YSNetworkTool isSuccessWithResp:responseObject]) {
            [YSTools DaojiShi:btn];
            [YTAlertUtil showTempInfo:responseObject[kMessage]];
        }else{
            [YTAlertUtil showTempInfo:responseObject[kMessage]];
        }
    } failure:nil];
}
- (IBAction)registerBtnClick:(id)sender {
    if ([YSTools dx_isNullOrNilWithObject:_phoneTF.text] || [YSTools dx_isNullOrNilWithObject:_verificationCodeTF.text] || [YSTools dx_isNullOrNilWithObject:_nwePasswordTF.text] || [YSTools dx_isNullOrNilWithObject:_confirmPasswordTF.text]) {
        [YTAlertUtil showTempInfo:@"请将信息填写完整"];
        return;
    }
    if (![YSTools isRightPhoneNumberFormat:_phoneTF.text]) {
        [YTAlertUtil showTempInfo:@"请填写正确的手机号码"];
        return;
    }
    if (![_nwePasswordTF.text isEqualToString:_confirmPasswordTF.text]) {
        [YTAlertUtil showTempInfo:@"两次密码输入不一致"];
        return;
    }
    WeakSelf
    [YSNetworkTool POST:registerUrl params:@{@"mobile":_phoneTF.text,@"password":_nwePasswordTF.text,@"verificationCode":_verificationCodeTF.text} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([YSNetworkTool isSuccessWithResp:responseObject]) {
            [YTAlertUtil showTempInfo:responseObject[kMessage]];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [YTAlertUtil showTempInfo:responseObject[kMessage]];
        }
    } failure:nil];
}
- (IBAction)termsOfUseBtnClick:(id)sender {
    
}
- (IBAction)privacyPolicyBtnClick:(id)sender {
    
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
