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
-(void)setUI{
    self.navigationItem.title = @"充值";
    self.balanceLab.text = self.balanceStr;
}
- (IBAction)confirmBtnClick:(id)sender {
    if(![YSTools dx_isNullOrNilWithObject:_amountTF.text]){
        [YTAlertUtil showTempInfo:@"请填写充值金额"];
    }
    [YSNetworkTool POST:v1UserWalletRecharge params:@{@"amount": _amountTF.text} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:nil];
}

@end
