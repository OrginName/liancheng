//
//  ProfileTwoController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/8/17.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ProfileTwoController.h"
#import "YTSideMenuModel.h"
#import "ProfileCell.h"
#import "ProfileHeadView.h"
#import "MemberRenewalController.h"
#import "EditProfileController.h"
#import "privateUserInfoModel.h"
#import "OccupationCategoryNameModel.h"
#import "UserMo.h"
#import "MyQRController.h"
#import "AgreementController.h"
#import "TakePhoto.h"
#import "ZoomImage.h"
#import "QiniuUploader.h"

@interface ProfileTwoController ()<ProfileHeadViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *menuModels;
@property (nonatomic, strong) ProfileHeadView *tableHeadV;

@end

@implementation ProfileTwoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setupTableView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //关闭自适应
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //设置导航透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    //去掉导航栏底部的黑线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    //获取用户信息
    [self requestV1PrivateUserInfo];
    //用户svip详情
    [self requestMembershipUserSvip];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:
     [UIImage imageNamed:@"椭圆2拷贝4"] forBarMetrics:UIBarMetricsDefault];
}
#pragma mark - Setup
- (void)setUI {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn setBackgroundImage:[UIImage imageNamed:@"erweima"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightBarClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
//    self.navigationItem.title = @"个人中心";
}
- (void)setupTableView {
    [self registerCell];
}
- (void)registerCell {
    self.tableHeadV = [[NSBundle mainBundle] loadNibNamed:@"ProfileHeadView" owner:nil options:nil][2];
    self.tableHeadV.delegate = self;
    self.tableHeadV.frame = CGRectMake(0, 0, kScreenWidth, 300);
    WeakSelf
    self.tableHeadV.Block = ^{
        weakSelf.tableHeadV.frame = CGRectMake(0, 0, kScreenWidth, 300);
        [weakSelf.tableView reloadData];
    };
    self.tableView.tableHeaderView = self.tableHeadV;
}
#pragma mark - setter and getter
- (NSArray<YTSideMenuModel *> *)menuModels {
    if (_menuModels == nil) {
        _menuModels = @[@[[YTSideMenuModel modelWithDictionary:@{@"icon": @"q-qinmi",@"title": @"亲密账户",@"class": @"kissAccountController"}]],@[[YTSideMenuModel modelWithDictionary:@{@"icon": @"qi-kefu",@"title": @"客服",@"class": @"SetViewController"}],[YTSideMenuModel modelWithDictionary:@{@"icon": @"q-hezuo",@"title": @"商务合作",@"class": @"SetViewController"}],[YTSideMenuModel modelWithDictionary:@{@"icon": @"q-yaoqing",@"title": @"邀请好友",@"class": @"ShareController"}]],@[[YTSideMenuModel modelWithDictionary:@{@"icon": @"1-fankui",@"title": @"有奖反馈",@"class": @"FeedbackController"}]]];
    }
    return _menuModels;
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.menuModels.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menuModels[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileCell *profileCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell0"];
    if (!profileCell) {
        profileCell = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell" owner:nil options:nil][0];
    }
    YTSideMenuModel *model = self.menuModels[indexPath.section][indexPath.row];
    profileCell.iconImgV.image = [UIImage imageNamed:model.mIcon];
    profileCell.titleLab.text = model.mTitle;
    return profileCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //客服
    if (indexPath.section==1 && indexPath.row==0) {
        AgreementController *connectUs = [[AgreementController alloc]init];
        connectUs.alias = @"customservice";
        [self.navigationController pushViewController:connectUs animated:YES];
        return;
    }
    //商务合作
    if(indexPath.section==1 && indexPath.row==1){
        AgreementController *agreementVC = [[AgreementController alloc]init];
        agreementVC.alias = cooperation;
        [self.navigationController pushViewController:agreementVC animated:YES];
        return;
    }
    YTSideMenuModel *model = self.menuModels[indexPath.section][indexPath.row];
    UIViewController *vc = (UIViewController *)[[NSClassFromString(model.mClass) alloc]init];
    vc.view.backgroundColor = [UIColor whiteColor];
    if (vc == nil)return;
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
#pragma mark - ProfileHeadViewDelegate
- (void)profileHeadView:(ProfileHeadView *)view editBtnClick:(UIButton *)btn {
    EditProfileController *editVC = [[EditProfileController alloc]init];
    [self.navigationController pushViewController:editVC animated:YES];
}
- (void)profileHeadView:(ProfileHeadView *)view xfBtnClick:(UIButton *)btn {
    MemberRenewalController *xfVC = [[MemberRenewalController alloc]init];
    [self.navigationController pushViewController:xfVC animated:YES];
}
- (void)profileHeadViewHeadImgTap:(ProfileHeadView *)view {
    [ZoomImage showImage:_tableHeadV.headImage];
}
- (void)profileHeadViewHeadImgLongTap:(ProfileHeadView *)view {
    WeakSelf
    [[TakePhoto sharedPhoto] sharePicture:^(UIImage *image) {
        [YTAlertUtil showHUDWithTitle:nil];
        [[QiniuUploader defaultUploader] uploadImageToQNFilePath:image withBlock:^(NSDictionary *url) {
            [YTAlertUtil hideHUD];
            [weakSelf requestPrivateUserUpdateWithDic:@{@"headImage": [NSString stringWithFormat:@"%@%@",QINIUURL,url[@"hash"]]}];
        }];
    }];
}
#pragma mark - 点击事件
- (void)rightBarClick {
    MyQRController *myqrVC = [[MyQRController alloc]init];
    [self.navigationController pushViewController:myqrVC animated:YES];
}

#pragma mark - 数据请求
- (void)requestV1PrivateUserInfo {
    //获取用户信息
    WeakSelf
    [YSNetworkTool POST:v1PrivateUserInfo params:nil showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        privateUserInfoModel *userInfoModel = [privateUserInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
        [YSAccountTool saveUserinfo:userInfoModel];
        [weakSelf.tableHeadV.threebackgroundImage sd_setImageWithURL:[NSURL URLWithString:userInfoModel.backgroundImage] placeholderImage:[UIImage imageNamed:@"2"]];
        [weakSelf.tableHeadV.threeheadImage sd_setImageWithURL:[NSURL URLWithString:userInfoModel.headImage] placeholderImage:[UIImage imageNamed:@"our-center-1"]];
        weakSelf.tableHeadV.threenickName.text = userInfoModel.nickName;
    } failure:nil];
}
//用户svip详情
- (void)requestMembershipUserSvip {
    WeakSelf
    [YSNetworkTool POST:v1MembershipUserSvip params:nil showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if (![YSTools dx_isNullOrNilWithObject:responseObject[kData]]) {
            if (![responseObject[kData] isKindOfClass:[NSArray class]]) {
                weakSelf.tableHeadV.threesvipImgV.hidden = NO;
                weakSelf.tableHeadV.threeembershipRenewalBtn.hidden = NO;
                weakSelf.tableHeadV.threesvipTimeLab.text = [responseObject[kData] objectForKey:@"endTime"];
            }
        }
    } failure:nil];
}
- (void)requestPrivateUserUpdateWithDic:(NSDictionary *)dic{
    WeakSelf
    [YSNetworkTool POST:v1PrivateUserUpdate params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        privateUserInfoModel *userInfoModel = [privateUserInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
        [YSAccountTool saveUserinfo:userInfoModel];
        [weakSelf.tableHeadV.headImage sd_setImageWithURL:[NSURL URLWithString:userInfoModel.headImage]];
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
