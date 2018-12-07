//
//  FollowController.m
//  ConnectionCity
//
//  Created by qt on 2018/11/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FollowController.h"
#import "FollowHeadView.h"
#import "ListCell.h"
#import "NoticeView.h"
#import "PersonNet.h"
#import "ShowResumeController.h"
#import "PersonalBasicDataController.h"
#import "serviceListNewMo.h"
@interface FollowController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _page;
}
@property (weak, nonatomic) IBOutlet MyTab *tab_bottom;
@property (weak, nonatomic) IBOutlet UIView *view_Bottom;
@property (nonatomic,strong) NoticeView *noticeView;
@property (nonatomic,strong) NSMutableArray * arr_data;
@property (nonatomic,strong) NSMutableArray * arr_data1;
@end

@implementation FollowController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tab_bottom registerClass:[FollowHeadView class] forHeaderFooterViewReuseIdentifier:@"FollowHeadView"];
    _page=1;
    self.arr_data = [NSMutableArray array];
    self.arr_data1 = [NSMutableArray array];
    [self setUI];
    [self initData];
}
-(void)initData{
    WeakSelf
    NSDictionary * dic = @{
                           @"pageNumber":@(_page),
                           @"pageSize":@20
                           };
    [PersonNet requstGZList:dic withDic:^(NSDictionary *successDicValue) {
        if (_page==1) {
            [self.arr_data removeAllObjects];
            [self.arr_data1 removeAllObjects];
        }
        _page++;
        [self.arr_data addObjectsFromArray:successDicValue[@"key1"]];
        [self.arr_data1 addObjectsFromArray:successDicValue[@"key2"]];
        [self.tab_bottom reloadData];
        [weakSelf.tab_bottom.mj_header endRefreshing];
        [weakSelf.tab_bottom.mj_footer endRefreshing];
    } FailDicBlock:^(NSError *failValue) {
        [weakSelf.tab_bottom.mj_header endRefreshing];
        [weakSelf.tab_bottom.mj_footer endRefreshing];
    }];
}
-(void)setUI{
    [self.view_Bottom addSubview:self.noticeView];
    WeakSelf
    self.tab_bottom.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page=1;
        [weakSelf initData];
    }];
    self.tab_bottom.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf initData];
    }];
}
#pragma mark ---------UITableviewDelegate----------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr_data1.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ListCell" owner:nil options:nil][0];
    }
    cell.mo = self.arr_data1[indexPath.row];
    WeakSelf
    cell.block = ^(ListCell *cell) {
        ShowResumeController * show = [ShowResumeController new];
        show.Receive_Type = ENUM_TypeTrval;
        show.flag = @"1";
        NSMutableArray * arr = [NSMutableArray array];
        for (GZMo * mo in weakSelf.arr_data) {
            serviceListNewMo * mo1 = [serviceListNewMo new];
            mo1.ID = mo.ID;
            [arr addObject:mo1];
        }
        show.data_Count = arr;
        [weakSelf.navigationController pushViewController:show animated:YES];
    };
    cell.headBlcok = ^(ListCell *cell) {
        NSIndexPath * index = [self.tab_bottom indexPathForCell:cell];
        GZMo * mo = self.arr_data[index.row];
        PersonalBasicDataController * base = [PersonalBasicDataController new];
        UserMo * user = [UserMo new];
        user.ID = mo.ID;
        base.connectionMo = user;
        [self.navigationController pushViewController:base animated:YES];
    };
    cell.labBlock = ^(ListCell *cell1) {
        NSIndexPath * index = [self.tab_bottom indexPathForCell:cell1];
        CircleListMo * cir = self.arr_data1[indexPath.row];
        cir.isOpen = !cir.isOpen;
        [weakSelf.tab_bottom reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    };
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    FollowHeadView * head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FollowHeadView"];
    head.clickBlock = ^(NSIndexPath *index) {
        GZMo * mo = self.arr_data[index.row];
        PersonalBasicDataController * base = [PersonalBasicDataController new];
        UserMo * user = [UserMo new];
        user.ID = mo.ID;
        base.connectionMo = user;
        [self.navigationController pushViewController:base animated:YES];
    };
    head.arr_receive = self.arr_data;
    return head;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleListMo * cir = self.arr_data1[indexPath.row];
    if (cir.isOpen == false) {
        return cir.rowHeight;
    }else{
        return cir.SJHeight;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.arr_data.count==0?0.001f:((kScreenWidth-20)/5+35);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
-(NoticeView *)noticeView{
    if (!_noticeView) {
        _noticeView = [[NoticeView alloc] initWithFrame:CGRectMake(0, 0, self.view_Bottom.width, 50) controller:self];
    }
    return _noticeView;
}
@end
