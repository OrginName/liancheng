//
//  YSLoginController.m
//  NeckPillow
//
//  Created by YanShuang Jiang on 2018/4/22.
//  Copyright © 2018年 DKMedical. All rights reserved.
//

#import "YSLoginController.h"
#import "YSRegisterController.h"
#import "ChangePasswordController.h"

@interface YSLoginController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation YSLoginController

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
    self.loginBtn.layer.cornerRadius = 3;
}
#pragma mark - Event response
- (IBAction)eyeBtnClick:(id)sender {

}
- (IBAction)checkBtnClick:(id)sender {
    
}
- (IBAction)serviceBtnClick:(id)sender {
    
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
    //WeakSelf
    [YSNetworkTool POST:login params:@{@"loginName":_phoneTF.text,@"password":_passwordTF.text} progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([YSNetworkTool isSuccessWithResp:responseObject]) {
            [YTAlertUtil showTempInfo:responseObject[kMessage]];
            YSAccount *account = [YSAccount mj_objectWithKeyValues:responseObject[kData]];
            [YSAccountTool saveAccount:account];
            BaseTabBarController *baseTabBar = [[BaseTabBarController alloc]init];
            [kWindow setRootViewController:baseTabBar];
        }else{
            [YTAlertUtil showTempInfo:responseObject[kMessage]];
        }
    } failure:nil];
}
- (IBAction)forgetBtnClick:(id)sender {
    ChangePasswordController *forgetVC = [[ChangePasswordController alloc]init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}
- (IBAction)registerBtnClick:(id)sender {
    YSRegisterController *registerVC = [[YSRegisterController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}
- (IBAction)wxBtnClick:(id)sender {
    
}
- (IBAction)qqBtnClick:(id)sender {
    
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
