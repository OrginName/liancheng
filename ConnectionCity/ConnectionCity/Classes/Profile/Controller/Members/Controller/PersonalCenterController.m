//
//  PersonalCenterController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "PersonalCenterController.h"
#import "MemberRenewalController.h"
#import "privateUserInfoModel.h"
#import "OccupationCategoryNameModel.h"

@interface PersonalCenterController ()
@property (weak, nonatomic) IBOutlet UIView *yearBgView;
@property (weak, nonatomic) IBOutlet UIView *functionBgView;
@property (weak, nonatomic) IBOutlet UIView *activityBgView;
@property (weak, nonatomic) IBOutlet UIView *coinBgView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *svipTimeLab;

@end

@implementation PersonalCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestV1PrivateUserInfo];
    [self requestMembershipUserSvip];
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
    self.headImage.layer.cornerRadius = 27;
    self.headImage.clipsToBounds = YES;
}
#pragma mark - 点击事件
- (IBAction)membershipRenewalBtnClick:(id)sender {
    MemberRenewalController *xfVC = [[MemberRenewalController alloc]init];
    [self.navigationController pushViewController:xfVC animated:YES];
}
#pragma mark - 数据请求
- (void)requestV1PrivateUserInfo {
    //获取用户信息
    WeakSelf
    [YSNetworkTool POST:v1PrivateUserInfo params:nil showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        privateUserInfoModel *userInfoModel = [privateUserInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
        userInfoModel.ID = responseObject[@"data"][@"id"];
        [weakSelf.backgroundImage sd_setImageWithURL:[NSURL URLWithString:userInfoModel.backgroundImage] placeholderImage:[UIImage imageNamed:@"2"]];
        [weakSelf.headImage sd_setImageWithURL:[NSURL URLWithString:userInfoModel.headImage] placeholderImage:[UIImage imageNamed:@"our-center-1"]];
        weakSelf.nickName.text = userInfoModel.nickName;
    } failure:nil];
}
//用户svip详情
- (void)requestMembershipUserSvip {
    WeakSelf
    [YSNetworkTool POST:v1MembershipUserSvip params:nil showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if (![YSTools dx_isNullOrNilWithObject:responseObject[kData]]) {
            if (![responseObject[kData] isKindOfClass:[NSArray class]]) {
                weakSelf.svipTimeLab.text = [responseObject[kData] objectForKey:@"endTime"];
            }
        }
    } failure:nil];
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
