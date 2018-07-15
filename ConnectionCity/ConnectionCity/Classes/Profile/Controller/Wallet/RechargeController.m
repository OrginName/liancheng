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
    [YSNetworkTool POST:v1UserWalletRecharge params:@{@"amount": _amountTF.text} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = responseObject[kData];
        [YTThirdPartyPay v1Pay:@{@"orderNo": [dic objectForKey:@"orderNo"],@"payType":kAlipay}];
    } failure:nil];
}

#pragma mark - alipayNotice
- (void)alipayNotice:(NSNotification *)notification {
    if ([[[notification object] objectForKey:@"userInfo"] integerValue] == 9000) {
        //支付成功
        
    }else{
        //支付失败
        
    };

}
@end
