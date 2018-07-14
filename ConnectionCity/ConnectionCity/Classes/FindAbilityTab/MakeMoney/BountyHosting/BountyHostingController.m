//
//  BountyHostingController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/10.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BountyHostingController.h"
#import "MarginCell.h"
#import "MarginSectionHeadV.h"
#import "FirstControllerMo.h"

@interface BountyHostingController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;

@end

@implementation BountyHostingController

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
    [self.tableView registerNib:[UINib nibWithNibName:@"MarginCell" bundle:nil] forCellReuseIdentifier:@"MarginCell"];
    [self.tableView registerClass:[MarginSectionHeadV class] forHeaderFooterViewReuseIdentifier:@"MarginSectionHeadV"];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MarginCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MarginCell"];
    cell.titleLab.text = [NSString stringWithFormat:@"赏金%ld期",(long)indexPath.row +1];
    FirstControllerMo *mo = _dataArr[indexPath.section];
    switch (indexPath.row) {
        case 0:
        {
            cell.marginMoneyLab.text = mo.periodAmount1;
            break;
        }
        case 1:
        {
            cell.marginMoneyLab.text = mo.periodAmount2;
            break;
        }
        case 2:
        {
            cell.marginMoneyLab.text = mo.periodAmount3;
            break;
        }
        case 3:
        {
            cell.marginMoneyLab.text = mo.periodAmount4;
            break;
        }
        case 4:
        {
            cell.marginMoneyLab.text = mo.periodAmount5;
            break;
        }
        default:
            break;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //重用区头视图
    MarginSectionHeadV *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MarginSectionHeadV"];
    headerView.model = _dataArr[section];
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
                          @"cityCode": @"",
                          @"industryCategoryId":@"",
                          @"maxDate": @"",
                          @"minDate": @"",
                          @"pageNumber": [NSString stringWithFormat:@"%ld",(long)_page],
                          @"pageSize": @"10",
                          };
    
    WeakSelf
    [YSNetworkTool POST:v1TalentTenderRewardList params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
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
    [YSNetworkTool POST:v1TalentTenderRewardList params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
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
