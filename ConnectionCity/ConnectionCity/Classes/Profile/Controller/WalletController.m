//
//  WalletController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/3.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "WalletController.h"
#import "RechargeController.h"
#import "ExpressiveController.h"
#import "ExchangeController.h"
#import "TransactionRecordController.h"

@interface WalletController ()
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UILabel *fbLab;

@end

@implementation WalletController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self v1UserWalletInfo];
}
-(void)setUI{
    self.navigationItem.title = @"钱包";
}
- (IBAction)BtnClick:(UIButton *)sender {
    if (sender.tag == 1) {
        RechargeController *vc = [[RechargeController alloc]init];
        vc.balanceStr = _balanceLab.text;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else if (sender.tag == 2){
        ExpressiveController *vc = [[ExpressiveController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else if (sender.tag == 3){
        ExchangeController *vc = [[ExchangeController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else if (sender.tag == 4){
        TransactionRecordController *vc = [[TransactionRecordController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (sender.tag>4) {
        [YTAlertUtil showTempInfo:@"待开发"];
        return;
    }
    NSArray * arr = @[@"RechargeController",@"ExpressiveController",@"ExchangeController",@"TransactionRecordController"];
    [self.navigationController pushViewController:[super rotateClass:arr[sender.tag-1]] animated:YES];
}
#pragma mark - 数据请求
- (void)v1UserWalletInfo {
    //我的钱包
    WeakSelf
    [YSNetworkTool POST:v1UserWalletInfo params:nil showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        weakSelf.balanceLab.text = [NSString stringWithFormat:@"%@",responseObject[kData][@"balance"]];
        weakSelf.fbLab.text = [NSString stringWithFormat:@"%@",responseObject[kData][@"fb"]];
    } failure:nil];
}
@end
