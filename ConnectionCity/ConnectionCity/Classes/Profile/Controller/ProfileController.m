//
//  ProfileController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ProfileController.h"
#import "YTSideMenuModel.h"
#import "ProfileCell.h"
#import "ProfileHeadView.h"
#import "MemberRenewalController.h"
#import "EditProfileController.h"
#import "privateUserInfoModel.h"
#import "OccupationCategoryNameModel.h"
#import "UserMo.h"

@interface ProfileController ()<ProfileHeadViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray <YTSideMenuModel *> *menuModels;
@property (nonatomic, strong) ProfileHeadView *tableHeadV;

@end

@implementation ProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setupTableView];

    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //关闭自适应
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = YES;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Setup
- (void)setUI {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightBarClick) image:@"erweima" title:nil EdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}
- (void)setupTableView {
    [self registerCell];
}
- (void)registerCell {
//    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileCell" bundle:nil] forCellReuseIdentifier:@"ProfileCell0"];
    _tableHeadV = [[[NSBundle mainBundle] loadNibNamed:@"ProfileHeadView" owner:nil options:nil] firstObject];
    _tableHeadV.frame = CGRectMake(0, 0, kScreenWidth, 250 + 64);
    _tableHeadV.delegate = self;
    self.tableView.tableHeaderView = _tableHeadV;
}
#pragma mark - setter and getter
- (NSArray<YTSideMenuModel *> *)menuModels {
    if (_menuModels == nil) {
        NSMutableArray <YTSideMenuModel *> *menuArr = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle]pathForResource:@"MenuIcons" ofType:@"plist"];
        NSArray *menuArray = [NSArray arrayWithContentsOfFile:path];
        [menuArray enumerateObjectsUsingBlock:^(NSDictionary *_Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
            YTSideMenuModel *model = [YTSideMenuModel modelWithDictionary:dic];
            [menuArr addObject:model];
        }];
        _menuModels = menuArr;
    }
    return _menuModels;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuModels.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileCell *profileCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell0"];
    if (!profileCell) {
        profileCell = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell" owner:nil options:nil][0];
    }
    YTSideMenuModel *model = self.menuModels[indexPath.row];
    profileCell.iconImgV.image = [UIImage imageNamed:model.mIcon];
    profileCell.titleLab.text = model.mTitle;
    return profileCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 根据类名跳转控制器
//    NSString *className = [YTAccountInfo loginState] ? self.menuModels[indexPath.row].mClass : @"YTLoginViewController";
    
    NSString *className = self.menuModels[indexPath.row].mClass;
    UIViewController *vc = (UIViewController *)[[NSClassFromString(className) alloc]init];
    if (vc == nil)return;
    [self.navigationController pushViewController:vc animated:YES];
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

#pragma mark - 点击事件
- (void)rightBarClick {
    
}

#pragma mark - 数据请求
- (void)requestV1PrivateUserInfo {
    //获取用户信息
    WeakSelf
    [YSNetworkTool POST:v1PrivateUserInfo params:nil showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        privateUserInfoModel *userInfoModel = [privateUserInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
        [YSAccountTool saveUserinfo:userInfoModel];
        
        [weakSelf.tableHeadV.backgroundImage sd_setImageWithURL:[NSURL URLWithString:userInfoModel.backgroundImage] placeholderImage:[UIImage imageNamed:@"2"]];
        [weakSelf.tableHeadV.headImage sd_setImageWithURL:[NSURL URLWithString:userInfoModel.headImage] placeholderImage:[UIImage imageNamed:@"our-center-1"]];
        weakSelf.tableHeadV.nickName.text = userInfoModel.nickName;
        weakSelf.tableHeadV.genderName.text = userInfoModel.genderName;
        weakSelf.tableHeadV.age.text = [NSString stringWithFormat:@"%@岁",userInfoModel.age];
        weakSelf.tableHeadV.centerLab.text = [NSString stringWithFormat:@"%@  %@CM  %@KG  %@  %@",userInfoModel.cityName,userInfoModel.height,userInfoModel.weight,userInfoModel.educationName,userInfoModel.marriageName];
    } failure:nil];
}
//用户svip详情
- (void)requestMembershipUserSvip {
    WeakSelf
    [YSNetworkTool POST:v1MembershipUserSvip params:nil showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        weakSelf.tableHeadV.svipLogoBtn.hidden = NO;
        weakSelf.tableHeadV.svipxfBtn.hidden = NO;
        weakSelf.tableHeadV.svipTimeLab.text = @"xxxx.xx.xx到期";
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
