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
#import "ServiceMo.h"
#import "tourismMo.h"
#import "TravelInvite.h"
#import "WorkExperienceListModel.h"
#import "educationExperienceListModel.h"
#import "privateUserInfoModel.h"
#import "OccupationCategoryNameModel.h"


@interface OurResumeController ()<UITableViewDelegate,UITableViewDataSource,profileCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
//简历数组
@property (nonatomic, strong) NSArray *resumedataArr;
//服务数组
@property (nonatomic, strong) NSArray *servicedataArr;
//陪旅游数组
@property (nonatomic, strong) NSArray *tourismdataArr;
//旅游邀约数组
@property (nonatomic, strong) NSArray *invitationdataArr;
//宝物数组
@property (nonatomic, strong) NSArray *goodsdataArr;
//身份互换数组
@property (nonatomic, strong) NSArray *identitySwapsdataArr;

@end

@implementation OurResumeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
<<<<<<< HEAD
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
=======
>>>>>>> fe7a2fdade5d0c8cdbf985cfa133deb45eb31555
    
    if(self.index==2){
        //我的发布-简历
        [self requestMyResumePage];
    }else if(self.index==3){
        //我的发布-服务
        [self v1MyServicePage];
    }else if(self.index==4){
        //我的发布-旅行
        [self v1MyTravelPage];
    }else if(self.index==5){
        //我的发布-邀约
        [self v1MyTravelInvitePage];
    }else if(self.index==6){
        //我的发布-宝物
        [self requestMyTreasurePage];
    }else if(self.index==7){
        //我的发布-身份互换
        [self v1MyIdentityPage];
    }
}
-(void)setUI{
    self.navigationItem.title = [NSString stringWithFormat:@"我的发布-%@",self.receive_Mo.mTitle];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.index == 2) {
        return _resumedataArr.count;
    }else if (self.index==3){
        return _servicedataArr.count;
    }else if (self.index==4){
        return _tourismdataArr.count;
    }else if (self.index==5){
        return _invitationdataArr.count;
    }else if (self.index==6){
        return _goodsdataArr.count;
    }else if (self.index==7){
        return _identitySwapsdataArr.count;
    }
    return 0;
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
<<<<<<< HEAD
=======
        cell.resumeeditBtn.tag = 1000+indexPath.row;
        cell.resumeedeleteBtn.tag = 10000+indexPath.row;
    }else if (self.index == 3){
        cell.serviceModel = self.servicedataArr[indexPath.row];
    }else if (self.index == 4){
        cell.tourismModel = self.tourismdataArr[indexPath.row];
    }else if (self.index == 5){
        cell.travelInviteModel = self.invitationdataArr[indexPath.row];
    }else if (self.index == 6){
        cell.serviceModel = self.servicedataArr[indexPath.row];
    }else if (self.index == 7){
        cell.serviceModel = self.servicedataArr[indexPath.row];
>>>>>>> fe7a2fdade5d0c8cdbf985cfa133deb45eb31555
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark -----profileCellDelegate-----
- (void)selectedItemButton:(NSInteger)index{
    NSLog(@"%ld",index);
<<<<<<< HEAD
=======
}
//编辑简历
- (void)resumeeditBtn:(UIButton *)btn {
    OurResumeMo *mo = self.resumedataArr[btn.tag - 1000];
}
//删除简历
- (void)resumeedeleteBtn:(UIButton *)btn {
    OurResumeMo *mo = self.resumedataArr[btn.tag - 10000];
    WeakSelf
    [YSNetworkTool POST:v1TalentResumeDelete params:@{@"id": mo.modelId} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [weakSelf requestMyResumePage];
    } failure:nil];
>>>>>>> fe7a2fdade5d0c8cdbf985cfa133deb45eb31555
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
        weakSelf.servicedataArr = [ServiceMo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"content"]];
        [weakSelf.tab_Bottom reloadData];
    } failure:nil];
}
//我的发布-旅行
- (void)v1MyTravelPage {
    WeakSelf
    [YSNetworkTool POST:v1MyTravelPage params:@{@"pageNumber": @"1",@"pageSize":@"10"} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        weakSelf.tourismdataArr = [tourismMo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"content"]];
        [weakSelf.tab_Bottom reloadData];
    } failure:nil];
}
//我的发布-邀约
- (void)v1MyTravelInvitePage {
    WeakSelf
    [YSNetworkTool POST:v1MyTravelInvitePage params:@{@"pageNumber": @"1",@"pageSize":@"10"} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        weakSelf.invitationdataArr = [TravelInvite mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"content"]];
        [weakSelf.tab_Bottom reloadData];
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
