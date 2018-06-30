//
//  FirstController.m
//  ConnectionCity
//
//  Created by qt on 2018/5/20.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FirstController.h"
#import "FirstTableViewCell.h"
#import "FirstSectionHeadV.h"
#import "ReleaseTenderController.h"
#import "BiddInfoController.h"
#import "WinnerInfoController.h"
#import "BidManageController.h"
#import "JFCityViewController.h"
#import "ClassificationsController.h"
#import "AbilityNet.h"
#import "LCDatePicker.h"


@interface FirstController ()<FirstSectionHeadVDelegate,FirstTableViewCellDelegate,JFCityViewControllerDelegate,LCDatePickerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) FirstSectionHeadV *sectinV;
@property (nonatomic, strong) LCDatePicker * myDatePick;
@property (nonatomic,strong) NSMutableArray * arr_Class;
@property (nonatomic,strong) NSString *areaCode;
@property (nonatomic,strong) NSString *industryCategoryId;
@property (nonatomic,strong) NSString *timeStr;

@end

@implementation FirstController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    [self initData];
    [self initDate];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup
- (void)setTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"FirstTableViewCell" bundle:nil] forCellReuseIdentifier:@"FirstTableViewCell"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
}
#pragma mark ----初始化加载数据（开始）------
-(void)initData{
    self.areaCode = [KUserDefults objectForKey:kUserCityID];
    [self v1TalentTenderPage];
    //加载分类数据
    WeakSelf
    [AbilityNet requstMakeMoneyClass:^(NSMutableArray *successArrValue) {
        weakSelf.arr_Class = successArrValue;
    }];
}
//创建日期插件
-(void)initDate{
    self.myDatePick = [[LCDatePicker alloc] initWithFrame:kScreen];
    self.myDatePick.delegate  = self;
    [self.view addSubview:self.myDatePick];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FirstTableViewCell"];
    cell.delegate = self;
    cell.bidBtn.tag = 1000 + indexPath.row;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //重用区头视图
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (headerView.subviews.count == 1) {
        _sectinV = [[[NSBundle mainBundle] loadNibNamed:@"FirstSectionHeadV" owner:nil options:nil] firstObject];
        _sectinV.delegate = self;
        _sectinV.frame = CGRectMake(0, 0, kScreenWidth - 20, 100);
        [headerView addSubview:_sectinV];
    }
    [_sectinV.cityBtn setTitle:[KUserDefults objectForKey:kUserCity]?[KUserDefults objectForKey:kUserCity]:@"请选择" forState:UIControlStateNormal];
    //返回区头视图
    return headerView;
}
#pragma mark - FirstTableViewCellDelegate
- (void)firstTableViewCell:(FirstTableViewCell *)firstTableViewCell  bidBtnClick:(UIButton *)btn {
    BiddInfoController *bidVC = [[BiddInfoController alloc]init];
    [self.navigationController pushViewController:bidVC animated:YES];
}
#pragma mark - FirstSectionHeadVDelegate
- (void)firstSectionHeadV:(FirstSectionHeadV *)view fbzbBtnClick:(UIButton *)btn {
    ReleaseTenderController *fbVC = [[ReleaseTenderController alloc]init];
    [self.navigationController pushViewController:fbVC animated:YES];
}
- (void)firstSectionHeadV:(FirstSectionHeadV *)view zbglBtnClick:(UIButton *)btn {
    WinnerInfoController *winnerInfoVC = [[WinnerInfoController alloc]init];
    [self.navigationController pushViewController:winnerInfoVC animated:YES];
//    BidManageController *bidManageVC = [[BidManageController alloc]init];
//    [self.navigationController pushViewController:bidManageVC animated:YES];
}
- (void)firstSectionHeadV:(FirstSectionHeadV *)view cityBtnClick:(UIButton *)btn {
    JFCityViewController * jf= [JFCityViewController new];
    jf.delegate = self;
    BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:jf];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
- (void)firstSectionHeadV:(FirstSectionHeadV *)view typeBtnClick:(UIButton *)btn {
    ClassificationsController * class = [ClassificationsController new];
    class.title = @"行业类型";
    class.arr_Data = self.arr_Class;
    WeakSelf
    class.block = ^(NSString *classifiation){
        [weakSelf.sectinV.typeBtn setTitle:classifiation forState:UIControlStateNormal];
    };
    class.block1 = ^(NSString *classifiationID, NSString *classifiation) {
        weakSelf.industryCategoryId = classifiationID;
        [weakSelf v1TalentTenderPage];
    };
    [self.navigationController pushViewController:class animated:YES];
}
- (void)firstSectionHeadV:(FirstSectionHeadV *)view timeBtnClick:(UIButton *)btn {
    [self.myDatePick animateShow];
}
#pragma mark - JFCityViewControllerDelegate
- (void)cityName:(NSString *)name {
    [_sectinV.cityBtn setTitle:name forState:UIControlStateNormal];
}
-(void)cityMo:(CityMo *)mo{
    self.areaCode = mo.ID;
    [self v1TalentTenderPage];
}
#pragma mark ---LCDatePickerDelegate-----
- (void)lcDatePickerViewWithPickerView:(LCDatePicker *)picker str:(NSString *)str {
    [_sectinV.timeBtn setTitle:str forState:UIControlStateNormal];
    _timeStr = str;
    [self v1TalentTenderPage];
}
#pragma mark - 接口请求
- (void)v1TalentTenderPage{
    NSDictionary * dic = @{
                            @"cityCode":_areaCode?_areaCode:@"",
                            @"industryCategoryId":_industryCategoryId?_industryCategoryId:@"",
                            @"maxDate":_timeStr?_timeStr:[NSDate date],
                            @"minDate":_timeStr?_timeStr:[NSDate date],
                            @"pageNumber": @"1",
                            @"pageSize":@"10"
                            };
    WeakSelf
    [YSNetworkTool POST:v1TalentTenderPage params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        
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
