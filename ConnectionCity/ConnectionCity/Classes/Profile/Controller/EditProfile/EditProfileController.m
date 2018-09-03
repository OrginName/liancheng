//
//  EditProfileController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/3.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "EditProfileController.h"
#import "EditProfileCell.h"
#import "EditProfileHeadView.h"
#import "EditAllController.h"
#import "QiniuUploader.h"
#import "TakePhoto.h"
#import "privateUserInfoModel.h"
#import "OccupationCategoryNameModel.h"
#import "JFCityViewController.h"
#import "CityMo.h"
#import "AllDicMo.h"
#import "AbilityNet.h"
#import "ClassificationsController1.h"
#import "SortCollProController.h"
@interface EditProfileController ()<EditProfileHeadViewDelegate,JFCityViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) EditProfileHeadView *tableHeadV;
@property (nonatomic, strong) NSArray *titleDataArr;
@property (nonatomic, strong) NSArray *parmeDataArr;
@property (nonatomic, strong) NSMutableArray *contentDataArr;
@property (nonatomic, strong) NSMutableArray * arr_Class;

@end

@implementation EditProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setupTableView];
    //请求用户信息
    [self requestV1PrivateUserInfo];
    
    // Do any additional setup after loading the view from its nib.
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
    self.navigationItem.title = @"基础资料";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightBarClick) image:nil title:@"保存" EdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    WeakSelf
    [AbilityNet requstAbilityClass:^(NSMutableArray *successArrValue) {
        weakSelf.arr_Class = successArrValue;
    }];
}
- (void)setupTableView {
    [self registerCell];
}
- (void)registerCell {
    [self.tableView registerNib:[UINib nibWithNibName:@"EditProfileCell" bundle:nil] forCellReuseIdentifier:@"EditProfileCell"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    _tableHeadV = [[[NSBundle mainBundle] loadNibNamed:@"EditProfileHeadView" owner:nil options:nil] firstObject];
    _tableHeadV.frame = CGRectMake(0, 0, kScreenWidth, 300);
    WeakSelf
    _tableHeadV.Block = ^{
        weakSelf.tableHeadV.frame = CGRectMake(0, 0, kScreenWidth, 300);
        [weakSelf.tableView reloadData];
    };
    _tableHeadV.delegate = self;
    self.tableView.tableHeaderView = _tableHeadV;
}
#pragma mark - setter and getter
- (NSArray *)titleDataArr{
    if (!_titleDataArr) {
        _titleDataArr = @[@[@"昵称",@"姓名",@"年龄",@"性别",@"所在地区"],@[@"身高cm",@"体重kg",@"婚姻",@"学历",@"行业",@"学校",@"签名"]];
        _parmeDataArr = @[@[@"nickName",@"realName",@"age",@"gender",@"areaCode"],@[@"height",@"weight",@"marriage",@"educationId",@"occupationCategoryId",@"schoolName",@"sign"]];
    }
    return _titleDataArr;
}
- (NSMutableArray *)contentDataArr {
    if (!_contentDataArr) {
        NSMutableArray *firstMutArr = [[NSMutableArray alloc]initWithArray:@[@"东方奇迹",@"江小白",@"18",@"女",@"武汉"]];
        NSMutableArray *secondMutArr = [[NSMutableArray alloc]initWithArray:@[@"160",@"45",@"未婚",@"研究生",@"行业",@"北大",@"我是单身贵族"]];
        _contentDataArr = [[NSMutableArray alloc]initWithArray:@[firstMutArr,secondMutArr]];
    }
    return _contentDataArr;
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.titleDataArr count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titleDataArr[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditProfileCell *editProfileCell = [tableView dequeueReusableCellWithIdentifier:@"EditProfileCell"];
    editProfileCell.titleLab.text = self.titleDataArr[indexPath.section][indexPath.row];
    editProfileCell.contentLab.text = self.contentDataArr[indexPath.section][indexPath.row];
    return editProfileCell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //重用区头视图
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (section == 1) {
        if (headerView.subviews.count == 1) {
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
            lab.text = @"以下内容选填，完善后更引人注目";
            lab.font = [UIFont systemFontOfSize:12];
            lab.textColor = [UIColor orangeColor];
            lab.textAlignment = NSTextAlignmentCenter;
            [headerView addSubview:lab];
        }
    }else{
        return nil;
    }
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0&&indexPath.row==3) {
        NSMutableArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:KAllDic]];
        NSArray *contentArr = [arr[7] contentArr];
        NSMutableArray *title = [NSMutableArray array];
        for (int i=0; i < contentArr.count; i++) {
            AllContentMo * mo = contentArr[i];
            [title addObject:mo.description1];
            YTLog(@"%@",mo.description1);
            YTLog(@"%@",mo.value);
        }
        WeakSelf
        [YTAlertUtil alertMultiWithTitle:nil message:nil style:UIAlertControllerStyleActionSheet multiTitles:title multiHandler:^(UIAlertAction *action, NSArray *titles, NSUInteger idx) {
            AllContentMo * mo = contentArr[idx];
            NSDictionary *dic = @{@"gender": mo.value};
            [weakSelf requestPrivateUserUpdateWithDic:dic];
        } cancelTitle:@"取消" cancelHandler:nil completion:nil];
    }else if(indexPath.section==0&&indexPath.row==4){
        JFCityViewController * jf= [JFCityViewController new];
        jf.delegate = self;
        BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:jf];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }else if (indexPath.section==1&&indexPath.row==2){
        NSMutableArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:KAllDic]];
        NSArray *contentArr = [arr[22] contentArr];
        NSMutableArray *title = [NSMutableArray array];
        for (int i=0; i < contentArr.count; i++) {
            AllContentMo * mo = contentArr[i];
            [title addObject:mo.description1];
            YTLog(@"%@",mo.description1);
            YTLog(@"%@",mo.value);
        }
        WeakSelf
        [YTAlertUtil alertMultiWithTitle:nil message:nil style:UIAlertControllerStyleActionSheet multiTitles:title multiHandler:^(UIAlertAction *action, NSArray *titles, NSUInteger idx) {
            AllContentMo * mo = contentArr[idx];
            NSDictionary *dic = @{@"marriage": mo.value};
            [weakSelf requestPrivateUserUpdateWithDic:dic];
        } cancelTitle:@"取消" cancelHandler:nil completion:nil];
    }else if (indexPath.section==1&&indexPath.row==3){
        NSMutableArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:KAllDic]];
        NSArray *contentArr = [arr[0] contentArr];
        NSMutableArray *title = [NSMutableArray array];
        for (int i=0; i < contentArr.count; i++) {
            AllContentMo * mo = contentArr[i];
            [title addObject:mo.description1];
            YTLog(@"%@",mo.description1);
            YTLog(@"%@",mo.value);
        }
        WeakSelf
        [YTAlertUtil alertMultiWithTitle:nil message:nil style:UIAlertControllerStyleActionSheet multiTitles:title multiHandler:^(UIAlertAction *action, NSArray *titles, NSUInteger idx) {
            AllContentMo * mo = contentArr[idx];
            NSDictionary *dic = @{@"educationId": mo.value};
            [weakSelf requestPrivateUserUpdateWithDic:dic];
        } cancelTitle:@"取消" cancelHandler:nil completion:nil];
    }else if (indexPath.section==1&&indexPath.row==4){
        ClassificationsController1 * class = [ClassificationsController1 new];
        class.title = @"行业类型";
        class.arr_Data = self.arr_Class;
        WeakSelf
        class.block = ^(NSString *classifiation){
            
        };
        class.block1 = ^(NSString *classifiationID, NSString *classifiation) {
            [weakSelf requestPrivateUserUpdateWithDic:@{_parmeDataArr[indexPath.section][indexPath.row]: classifiationID?classifiationID:@""}];
        };
        [self.navigationController pushViewController:class animated:YES];

    }else if (indexPath.section==1&&indexPath.row==5){
        SortCollProController * sort = [SortCollProController new];
        sort.title = @"学校";
        sort.url = dictionarySchool;
        WeakSelf
        sort.block = ^(ShoolOREduMo *mo) {
             weakSelf.contentDataArr[indexPath.section][indexPath.row] = mo.name;
            [weakSelf requestPrivateUserUpdateWithDic:@{@"schoolId":mo.ID}];
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:sort animated:YES];
    }else{
        EditAllController * edit = [EditAllController new];
        WeakSelf
        edit.block = ^(NSString * str){
            [weakSelf requestPrivateUserUpdateWithDic:@{_parmeDataArr[indexPath.section][indexPath.row]: str?str:@""}];
            weakSelf.contentDataArr[indexPath.section][indexPath.row] = str;
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:edit animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 44;
    }else{
        return 0.1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 10;
    }else{
        return 0.1;
    }
}
#pragma mark - EditProfileHeadViewDelegate
- (void)profileHeadView:(EditProfileHeadView *)view photoBtnClick:(UIButton *)btn {
    WeakSelf
    [[TakePhoto sharedPhoto] sharePicture:^(UIImage *image) {
        [YTAlertUtil showHUDWithTitle:nil];
        [[QiniuUploader defaultUploader] uploadImageToQNFilePath:image withBlock:^(NSDictionary *url) {
            [YTAlertUtil hideHUD];
            [weakSelf requestPrivateUserUpdateWithDic:@{@"headImage": [NSString stringWithFormat:@"%@%@",QINIUURL,url[@"hash"]]}];
        }];
    }];
}
- (void)profileHeadView:(EditProfileHeadView *)view refreshBtnClick:(UIButton *)btn {
    WeakSelf
    [[TakePhoto sharedPhoto] sharePicture:^(UIImage *image) {
        [YTAlertUtil showHUDWithTitle:nil];
        [[QiniuUploader defaultUploader] uploadImageToQNFilePath:image withBlock:^(NSDictionary *url) {
            [YTAlertUtil hideHUD];
            [weakSelf requestPrivateUserUpdateWithDic:@{@"backgroundImage": [NSString stringWithFormat:@"%@%@",QINIUURL,url[@"hash"]]}];
        }];
    }];
}
#pragma mark - JFCityViewControllerDelegate
- (void)cityName:(NSString *)name {
    
}
-(void)cityMo:(CityMo *)mo{
    [self requestPrivateUserUpdateWithDic:@{@"areaCode": mo.ID}];
}
-(void)city:(NSString *)name ID:(NSString *)ID lat:(NSString *)lat lng:(NSString *)lng {
    [self requestPrivateUserUpdateWithDic:@{@"areaCode": ID}];
}
#pragma mark - 点击事件
- (void)rightBarClick {
    [YTAlertUtil showTempInfo:@"保存成功"];
}
#pragma mark - 数据请求
- (void)requestV1PrivateUserInfo {
    //获取用户信息
    WeakSelf
    [YSNetworkTool POST:v1PrivateUserInfo params:nil showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        privateUserInfoModel *userInfoModel = [privateUserInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
        [YSAccountTool saveUserinfo:userInfoModel];
        
        NSMutableArray *firstMutArr = [[NSMutableArray alloc]initWithArray:@[userInfoModel.nickName?userInfoModel.nickName:@"",userInfoModel.realName?userInfoModel.realName:@"",userInfoModel.age?userInfoModel.age:@"",userInfoModel.genderName?userInfoModel.genderName:@"",userInfoModel.cityName?userInfoModel.cityName:@""]];
        NSMutableArray *secondMutArr = [[NSMutableArray alloc]initWithArray:@[userInfoModel.height?[NSString stringWithFormat:@"%@CM",userInfoModel.height]:@"",userInfoModel.weight?[NSString stringWithFormat:@"%@KG",userInfoModel.weight]:@"",userInfoModel.marriageName?userInfoModel.marriageName:@"",userInfoModel.educationName?userInfoModel.educationName:@"",userInfoModel.occupationCategoryName.name?userInfoModel.occupationCategoryName.name:@"",userInfoModel.schoolName[@"name"]?userInfoModel.schoolName[@"name"]:@"",userInfoModel.sign?userInfoModel.sign:@""]];
        weakSelf.contentDataArr = [[NSMutableArray alloc]initWithArray:@[firstMutArr,secondMutArr]];
        [weakSelf.tableHeadV.backgroundImage sd_setImageWithURL:[NSURL URLWithString:userInfoModel.backgroundImage] placeholderImage:[UIImage imageNamed:@"2"]];
        [weakSelf.tableHeadV.headImage sd_setBackgroundImageWithURL:[NSURL URLWithString:userInfoModel.headImage] forState:UIControlStateNormal];
        [weakSelf.tableView reloadData];
    } failure:nil];
}
- (void)requestPrivateUserUpdateWithDic:(NSDictionary *)dic{
    WeakSelf
    [YSNetworkTool POST:v1PrivateUserUpdate params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        privateUserInfoModel *userInfoModel = [privateUserInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
        [YSAccountTool saveUserinfo:userInfoModel];
        
        NSMutableArray *firstMutArr = [[NSMutableArray alloc]initWithArray:@[userInfoModel.nickName?userInfoModel.nickName:@"",userInfoModel.realName?userInfoModel.realName:@"",userInfoModel.age?userInfoModel.age:@"",userInfoModel.genderName?userInfoModel.genderName:@"",userInfoModel.cityName?userInfoModel.cityName:@""]];
        NSMutableArray *secondMutArr = [[NSMutableArray alloc]initWithArray:@[userInfoModel.height?[NSString stringWithFormat:@"%@CM",userInfoModel.height]:@"",userInfoModel.weight?[NSString stringWithFormat:@"%@KG",userInfoModel.weight]:@"",userInfoModel.marriageName?userInfoModel.marriageName:@"",userInfoModel.educationName?userInfoModel.educationName:@"",userInfoModel.occupationCategoryName.name?userInfoModel.occupationCategoryName.name:@"",userInfoModel.schoolName[@"name"]?userInfoModel.schoolName[@"name"]:@"",userInfoModel.sign?userInfoModel.sign:@""]];
        weakSelf.contentDataArr = [[NSMutableArray alloc]initWithArray:@[firstMutArr,secondMutArr]];
        [weakSelf.tableHeadV.backgroundImage sd_setImageWithURL:[NSURL URLWithString:userInfoModel.backgroundImage] placeholderImage:[UIImage imageNamed:@"2"]];
        [weakSelf.tableHeadV.headImage sd_setBackgroundImageWithURL:[NSURL URLWithString:userInfoModel.headImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"our-center-1"]];
        [weakSelf.tableView reloadData];
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
