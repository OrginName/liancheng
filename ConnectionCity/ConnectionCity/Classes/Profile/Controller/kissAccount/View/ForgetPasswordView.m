//
//  ForgetPasswordView.m
//  ConnectionCity
//
//  Created by umbrella on 2018/8/21.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ForgetPasswordView.h"
#import <UIView+TYAlertView.h>

@implementation ForgetPasswordView
- (IBAction)BtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 1://获取验证码
        {
            //WeakSelf
            if ([YSTools dx_isNullOrNilWithObject:self.txt_phone.text]||![YSTools isRightPhoneNumberFormat:self.txt_phone.text]) {
                return [YTAlertUtil showTempInfo:@"请输入正确的手机号"];
            }
            [YSNetworkTool POST:smsVerificationCode params:@{@"mobile": self.txt_phone.text} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([YSNetworkTool isSuccessWithResp:responseObject]) {
                    [YSTools DaojiShi:self.btn_YZM];
                    YZM = [responseObject[@"data"][@"debug"] description];
                    [YTAlertUtil showTempInfo:responseObject[kMessage]];
                }else{
                    [YTAlertUtil showTempInfo:responseObject[kMessage]];
                }
            } failure:nil];
        }
            break;
        case 2://取消
            [self hideView];
            break;
        case 3://忘记密码提交
        {
            if ([YSTools dx_isNullOrNilWithObject:self.txt_phone.text]||![YSTools isRightPhoneNumberFormat:self.txt_phone.text]) {
                return [YTAlertUtil showTempInfo:@"请输入正确的手机号"];
            }
            if ([YSTools dx_isNullOrNilWithObject:self.txt_yzm.text]||![YZM isEqualToString:self.txt_yzm.text]) {
                return [YTAlertUtil showTempInfo:@"请输入正确的验证码"];
            }
            if ([YSTools dx_isNullOrNilWithObject:self.txt_newPW.text]) {
                return [YTAlertUtil showTempInfo:@"请再次输入新密码"];
            }
            if ([YSTools dx_isNullOrNilWithObject:self.txt_newPWAgain.text]) {
                return [YTAlertUtil showTempInfo:@"请再次输入新密码"];
            }
            if (![self.txt_newPW.text isEqualToString:self.txt_newPWAgain.text]) {
                return [YTAlertUtil showTempInfo:@"两次输入的密码不一致"];
            }
            [self UpdatePW];
        }
            break;
        case 4://重置密码提交
        {
            if ([YSTools dx_isNullOrNilWithObject:self.txt_oldPW.text]) {
                return [YTAlertUtil showTempInfo:@"请输入原始密码"];
            }
            if ([YSTools dx_isNullOrNilWithObject:self.txt_newPW2.text]) {
                return [YTAlertUtil showTempInfo:@"请输入新密码"];
            }
            if ([YSTools dx_isNullOrNilWithObject:self.txt_newPWAgain2.text]) {
                return [YTAlertUtil showTempInfo:@"请再次输入新密码"];
            }
            if (![self.txt_newPW2.text isEqualToString:self.txt_newPWAgain2.text]) {
                return [YTAlertUtil showTempInfo:@"两次输入的密码不一致"];
            }
            [self resettingPW];
        }
            break;
        default:
            break;
    }
}
//忘记密码
-(void)UpdatePW{
    NSDictionary * dic = @{
                           @"code": YZM,
                           @"id": @([self.modelR.modelId intValue]),
                           @"mobile": self.txt_phone.text,
                           @"password": self.txt_newPW.text, 
                           };
    WeakSelf
    [YSNetworkTool POST:v1UserCloseAccountForget params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [weakSelf hideView];
        [YTAlertUtil showTempInfo:responseObject[@"message"]];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
//重置密码
-(void)resettingPW{
    NSDictionary * dic = @{
                           @"newPassword": self.txt_newPW2.text,
                           @"newPassword2": self.txt_newPWAgain2.text,
                           @"oldPassword": self.txt_oldPW.text,
                           @"userCloseAccountId": @([self.modelR.modelId intValue])
                           };
    WeakSelf
    [YSNetworkTool POST:v1usercloseaccountchangpwd params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [weakSelf hideView];
        [YTAlertUtil showTempInfo:responseObject[@"message"]];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end
