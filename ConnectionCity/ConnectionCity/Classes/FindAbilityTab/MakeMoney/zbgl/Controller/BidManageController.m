//
//  BidManageController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/23.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BidManageController.h"
#import "BidManagerCell.h"
#import "BidManagerFootV.h"
#import "BidManagerHeadV.h"
#import "ConsultativeNegotiationController.h"
#import "FirstControllerMo.h"
#import "ReleaseTenderController.h"
#import "CityMo.h"

@interface BidManageController ()<BidManagerCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;

@end

@implementation BidManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setTableView];
    [self addHeaderRefresh];
    [self addFooterRefresh];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    BidManagerHeadV *tableHeadV = [[[NSBundle mainBundle] loadNibNamed:@"BidManagerHeadV" owner:nil options:nil] firstObject];
    tableHeadV.frame = CGRectMake(0, 0, kScreenWidth, 120);
    self.tableView.tableHeaderView = tableHeadV;
    BidManagerFootV *tableFootV = [[[NSBundle mainBundle] loadNibNamed:@"BidManagerFootV" owner:nil options:nil] firstObject];
    tableFootV.frame = CGRectMake(0, 0, kScreenWidth, 90);
    self.tableView.tableFooterView = tableFootV;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup
- (void)setUI {
    self.navigationItem.title = @"任务管理";
    self.dataArr = [[NSMutableArray alloc]init];
}
- (void)setTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"BidManagerCell" bundle:nil] forCellReuseIdentifier:@"BidManagerCell"];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BidManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BidManagerCell"];
    cell.delegate = self;
    cell.model = _dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - BidManagerCellDelegate
- (void)bidManagerCell:(BidManagerCell *)view changeBtnClick:(UIButton *)btn {
    [YTAlertUtil showTempInfo:@"修改"];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:view];
    FirstControllerMo *mo = _dataArr[indexPath.row];
    ReleaseTenderController *releasevc = [[ReleaseTenderController alloc]init];
    releasevc.firstMo = mo;
    releasevc.tenderId = mo.modelId;
    releasevc.receive_flag = @"EDIT";
    [self.navigationController pushViewController:releasevc animated:YES];
}
- (void)bidManagerCell:(BidManagerCell *)view deleteBtnClick:(UIButton *)btn {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:view];
    FirstControllerMo *mo = _dataArr[indexPath.row];
    [self v1TalentTenderDelete:@{@"id": mo.modelId}];
}
- (void)bidManagerCell:(BidManagerCell *)view negotiationBtnClick:(UIButton *)btn {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:view];
    FirstControllerMo *mo = _dataArr[indexPath.row];
    ConsultativeNegotiationController *xsyjVC = [[ConsultativeNegotiationController alloc]init];
    xsyjVC.mo = mo;
    [self.navigationController pushViewController:xsyjVC animated:YES];
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
                          @"industryCategoryId":@"",
                          @"maxDate": @"",
                          @"minDate": @"",
                          @"pageNumber": [NSString stringWithFormat:@"%ld",(long)_page],
                          @"pageSize": @"10",
                          @"provinceCode": @""
                          };
    
    WeakSelf
    [YSNetworkTool POST:v1TalentTenderMyPage params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
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
                          @"industryCategoryId":@"",
                          @"maxDate": @"",
                          @"minDate": @"",
                          @"pageNumber": [NSString stringWithFormat:@"%ld",(long)_page],
                          @"pageSize": @"10",
                          @"provinceCode": @""
                          };
    
    WeakSelf
    [YSNetworkTool POST:v1TalentTenderMyPage params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        for (FirstControllerMo *mo in [FirstControllerMo mj_objectArrayWithKeyValuesArray:responseObject[kData][@"content"]]) {
            [weakSelf.dataArr addObject:mo];
        }
        [weakSelf.tableView reloadData];
        [YSRefreshTool endRefreshingWithView:self.tableView];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [YSRefreshTool endRefreshingWithView:self.tableView];
    }];
}

- (void)v1TalentTenderDelete:(NSDictionary *)dic {
    WeakSelf
    [YSNetworkTool POST:v1TalentTenderDelete params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        [YSRefreshTool beginRefreshingWithView:weakSelf.tableView];
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
