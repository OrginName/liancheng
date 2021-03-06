//
//  ServiceHomeController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/26.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ServiceHomeController.h"
//#import "CustomMap.h"
#import "JFCityViewController.h"
#import "ClassificationsController.h"
#import "FilterOneController.h"
#import "ShowResumeController.h"
#import "SearchHistoryController.h"
#import "ServiceHomeNet.h"
#import "RefineView.h"
#import "PopThree.h"
#import "SendServiceController.h"
//#import "CustomScro.h"
#import "CustomAnnotationView.h"
#import "ClassificationsController1.h"
#import "privateUserInfoModel.h"
#import "serviceListNewMo.h"
#import "TXScrollLabelView.h"
#import "CircleNet.h"
#import "NoticeMo.h"
#import "AgreementController.h"
#import "PersonalBasicDataController.h"
//CustomScroDelegate
@interface ServiceHomeController ()<JFCityViewControllerDelegate,CustomMapDelegate,PopThreeDelegate,TXScrollLabelViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btn_SXOne;
@property (weak, nonatomic) IBOutlet UIButton *btn_SX;
@property (weak, nonatomic) IBOutlet UIView *notice_Scro;
@property (weak, nonatomic) IBOutlet UILabel *lab_location;
@property (weak, nonatomic) IBOutlet UIView *noticeView;
@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UIView *view_Map;
@property (weak, nonatomic) IBOutlet UIButton *btn_fajianli;
@property (weak, nonatomic) IBOutlet UIView *view_fajianli;
@property (weak, nonatomic) IBOutlet UIView *view_SX;
@property (weak, nonatomic) IBOutlet UIView *view_KeyWords;
@property (nonatomic,strong) NSMutableArray * Arr_SX;
@property (nonatomic,strong) NSMutableArray * Arr_Classify;//分类数据源数组
@property (nonatomic,strong) RefineView * refine;
@property (nonatomic,strong) PopThree * pop;
@property (nonatomic,assign) NSInteger  flag;
@property (nonatomic,strong) NSMutableArray * Arr_keyWords;
@property (nonatomic,strong) TXScrollLabelView *scrollLable;
@property (nonatomic,strong) NSMutableArray * arr_notice;

@end

@implementation ServiceHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    //@"cityCode":[KUserDefults objectForKey:kUserCityID]
    [self setUI];
    [self loadData];
    if ([KUserDefults objectForKey:kUserCityID]!=nil) {
         [self loadServiceList:@{@"lat":[KUserDefults objectForKey:kLat],@"lng":[KUserDefults objectForKey:KLng]}];
    }
//    if ([[[YSAccountTool userInfo] modelId] isEqualToString:APPID]) {
//        self.view_fajianli.hidden = YES;
//        self.btn_fajianli.hidden = YES;
//    }
    _flag = NO;
}
-(void)initData{
    NSDictionary * dic = @{
                           @"pageNumber":@1,
                           @"pageSize":@20,
                           @"cityCode":[KUserDefults objectForKey:kUserCityID]?@([[KUserDefults objectForKey:kUserCityID] intValue]):@"",
                           };
    WeakSelf
    [CircleNet requstNotice:dic withSuc:^(NSMutableArray *successDicValue) {
        if([successDicValue count]==0){
            weakSelf.noticeView.hidden = YES;
        }else{
            weakSelf.noticeView.hidden = NO;
            NSArray * arr = [NoticeMo mj_objectArrayWithKeyValuesArray:successDicValue];
            weakSelf.arr_notice = [arr mutableCopy];
            weakSelf.scrollLable.scrollTitle = [arr[arr.count-1] title];
            [weakSelf.scrollLable beginScrolling];
        }
    }];
}
//导航条人才类型选择
-(void)AddressClick:(UIButton *)btn{
    self.pop = [[[NSBundle mainBundle] loadNibNamed:@"PopThree" owner:nil options:nil] lastObject];
    self.pop.frame = CGRectMake(0, 0, kScreenWidth, 165);
    self.pop.delegate = self;
    self.refine = [[RefineView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) type:self.pop];
    [self.refine alertSelectViewshow];
}
//搜索按钮点击
-(void)SearchClick{
    SearchHistoryController * search = [SearchHistoryController new];
    WeakSelf
    search.block = ^(NSString *str) {
        [weakSelf loadServiceList:@{@"lat":[KUserDefults objectForKey:kLat],@"lng":[KUserDefults objectForKey:KLng],@"keyword":str}];
    };
    [self.navigationController pushViewController:search animated:YES];
}
//PopThreeDelegate声明协议方法
- (void)sendValue:(NSInteger )tag{
    _flag = YES;
    if (tag==1||tag==3) {
        NSString * str = tag==1?@"BaseOneTabController":@"BaseChangeTabController";
        [self.navigationController pushViewController:[super rotateClass:str] animated:YES];
    }
}
//发布简历按钮点击
- (IBAction)sendResume:(UIButton *)sender {
    _flag = NO;
    WeakSelf
    SendServiceController * send = [SendServiceController new];
    send.arr_receive = self.Arr_Classify;
    send.refreshBlock = ^{
        [weakSelf loadServiceList:@{@"lat":[KUserDefults objectForKey:kLat],@"lng":[KUserDefults objectForKey:KLng]}];
    };
    [self.navigationController pushViewController:send animated:YES];
}
//顶部三个筛选按钮的点击
- (IBAction)btn_SX:(UIButton *)sender {
    _flag = NO;
    switch (sender.tag) {
        case 1:
        {
            JFCityViewController * jf= [JFCityViewController new];
            jf.delegate = self;
            BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:jf];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 2:
        {
            ClassificationsController1 * class = [ClassificationsController1 new];
            class.title = @"服务分类";
            class.arr_Data = self.Arr_Classify;
            class.block = ^(NSString *classifiation){
                UILabel * btn = (UILabel *)[self.view_SX viewWithTag:2];
                btn.text = classifiation; 
            };
            class.block1 = ^(NSString *classifiationID, NSString *classifiation) {
                [self loadServiceList:@{@"lat":[KUserDefults objectForKey:kLat],@"lng":[KUserDefults objectForKey:KLng],@"category":classifiationID}];
            };
            [self.navigationController pushViewController:class animated:YES];
        }
            break;
        case 3:
        {
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
                                          @"lat":[KUserDefults objectForKey:kLat],@"lng":[KUserDefults objectForKey:KLng],@"cityCode":[KUserDefults objectForKey:kUserCityID]
                                        }];
            };
            [self.navigationController pushViewController:filter animated:YES];
        }
            break;
        default:
            break;
    }
}
-(void)setUI{
    [super setFlag_back:YES];//设置返回按钮
    self.cusMap = [[CustomMap alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-44-50)];
    self.cusMap.delegate = self;
    [self.view_Map addSubview:self.cusMap];
    self.cusMap.delegate = self;
 
    [self.view_Map bringSubviewToFront:self.locationView];
    [self.view_Map bringSubviewToFront:self.noticeView];
    [self.view_Map bringSubviewToFront:self.btn_SX];
    [self.view_Map bringSubviewToFront:self.btn_SXOne];
 
    NSString *scrollTitle = @"";
    TXScrollLabelView *scrollLabelView = [TXScrollLabelView scrollWithTitle:scrollTitle type:TXScrollLabelViewTypeLeftRight velocity:2 options:UIViewAnimationOptionCurveEaseInOut];
//    scrollLabelView.scrollLabelViewDelegate = self;
    scrollLabelView.scrollInset = UIEdgeInsetsMake(0, -100, 0, 0);
    scrollLabelView.scrollTitleColor = YSColor(40, 40, 40);
    scrollLabelView.font = [UIFont systemFontOfSize:15];
    scrollLabelView.backgroundColor = [UIColor whiteColor];
    scrollLabelView.frame = CGRectMake(0, 0, kScreenWidth-70, 50);
    [self.notice_Scro addSubview:scrollLabelView];
    self.scrollLable = scrollLabelView;
//    [self.view_Map bringSubviewToFront:self.btn_fajianli];
//    [self.view_Map bringSubviewToFront:self.view_fajianli];
//    [self initNavi];
//    [self initRightBarItem];
}
- (IBAction)btn_SXClick:(UIButton *)sender {
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
                                @"lat":[KUserDefults objectForKey:kLat],@"lng":[KUserDefults objectForKey:KLng],@"cityCode":[KUserDefults objectForKey:kUserCityID]
                                }];
    };
    [self.navigationController pushViewController:filter animated:YES];
}
- (IBAction)btn_SXOnew:(UIButton *)sender {
    ClassificationsController1 * class = [ClassificationsController1 new];
    class.title = @"服务分类";
    class.arr_Data = self.Arr_Classify;
    class.block = ^(NSString *classifiation){
        UILabel * btn = (UILabel *)[self.view_SX viewWithTag:2];
        btn.text = classifiation;
    };
    class.block1 = ^(NSString *classifiationID, NSString *classifiation) {
        [self loadServiceList:@{@"lat":[KUserDefults objectForKey:kLat],@"lng":[KUserDefults objectForKey:KLng],@"category":classifiationID}];
    };
    [self.navigationController pushViewController:class animated:YES];
}
-(void)initNavi{
    //自定义标题视图
    UIView * nav_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    btn.tag = 99999;
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:@"约技能" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"Arrow-xia"] forState:UIControlStateNormal];
    [btn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:5];
    [btn addTarget:self action:@selector(AddressClick:) forControlEvents:UIControlEventTouchUpInside];
    [nav_view addSubview:btn];
    self.navigationItem.titleView = nav_view;
}
-(void)initRightBarItem{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(SearchClick) image:@"search" title:@"" EdgeInsets:UIEdgeInsetsZero];
}
#pragma mark - JFCityViewControllerDelegate
- (void)cityName:(NSString *)name {
    UILabel * btn = (UILabel *)[self.view_SX viewWithTag:1];
    btn.text = name;
}
-(void)city:(NSString *)name ID:(NSString *)ID lat:(NSString *)lat lng:(NSString *)lng{
    [self.cusMap.location cleanUpAction];
    UILabel * btn = (UILabel *)[self.view_SX viewWithTag:1];
    btn.text = name;
//    @"cityCode":ID
    [self loadServiceList:@{@"lat":lat,@"lng":lng}];
    [self.cusMap.mapView setCenterCoordinate:CLLocationCoordinate2DMake([lat floatValue], [lng floatValue])];
    [self.cusMap.mapView setZoomLevel:15.1 animated:NO];
}
-(void)cityMo:(CityMo *)mo{
    [self.cusMap.location cleanUpAction];
    [self loadServiceList:@{@"lat":mo.lat,@"lng":mo.lng}];
    [self.cusMap.mapView setCenterCoordinate:CLLocationCoordinate2DMake([mo.lat floatValue], [mo.lng floatValue])];
    [self.cusMap.mapView setZoomLevel:15.1 animated:NO];
}
#pragma mark - CustomMapDelegate
- (void)currentMapLocation:(NSDictionary *)locationDictionary location:(CLLocation*)location{
//    UILabel * btn = (UILabel *)[self.view_SX viewWithTag:1];
//    btn.text = locationDictionary[@"city"];
    self.lab_location.text =locationDictionary[@"addRess"];
    [self initData];
}
//回到当前位置的按钮点击
-(void)currentLocationClick:(CLLocationCoordinate2D)location{
//    if(self.cusMap.mapView.userLocation.updating && self.cusMap.mapView.userLocation.location) {
//        [self.cusMap.mapView setCenterCoordinate:self.cusMap.mapView.userLocation.location.coordinate animated:YES];
//        [self.cusMap.mapView setZoomLevel:15.1 animated:NO];
//    }
    
}
-(void)dragCenterLocation:(CLLocationCoordinate2D)location{
//    ,@"cityCode":[KUserDefults objectForKey:kUserCityID]
    [self loadServiceList:@{@"lat":KString(@"%f", location.latitude),@"lng":KString(@"%f", location.longitude),@"distance":KDistance}];
}
-(void)currentAnimatinonViewClick:(CustomAnnotationView *)view annotation:(ZWCustomPointAnnotation *)annotation {
    WeakSelf
    NSMutableArray * rArr = [NSMutableArray array];
    NSMutableArray * uArr = [NSMutableArray array];
//    __block NSUInteger index = 0;
//    __block BOOL flag = NO;
    [self.cusMap.Arr_Mark enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        serviceListNewMo* list = (serviceListNewMo *)obj;
        if ([list.hasService isEqualToString:@"1"]) {
            [rArr addObject:list];
        }else{
            [uArr addObject:list];
        }
    }];
    [rArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        serviceListNewMo* list = (serviceListNewMo *)obj;
        if ((annotation.title == list.ID||(([annotation.title isEqualToString:@"当前位置"]||annotation.title.length==0)&&[[[YSAccountTool userInfo]modelId]isEqualToString:list.ID]))&&[list.hasService isEqualToString:@"1"]) {
            ShowResumeController * show = [ShowResumeController new];
            show.Receive_Type = ENUM_TypeTrval;
            show.flag = @"1";
            show.data_Count = rArr;
            show.zIndex = idx;
            [weakSelf.navigationController pushViewController:show animated:YES];
            *stop = YES;
         }
    }];
    [uArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        serviceListNewMo* list = (serviceListNewMo *)obj;
        if ((annotation.title == list.ID||(([annotation.title isEqualToString:@"当前位置"]||annotation.title.length==0)&&[[[YSAccountTool userInfo]modelId]isEqualToString:list.ID]))&&[list.hasService isEqualToString:@"0"]) {
            PersonalBasicDataController * person = [PersonalBasicDataController new];
            UserMo * user = [UserMo new];
            serviceListNewMo * list = (serviceListNewMo *)obj;
            user.ID = list.ID;
            person.connectionMo = user;
            [weakSelf.navigationController pushViewController:person animated:YES];
            *stop = YES;
        }
    }];
}
//加载服务列表数据
-(void)loadServiceList:(NSDictionary *)dic{
    NSDictionary * dic1 = @{
                            @"age": dic[@"age"]?dic[@"age"]:@"",
                            @"category": dic[@"category"]?dic[@"category"]:@"",
                            @"cityCode":dic[@"cityCode"]?dic[@"cityCode"]:@"",
                           @"distance":@([dic[@"distance"]?dic[@"distance"]:KDistance integerValue]),
                            
                            @"gender":
                                dic[@"gender"]?@([dic[@"gender"] integerValue]):@"",
                            @"lat": @([dic[@"lat"] floatValue]),
                            @"lng": @([dic[@"lng"] floatValue]),
                            @"userStatus": dic[@"userStatus"]?@([dic[@"userStatus"] integerValue]):@"",
                            @"validType":
                                dic[@"validType"]?@([dic[@"validType"] integerValue]):@"",
                            @"keyword":dic[@"keyword"]?dic[@"keyword"]:@""
                            };
    //    加载服务列表
    [ServiceHomeNet requstServiceList:dic1 withSuc:^(NSMutableArray *successArrValue) {
        self.cusMap.Arr_Mark = successArrValue;
    }];
}
-(void)loadData{
    self.Arr_SX = [NSMutableArray array];
    self.Arr_Classify = [NSMutableArray array];
    self.Arr_keyWords = [NSMutableArray array];
//    服务类别列表
    [ServiceHomeNet requstServiceClass:^(NSMutableArray *successArrValue) {
        self.Arr_Classify = successArrValue;
    }];
//    关键字
//    [ServiceHomeNet requstServiceHot:^(NSMutableArray *successArrValue) {
//        self.Arr_keyWords = successArrValue;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self loadketBtn:successArrValue];
//        });
//    }];
}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden= NO;
//}
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    if (_flag) {
//        self.navigationController.navigationBar.hidden= YES;
//    }
//}
//#pragma mark ---初始化关键字button加载-----
//-(void)loadketBtn:(NSMutableArray *)arr{
//    CustomScro * cus = [[CustomScro alloc] initWithFrame:CGRectMake(103, 52, kScreenWidth-113, 47) arr:[arr copy] flag:NO];
//    cus.delegate = self;
//    [self.view addSubview:cus];
//}
-(void)CustomScroBtnClick:(UIButton *)tag{
    [self loadServiceList:@{@"lat":[KUserDefults objectForKey:kLat],@"lng":[KUserDefults objectForKey:KLng],@"keyword":tag.titleLabel.text}];
}
#pragma mark - LMJScrollTextView2 Delegate
- (void)scrollLabelView:(TXScrollLabelView *)scrollLabelView didClickWithText:(NSString *)text atIndex:(NSInteger)index{
    NoticeMo * mo  = self.arr_notice[self.arr_notice.count-1];
    AgreementController *agreementVC = [[AgreementController alloc]init];
    agreementVC.title = @"详情";
    agreementVC.url = mo.url;
    [self.navigationController pushViewController:agreementVC animated:YES];
}
@end
