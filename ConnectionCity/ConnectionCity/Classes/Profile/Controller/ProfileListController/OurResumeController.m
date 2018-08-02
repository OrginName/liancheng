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
#import "ShowResumeController.h"
#import "ServiceListMo.h"
#import "trvalMo.h"
#import "ResumeController.h"
#import "SendServiceController.h"
#import "SendTripController.h"
#import "TrvalInvitController.h"
@interface OurResumeController ()<UITableViewDelegate,UITableViewDataSource,profileCellDelegate>
{
    int _page;
}
@property (weak, nonatomic) IBOutlet MyTab *tab_Bottom;
//简历数组
@property (nonatomic, strong) NSMutableArray *resumedataArr;
//服务数组
@property (nonatomic, strong) NSMutableArray *servicedataArr;
//陪旅游数组
@property (nonatomic, strong) NSMutableArray *tourismdataArr;
//旅游邀约数组
@property (nonatomic, strong) NSMutableArray *invitationdataArr;
//宝物数组
@property (nonatomic, strong) NSArray *goodsdataArr;
//身份互换数组
@property (nonatomic, strong) NSArray *identitySwapsdataArr;

@end

@implementation OurResumeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    self.resumedataArr = [NSMutableArray array];
    self.servicedataArr = [NSMutableArray array];
    self.tourismdataArr = [NSMutableArray array];
    self.invitationdataArr = [NSMutableArray array];
    _page=1;
    self.tab_Bottom.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page=1;
        [self loadData];
    }];
    self.tab_Bottom.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadData];
    }];
    [self.tab_Bottom.mj_header beginRefreshing];
}
-(void)loadData{
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
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.index==3) {
        NSMutableArray *mutArr = [NSMutableArray array];
        __block ServiceMo *model = self.servicedataArr[indexPath.row];
        __block NSUInteger index = 0;
        [self.servicedataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ServiceMo * mo = (ServiceMo *)obj;
            ServiceListMo *listMo = [[ServiceListMo alloc]init];
            listMo.ID = mo.Id;
            listMo.images = mo.images;
            listMo.title = mo.title;
            listMo.serviceCategoryId = mo.serviceCategoryId;
            listMo.property = mo.property;
            listMo.introduce = mo.introduce;
            listMo.price = mo.price;
            listMo.type = mo.type;
            listMo.content = mo.content;
            listMo.lng = mo.lng;
            listMo.lat = mo.lat;
            listMo.cityName = mo.cityName;
            listMo.cityCode = mo.cityCode;
            listMo.areaName = mo.areaName;
            listMo.areaCode = mo.areaCode;
            listMo.typeName = mo.typeName;
            listMo.user1 = (UserMo *)mo.user;
            [mutArr addObject:listMo];
            if (mo.Id == model.Id) {
                index = idx;
            }
        }];
        SendServiceController * send = [SendServiceController new];
        [self.navigationController pushViewController:send animated:YES];
//        ShowResumeController * show = [ShowResumeController new];
//        show.Receive_Type = ENUM_TypeTrval;
//        show.data_Count = mutArr;
//        show.zIndex = index;
//        NSLog(@"当前zindex为：%ld",index);
//        [self.navigationController pushViewController:show animated:YES];
    }else if (self.index==4){
        NSMutableArray *mutArr = [NSMutableArray array];
        __block tourismMo *model = self.tourismdataArr[indexPath.row];
        __block NSUInteger index = 0;
        [self.tourismdataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            tourismMo * mo = (tourismMo *)obj;
            trvalMo *listMo = [[trvalMo alloc]init];
            listMo.ID = mo.Id;
            listMo.images = mo.images;
            listMo.cityName = mo.cityName;
            listMo.cityCode = mo.cityCode;
            listMo.createTime = mo.createTime;
            listMo.introduce = mo.introduce;
            listMo.price = mo.price;
            listMo.type = mo.type;
            listMo.comments = mo.comments;
//            proStr(departTimeName);//出发时间
//            proStr(description1);//旅行说明
//            proStr(inviteObjectName);//邀约对象
//            proStr(longTimeName);//旅行时长
//            proStr(placeTravel);//旅行去哪
//            proStr(travelFeeName);//旅行话费
//            proStr(travelModeName);//出行方式
            listMo.browseTimes = mo.browseTimes;
            listMo.priceUnit = mo.priceUnit;
            listMo.user = (UserMo *)mo.user;
            [mutArr addObject:listMo];
            if (mo.Id == model.Id) {
                index = idx;
            }
        }];
        SendTripController * trip = [SendTripController new];
        [self.navigationController pushViewController:trip animated:YES];
//        ShowResumeController * show = [ShowResumeController new];
//        show.Receive_Type = ENUM_TypeTrval;
//        show.data_Count = mutArr;
//        show.zIndex = index;
//        show.str = @"TrvalTrip";
//        NSLog(@"当前zindex为：%ld",index);
//        [self.navigationController pushViewController:show animated:YES];
    }else if (self.index==5){
        NSMutableArray *mutArr = [NSMutableArray array];
        __block TravelInvite *model = self.invitationdataArr[indexPath.row];
        __block NSUInteger index = 0;
        [self.invitationdataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TravelInvite * mo = (TravelInvite *)obj;
            trvalMo *listMo = [[trvalMo alloc]init];
//            listMo.ID = mo.Id;
//            listMo.images = mo.images;
//            listMo.cityName = mo.cityName;
//            listMo.cityCode = mo.cityCode;
//            listMo.createTime = mo.createTime;
//            listMo.introduce = mo.introduce;
//            listMo.price = mo.price;
//            listMo.type = mo.type;
//            listMo.comments = mo.comments;
//            //            proStr(departTimeName);//出发时间
//            //            proStr(description1);//旅行说明
//            //            proStr(inviteObjectName);//邀约对象
//            //            proStr(longTimeName);//旅行时长
//            //            proStr(placeTravel);//旅行去哪
//            //            proStr(travelFeeName);//旅行话费
//            //            proStr(travelModeName);//出行方式
//            listMo.browseTimes = mo.browseTimes;
//            listMo.priceUnit = mo.priceUnit;
//            listMo.user1 = (UserMo *)mo.user;
            [mutArr addObject:listMo];
            if (mo.Id == model.Id) {
                index = idx;
            }
        }];
        TrvalInvitController * trval = [TrvalInvitController new];
        WeakSelf
        trval.block = ^{
            [weakSelf v1MyTravelInvitePage];
        };
        [self.navigationController pushViewController:trval animated:YES];
//        if (self.index!=5) {
//            ShowResumeController * show = [ShowResumeController new];
//            show.Receive_Type = ENUM_TypeTrval;
//            show.data_Count = mutArr;
//            show.zIndex = index;
//            show.str = @"TrvalTrip";
//            NSLog(@"当前zindex为：%ld",index);
//            [self.navigationController pushViewController:show animated:YES];
//        }
    }
}
#pragma mark -----profileCellDelegate-----
- (void)selectedItemButton:(UIButton *)btn index:(NSInteger)index {
    NSLog(@"%ld",index);
    //简历1编辑2删除
    if (index==1) {
        OurResumeMo *mo = self.resumedataArr[btn.tag - 1000];
        ResumeController * resume = [ResumeController new];
        resume.resume = mo;
        [self.navigationController pushViewController:resume animated:YES];
    }else if (index==2){
        OurResumeMo *mo = self.resumedataArr[btn.tag - 10000];
        WeakSelf
        [YTAlertUtil alertDualWithTitle:@"连程" message:@"是否要删除当前简历" style:UIAlertControllerStyleAlert cancelTitle:@"否" cancelHandler:^(UIAlertAction *action) {
        } defaultTitle:@"是" defaultHandler:^(UIAlertAction *action) {
            [YSNetworkTool POST:v1TalentResumeDelete params:@{@"id": mo.modelId} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
                [weakSelf requestMyResumePage];
            } failure:nil];
        } completion:nil];
    }
}
#pragma mark - 数据请求
//我的发布-简历
- (void)requestMyResumePage {
    WeakSelf
    [YSNetworkTool POST:v1MyResumePage params:@{@"pageNumber": @(_page),@"pageSize":@"20"} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if (_page==1) {
            [[weakSelf.resumedataArr mutableCopy] removeAllObjects];
        }
        _page++;
        weakSelf.resumedataArr = [OurResumeMo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"content"]];
        [weakSelf.tab_Bottom reloadData];
        [weakSelf endRefresh];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf endRefresh];
    }];
}
//我的发布-服务
- (void)v1MyServicePage {
    WeakSelf
    [YSNetworkTool POST:v1MyServicePage params:@{@"pageNumber": @(_page),@"pageSize":@"20"} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if (_page==1) {
            [weakSelf.servicedataArr  removeAllObjects];
        }
        _page++;
        NSArray * arr = [ServiceMo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"content"]];
        [weakSelf.servicedataArr addObjectsFromArray:arr];
        [weakSelf.tab_Bottom reloadData];
        [weakSelf endRefresh];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf endRefresh];
    }];
}
//我的发布-旅行
- (void)v1MyTravelPage {
    WeakSelf
    [YSNetworkTool POST:v1MyTravelPage params:@{@"pageNumber": @(_page),@"pageSize":@"20"} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if (_page==1) {
            [weakSelf.tourismdataArr removeAllObjects];
        }
        _page++;
        NSArray * arr = [tourismMo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"content"]];
        [weakSelf.tourismdataArr addObjectsFromArray:arr];
        [weakSelf.tab_Bottom reloadData];
        [weakSelf endRefresh];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf endRefresh];
    }];
}
//我的发布-邀约
- (void)v1MyTravelInvitePage {
    WeakSelf
    [YSNetworkTool POST:v1MyTravelInvitePage params:@{@"pageNumber": @(_page),@"pageSize":@"20"} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if (_page==1) {
            [[weakSelf.invitationdataArr mutableCopy] removeAllObjects];
        }
        _page++;
        NSArray * arr = [TravelInvite mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"content"]];
        [weakSelf.invitationdataArr addObjectsFromArray:arr];
        [weakSelf.tab_Bottom reloadData];
        [weakSelf endRefresh];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf endRefresh];
    }];
}
//我的发布-宝物
- (void)requestMyTreasurePage {
    
    [YSNetworkTool POST:v1MyTreasurePage params:@{@"pageNumber": @"1",@"pageSize":@"10"} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:nil];
}
//我的发布-身份互换
- (void)v1MyIdentityPage {
    
    [YSNetworkTool POST:v1MyIdentityPage params:@{@"pageNumber": @"1",@"pageSize":@"10"} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:nil];
}
-(void)endRefresh{
    [self.tab_Bottom.mj_header endRefreshing];
    [self.tab_Bottom.mj_footer endRefreshing];
}
@end
