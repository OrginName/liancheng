//
//  WalletController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/3.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "WalletController.h"

@interface WalletController ()

@end

@implementation WalletController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.navigationItem.title = @"钱包";
}
- (IBAction)BtnClick:(UIButton *)sender {
    if (sender.tag>4) {
        [YTAlertUtil showTempInfo:@"待开发"];
        return;
    }
    NSArray * arr = @[@"RechargeController",@"ExpressiveController",@"ExchangeController",@"TransactionRecordController"];
    [self.navigationController pushViewController:[super rotateClass:arr[sender.tag-1]] animated:YES];
}
@end
