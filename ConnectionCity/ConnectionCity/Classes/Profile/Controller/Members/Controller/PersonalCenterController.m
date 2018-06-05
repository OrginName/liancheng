//
//  PersonalCenterController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "PersonalCenterController.h"
#import "MemberRenewalController.h"

@interface PersonalCenterController ()
@property (weak, nonatomic) IBOutlet UIView *yearBgView;
@property (weak, nonatomic) IBOutlet UIView *functionBgView;
@property (weak, nonatomic) IBOutlet UIView *activityBgView;
@property (weak, nonatomic) IBOutlet UIView *coinBgView;

@end

@implementation PersonalCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置导航透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    //去掉导航栏底部的黑线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:
     [UIImage imageNamed:@"椭圆2拷贝4"] forBarMetrics:UIBarMetricsDefault];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup
- (void)setUI{
    self.navigationItem.title = @"会员中心";
    self.yearBgView.layer.cornerRadius = 5;
    self.yearBgView.layer.borderColor = YSColor(242,242,242).CGColor;
    self.yearBgView.layer.borderWidth = 0.5;
    self.functionBgView.layer.cornerRadius = 5;
    self.functionBgView.layer.borderColor = YSColor(242,242,242).CGColor;
    self.functionBgView.layer.borderWidth = 0.5;
    self.activityBgView.layer.cornerRadius = 5;
    self.activityBgView.layer.borderColor = YSColor(242,242,242).CGColor;
    self.activityBgView.layer.borderWidth = 0.5;
    self.coinBgView.layer.cornerRadius = 5;
    self.coinBgView.layer.borderColor = YSColor(242,242,242).CGColor;
    self.coinBgView.layer.borderWidth = 0.5;
}
#pragma mark - 点击事件
- (IBAction)membershipRenewalBtnClick:(id)sender {
    MemberRenewalController *xfVC = [[MemberRenewalController alloc]init];
    [self.navigationController pushViewController:xfVC animated:YES];
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
