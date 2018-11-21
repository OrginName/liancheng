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
#import "MyQRController.h"
#import "AgreementController.h"
#import "TakePhoto.h"
#import "ZoomImage.h"
#import "QiniuUploader.h"
#import "UITabBar+badge.h"
#import "MemberCenterController.h"
#import "AgreementController.h"
@interface ProfileController ()<ProfileHeadViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray <YTSideMenuModel *> *menuModels;
@property (nonatomic, strong) ProfileHeadView *tableHeadV;
@property (nonatomic,strong) NSDictionary * dic;
@end

@implementation ProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setupTableView];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBadge:) name:@"MYSERVICE" object:nil];
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
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tableHeadV.frame = CGRectMake(0, 0, kScreenWidth, 300);
    [self.tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:
     [UIImage imageNamed:@"椭圆2拷贝4"] forBarMetrics:UIBarMetricsDefault];
   
}
//更新角标标示
-(void)updateBadge:(NSNotification *)noti{
    NSDictionary * dic = noti.object;
    ProfileCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if ([dic[@"num"] intValue]==0) {
        [self.tabBarController.tabBar hideBadgeOnItemIndex:4];
        cell.view_Layer.hidden = YES;
    }else{
        [self.tabBarController.tabBar showBadgeOnItemIndex:4 badgeValue:[dic[@"num"] intValue]];
        cell.view_Layer.hidden = NO;
    }
    self.dic = dic;
}
#pragma mark - Setup
- (void)setUI {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn setBackgroundImage:[UIImage imageNamed:@"erweima"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightBarClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
- (void)setupTableView {
    [self registerCell];
}
- (void)registerCell {
//    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileCell" bundle:nil] forCellReuseIdentifier:@"ProfileCell0"];
    _tableHeadV = [[[NSBundle mainBundle] loadNibNamed:@"ProfileHeadView" owner:nil options:nil] firstObject];
    _tableHeadV.frame = CGRectMake(0, 0, kScreenWidth, 300);
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
            if ([[[YSAccountTool userInfo] modelId] isEqualToString:APPID]) {
                if (idx!=0&&idx!=3) {
                    [menuArr addObject:model];
                }
            }else{
                [menuArr addObject:model];
            }
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
    
    //相册
    if (indexPath.row==5) {
        [[TakePhoto sharedPhoto] hehe:^(UIImage *image) {
            
        }];
        return;
    }
//    //客服
//    if (indexPath.row==6) {
//        
//        AgreementController *connectUs = [[AgreementController alloc]init];
//        connectUs.alias = @"customservice";
//        [self.navigationController pushViewController:connectUs animated:YES];
//        
//        return;
//    }
//    //商务合作
//    if(indexPath.row==7){
//        AgreementController *agreementVC = [[AgreementController alloc]init];
//        agreementVC.alias = cooperation;
//        [self.navigationController pushViewController:agreementVC animated:YES];
//        return;
//    }
    NSString *className = self.menuModels[indexPath.row].mClass;
    UIViewController *vc = (UIViewController *)[[NSClassFromString(className) alloc]init];
    vc.view.backgroundColor = [UIColor whiteColor];
    if ([vc isKindOfClass:[MemberCenterController class]]) {
        MemberCenterController * menmber = (MemberCenterController*)vc;
        menmber.dic_Receive = self.dic;//推送的字典 
    }
    if ([vc isKindOfClass:[AgreementController class]]) {
        AgreementController *agreementVC = [AgreementController new];
        agreementVC.url = @"http://www.lian-cheng.com/yingshi.asp";
        agreementVC.title = @"隐私政策";
        [self.navigationController pushViewController:agreementVC animated:YES];
        return;
    }
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
        
        [weakSelf.tableHeadV.backgroundImage sd_setImageWithURL:[NSURL URLWithString:userInfoModel.backgroundImage] placeholderImage:[UIImage imageNamed:@"2"]];
        [weakSelf.tableHeadV.headImage sd_setImageWithURL:[NSURL URLWithString:userInfoModel.headImage] placeholderImage:[UIImage imageNamed:@"our-center-1"]];
        weakSelf.tableHeadV.nickName.text = userInfoModel.nickName;
        weakSelf.tableHeadV.genderName.text = userInfoModel.genderName;
        weakSelf.tableHeadV.age.text = [NSString stringWithFormat:@"%@",userInfoModel.age?[NSString stringWithFormat:@"%@岁",userInfoModel.age]:@""];
        weakSelf.tableHeadV.centerLab.text = [NSString stringWithFormat:@"%@  %@  %@  %@  %@",userInfoModel.cityName?userInfoModel.cityName:@"",userInfoModel.height?[NSString stringWithFormat:@"%@CM",userInfoModel.height]:@"",userInfoModel.weight?[NSString stringWithFormat:@"%@KG",userInfoModel.weight]:@"",userInfoModel.educationName?userInfoModel.educationName:@"",userInfoModel.marriageName?userInfoModel.marriageName:@""];
    } failure:nil];
}
//用户svip详情
- (void)requestMembershipUserSvip {
    WeakSelf
    [YSNetworkTool POST:v1MembershipUserSvip params:nil showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if (![YSTools dx_isNullOrNilWithObject:responseObject[kData]]) {
            if (![responseObject[kData] isKindOfClass:[NSArray class]]) {
                weakSelf.tableHeadV.svipLogoBtn.hidden = NO;
                weakSelf.tableHeadV.svipxfBtn.hidden = NO;
                weakSelf.tableHeadV.svipTimeLab.text = [responseObject[kData] objectForKey:@"endTime"];
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
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
