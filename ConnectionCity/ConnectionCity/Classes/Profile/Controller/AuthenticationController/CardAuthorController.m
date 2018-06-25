//
//  CardAuthorController.m
//  ConnectionCity
//
//  Created by qt on 2018/6/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "CardAuthorController.h"

@interface CardAuthorController ()
@property (weak, nonatomic) IBOutlet UILabel *lab_tips;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTF;

@end

@implementation CardAuthorController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.navigationItem.title = @"手机号认证";
    NSMutableAttributedString * firstPart = [[NSMutableAttributedString alloc] initWithString:self.lab_tips.text];
    NSDictionary * firstAttributes = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName:[UIColor redColor],};
    [firstPart setAttributes:firstAttributes range:NSMakeRange(10,4)];
    [firstPart setAttributes:firstAttributes range:NSMakeRange(15,4)];
    self.lab_tips.attributedText = firstPart;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labClick:)];
    [self.lab_tips addGestureRecognizer:tap];
}
-(void)labClick:(UIGestureRecognizer *)tap{
    //取得所点击的点的坐标
    CGPoint point = [tap locationInView:self.lab_tips];
    if (point.x>147&&point.x<197) {
        [YTAlertUtil showTempInfo:@"使用条款"];
    }else if (point.x>217&&point.x<270){
        [YTAlertUtil showTempInfo:@"隐私政策"];
    }
}
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
- (IBAction)bindBtnClick:(id)sender {
    if ([YSTools dx_isNullOrNilWithObject:_phoneTF.text] || [YSTools dx_isNullOrNilWithObject:_verificationCodeTF.text]) {
        [YTAlertUtil showTempInfo:@"请将信息填写完整"];
        return;
    }
    if (![YSTools isRightPhoneNumberFormat:_phoneTF.text]) {
        [YTAlertUtil showTempInfo:@"请填写正确的手机号码"];
        return;
    }
    [self requestData];
}
- (void)requestData {
    WeakSelf
    [YSNetworkTool POST:v1MyAuthUsermobileAuthCreate params:@{@"mobile": _phoneTF.text,@"code": _verificationCodeTF.text} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [YTAlertUtil alertSingleWithTitle:@"提示" message:responseObject[kMessage] defaultTitle:@"确定" defaultHandler:^(UIAlertAction *action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } completion:nil];
    } failure:nil];
}
@end
