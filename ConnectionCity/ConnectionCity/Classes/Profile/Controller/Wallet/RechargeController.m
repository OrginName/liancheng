//
//  RechargeController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/6.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "RechargeController.h"

@interface RechargeController ()
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;

@end

@implementation RechargeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayNotice:) name:NOTI_ALI_PAY_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxNotice:) name:NOTI_WEI_XIN_PAY_SUCCESS object:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_ALI_PAY_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_WEI_XIN_PAY_SUCCESS object:nil];
    //键盘消失
    [self.amountTF resignFirstResponder];
}
-(void)setUI{
    self.navigationItem.title = @"充值";
    self.balanceLab.text = self.balanceStr;
}
- (IBAction)confirmBtnClick:(id)sender {
    if([YSTools dx_isNullOrNilWithObject:_amountTF.text]){
        [YTAlertUtil showTempInfo:@"请填写充值金额"];
        return;
    }
    [YSNetworkTool POST:v1UserWalletRecharge params:@{@"amount": _amountTF.text} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = responseObject[kData];
        [YTAlertUtil alertMultiWithTitle:nil message:nil style:UIAlertControllerStyleActionSheet multiTitles:@[@"支付宝",@"微信"] multiHandler:^(UIAlertAction *action, NSArray *titles, NSUInteger idx) {
            if (idx==0) {
                [YTThirdPartyPay v1Pay:@{@"orderNo": [dic objectForKey:@"orderNo"],@"payType":kAlipay}];
            }else{
                [YTThirdPartyPay v1Pay:@{@"orderNo": [dic objectForKey:@"orderNo"],@"payType":kWechat}];
            }
        } cancelTitle:@"取消" cancelHandler:^(UIAlertAction *action) {
        } completion:nil];
    } failure:nil];
}

#pragma mark - alipayNotice
- (void)alipayNotice:(NSNotification *)notification {
    if ([[notification.userInfo objectForKey:@"status"] isEqualToString:@"success"]) {
        //支付成功
        WeakSelf
        [YTAlertUtil alertSingleWithTitle:@"提示" message:@"支付成功" defaultTitle:@"确定" defaultHandler:^(UIAlertAction *action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } completion:nil];
    }else if ([[notification.userInfo objectForKey:@"status"] isEqualToString:@"failure"]) {
        //支付失败
        WeakSelf
        [YTAlertUtil alertSingleWithTitle:@"提示" message:@"支付失败" defaultTitle:@"确定" defaultHandler:^(UIAlertAction *action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } completion:nil];
    }
}
- (void)wxNotice:(NSNotification *)notification {
    if ([[notification.userInfo objectForKey:@"status"] isEqualToString:@"success"]) {
        //支付成功
        WeakSelf
        [YTAlertUtil alertSingleWithTitle:@"提示" message:@"支付成功" defaultTitle:@"确定" defaultHandler:^(UIAlertAction *action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } completion:nil];
    }else if ([[notification.userInfo objectForKey:@"status"] isEqualToString:@"failure"]) {
        //支付失败
        WeakSelf
        [YTAlertUtil alertSingleWithTitle:@"提示" message:@"支付失败" defaultTitle:@"确定" defaultHandler:^(UIAlertAction *action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } completion:nil];
    }
}

@end
