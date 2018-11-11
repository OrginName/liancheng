//
//  NewsListController.m
//  ConnectionCity
//
//  Created by qt on 2018/11/4.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "NewsListController.h"
#import "NewsListCell.h"
#import "HomeNet.h"
#import "ShowResumeController.h"
#import "serviceListNewMo.h"
@interface NewsListController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString * _cityCode;
}
@property (nonatomic,strong) NSMutableArray * data_Arr;

@end

@implementation NewsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page=1;
    _cityCode = @"";
    [self initData];
    self.view.backgroundColor = [UIColor whiteColor];
}
-(void)initData{
    self.data_Arr = [NSMutableArray array];
    self.tab_Bottom.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page=1;
        [self requstLoad:_cityCode];
    }];
    self.tab_Bottom.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requstLoad:_cityCode];
    }];
    [self.tab_Bottom.mj_header beginRefreshing];
}
-(void)requstLoad:(NSString *)cityCode{
    _cityCode = cityCode;
    NSDictionary * dic = @{
                           @"cityCode": _cityCode,
                           @"pageNumber": @(_page),
                           @"pageSize": @15,
                           };
    [HomeNet loadYLList:dic withSuc:^(NSMutableArray *successArrValue) {
        if (_page==1) {
            [self.data_Arr removeAllObjects];
        }
        _page++;
        [self.tab_Bottom.mj_header endRefreshing];
        [self.tab_Bottom.mj_footer endRefreshing];
        [self.data_Arr addObjectsFromArray:successArrValue];
        [self.tab_Bottom reloadData];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data_Arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NewsListCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"NewsListCell" owner:nil options:nil][0];
    }
    cell.ylMo = self.data_Arr[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NewsListDetailController * detail = [NewsListDetailController new];
//    detail.receiveMo = self.data_Arr[indexPath.row];
//    [self.navigationController pushViewController:detail animated:YES];
    
    ShowResumeController * show = [ShowResumeController new];
    show.Receive_Type = ENUM_TypeTrval;
    NSMutableArray * arr = [NSMutableArray array];
    for (YLMo * mo in self.data_Arr) {
        serviceListNewMo * list = [serviceListNewMo new];
        list.ID = mo.user.ID;
        [arr addObject:list];
    }
    show.data_Count = arr;
    show.zIndex = indexPath.row;
    show.flag = @"1";
    show.flagNext = @"NONext";
    [self.navigationController pushViewController:show animated:YES];
}
@end
