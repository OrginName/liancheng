//
//  NoticeController.m
//  ConnectionCity
//
//  Created by qt on 2018/7/24.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "NoticeController.h"
@interface NoticeController ()<UITableViewDelegate,UITableViewDataSource>
{
    int _page;
}
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@property (nonatomic,strong) NSMutableArray * arr_Data;
@end
@implementation NoticeController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.arr_Data = [NSMutableArray array];
    _page = 1;
    WeakSelf
    self.tab_Bottom.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page=1;
        [weakSelf loadData];
    }];
    self.tab_Bottom.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    [self.tab_Bottom.mj_header beginRefreshing];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arr_Data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UITableViewCell new];
}
-(void)loadData{
    NSDictionary * dic = @{@"pageNumber": @1,
                           @"pageSize": @15};
    WeakSelf
    [YSNetworkTool POST:v1CommonMessagePage params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        if (_page==1) {
            [self.arr_Data removeAllObjects];
        }
        _page++;
        [weakSelf endRefrsh];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf endRefrsh];
    }];
}
-(void)endRefrsh{
    [self.tab_Bottom.mj_header endRefreshing];
    [self.tab_Bottom.mj_footer endRefreshing];
}
@end
