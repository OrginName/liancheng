//
//  FootprintController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/10.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FootprintController.h"
#import "FootprintTabbleHeadV.h"
#import "FootSectionHeadV.h"
#import "FootprintCell.h"
#import "MarginCell.h"
#import "FirstControllerMo.h"

@interface FootprintController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) FootprintTabbleHeadV *tableHeadV;
@property (nonatomic, strong) NSString *totalAmount;
@property (nonatomic, strong) NSString *todayAmount;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;

@end

@implementation FootprintController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initdata];
    [self setTableView];
    [self addHeaderRefresh];
    [self addFooterRefresh];
    [self v1TalentTenderFootPrintPage];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_tableHeadV) {
        _tableHeadV = [[[NSBundle mainBundle] loadNibNamed:@"FootprintTabbleHeadV" owner:nil options:nil] firstObject];
        _tableHeadV.totalAmountLab.text = self.totalAmount?self.totalAmount:@"0";
        _tableHeadV.todayAmountLab.text = self.todayAmount?self.todayAmount:@"0";
        _tableHeadV.frame = CGRectMake(0, 0, kScreenWidth, 110);
        self.tableView.tableHeaderView = _tableHeadV;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup
- (void)initdata {
    self.dataArr = [[NSMutableArray alloc]init];
}
- (void)setTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"MarginCell" bundle:nil] forCellReuseIdentifier:@"MarginCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FootprintCell" bundle:nil] forCellReuseIdentifier:@"FootprintCell"];
    [self.tableView registerClass:[FootSectionHeadV class] forHeaderFooterViewReuseIdentifier:@"FootSectionHeadV"];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    FirstControllerMo *mo = _dataArr[section];
    if ([mo.isWin isEqualToString:@"1"]) {
        return 5;
    }else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MarginCell *biddercell = [tableView dequeueReusableCellWithIdentifier:@"MarginCell"];
    FootprintCell *winnercell = [tableView dequeueReusableCellWithIdentifier:@"FootprintCell"];
    FirstControllerMo *mo = _dataArr[indexPath.section];
    if ([mo.isWin isEqualToString:@"1"]) {
        winnercell.model = mo;
        return winnercell;
    }else{
        biddercell.footModel = mo;
        return biddercell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 101;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //重用区头视图
    FootSectionHeadV *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FootSectionHeadV"];
    FirstControllerMo *mo = _dataArr[section];
    headerView.model = mo;
    //返回区头视图
    return headerView;
}
#pragma mark - profile method
-(void)p_back {
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BACKMAINWINDOW" object:nil];
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
                          @"cityCode": @"",
                          @"industryCategoryId":@0,
                          @"maxDate": @"",
                          @"minDate": @"",
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
                          @"cityCode": @"",
                          @"industryCategoryId":@0,
                          @"maxDate": @"",
                          @"minDate": @"",
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
- (void)v1TalentTenderFootPrintPage{
    NSDictionary *dic = @{
                          @"areaCode": @"",
                          @"cityCode": @"",
                          @"industryCategoryId":@"",
                          @"maxDate": @"",
                          @"minDate": @"",
                          @"pageNumber": @"1",
                          @"pageSize": @"10",
                          @"provinceCode": @""
                          };
    WeakSelf
    [YSNetworkTool POST:v1TalentTenderFootPrintPage params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        weakSelf.todayAmount = responseObject[kData][@"totalAmount"];
        weakSelf.totalAmount = responseObject[kData][@"todayAmount"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

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
