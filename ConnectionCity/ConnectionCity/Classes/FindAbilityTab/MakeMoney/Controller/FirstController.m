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
#import "BidManageController.h"
#import "JFCityViewController.h"
#import "ClassificationsController.h"
#import "AbilityNet.h"
#import "LCDatePicker.h"
#import "FirstControllerMo.h"
#import "WinnerInfoController.h"
#import "DubTimeSlectorController.h"

@interface FirstController ()<FirstSectionHeadVDelegate,FirstTableViewCellDelegate,JFCityViewControllerDelegate,LCDatePickerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) FirstSectionHeadV *sectinV;
@property (nonatomic, strong) LCDatePicker * myDatePick;
@property (nonatomic, strong) NSMutableArray * arr_Class;
@property (nonatomic, strong) NSString *areaCode;
@property (nonatomic, strong) NSString *areaName;
@property (nonatomic, strong) NSString *industryCategoryId;
@property (nonatomic, strong) NSString *industryCategoryName;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;


@end

@implementation FirstController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    [self initData];
    [self initDate];
    [self addHeaderRefresh];
    [self addFooterRefresh];
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
    //self.areaCode = [KUserDefults objectForKey:kUserCityID];
    //加载分类数据
    WeakSelf
    [AbilityNet requstMakeMoneyClass:^(NSMutableArray *successArrValue) {
        weakSelf.arr_Class = successArrValue;
    }];
    self.dataArr = [[NSMutableArray alloc]init];
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
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FirstTableViewCell"];
    cell.delegate = self;
    cell.bidBtn.tag = 1000 + indexPath.row;
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FirstControllerMo *mo = self.dataArr[indexPath.row];
    if ([mo.isWin isEqualToString:@"1"]) {
        WinnerInfoController *winnerInfoVC = [[WinnerInfoController alloc]init];
        winnerInfoVC.bidid = mo.modelId;
        [self.navigationController pushViewController:winnerInfoVC animated:YES];
    }
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
        _sectinV.frame = CGRectMake(0, 0, kScreenWidth - 20, 100);
        _sectinV.delegate = self;
        [headerView addSubview:_sectinV];
    }
    [_sectinV.cityBtn setTitle:_areaName?_areaName:@"地点" forState:UIControlStateNormal];
    [_sectinV.typeBtn setTitle:_industryCategoryName?_industryCategoryName:@"行业类型" forState:UIControlStateNormal];
    [_sectinV.timeBtn setTitle:_timeStr?_timeStr:@"时间" forState:UIControlStateNormal];
    //返回区头视图
    return headerView;
}
#pragma mark - FirstTableViewCellDelegate
- (void)firstTableViewCell:(FirstTableViewCell *)firstTableViewCell  bidBtnClick:(UIButton *)btn {
    BiddInfoController *bidVC = [[BiddInfoController alloc]init];
    FirstControllerMo *mo = self.dataArr[btn.tag - 1000];
    bidVC.bidid = mo.modelId;
    [self.navigationController pushViewController:bidVC animated:YES];
}
#pragma mark - FirstSectionHeadVDelegate
- (void)firstSectionHeadV:(FirstSectionHeadV *)view fbzbBtnClick:(UIButton *)btn {
    ReleaseTenderController *fbVC = [[ReleaseTenderController alloc]init];
    [self.navigationController pushViewController:fbVC animated:YES];
}
- (void)firstSectionHeadV:(FirstSectionHeadV *)view zbglBtnClick:(UIButton *)btn {
    BidManageController *bidManageVC = [[BidManageController alloc]init];
    [self.navigationController pushViewController:bidManageVC animated:YES];
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

    };
    class.block1 = ^(NSString *classifiationID, NSString *classifiation) {
        weakSelf.industryCategoryId = classifiationID;
        weakSelf.industryCategoryName = classifiation;
        [YSRefreshTool beginRefreshingWithView:weakSelf.tableView];
    };
    [self.navigationController pushViewController:class animated:YES];
}
- (void)firstSectionHeadV:(FirstSectionHeadV *)view timeBtnClick:(UIButton *)btn {
    //[self.myDatePick animateShow];
    DubTimeSlectorController *timevc = [[DubTimeSlectorController alloc]init];
    WeakSelf
    timevc.timeBlock = ^(NSString *startTime, NSString *endTime) {
        NSLog(@"startTime:%@,endTime:%@",startTime,endTime);
        weakSelf.startTime = startTime;
        weakSelf.endTime = endTime;
        [YSRefreshTool beginRefreshingWithView:weakSelf.tableView];
    };
    [self.navigationController pushViewController:timevc animated:YES];
}
#pragma mark - JFCityViewControllerDelegate
- (void)cityName:(NSString *)name {
    YTLog(@"%@",name);
}
-(void)cityMo:(CityMo *)mo{
    self.areaName = mo.name;
    self.areaCode = mo.ID;
    [YSRefreshTool beginRefreshingWithView:self.tableView];
}
-(void)city:(NSString *)name ID:(NSString *)ID lat:(NSString *)lat lng:(NSString *)lng {
    self.areaName = name;
    self.areaCode = ID;
    [YSRefreshTool beginRefreshingWithView:self.tableView];
}
#pragma mark ---LCDatePickerDelegate-----
- (void)lcDatePickerViewWithPickerView:(LCDatePicker *)picker str:(NSString *)str {
    self.timeStr = str;
    [YSRefreshTool beginRefreshingWithView:self.tableView];
}
#pragma mark - 接口请求
- (void)addHeaderRefresh {
    __weak typeof(self) weakSelf = self;
    [YSRefreshTool addRefreshHeaderWithView:self.tableView refreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [strongSelf getHeaderData];
    }];
    [YSRefreshTool beginRefreshingWithView:self.tableView];
}
- (void)addFooterRefresh {
    __weak typeof(self) weakSelf = self;
    [YSRefreshTool addRefreshFooterWithView:self.tableView refreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.page ++;
        [strongSelf getFooterData];
    }];
}
- (void)getHeaderData {
    NSDictionary *dic = @{
                          @"areaCode": @"",
                          @"cityCode": _areaCode?_areaCode:@"",
                          @"industryCategoryId":_industryCategoryId?_industryCategoryId:@"",
                          @"maxDate": _endTime?_endTime:@"",
                          @"minDate": _startTime?_startTime:@"",
                          @"pageNumber": [NSString stringWithFormat:@"%ld",(long)_page],
                          @"pageSize": @"10",
                          @"provinceCode": @""
                          };
    
    WeakSelf
    [YSNetworkTool POST:v1TalentTenderPage params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        [weakSelf.dataArr removeAllObjects];
        weakSelf.dataArr = [FirstControllerMo mj_objectArrayWithKeyValuesArray:responseObject[kData][@"content"]];
        [weakSelf.tableView reloadData];
        [YSRefreshTool endRefreshingWithView:self.tableView];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [YSRefreshTool endRefreshingWithView:self.tableView];
    }];
}
- (void)getFooterData {
    NSDictionary *dic = @{
                          @"areaCode": @"",
                          @"cityCode": _areaCode?_areaCode:@"",
                          @"industryCategoryId":_industryCategoryId?_industryCategoryId:@"",
                          @"maxDate": _endTime?_endTime:@"",
                          @"minDate": _startTime?_startTime:@"",
                          @"pageNumber": [NSString stringWithFormat:@"%ld",(long)_page],
                          @"pageSize": @"10",
                          @"provinceCode": @""
                          };
    
    WeakSelf
    [YSNetworkTool POST:v1TalentTenderPage params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        for (FirstControllerMo *mo in [FirstControllerMo mj_objectArrayWithKeyValuesArray:responseObject[kData][@"content"]]) {
            [weakSelf.dataArr addObject:mo];
        }
        [weakSelf.tableView reloadData];
        [YSRefreshTool endRefreshingWithView:self.tableView];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [YSRefreshTool endRefreshingWithView:self.tableView];
    }];
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
