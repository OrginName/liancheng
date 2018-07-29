//
//  PayOrderController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/26.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "PayOrderController.h"
#import "AllDicMo.h"

@interface PayOrderController ()
@property (weak, nonatomic) IBOutlet UIView *pintView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (nonatomic, strong) UIButton *lastBtn;

@end

@implementation PayOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    // Do any additional setup after loading the view from its nib.
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
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup
- (void)initUI {
    self.confirmBtn.layer.cornerRadius = 3;
    self.pintView.layer.cornerRadius = 4;
    self.pintView.clipsToBounds = YES;
    self.amountLab.text = _amount;
}
#pragma mark - 点击事件
- (IBAction)confirmBtnClick:(id)sender {
    [self v1TalentTenderorderCreate];
}
- (IBAction)selectedBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    _lastBtn.selected = !_lastBtn.selected;
    _lastBtn = btn;
    if (btn.tag==0) {
        
    }else if (btn.tag==1){
        
    }else if (btn.tag==2){
        
    }
}

#pragma mark - 接口请求
//赚外快-创建订单（支付全额/分期/保证金）
- (void)v1TalentTenderorderCreate {
    if (_lastBtn==nil) {
        [YTAlertUtil showTempInfo:@"请选择支付方式"];
        return;
    }
    NSDictionary *dic = @{@"payTypeId": _orderType,@"tenderId":_tenderId,@"depositAmount":_amount};
    WeakSelf
    [YSNetworkTool POST:v1TalentTenderorderCreate params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (weakSelf.lastBtn.tag==101) {
            [YTThirdPartyPay v1Pay:@{@"orderNo": responseObject[kData],@"payType":kWechat}];
        }else if(weakSelf.lastBtn.tag==102){
            [YTThirdPartyPay v1Pay:@{@"orderNo": responseObject[kData],@"payType":kAlipay}];
        }
        
    } failure:nil];
}

#pragma mark - alipayNotice
- (void)alipayNotice:(NSNotification *)notification {
    if ([[notification.userInfo objectForKey:@"status"] isEqualToString:@"success"]) {
        //支付成功
        WeakSelf
        [YTAlertUtil alertSingleWithTitle:@"提示" message:@"支付成功" defaultTitle:@"确定" defaultHandler:^(UIAlertAction *action) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
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
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        } completion:nil];
    }else if ([[notification.userInfo objectForKey:@"status"] isEqualToString:@"failure"]) {
        //支付失败
        WeakSelf
        [YTAlertUtil alertSingleWithTitle:@"提示" message:@"支付失败" defaultTitle:@"确定" defaultHandler:^(UIAlertAction *action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } completion:nil];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

