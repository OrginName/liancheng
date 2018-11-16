//
//  NewsController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/11/16.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "NewsController.h"
#import "NewsListCell.h"
#import "PersonNet.h"
#import "ShowResumeController.h"
#import "serviceListNewMo.h"
@interface NewsController ()
@property (nonatomic,strong) NSMutableArray * data_Arr;
@property (nonatomic,assign) NSInteger  page;

@end
@implementation NewsController
- (void)viewDidLoad {
    [super viewDidLoad];
    _page=1;
    [self initData];
}
-(void)initData{
    self.data_Arr = [NSMutableArray array];
    self.tab_Bottom.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page=1;
        [self requstLoad];
    }];
    self.tab_Bottom.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requstLoad];
    }];
    [self requstLoad];
}
-(void)requstLoad{
    NSDictionary * dic = @{
                           @"channelId": @(2),
                           @"pageNumber": @(_page),
                           @"pageSize": @(15),
                           @"userId": self.userID
                           };
    [PersonNet requstPersonYL1:dic withArr:^(NSMutableArray * _Nonnull successArrValue) {
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
