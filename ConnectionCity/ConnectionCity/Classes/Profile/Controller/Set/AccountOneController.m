//
//  AccountOneController.m
//  ConnectionCity
//
//  Created by qt on 2018/6/7.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AccountOneController.h"
#import "AccountSecurityController.h"
#import "privateUserInfoModel.h"

@interface AccountOneController ()
@property (weak, nonatomic) IBOutlet UILabel *lab_LCH;
@property (weak, nonatomic) IBOutlet UILabel *lab_phone;
@property (weak, nonatomic) IBOutlet UITextField *txt_LCPassword;
@property (weak, nonatomic) IBOutlet UILabel *lab_Email;
@property (weak, nonatomic) IBOutlet UIView *view_Bottom1;
@property (weak, nonatomic) IBOutlet UIView *view_Bottom2;
@property (weak, nonatomic) IBOutlet UITextField *txt_oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *txt_NewPass;
@property (weak, nonatomic) IBOutlet UITextField *txt_newPassAgain;

@end

@implementation AccountOneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self.str isEqualToString:@"AccountTwo"]) {
        self.view_Bottom1.hidden = NO;
        self.view_Bottom2.hidden = YES;
        self.navigationItem.title = @"修改密码";
    }else{
        self.view_Bottom1.hidden = YES;
        self.view_Bottom2.hidden = NO;
        self.navigationItem.title = @"账号安全";

    }
    self.lab_LCH.text = kAccount.userId;
    self.lab_phone.text = kUserinfo.mobile;
    [self requestV1PrivateUserInfo];
}
- (IBAction)BDPhoneClick:(UIButton *)sender {
    if (sender.tag==1) {
        AccountSecurityController * account = [AccountSecurityController new];
        [self.navigationController pushViewController:account animated:YES];
    }else if(sender.tag==2){
        //[YTAlertUtil showTempInfo:@"邮箱绑定"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"输入邮件地址" message:@"如果你更改了邮件地址，需要对邮件地址重新进行验证" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        UITextField * firstTextField = [alertView textFieldAtIndex:0];
        firstTextField.placeholder = @"请输入邮件地址";
        [alertView show];
        
    }else if (sender.tag==3){
        AccountOneController * account = [AccountOneController new];
        account.str = @"AccountTwo";
        [self.navigationController pushViewController:account animated:YES];
    }else if (sender.tag==8){
        //[YTAlertUtil showTempInfo:@"确定"];
        if ([YSTools dx_isNullOrNilWithObject:_txt_oldPassword.text] || [YSTools dx_isNullOrNilWithObject:_txt_NewPass.text] || [YSTools dx_isNullOrNilWithObject:_txt_newPassAgain.text]) {
            [YTAlertUtil showTempInfo:@"请将信息填写完整"];
            return;
        }
        if (![_txt_NewPass.text isEqualToString:_txt_newPassAgain.text]) {
            [YTAlertUtil showTempInfo:@"两次密码输入不一致"];
            return;
        }
        [self requestPrivateUserChangePassword];
    }
 
}
#pragma mark - 数据请求
//修改密码
- (void)requestPrivateUserChangePassword {
    WeakSelf
    [YSNetworkTool POST:v1PrivateUserChangePassword params:@{@"newPassword": _txt_NewPass.text,@"oldPassword": _txt_oldPassword.text} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        [YTAlertUtil alertSingleWithTitle:@"提示" message:responseObject[kMessage] defaultTitle:@"确定" defaultHandler:^(UIAlertAction *action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } completion:nil];
    } failure:nil];
}
//请求用户信息
- (void)requestV1PrivateUserInfo {
    //获取用户信息
    WeakSelf
    [YSNetworkTool POST:v1PrivateUserInfo params:nil showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        privateUserInfoModel *userInfoModel = [privateUserInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
        if ([YSTools dx_isNullOrNilWithObject:userInfoModel.email]) {
            weakSelf.lab_Email.text = @"未绑定";
        }else{
            weakSelf.lab_Email.text = userInfoModel.email;
        }
    } failure:nil];
}
//保存用户信息
- (void)requestPrivateUserUpdateWithDic:(NSDictionary *)dic{
    WeakSelf
    [YSNetworkTool POST:v1PrivateUserUpdate params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        privateUserInfoModel *userInfoModel = [privateUserInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
        if ([YSTools dx_isNullOrNilWithObject:userInfoModel.email]) {
            weakSelf.lab_Email.text = @"未绑定";
        }else{
            weakSelf.lab_Email.text = userInfoModel.email;
        }
    } failure:nil];
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0) {
    if(buttonIndex == 1){
        //获取警告框中输入框
        UITextField *tf = [alertView textFieldAtIndex:0];
        if([YSTools dx_isNullOrNilWithObject:tf.text]){
            [MBProgressHUD showProgressHUDWithOnlyText:@"请输入邮件地址" view:self.view];
            return;
        }
        //请求邮箱绑定接口
        NSDictionary *dic = @{@"email": tf.text};
        [self requestPrivateUserUpdateWithDic:dic];
    }
}
@end
