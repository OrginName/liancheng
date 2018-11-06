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
@interface NewsListController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger  _page;
}
@property (weak, nonatomic) IBOutlet MyTab *tab_Bottom;
@property (nonatomic,strong) NSMutableArray * data_Arr;

@end

@implementation NewsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page=1;
    [self initData];
    self.view.backgroundColor = [UIColor whiteColor];
}
-(void)initData{
    self.data_Arr = [NSMutableArray array];
    self.tab_Bottom.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page=1;
        [self requstLoad:@{}];
    }];
    self.tab_Bottom.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requstLoad:@{}];
    }];
    [self.tab_Bottom.mj_header beginRefreshing];
}
-(void)requstLoad:(NSDictionary *)dic1{
    NSDictionary * dic = @{
                           //                           @"areaCode": 110101,
                           //                           @"cityCode": @(110000),
                           @"pageNumber": @(_page),
                           @"pageSize": @15,
                           //                           @"provinceCode": 110000
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
@end
