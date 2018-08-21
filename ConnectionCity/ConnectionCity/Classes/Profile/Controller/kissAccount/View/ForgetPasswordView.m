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
            
            break;
        case 2://取消
            [self hideView];
            break;
        case 3://修改密码提交
        {
            
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
//更新密码
-(void)UpdatePW{
    [YTAlertUtil showTempInfo:@"更新密码"];
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
