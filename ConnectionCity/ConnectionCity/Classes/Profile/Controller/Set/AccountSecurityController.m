//
//  AccountSecurityController.m
//  ConnectionCity
//
//  Created by qt on 2018/6/7.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AccountSecurityController.h"
#import "privateUserInfoModel.h"

@interface AccountSecurityController ()
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *txt_Phone;
@property (weak, nonatomic) IBOutlet UILabel *lab_Phone;
@property (weak, nonatomic) IBOutlet UIButton *btn_SelectOpen;
@property (weak, nonatomic) IBOutlet UIView *view_Bottom2;
@property (weak, nonatomic) IBOutlet UIView *view_bottom1;
 
@end

@implementation AccountSecurityController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
}
- (IBAction)openPhoneClick:(UIButton *)sender {
    if (sender.tag==2) {
        if (![YSTools isRightPhoneNumberFormat:_txt_Phone.text]) {
            [YTAlertUtil showTempInfo:@"请填写正确的手机号码"];
            return;
        }
        AccountSecurityController * cont = [AccountSecurityController new];
        cont.phoneStr = _txt_Phone.text;
        cont.str = @"flag1";
        [self.navigationController pushViewController:cont animated:YES];
    }else if(sender.tag==3){
        self.btn_SelectOpen.selected = !self.btn_SelectOpen.selected;
    }else if (sender.tag==5){
        [self requestData];
        //[YTAlertUtil showTempInfo:@"提交"];
    }
}
- (IBAction)getVerificationCodeBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    //WeakSelf
    [YSNetworkTool POST:smsVerificationCode params:@{@"mobile": _phoneStr} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([YSNetworkTool isSuccessWithResp:responseObject]) {
            [YSTools DaojiShi:btn];
            [YTAlertUtil showTempInfo:responseObject[kMessage]];
        }else{
            [YTAlertUtil showTempInfo:responseObject[kMessage]];
        }
    } failure:nil];
}
-(void)setUI{
    self.navigationItem.title = @"账号安全";
    self.lab_Phone.text = kUserinfo.mobile;
    if ([self.str isEqualToString:@"flag1"]) {
        self.view_bottom1.hidden = NO;
        self.view_Bottom2.hidden = YES;
    }else{
        self.view_bottom1.hidden = YES;
        self.view_Bottom2.hidden = NO;
    }
}
- (void)requestData {
    WeakSelf
    [YSNetworkTool POST:v1MyAuthUsermobileAuthCreate params:@{@"mobile": _phoneStr,@"code": _verificationCodeTF.text} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [YTAlertUtil alertSingleWithTitle:@"提示" message:responseObject[kMessage] defaultTitle:@"确定" defaultHandler:^(UIAlertAction *action) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        } completion:nil];
    } failure:nil];
}
@end
