//
//  OurConcernController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "OurConcernController.h"
#import "ProfileCell.h"
#import "OurConcernMo.h"

@interface OurConcernController ()<UITableViewDelegate,UITableViewDataSource,profileCellDelegate>
@property (weak, nonatomic) IBOutlet MyTab *tab_Bottom;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;

@end

@implementation OurConcernController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self addHeaderRefresh];
    [self addFooterRefresh];
}
-(void)setUI{
    self.navigationItem.title = @"我的关注";
    self.dataArr = [[NSMutableArray alloc]init];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfileCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell1"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell" owner:nil options:nil][1];
    }
    cell.cancelConcerBtn.tag = indexPath.row + 100;
    cell.concernModel = _dataArr[indexPath.row];
    cell.delegate = self;
    return cell;
}
#pragma mark ---profileCellDelegate ----
- (void)selectedItemButton:(UIButton *)btn index:(NSInteger)index {
    [YTAlertUtil showTempInfo:@"取消关注"];
    OurConcernMo *mo = self.dataArr[index-100];
    [YSNetworkTool POST:v1CommonFollowCreate params:@{@"typeId":@(mo.typeId),@"type":@(mo.type)} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [YSRefreshTool beginRefreshingWithView:self.tab_Bottom];
        [YTAlertUtil showTempInfo:responseObject[@"message"]];
    } failure:nil];
}
#pragma mark - 接口请求
- (void)addHeaderRefresh {
    __weak typeof(self) weakSelf = self;
    [YSRefreshTool addRefreshHeaderWithView:self.tab_Bottom refreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [strongSelf getHeaderData];
    }];
    [YSRefreshTool beginRefreshingWithView:self.tab_Bottom];
}
- (void)addFooterRefresh {
    __weak typeof(self) weakSelf = self;
    [YSRefreshTool addRefreshFooterWithView:self.tab_Bottom refreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.page ++;
        [strongSelf getFooterData];
    }];
}
- (void)getHeaderData {
    NSDictionary *dic = @{
                          @"pageNumber": [NSString stringWithFormat:@"%ld",(long)_page],
                          @"pageSize": @"10"
                          };
    
    WeakSelf
    [YSNetworkTool POST:v1MyFollowPage params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        [weakSelf.dataArr removeAllObjects];
        weakSelf.dataArr = [OurConcernMo mj_objectArrayWithKeyValuesArray:responseObject[kData][@"content"]];
        [weakSelf.tab_Bottom reloadData];
        [YSRefreshTool endRefreshingWithView:self.tab_Bottom];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [YSRefreshTool endRefreshingWithView:self.tab_Bottom];
    }];
}
- (void)getFooterData {
    NSDictionary *dic = @{
                          @"pageNumber": [NSString stringWithFormat:@"%ld",(long)_page],
                          @"pageSize": @"10"
                          };
    
    WeakSelf
    [YSNetworkTool POST:v1MyFollowPage params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        for (OurConcernMo *mo in [OurConcernMo mj_objectArrayWithKeyValuesArray:responseObject[kData][@"content"]]) {
            [weakSelf.dataArr addObject:mo];
        }
        [weakSelf.tab_Bottom reloadData];
        [YSRefreshTool endRefreshingWithView:self.tab_Bottom];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [YSRefreshTool endRefreshingWithView:self.tab_Bottom];
    }];
}


@end
