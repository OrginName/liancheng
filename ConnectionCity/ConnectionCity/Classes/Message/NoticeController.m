//
//  NoticeController.m
//  ConnectionCity
//
//  Created by qt on 2018/7/24.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "NoticeController.h"
#import "NoticeMo.h"
#import "NoticeCell.h"
#import "CircleNet.h"
#import "RCDHttpTool.h"
#import "RCDAddressBookViewController.h"
@interface NoticeController ()<UITableViewDelegate,UITableViewDataSource,NoticeCellDelegate>
{
    int _page;
}
@property (weak, nonatomic) IBOutlet MyTab *tab_Bottom;
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr_Data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NoticeCell" owner:nil options:nil] lastObject];
    }
    cell.btn_agree.tag = indexPath.row;
    cell.delegate = self;
    cell.mo = self.arr_Data[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeMo * mo = self.arr_Data[indexPath.row];
    if (![[mo.type description] isEqualToString:@"99"]) {
        RCDAddressBookViewController * address = [RCDAddressBookViewController new];
        [self.navigationController pushViewController:address animated:YES];
    }
}
-(void)loadData{
    NSDictionary * dic = @{@"pageNumber": @(_page),
                           @"pageSize": @15};
    WeakSelf
    [YSNetworkTool POST:v1CommonMessagePage params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if (_page==1) {
            [self.arr_Data removeAllObjects];
        }
        _page++;
//        for (NSDictionary * dic in responseObject[@"data"][@"content"]) {
//            NoticeMo * mo = [NoticeMo mj_objectWithKeyValues:dic];
//            [self.arr_Data addObject:mo];
//        }
        self.arr_Data = [NoticeMo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"content"]];
        [self.tab_Bottom reloadData];
        [weakSelf endRefrsh];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf endRefrsh];
    }];
}
//- (void)agreeClik:(UIButton *)btn{
//    NoticeMo * notice = self.arr_Data[btn.tag];
//    if ([[notice.type description] isEqualToString:@"10"]) {
//        [RCDHTTPTOOL processInviteFriendRequest:[notice.sendUserId description] complete:^(BOOL a) {
//        }];
//    }else if ([notice.type intValue]>10&&[notice.type intValue]<=40){
//        [CircleNet requstAgreeJoinQun:@{@"groupId":notice.ID} withFlag:[notice.type intValue] withSuc:^(NSDictionary *successDicValue) {
//
//        } withFailBlock:^(NSError *failValue) {
//        }];
//    }else{
//        [YTAlertUtil showTempInfo:@"其他"];
//    }
//}
-(void)endRefrsh{
    [self.tab_Bottom.mj_header endRefreshing];
    [self.tab_Bottom.mj_footer endRefreshing];
}
@end
