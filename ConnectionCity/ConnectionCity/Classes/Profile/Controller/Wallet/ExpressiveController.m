//
//  ExpressiveController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/6.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ExpressiveController.h"
#import "PresentManageViewController.h"
#import "AccountPageMo.h"

@interface ExpressiveController ()
@property (weak, nonatomic) IBOutlet UILabel *accountLab;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (nonatomic, strong) AccountPageMo *mo;

@end

@implementation ExpressiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.navigationItem.title = @"提现";
    self.balanceLab.text = self.balanceStr;
}
- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag==1) {
        PresentManageViewController *vc = [[PresentManageViewController alloc]init];
        WeakSelf
        vc.accountBlock = ^(AccountPageMo * mo) {
            weakSelf.mo = mo;
            weakSelf.accountLab.text = mo.accountNumber;
        };
        [self.navigationController pushViewController:vc animated:YES];
        //[self.navigationController pushViewController:[super rotateClass:@"PresentManageViewController"] animated:YES];
    }else{
        if ([YSTools dx_isNullOrNilWithObject:_accountLab.text]) {
            [YTAlertUtil showTempInfo:@"请选择到账账户"];
            return;
        }
        if([YSTools dx_isNullOrNilWithObject:_amountTF.text]){
            [YTAlertUtil showTempInfo:@"请填写提现金额"];
            return;
        }
        
        
        WeakSelf
        [YSNetworkTool POST:v1UserWalletWithdraw params:@{@"amount": _amountTF.text,@"userWithDrawAccountId":_mo.modelId} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            [YTAlertUtil alertSingleWithTitle:@"提示" message:responseObject[kMessage] defaultTitle:@"确定" defaultHandler:^(UIAlertAction *action) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } completion:nil];
        } failure:nil];
    }
}

@end
