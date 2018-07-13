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
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_ALI_PAY_SUCCESS object:nil];
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
    WeakSelf
    [YSNetworkTool POST:v1UserWalletRecharge params:@{@"amount": _amountTF.text} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = responseObject[kData];
        [weakSelf pay:@{@"orderNo": [dic objectForKey:@"orderNo"],@"payType":kWechat}];
    } failure:nil];
}
- (void)pay:(NSDictionary *)dic {
    [YSNetworkTool POST:v1Pay params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [YTThirdPartyPay payByThirdPartyWithPaymet:YTThirdPartyPaymentWechat dictionary:responseObject[kData]];
    } failure:nil];
}
#pragma mark - alipayNotice
- (void)alipayNotice:(NSNotification *)notification {
    if ([[[notification object] objectForKey:@"userInfo"] integerValue] == 9000) {
        //支付失败
        
    }else{
        //支付成功
        
    };

}
@end
