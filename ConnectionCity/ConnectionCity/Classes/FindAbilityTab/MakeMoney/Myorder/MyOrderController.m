//
//  MyOrderController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/10/17.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "MyOrderController.h"
#import "OrderCell.h"
#import "OrderMo.h"
@interface MyOrderController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _page;
}
@property (weak, nonatomic) IBOutlet MyTab *tab_bottom;
@property (nonatomic,strong) NSMutableArray * dataArr;
@end

@implementation MyOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
     _page = 1;
    [self initData];
    WeakSelf
    self.dataArr = [NSMutableArray array];
    self.tab_bottom.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [weakSelf initData];
    }];
    self.tab_bottom.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf initData];
    }];
}
//加载数据
-(void)initData{
    WeakSelf
    NSDictionary * dic = @{
                           @"pageNumber": @(_page),
                           @"pageSize": @20,
                           };
    [YSNetworkTool POST:v1TalentTenderMyWinPage params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if (_page==1) {
            [weakSelf.dataArr removeAllObjects];
        }
        _page++;
        NSMutableArray * arr1 = [NSMutableArray array];
        NSArray * arr = responseObject[@"data"][@"content"];
        for (int i=0; i<arr.count; i++) {
             NSMutableArray * arr2 = [NSMutableArray array];
            OrderMo * mo = [OrderMo mj_objectWithKeyValues:arr[i]];
            if (![YSTools dx_isNullOrNilWithObject:mo.periodAmount1]) {
                OrderMoFQ * order = [OrderMoFQ new];
                order.amount = mo.periodAmount1;
                order.name = @"一期";
                order.FQstatus = mo.payStatus1;
                [arr2 addObject:order];
            }
            
            if (![YSTools dx_isNullOrNilWithObject:mo.periodAmount2]) {
                OrderMoFQ * order = [OrderMoFQ new];
                order.amount = mo.periodAmount2;
                order.name = @"二期";
                order.FQstatus = mo.payStatus2;
                [arr2 addObject:order];
            }
            if (![YSTools dx_isNullOrNilWithObject:mo.periodAmount3]) {
                OrderMoFQ * order = [OrderMoFQ new];
                order.amount = mo.periodAmount3;
                order.name = @"三期";
                order.FQstatus = mo.payStatus3;
                [arr2 addObject:order];
            }
            if (![YSTools dx_isNullOrNilWithObject:mo.periodAmount4]) {
                OrderMoFQ * order = [OrderMoFQ new];
                order.amount = mo.periodAmount4;
                order.name = @"四期";
                order.FQstatus = mo.payStatus4;
                [arr2 addObject:order];
            }
            if (![YSTools dx_isNullOrNilWithObject:mo.periodAmount5]) {
                OrderMoFQ * order = [OrderMoFQ new];
                order.amount = mo.periodAmount5;
                order.name = @"五期";
                order.FQstatus = mo.payStatus5;
                [arr2 addObject:order];
            }
            mo.fq = arr2;
            [arr1 addObject:mo];
        }
        [weakSelf.dataArr addObjectsFromArray:arr1];
        [weakSelf endRefresh];
        [weakSelf.tab_bottom reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
-(void)endRefresh{
    [self.tab_bottom.mj_header endRefreshing];
    [self.tab_bottom.mj_footer endRefreshing];
}
#pragma mark ------UITableViewDelegate------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.dataArr[section] fq] count];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    OrderCell * cell = [[NSBundle mainBundle] loadNibNamed:@"OrderCell" owner:nil options:nil][0];
    cell.mo = self.dataArr[section];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{ 
    OrderCell * cell = [[NSBundle mainBundle] loadNibNamed:@"OrderCell" owner:nil options:nil][2];
    cell.mo = self.dataArr[section];
    return cell;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCell1"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"OrderCell" owner:nil options:nil][1];
    }
    cell.fqMo = [self.dataArr[indexPath.section] fq][indexPath.row];
    return cell;
}
@end
