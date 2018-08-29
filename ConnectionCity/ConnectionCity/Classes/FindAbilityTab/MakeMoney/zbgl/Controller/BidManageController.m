//
//  BidManageController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/23.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BidManageController.h"
//#import "BidManagerCell.h"
#import "BidManagerFootV.h"
#import "BidManagerHeadV.h"
#import "ConsultativeNegotiationController.h"
#import "FirstControllerMo.h"
#import "orderListModel.h"
#import "ReleaseTenderController.h"
#import "CityMo.h"
#import "BidManagerCellOne.h"
#import "BidManagerSectionHeadV.h"
#import "BidManagerSectionFootV.h"

@interface BidManageController ()<BidManagerCellOneDelegate,BidManagerSectionFootVDelegate>
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
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayNotice:) name:NOTI_ALI_PAY_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxNotice:) name:NOTI_WEI_XIN_PAY_SUCCESS object:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_ALI_PAY_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_WEI_XIN_PAY_SUCCESS object:nil];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"BidManagerCellOne" bundle:nil] forCellReuseIdentifier:@"BidManagerCellOne"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BidManagerSectionHeadV" bundle:nil] forHeaderFooterViewReuseIdentifier:@"BidManagerSectionHeadV"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BidManagerSectionFootV" bundle:nil] forHeaderFooterViewReuseIdentifier:@"BidManagerSectionFootV"];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    FirstControllerMo *mo = self.dataArr[section];
    return mo.orderList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BidManagerCellOne *cell = [tableView dequeueReusableCellWithIdentifier:@"BidManagerCellOne"];
    cell.delegate = self;
    FirstControllerMo *mo = self.dataArr[indexPath.section];
    cell.model = mo.orderList[indexPath.row];
    NSString *pointStr;
    switch (indexPath.row) {
        case 0:
            pointStr = @"一期";
            break;
        case 1:
            pointStr = @"二期";
            break;
        case 2:
            pointStr = @"三期";
            break;
        case 3:
            pointStr = @"四期";
            break;
        case 4:
            pointStr = @"五期";
            break;
        default:
            break;
    }
    cell.pointLab.text = pointStr;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //重用区头视图
    BidManagerSectionHeadV *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"BidManagerSectionHeadV"];
    headerView.model = _dataArr[section];
    //返回区头视图
    return headerView;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    //重用区脚视图
    BidManagerSectionFootV *footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"BidManagerSectionFootV"];
    footView.changeBtn.tag = section + 100;
    footView.deleteBtn.tag = section + 100;
    footView.negotiationBtn.tag = section + 100;
    footView.model = _dataArr[section];
    footView.delegate = self;
    //返回区脚视图
    return footView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 140;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 60;
}
#pragma mark - BidManagerSectionFootVDelegate
- (void)BidManagerSectionFootV:(BidManagerSectionFootV *)view changeBtnClick:(UIButton *)btn {
    FirstControllerMo *mo = _dataArr[btn.tag - 100];
    ReleaseTenderController *releasevc = [[ReleaseTenderController alloc]init];
    releasevc.firstMo = mo;
    releasevc.tenderId = mo.modelId;
    releasevc.receive_flag = @"EDIT";
    [self.navigationController pushViewController:releasevc animated:YES];
}
- (void)BidManagerSectionFootV:(BidManagerSectionFootV *)view deleteBtnClick:(UIButton *)btn {
    WeakSelf
    [YTAlertUtil alertDualWithTitle:@"提示" message:@"确认删除？" style:UIAlertControllerStyleAlert cancelTitle:@"取消" cancelHandler:nil defaultTitle:@"确定" defaultHandler:^(UIAlertAction *action) {
        FirstControllerMo *mo = _dataArr[btn.tag - 100];
        [weakSelf v1TalentTenderDelete:@{@"id": mo.modelId}];
    } completion:nil];
}
- (void)BidManagerSectionFootV:(BidManagerSectionFootV *)view negotiationBtnClick:(UIButton *)btn {
    FirstControllerMo *mo = _dataArr[btn.tag - 100];
    ConsultativeNegotiationController *xsyjVC = [[ConsultativeNegotiationController alloc]init];
    xsyjVC.mo = mo;
    [self.navigationController pushViewController:xsyjVC animated:YES];
}
#pragma mark - BidManagerCellOneDelegate
- (void)bidManagerCell:(BidManagerCellOne *)view btn:(UIButton *)btn {
    NSIndexPath *indexPath = [_tableView indexPathForCell:view];
    FirstControllerMo *mo = _dataArr[indexPath.section];
    orderListModel *orderlist = mo.orderList[indexPath.row];
    if ([btn.titleLabel.text containsString:@"确认"]) {
        NSDictionary *dic = @{@"orderNo": orderlist.orderNo,@"status":@"60"};
        [self v1TalentTenderUpdateOrderStatus:dic];
    }else if([btn.titleLabel.text containsString:@"付款"]){
        [YTAlertUtil alertMultiWithTitle:nil message:nil style:UIAlertControllerStyleActionSheet multiTitles:@[@"支付宝",@"微信"] multiHandler:^(UIAlertAction *action, NSArray *titles, NSUInteger idx) {
            if (idx==0) {
                [YTThirdPartyPay v1Pay:@{@"orderNo": orderlist.orderNo,@"payType":kAlipay}];
            }else{
                [YTThirdPartyPay v1Pay:@{@"orderNo": orderlist.orderNo,@"payType":kWechat}];
            }
        } cancelTitle:@"取消" cancelHandler:^(UIAlertAction *action) {
        } completion:nil];
    }
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
    [YSNetworkTool POST:v1TalentTenderDelete params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [YSRefreshTool beginRefreshingWithView:weakSelf.tableView];
    } failure:nil];
}
- (void)v1TalentTenderUpdateOrderStatus:(NSDictionary *)dic {
    WeakSelf
    [YSNetworkTool POST:v1TalentTenderUpdateOrderStatus params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [YSRefreshTool beginRefreshingWithView:weakSelf.tableView];
    } failure:nil];
}
#pragma mark - alipayNotice
- (void)alipayNotice:(NSNotification *)notification {
    if ([[notification.userInfo objectForKey:@"status"] isEqualToString:@"success"]) {
        //支付成功
        [YTAlertUtil showTempInfo:@"支付成功"];
        [YSRefreshTool beginRefreshingWithView:self.tableView];

    }else if ([[notification.userInfo objectForKey:@"status"] isEqualToString:@"failure"]) {
        //支付失败
        [YTAlertUtil showTempInfo:@"支付失败"];
    }
}
- (void)wxNotice:(NSNotification *)notification {
    if ([[notification.userInfo objectForKey:@"status"] isEqualToString:@"success"]) {
        //支付成功
        [YTAlertUtil showTempInfo:@"支付成功"];
        [YSRefreshTool beginRefreshingWithView:self.tableView];

    }else if ([[notification.userInfo objectForKey:@"status"] isEqualToString:@"failure"]) {
        //支付失败
        [YTAlertUtil showTempInfo:@"支付失败"];
    }
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
