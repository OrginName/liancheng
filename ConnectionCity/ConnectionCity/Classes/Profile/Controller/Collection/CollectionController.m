//
//  CollectionController.m
//  ConnectionCity
//
//  Created by qt on 2018/6/8.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
// 收藏页面

#import "CollectionController.h"
#import "CollectionCell.h"
#import "CollectionMo.h"
#import "Moment.h"

@interface CollectionController ()<UITableViewDelegate,UITableViewDataSource,CollectionCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@property (nonatomic,strong)NSMutableArray * momentList;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;

@end
@implementation CollectionController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self initTestInfo];
    [self addHeaderRefresh];
    [self addFooterRefresh];
}
-(void)setUI{
    self.navigationItem.title = @"收藏";
    self.momentList = [NSMutableArray array];
    self.dataArr = [[NSMutableArray alloc]init];
}
#pragma mark - 测试数据
- (void)initTestInfo
{
    for (int i = 0;  i < 10; i ++)  {
        Moment *moment = [[Moment alloc] init];
        moment.praiseNameList = @"";
        moment.userName = @"Jeanne";
        moment.time = 1487649403;
        moment.singleWidth = 500;
        moment.singleHeight = 315;
        moment.text = @"蜀绣又名“川绣”，是在丝绸或其他织物上采用蚕丝线绣出花纹图案的中国传统工艺，18107891687主要指以四川成都为中心的川西平原一带的刺绣。😁蜀绣最早见于西汉的记载，当时的工艺已相当成熟，同时传承了图案配色鲜艳、常用红绿颜色的特点。😁蜀绣又名“川绣”，是在丝绸或其他织物上采用蚕丝线绣出花纹图案的中国传统工艺，https://www.baidu.com，主要指以四川成都为中心的川西平原一带的刺绣。蜀绣最早见于西汉的记载，当时的工艺已相当成熟，同时传承了图案配色鲜艳、常用红绿颜色的特点。";
            moment.fileCount = arc4random()%10;
        [self.momentList addObject:moment];
    }
    [self.tab_Bottom reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.momentList[indexPath.row] cellHeight];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CollectionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CollectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.receive_Mo = self.momentList[indexPath.row];
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)didSelectFullText:(CollectionCell *)cell{
    NSIndexPath * index = [self.tab_Bottom indexPathForCell:cell];
    [self.tab_Bottom reloadRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationTop];
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
                          @"pageSize": @"10",
                          };
    
    WeakSelf
    [YSNetworkTool POST:v1MyCollectPage params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        [weakSelf.dataArr removeAllObjects];
        weakSelf.dataArr = [CollectionMo mj_objectArrayWithKeyValuesArray:responseObject[kData][@"content"]];
        [weakSelf.tab_Bottom reloadData];
        [YSRefreshTool endRefreshingWithView:self.tab_Bottom];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [YSRefreshTool endRefreshingWithView:self.tab_Bottom];
    }];
}
- (void)getFooterData {
    NSDictionary *dic = @{
                          @"pageNumber": [NSString stringWithFormat:@"%ld",(long)_page],
                          @"pageSize": @"10",
                          };
    
    WeakSelf
    [YSNetworkTool POST:v1MyCollectPage params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        for (CollectionMo *mo in [CollectionMo mj_objectArrayWithKeyValuesArray:responseObject[kData][@"content"]]) {
            [weakSelf.dataArr addObject:mo];
        }
        [weakSelf.tab_Bottom reloadData];
        [YSRefreshTool endRefreshingWithView:self.tab_Bottom];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [YSRefreshTool endRefreshingWithView:self.tab_Bottom];
    }];
}

@end
