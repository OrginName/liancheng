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
#import "NoticeView.h"
@interface NewsListController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString * _cityCode;
}
@property (weak, nonatomic) IBOutlet UIView *view_Bottom;
@property (nonatomic,strong) NSMutableArray * data_Arr;
@property (nonatomic,strong) NoticeView *noticeView;

@end

@implementation NewsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page=1;
    _cityCode = @"";
    [self initData];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view_Bottom addSubview:self.noticeView];
}
-(void)initData{
    self.data_Arr = [NSMutableArray array];
    self.tab_Bottom.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page=1;
        [self requstLoad:_cityCode];
    }];
    self.tab_Bottom.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requstLoad:_cityCode];
    }];
    [self.tab_Bottom.mj_header beginRefreshing];
}
-(NoticeView *)noticeView{
    if (!_noticeView) {
        _noticeView = [[NoticeView alloc] initWithFrame:CGRectMake(0, 0, self.view_Bottom.width, 50) controller:self];
    }
    return _noticeView;
}
-(void)requstLoad:(NSString *)cityCode{
    WeakSelf
    _cityCode = cityCode;
    NSString * code = [KUserDefults objectForKey:YCode]?[KUserDefults objectForKey:YCode]:@"";
    NSDictionary * dic = @{
                           @"cityCode": code,
                           @"pageNumber": @(_page),
                           @"pageSize": @15,
                           };
    [HomeNet loadYLList:dic withSuc:^(NSMutableArray *successArrValue) {
        if (weakSelf.page==1) {
            [weakSelf.data_Arr removeAllObjects];
        }
        weakSelf.page++;
        [weakSelf.tab_Bottom.mj_header endRefreshing];
        [weakSelf.tab_Bottom.mj_footer endRefreshing];
        [weakSelf.data_Arr addObjectsFromArray:successArrValue];
        [weakSelf.tab_Bottom reloadData];
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
