//
//  MessageController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "MessageController.h"
#import "JFCityViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "CustomAnnotationView.h"
#import "RefineView.h"
#import "FirstTanView.h"
#import "BaseOneTabController.h"
#import "CustomMap.h"
#import "BaseChangeTabController.h"
#import "BaseFindServiceTabController.h"
#import "UserMo.h"
#import "AllDicMo.h"
#import "SendServiceController.h"
#import "ServiceHomeNet.h"
#import "ShowResumeController.h"
#import "CircleNet.h"
#import "NoticeController.h"
#import "UITabBar+badge.h"
#import "AgreementController.h"
#import "privateUserInfoModel.h"
#import "PersonalBasicDataController.h"
#import "FilterOneController.h"
@interface MessageController ()<JFCityViewControllerDelegate,MAMapViewDelegate, AMapLocationManagerDelegate,CustomMapDelegate>
{
    BOOL flag;
}
@property (nonatomic,strong) NSString * url;
@property (strong,nonatomic)UIButton * tmpBtn;
@property (weak, nonatomic) IBOutlet UIView *view_line;
@property (weak, nonatomic) IBOutlet UIView *view_Map;
@property (weak, nonatomic) IBOutlet UIButton *btn_findPeople;
@property (nonatomic, strong) MAPinAnnotationView * annotationView;
@property (nonatomic, strong) AMapLocationManager * locationManager;
@property (nonatomic, strong) MAPointAnnotation * pointAnnotaiton;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, assign) CGFloat annotationViewAngle;
@property (nonatomic, strong) CLHeading *heading;
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;
@property (weak, nonatomic) IBOutlet UIButton *btn_mapUserLocation;
@property (weak, nonatomic) IBOutlet UIView *view_notice;
@property (weak, nonatomic) IBOutlet UIView *view_userLocation;
@property (weak, nonatomic) IBOutlet UILabel *lab_Location;
@property (weak, nonatomic) IBOutlet UILabel *lab_Notice;
@property (weak, nonatomic) IBOutlet UIButton *btn_SX;
@property (nonatomic,strong) RefineView * refine;
@property (nonatomic,strong) FirstTanView * first;
@property (nonatomic,strong) CustomMap * cusMap;
@end

@implementation MessageController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self setUI];
    [self initData];
    flag = NO;
//    if ([KUserDefults objectForKey:kLat]!=nil&&[KUserDefults objectForKey:KLng]!=nil) {
//        [self loadServiceList:@{@"lat":[KUserDefults objectForKey:kLat],@"lng":[KUserDefults objectForKey:KLng]}];
//    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JB:) name:@"TSJBACTIVE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:@"LOADSERVICELIST" object:nil];
}
#pragma mark -----首页筛选------------
- (IBAction)SXClick:(UIButton *)sender {
    FilterOneController * filter = [FilterOneController new];
    filter.title = @"筛选条件";
    filter.flag_SX = 1;
    filter.block = ^(NSDictionary *strDic) {
        [self loadServiceList:@{
                                @"age":strDic[@"0"],
                                @"distance":strDic[@"1"],
                                @"gender":strDic[@"2"],
                                @"userStatus":strDic[@"10"],
                                @"validType":strDic[@"3"],
                                @"lat":[KUserDefults objectForKey:kLat],
                                @"lng":[KUserDefults objectForKey:KLng]
                                }];
    };
    [self.navigationController pushViewController:filter animated:YES];
}
-(void)JB:(NSNotification *)noti{
    NSDictionary * dic = noti.object;
    if ([dic[@"num"] intValue]==0) {
        [self.tabBarController.tabBar hideBadgeOnItemIndex:0];
        [self.navigationItem.rightBarButtonItem setBadgeValue:@""];
    }else{
        [self.tabBarController.tabBar showBadgeOnItemIndex:0 badgeValue:[dic[@"num"] intValue]];
        [self.navigationItem.rightBarButtonItem setBadgeValue:@" "];
    }
}
- (void)updateData {
    [self.cusMap.mapView removeAnnotations:self.cusMap.mapView.annotations];
    [self.cusMap.location startUpdatingLocation];
//    [self setUI];
//    [self.cusMap.location startUpdatingLocation];
//    if ([KUserDefults objectForKey:kUserCityID]!=nil) {
//        [self loadServiceList:@{@"lat":[KUserDefults objectForKey:kLat],@"lng":[KUserDefults objectForKey:KLng],@"cityCode":[KUserDefults objectForKey:kUserCityID]}];
//    }
}
//导航左按钮我的点击
-(void)MyselfClick{
    flag = NO;
    [self.navigationController pushViewController:[super rotateClass:@"ProfileTwoController"] animated:YES];
//    self.navigationController.tabBarController.selectedIndex=4;
}
//导航右侧按钮点击
-(void)MessageClick{
    flag = NO;
    NoticeController * noice = [NoticeController new];
    noice.title = @"消息列表";
    [self.navigationController pushViewController:noice animated:YES];
}
//天生我才必有用的按钮点击
- (IBAction)btn_TS:(UIButton *)sender {
    self.first = [[[NSBundle mainBundle] loadNibNamed:@"FirstTanView" owner:nil options:nil] firstObject];
    self.first.frame = CGRectMake(20, 0, kScreenWidth-40, 310);
    self.first.messController = self;
    self.refine = [[RefineView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) type:self.first];
    [self.refine alertSelectViewshow];
    flag = NO;
}
//加载服务列表数据
-(void)loadServiceList:(NSDictionary *)dic{
//    NSDictionary * dic1 = @{
//                 @"distance": @([KDistance intValue]),
//                 @"lat": @([dic[@"lat"] floatValue]),
//                 @"lng": @([dic[@"lng"] floatValue]),
//                 };
//    //    加载服列表
//    [ServiceHomeNet requstServiceList:dic1 withSuc:^(NSMutableArray *successArrValue) {
//        self.cusMap.Arr_Mark = successArrValue;
//    }];
    NSDictionary * dic1 = @{
                            @"age":dic[@"age"]?dic[@"age"]:@"",
                            @"distance":@([dic[@"distance"]?dic[@"distance"]:@"" intValue]),
                            @"gender":dic[@"gender"]?@([dic[@"gender"] intValue]):@"",
                            @"userStatus":dic[@"userStatus"]?@([dic[@"userStatus"] intValue]):@"",
                            @"validType":dic[@"validType"]?@([dic[@"validType"] intValue]):@"",
                            @"lat": @([dic[@"lat"]?dic[@"lat"]:@"" floatValue]),
                            @"lng": @([dic[@"lng"]?dic[@"lng"]:@"" floatValue]),
                            @"pageNumber": @1,
                            @"pageSize": @100
                           };
    [YSNetworkTool POST:v1PrivateUserHomeList params:dic1 showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray * arr = [UserMo mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        self.cusMap.Arr_Mark = arr;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
//获取当前自己的位置并设为中心点
- (IBAction)btn_UserLocation:(UIButton *)sender {
//    [self.mapView setCenterCoordinate:self.pointAnnotaiton.coordinate];
//    [self.mapView setZoomLevel:15.1 animated:NO];
}
-(void)dragCenterLocation:(CLLocationCoordinate2D)location{
    if (![YSTools dx_isNullOrNilWithObject:KString(@"%f", location.latitude)]&&![YSTools dx_isNullOrNilWithObject:KString(@"%f", location.longitude)]) {
        [self loadServiceList:@{@"lat":KString(@"%f", location.latitude),@"lng":KString(@"%f", location.longitude)}];
    }
}
//首页三个按钮点击选中方法
- (IBAction)btn_selected:(UIButton *)sender {
    if (sender.tag!=1) {
        self.btn_findPeople.selected = NO;
    }
    if (_tmpBtn == nil){
        sender.selected = YES;
        _tmpBtn = sender;
    }
    else  if (_tmpBtn !=nil &&_tmpBtn == sender){
        sender.selected = YES;
    } else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
    }
    flag = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.view_line.x = sender.x;
    }];
    switch (sender.tag) {
        case 1:
        {
            BaseFindServiceTabController * base = [BaseFindServiceTabController new];
            [self.navigationController pushViewController:base animated:YES];
//            BaseOneTabController * one = [[BaseOneTabController alloc] init];
//            [self.navigationController pushViewController:one animated:YES];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"TABBAR" object:nil];
//
        } 
            break;
        case 2:
        {
//            BaseFindServiceTabController * base = [BaseFindServiceTabController new];
//            [self.navigationController pushViewController:base animated:YES];
        }
            break;
        case 3:
        {
            BaseOneTabController * one = [[BaseOneTabController alloc] init];
            [self.navigationController pushViewController:one animated:YES];
//            BaseChangeTabController * one = [[BaseChangeTabController alloc] init];
//            [self.navigationController pushViewController:one animated:YES];
        }
            break;
        default:
            break;
    }
}

//城市选择按钮点击
-(void)AddressClick:(UIButton *)btn{
    JFCityViewController * jf= [JFCityViewController new];
    jf.delegate = self;
    BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:jf];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}


#pragma mark - JFCityViewControllerDelegate
- (void)cityName:(NSString *)name {
    UIButton * btn = (UIButton *)[self.navigationItem.titleView viewWithTag:99999];
    [btn setTitle:name forState:UIControlStateNormal];
}
-(void)city:(NSString *)name ID:(NSString *)ID lat:(NSString *)lat lng:(NSString *)lng{
    [self.cusMap.location cleanUpAction];
    UIButton * btn = (UIButton *)[self.navigationItem.titleView viewWithTag:99999];
    [btn setTitle:name forState:UIControlStateNormal];
    [self loadServiceList:@{@"lat":lat,@"lng":lng}];
    [self.cusMap.mapView setCenterCoordinate:CLLocationCoordinate2DMake([lat floatValue], [lng floatValue])];
    [self.cusMap.mapView setZoomLevel:14.1 animated:NO];
}
-(void)cityMo:(CityMo *)mo{
    [self.cusMap.location cleanUpAction];
    [self loadServiceList:@{@"lat":mo.lat,@"lng":mo.lng}];
    [self.cusMap.mapView setCenterCoordinate:CLLocationCoordinate2DMake([mo.lat floatValue], [mo.lng floatValue])];
    [self.cusMap.mapView setZoomLevel:14.1 animated:NO];
}
-(void)setUI{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(MyselfClick) image:@"people" title:@"" EdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
     self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(MessageClick) image:@"index-dope" title:@"" EdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
    self.navigationItem.leftBarButtonItem.badgeValue=self.navigationItem.rightBarButtonItem.badgeValue = @"";
    self.navigationItem.leftBarButtonItem.badgeOriginX = 19;
    self.navigationItem.rightBarButtonItem.badgeOriginX = 29; self.navigationItem.leftBarButtonItem.badgeOriginY = 5;
    self.navigationItem.rightBarButtonItem.badgeOriginY = 2;
   
//    放置导航栏中间城市选择按钮
    //自定义标题视图
    UIView * nav_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
//    nav_view.backgroundColor = [UIColor redColor];
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 30, 25)];
    image.image = [UIImage imageNamed:@"logo"];
    [nav_view addSubview:image];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 60, 44)];
    btn.tag = 99999;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"苏州市" forState:UIControlStateNormal];
    [btn setTitleColor:KFontColor forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"Arrow-xia1"] forState:UIControlStateNormal];
    [btn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:5];
    [btn addTarget:self action:@selector(AddressClick:) forControlEvents:UIControlEventTouchUpInside];
    [nav_view addSubview:btn];
    self.navigationItem.titleView = nav_view;
//    初始化地图
//    [self initMapView];
    if (self.cusMap) {
        [self.cusMap removeFromSuperview];
    }
    self.cusMap = [[CustomMap alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-44-50)];
//    self.cusMap.selectAnimation = YES;
    [self.view_Map addSubview:self.cusMap];
    self.cusMap.delegate = self;
    [self.view_Map bringSubviewToFront:self.btn_mapUserLocation];
     [self.view_Map bringSubviewToFront:self.btn_mapUserLocation];
    [self.view_Map bringSubviewToFront:self.view_notice];
    [self.view_Map bringSubviewToFront:self.btn_SX];
    [self.view_Map bringSubviewToFront:self.view_userLocation];
}
- (void)currentMapLocation:(NSDictionary *)locationDictionary location:(CLLocation*)location{
    self.lab_Location.text =locationDictionary[@"addRess"];
    UIButton * btn = (UIButton *)[self.navigationItem.titleView viewWithTag:99999];
    [btn setTitle:locationDictionary[@"city"] forState:UIControlStateNormal];
}
//回到当前位置的按钮点击
-(void)currentLocationClick:(CLLocationCoordinate2D)location{
//    [self loadServiceList:@{@"lat":[KUserDefults objectForKey:kLat],@"lng":[KUserDefults objectForKey:KLng],@"cityCode":[KUserDefults objectForKey:kUserCityID]}];
}
-(void)currentAnimatinonViewClick:(CustomAnnotationView *)view annotation:(ZWCustomPointAnnotation *)annotation {
    flag = NO;
//    if ([annotation isKindOfClass:[ZWCustomPointAnnotation class]]) {
//        PersonalBasicDataController * show = [PersonalBasicDataController new];
//        show.Receive_Type = ENUM_TypeTrval;
//        show.data_Count = self.cusMap.Arr_Mark;
        __block NSUInteger index = 0;
//        [show.data_Count enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            UserMo * list = (UserMo *)obj;
//            if (annotation.title == list.ID) {
//                index = idx;
//                *stop = YES;
//            }
//            if (self.cusMap.Arr_Mark.count!=0&& [annotation.title isEqualToString:@"当前位置"]&&[[[YSAccountTool userInfo] modelId] isEqualToString:list.ID]) {
//                index = idx;
//                *stop = YES;
//            }
//        }];
//        show.zIndex = index;
//        [self.navigationController pushViewController:show animated:YES];
//    }
    [self.cusMap.Arr_Mark enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UserMo * list = (UserMo *)obj;
        if (annotation.title == list.ID) {
            index = idx;
            *stop = YES;
        }
        if ((annotation.title.length==0||[annotation.title isEqualToString:@"当前位置"])&&[[[YSAccountTool userInfo] modelId] isEqualToString:list.ID]) {
            index = idx;
            *stop = YES;
        }
    }];
    PersonalBasicDataController * center = [PersonalBasicDataController new];
//        UserMo * mo = self.cusMap.Arr_Mark[index];
//        center.connectionMo = mo;
    center.arr_User = self.cusMap.Arr_Mark;
    center.flag = index;
    [self.navigationController pushViewController:center animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden= NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setBackgroundImage:
     [UIImage createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (!flag) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [self.navigationController.navigationBar setBackgroundImage:
         [UIImage imageNamed:@"椭圆2拷贝4"] forBarMetrics:UIBarMetricsDefault];
    }else{
        self.navigationController.navigationBar.hidden= YES;
    }
}
-(void)initData{
    NSDictionary * dic = @{
                           @"pageNumber":@1,
                           @"pageSize":@20,
                           @"cityCode":@([[KUserDefults objectForKey:kUserCityID] intValue]),
                           };
    WeakSelf
    [CircleNet requstNotice:dic withSuc:^(NSMutableArray *successDicValue) {
        if([successDicValue count]==0){
            weakSelf.view_notice.hidden = YES;
        }else{
            weakSelf.view_notice.hidden = NO;
            weakSelf.lab_Notice.text = successDicValue[0][@"content"];
            weakSelf.url = successDicValue[0][@"url"];
        }
    }];
    if ([KUserDefults objectForKey:KAllDic]!=nil) {
        return;
    }
    [YSNetworkTool POST:dictionaryDictionaryAll params:@{} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray * arr1 = [NSMutableArray array];
        for (int i=0; i<[responseObject[@"data"] count]; i++) {
            NSMutableArray * arrContent= [NSMutableArray array];
            AllDicMo * Mo = [AllDicMo mj_objectWithKeyValues:responseObject[@"data"][i]];
            Mo.ID = responseObject[@"data"][i][@"id"];
            NSArray * arr= [YSTools stringToJSON:Mo.content];
            for (int j=0; j<[arr count]; j++) {
                AllContentMo * content = [AllContentMo mj_objectWithKeyValues:arr[j]];
                content.description1 = arr[j][@"description"];
                [arrContent addObject:content];
            }
            Mo.contentArr = arrContent;
            [arr1 addObject:Mo];
        }
        [KUserDefults setObject:[NSKeyedArchiver archivedDataWithRootObject:arr1] forKey:KAllDic];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (IBAction)NoticeClick:(UIButton *)sender {
    AgreementController *agreementVC = [[AgreementController alloc]init];
    agreementVC.url = self.url;
    [self.navigationController pushViewController:agreementVC animated:YES];
}
@end
