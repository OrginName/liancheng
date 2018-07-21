//
//  ExchangeController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/6.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ExchangeController.h"
#import "RechargeController.h"

@interface ExchangeController ()
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UILabel *changgeBalanceLab;

@end

@implementation ExchangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.navigationItem.title = @"兑换服币";
    self.balanceLab.text = self.balanceStr;
}
- (IBAction)BtnClick:(UIButton *)sender {
    if (sender.tag == 1) {
        RechargeController *rechargeVC = [[RechargeController alloc]init];
        rechargeVC.balanceStr = self.balanceStr;
        [self.navigationController pushViewController:rechargeVC animated:YES];
        return;
    }
    if([YSTools dx_isNullOrNilWithObject:_amountTF.text]){
        [YTAlertUtil showTempInfo:@"请填写提现金额"];
        return;
    }
    WeakSelf
    [YSNetworkTool POST:v1UserWalletExchange params:@{@"amount": _amountTF.text} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [YTAlertUtil alertSingleWithTitle:@"提示" message:responseObject[kMessage] defaultTitle:@"确定" defaultHandler:^(UIAlertAction *action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } completion:nil];
    } failure:nil];
}


@end
