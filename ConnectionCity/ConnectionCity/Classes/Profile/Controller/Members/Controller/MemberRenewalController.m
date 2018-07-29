//
//  MemberRenewalController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "MemberRenewalController.h"
#import "MemberRenewalM.h"
#import "MembershipMealModel.h"

@interface MemberRenewalController ()
@property (weak, nonatomic) IBOutlet UIView *membershipMealsVbg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *membershipMealsVbgH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewH;
@property (nonatomic, strong) MemberRenewalM *model;
@property (nonatomic, strong) MembershipMealModel *selectedmd;
@property (nonatomic, strong) UIButton *lastBtn;

@end

@implementation MemberRenewalController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    //获取svip套餐详情
    [self requestv1MembershipSvipInfo];
    
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
- (void)setUI{
    self.navigationItem.title = @"会员续费";
}
#pragma mark - 数据请求
//获取svip套餐详情
- (void)requestv1MembershipSvipInfo {
    WeakSelf
    [YSNetworkTool POST:v1MembershipSvipInfo params:nil showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        weakSelf.model = [MemberRenewalM mj_objectWithKeyValues:responseObject[@"data"]];
        [self.logo sd_setImageWithURL:[NSURL URLWithString:weakSelf.model.logo]];
        self.name.text = weakSelf.model.name;
        self.descriptions.text = weakSelf.model.modelDescription;
        self.descriptions.text = [NSString stringWithFormat:@"连程号  %@",kAccount.userId];
        self.remark.text = weakSelf.model.modelDescription;
        NSUInteger count = weakSelf.model.membershipMeals.count;
        int interval = 10;
        double width = (kScreenWidth - 40 - 20)/3.0;
        self.membershipMealsVbgH.constant = ceil((count / 3.0)) * (width + interval) + interval;
        self.bgViewH.constant = self.bgViewH.constant + self.membershipMealsVbgH.constant;
        for (int i=0; i<count; i++) {
            MembershipMealModel *m = weakSelf.model.membershipMeals[i];
            double x = (width + interval)*(i%3) + interval;
            double y = (i / 3) *(width + interval) + interval;
            UIView *bgv = [[UIView alloc]initWithFrame:CGRectMake(x, y, width, width)];
            bgv.backgroundColor = kCommonBGColor;
            bgv.layer.cornerRadius = 10;
            bgv.layer.borderWidth = 1;
            bgv.layer.borderColor = kCommonBGColor.CGColor;
            [weakSelf.membershipMealsVbg addSubview:bgv];
            UIImageView *headImgV = [[UIImageView alloc]initWithFrame:CGRectMake((width - 44)/2.0, 20, 44, 44)];
            [headImgV sd_setImageWithURL:[NSURL URLWithString:m.logo]];
            [bgv addSubview:headImgV];
            UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headImgV.frame), width, 30)];
            titleLab.text = [NSString stringWithFormat:@"￥%@/%@",m.price,m.title];
            titleLab.textAlignment = NSTextAlignmentCenter;
            [titleLab setFont:[UIFont systemFontOfSize:12]];
            [bgv addSubview:titleLab];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, width, width);
            btn.tag = 1000+i;
            [btn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgv addSubview:btn];
            if (i==0) {
                weakSelf.selectedmd = m;
                weakSelf.price.text = [NSString stringWithFormat:@"￥%@",m.price];
                weakSelf.lastBtn = btn;
                bgv.backgroundColor = [UIColor whiteColor];
                bgv.layer.borderColor = [UIColor orangeColor].CGColor;
            }
        }
    } failure:nil];
}

//开通套餐rechargeVip
- (void)requestv1MembershipSvipRecharge:(NSString *)ID {
    WeakSelf
    [YSNetworkTool POST:v1MembershipSvipRecharge params:@{@"id": ID} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
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

#pragma mark - 点击事件
- (void)selectedBtnClick:(UIButton *)btn{
    self.lastBtn.superview.backgroundColor = kCommonBGColor;
    self.lastBtn.superview.layer.borderColor = kCommonBGColor.CGColor;
    btn.superview.backgroundColor = [UIColor whiteColor];
    btn.superview.layer.borderColor = [UIColor orangeColor].CGColor;
    self.lastBtn = btn;
    self.selectedmd = self.model.membershipMeals[btn.tag - 1000];
    self.price.text = [NSString stringWithFormat:@"￥%@",self.selectedmd.price];
}
- (IBAction)ImmediatelyOpeneBtnClick:(id)sender {
    [self requestv1MembershipSvipRecharge:self.selectedmd.modelId];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
