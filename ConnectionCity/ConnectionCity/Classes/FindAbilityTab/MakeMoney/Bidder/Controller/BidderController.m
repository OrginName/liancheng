//
//  BidderController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/10.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BidderController.h"
#import "BidderCell.h"
#import "BidderSectionHeadV.h"
#import "FirstControllerMo.h"
#import "RCDHttpTool.h"

@interface BidderController ()<UITableViewCellDelegate>
@property (weak, nonatomic) IBOutlet MyTab *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;

@end

@implementation BidderController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setTableView];
    [self addHeaderRefresh];
    [self addFooterRefresh];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup
-(void)setUI {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(p_back) image:@"return-f" title:@"" EdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    self.dataArr = [[NSMutableArray alloc]init];
}
- (void)setTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"BidderCell" bundle:nil] forCellReuseIdentifier:@"BidderCell"];
    [self.tableView registerClass:[BidderSectionHeadV class] forHeaderFooterViewReuseIdentifier:@"BidderSectionHeadV"];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    FirstControllerMo *mo = _dataArr[section];
    return mo.tenderRecords.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BidderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BidderCell"];
    cell.delegate = self;
    FirstControllerMo *mo = _dataArr[indexPath.section];
    cell.model = mo.tenderRecords[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 93;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //重用区头视图
    BidderSectionHeadV *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"BidderSectionHeadV"];
    headerView.bidderLab.text = @"抢单人";
    headerView.headerImgV.image = [UIImage imageNamed:@"Bid"];
    headerView.model = _dataArr[section];
    //返回区头视图
    return headerView;
}
#pragma mark - UITableViewCellDelegate
- (void)bidderCell:(BidderCell *)cell addFrendBtnClick:(UIButton *)btn {
    //[YTAlertUtil showTempInfo:@"加好友"];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    FirstControllerMo *firstMo = _dataArr[indexPath.section];
    TenderRecordsMo *tendMo = firstMo.tenderRecords[indexPath.row];
    WeakSelf
    [RCDHTTPTOOL requestFriend:tendMo.user.modelId complete:^(BOOL result) {
        if (result) {
            [YTAlertUtil showTempInfo:@"添加成功"];
            [YSRefreshTool beginRefreshingWithView:weakSelf.tableView];
        }
    }];
}
- (void)bidderCell:(BidderCell *)cell selectedBtnClick:(UIButton *)btn {
    //[YTAlertUtil showTempInfo:@"选中"];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    FirstControllerMo *firstMo = _dataArr[indexPath.section];
    TenderRecordsMo *tendMo = firstMo.tenderRecords[indexPath.row];
    WeakSelf
    [YSNetworkTool POST:v1TalentTenderRecordWin params:@{@"id": tendMo.modelId} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        [YTAlertUtil showTempInfo:responseObject[kMessage]];
        [YSRefreshTool beginRefreshingWithView:weakSelf.tableView];
    } failure:nil];
}
#pragma mark - profile method
-(void)p_back {
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"BACKMAINWINDOW" object:nil];
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
                          @"cityCode": @"",
                          @"industryCategoryId":@"",
                          @"maxDate": @"",
                          @"minDate": @"",
                          @"pageNumber": [NSString stringWithFormat:@"%ld",(long)_page],
                          @"pageSize": @"10",
                          };
    
    WeakSelf
    [YSNetworkTool POST:v1TalentTenderRecordList params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
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
                          @"cityCode": @"",
                          @"industryCategoryId":@"",
                          @"maxDate": @"",
                          @"minDate": @"",
                          @"pageNumber": [NSString stringWithFormat:@"%ld",(long)_page],
                          @"pageSize": @"10",
                          };
    
    WeakSelf
    [YSNetworkTool POST:v1TalentTenderRecordList params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
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
