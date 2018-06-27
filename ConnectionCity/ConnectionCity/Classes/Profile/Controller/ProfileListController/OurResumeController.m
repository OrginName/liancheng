//
//  OurResumeController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "OurResumeController.h"
#import "ProfileCell.h"
#import "OurResumeMo.h"
#import "WorkExperienceListModel.h"
#import "educationExperienceListModel.h"
#import "privateUserInfoModel.h"
#import "OccupationCategoryNameModel.h"

@interface OurResumeController ()<UITableViewDelegate,UITableViewDataSource,profileCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
//简历数组
@property (nonatomic, strong) NSArray *resumedataArr;

@end

@implementation OurResumeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    //我的发布-简历
//    [self requestMyResumePage];
    //我的发布-服务
//    [self v1MyServicePage];
    //我的发布-旅行
//    [self v1MyTravelPage];
    //我的发布-邀约
//    [self v1MyTravelInvitePage];
    //我的发布-宝物
//    [self requestMyTreasurePage];
    //我的发布-身份互换
//    [self v1MyIdentityPage];
    
}
-(void)setUI{
    self.navigationItem.title = [NSString stringWithFormat:@"我的发布-%@",self.receive_Mo.mTitle];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.index == 2) {
        return _resumedataArr.count;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.index==2) {
        return 97;
    }else if(self.index==7){
        return 66;
    }else
        return 90;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfileCell * cell = [ProfileCell tempTableViewCellWith:tableView indexPath:indexPath currentTag:self.index];
    cell.delegate = self;
    if (self.index ==2) {
        cell.resumeModel = self.resumedataArr[indexPath.row];
    }
    return cell;
}
#pragma mark -----profileCellDelegate-----
- (void)selectedItemButton:(NSInteger)index{
    NSLog(@"%ld",index);
}
#pragma mark - 数据请求
//我的发布-简历
- (void)requestMyResumePage {
    WeakSelf
    [YSNetworkTool POST:v1MyResumePage params:@{@"pageNumber": @"1",@"pageSize":@"10"} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        weakSelf.resumedataArr = [OurResumeMo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"content"]];
        [weakSelf.tab_Bottom reloadData];
    } failure:nil];
}
//我的发布-服务
- (void)v1MyServicePage {
    WeakSelf
    [YSNetworkTool POST:v1MyServicePage params:@{@"pageNumber": @"1",@"pageSize":@"10"} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {

    } failure:nil];
}
//我的发布-旅行
- (void)v1MyTravelPage {
    WeakSelf
    [YSNetworkTool POST:v1MyTravelPage params:@{@"pageNumber": @"1",@"pageSize":@"10"} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:nil];
}
//我的发布-邀约
- (void)v1MyTravelInvitePage {
    WeakSelf
    [YSNetworkTool POST:v1MyTravelInvitePage params:@{@"pageNumber": @"1",@"pageSize":@"10"} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:nil];
}
//我的发布-宝物
- (void)requestMyTreasurePage {
    WeakSelf
    [YSNetworkTool POST:v1MyTreasurePage params:@{@"pageNumber": @"1",@"pageSize":@"10"} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:nil];
}
//我的发布-身份互换
- (void)v1MyIdentityPage {
    WeakSelf
    [YSNetworkTool POST:v1MyIdentityPage params:@{@"pageNumber": @"1",@"pageSize":@"10"} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:nil];
}
@end
