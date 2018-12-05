//
//  HomeController.m
//  ConnectionCity
//
//  Created by qt on 2018/11/3.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "HomeController.h"
#import "ZJScrollPageView.h"
#import "MessageController.h"
#import "EditMenuController.h"
#import "NoticeController.h"
#import "JFCityViewController.h"
#import "HomeNet.h"
#import "MenuMo.h"
#import "TravalController.h"
#import "NewsListController.h"
#import "ServiceHomeController.h"
#import "FriendCircleController.h"
#import "AbilityHomeController.h"
#import "TrvalInvitController.h"
#import "SendTripController.h"
#import "AllDicMo.h"
#import "OurResumeMo.h"
#import "ResumeController.h"
#import "SendMomentController.h"
#import "SendServiceController.h"
#import "ServiceHomeNet.h"
#import "ClassifyMo.h"
#import "RecommendController.h"
#import "FollowController.h"
#import "CustomMap.h"
#import "SecureController.h"
@interface HomeController ()<JFCityViewControllerDelegate>
{
    BOOL flag1;
    NSInteger currentIndexHome;
}
@property (weak, nonatomic) IBOutlet UIView *view_Bottom;
@property (weak, nonatomic) IBOutlet UIView *notice_Scro;
@property (weak, nonatomic) IBOutlet UIView *noticeView;
@property (nonatomic,strong) TravalController * trval;
@property (nonatomic,strong) TravalController * trval2;
@property (nonatomic,strong) ServiceHomeController * trval3;
@property (nonatomic,strong) NewsListController * news;
@property (nonatomic,strong) FriendCircleController * circle1;
@property (nonatomic,strong) FriendCircleController * circle2;
@property (nonatomic,strong) TravalController * trval5;
@property (nonatomic,strong) AbilityHomeController * ability;
@property (nonatomic,strong)NSMutableArray * myMenuArr;
@property (nonatomic,strong) NSMutableArray * Arr_Classify;//分类数据源数组
@property (nonatomic,strong)UIImageView * image_security;
@end

@implementation HomeController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    flag1 = NO; 
    self.myMenuArr  = [NSMutableArray array];
    [KUserDefults removeObjectForKey:YCode];
    [KUserDefults removeObjectForKey:YLat];
    [KUserDefults removeObjectForKey:YLng];
    [self setUI1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upDataANme) name:@"CityNameN" object:nil];
    [self initData];
}
-(void)setUI1{
    CustomMap * map = [[CustomMap alloc] initWithFrame:CGRectZero];
    map.hidden = YES;
    [self.view addSubview:map];
    
}
-(void)upDataANme{
    UIButton * btn = (UIButton *)[self.navigationItem.titleView viewWithTag:99999];
    [btn setTitle:@"首页" forState:UIControlStateNormal];
}
-(void)initData{
    WeakSelf
    [HomeNet loadMyMeu:^(NSMutableArray *successArrValue) {
        weakSelf.myMenuArr = successArrValue;
        [weakSelf setUI];
    }];
    self.Arr_Classify = [NSMutableArray array];
     //    服务类别列表
    [ServiceHomeNet requstServiceClass:^(NSMutableArray *successArrValue) {
        self.Arr_Classify = successArrValue;
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
-(void)setUI{
    
//    //必要的设置, 如果没有设置可能导致内容显示不正常
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示遮盖
    style.showCover = NO;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    // 显示附加的按钮
    style.showExtraButton = YES;
    style.titleFont = [UIFont systemFontOfSize:18];
    style.selectedTitleColor = YSColor(249, 145, 0);
    // 设置附加按钮的背景图片
//    style.extraBtnBackgroundImageName = @"our-more";
    style.extraBtnTitleName = @"●●●";
    // 设置子控制器 --- 注意子控制器需要设置title, 将用于对应的tag显示title
    NSArray *childVcs = [NSArray arrayWithArray:[self setupChildVcAndTitle]];
    // 初始化
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, self.view.bounds.size.height) segmentStyle:style childVcs:childVcs parentViewController:self];
    // 额外的按钮响应的block
    WeakSelf
    scrollPageView.extraBtnOnClick = ^(UIButton *extraBtn){
        flag1 = NO;
        EditMenuController * edit = [EditMenuController new];
        edit.dataBlock = ^{
            [weakSelf initData];
        };
        [weakSelf.navigationController presentViewController:edit animated:YES completion:nil];
    };
    scrollPageView.Index = ^(NSInteger currentIndex) {
        NSLog(@"当前index为：%ld",currentIndex);
        currentIndexHome = currentIndex;
        MenuMo * mo1 = self.myMenuArr[currentIndexHome];
        if ([mo1.ID isEqualToString:@"9"]||[mo1.ID isEqualToString:@"10"]) {
            self.navigationItem.rightBarButtonItem = nil;
        }else{
            if (self.navigationItem.rightBarButtonItem == nil) {
                if (![[[YSAccountTool userInfo] modelId] isEqualToString:APPID]) {
                    weakSelf.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(MessageClick) image:@"photo" title:@"" EdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
                }
            }
        }
        if (([KUserDefults objectForKey:YLat]!=nil&&[KUserDefults objectForKey:YLng]!=nil)||[KUserDefults objectForKey:YCode]!=nil) {
            [weakSelf homeLoadData:@"" lng:@"" ID:@""];
        }
    };
    [self.view_Bottom addSubview:scrollPageView];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(MyselfClick) image:@"people" title:@"" EdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    NSLog(@"%@=+==%@",[[YSAccountTool userInfo] modelId],APPID);
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
//    btn.backgroundColor = [UIColor redColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"首页" forState:UIControlStateNormal];
    [btn setTitleColor:KFontColor forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"Arrow-xia1"] forState:UIControlStateNormal];
    [btn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:15];
    [btn addTarget:self action:@selector(AddressClick:) forControlEvents:UIControlEventTouchUpInside];
    [nav_view addSubview:btn];
    self.navigationItem.titleView = nav_view;
    
    [self.view addSubview:self.image_security];
}
//城市选择按钮点击
-(void)AddressClick:(UIButton *)btn{
    JFCityViewController * jf= [JFCityViewController new];
    jf.delegate = self;
    BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:jf];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
//导航左按钮我的点击
-(void)MyselfClick{
    flag1 = NO;
    [self.navigationController pushViewController:[super rotateClass:@"ProfileTwoController"] animated:YES];
}
//导航右侧按钮点击
-(void)MessageClick{
    flag1 = NO;
    MenuMo * mo = self.myMenuArr[currentIndexHome];
    if ([mo.ID isEqualToString:@"1"]) {
        SendTripController * invit = [SendTripController new];
        invit.block = ^{
            [self.trval.trval.bollec_bottom.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:invit animated:YES];
    }else if ([mo.ID isEqualToString:@"2"]){
        SendServiceController * send = [SendServiceController new];
        NSMutableArray * arr = [NSMutableArray array];
        for (int i=0; i<self.Arr_Classify.count; i++) {
            ClassifyMo * mo = self.Arr_Classify[i];
            if ([[mo.ID description] isEqualToString:@"103"]) {
                [arr addObject:mo];
            }
        }
        send.arr_receive = arr;
        WeakSelf
        send.refreshBlock = ^{
            [weakSelf.news.tab_Bottom.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:send animated:YES];
    }else if ([mo.ID isEqualToString:@"3"]){
        SendServiceController * send = [SendServiceController new];
        send.arr_receive = self.Arr_Classify;
        send.refreshBlock = ^{
            [self.trval3 loadServiceList:@{@"lat":[KUserDefults objectForKey:kLat],@"lng":[KUserDefults objectForKey:KLng]}];
        };
        [self.navigationController pushViewController:send animated:YES];
        
    }else if ([mo.ID isEqualToString:@"4"]){
        SendMomentController * send = [SendMomentController new];
        send.block = ^{
            [self.circle1.frendTab.mj_header beginRefreshing]; 
        };
        send.flagStr = @"CircleSend";
        [self.navigationController pushViewController:send animated:YES];
    }else if ([mo.ID isEqualToString:@"5"]){
        SendMomentController * send = [SendMomentController new];
        send.block = ^{
            [self.circle2.frendVedio.mj_header beginRefreshing];
         };
        send.flagStr = @"SP";
        [self.navigationController pushViewController:send animated:YES];
    }else if ([mo.ID isEqualToString:@"6"]){
        [YSNetworkTool POST:v1MyResumePage params:@{@"pageNumber": @1,@"pageSize":@20} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"data"][@"content"] count]!=0) {
                NSArray * arr = [OurResumeMo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"content"]];
                OurResumeMo *mo = arr[0];
                ResumeController * resume = [ResumeController new];
                resume.resume = mo;
                [self.navigationController pushViewController:resume animated:YES];
            }else{
                [self.navigationController pushViewController:[self rotateClass:@"ResumeController"] animated:YES];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    }else if ([mo.ID isEqualToString:@"8"]){
        TrvalInvitController * invit = [TrvalInvitController new];
        invit.block = ^{
            [self.trval2.tab_Bottom.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:invit animated:YES];
    }
    NSLog(@"当前index%ld",(long)currentIndexHome);
}
#pragma mark - JFCityViewControllerDelegate
#pragma mark - JFCityViewControllerDelegate
- (void)cityName:(NSString *)name {
    UIButton * btn = (UIButton *)[self.navigationItem.titleView viewWithTag:99999];
    [btn setTitle:name forState:UIControlStateNormal];
}
-(void)city:(NSString *)name ID:(NSString *)ID lat:(NSString *)lat lng:(NSString *)lng{
    UIButton * btn = (UIButton *)[self.navigationItem.titleView viewWithTag:99999];
    [btn setTitle:name forState:UIControlStateNormal];
    [self homeLoadData:lat lng:lng ID:ID];
}
-(void)cityMo:(CityMo *)mo{
    [self homeLoadData:mo.lat lng:mo.lng ID:mo.ID];
}
#pragma mark ----根据城市筛选加载数据-------------
-(void)homeLoadData:(NSString *)lat lng:(NSString *)lng ID:(NSString *)cityCode{
    flag1 = NO;
    [KUserDefults setObject:lat forKey:YLat];
    [KUserDefults setObject:lng forKey:YLng];
    [KUserDefults setObject:cityCode forKey:YCode]; 
    MenuMo * mo1 = self.myMenuArr[currentIndexHome];
 
    if ([mo1.ID isEqualToString:@"1"]) {
        self.trval.trval.page = 1;
        [self.trval.trval loadData:@{@"lat":@"",@"lng":@""}];
    }else if ([mo1.ID isEqualToString:@"2"]){
        self.news.page = 1;
        [self.news requstLoad:cityCode];
    }else if ([mo1.ID isEqualToString:@"3"]){
        [self.trval3 loadServiceList:@{@"lat":@"",@"lng":@""}];
        [self.trval3.cusMap.mapView setCenterCoordinate:CLLocationCoordinate2DMake([lat floatValue], [lng floatValue])];
        [self.trval3.cusMap.mapView setZoomLevel:15.1 animated:NO];
    }else if ([mo1.ID isEqualToString:@"4"]){
        self.circle1.frendTab.page = 1;
        [self.circle1.frendTab loadDataFriendList:cityCode];
    }else if ([mo1.ID isEqualToString:@"6"]){
        [self.ability loadServiceList:@{@"lat":@"",@"lng":@""}];
        [self.ability.cusMap.mapView setCenterCoordinate:CLLocationCoordinate2DMake([lat floatValue], [lng floatValue])];
        [self.ability.cusMap.mapView setZoomLevel:15.1 animated:NO];
    }else if ([mo1.ID isEqualToString:@"5"]){
        self.circle2.frendVedio.page = 1;
        [self.circle2.frendVedio loadDataFriendList:cityCode flag:@"Home"];
    }else if ([mo1.ID isEqualToString:@"8"]){
        self.trval2.page = 1;
        [self.trval2 requstLoad:@{@"lat":@"",@"lng":@""}];
    }
}
- (NSArray *)setupChildVcAndTitle {
    TravalController * trval;
    TravalController * trval2;
    ServiceHomeController * trval3;
    NewsListController * news;
    FriendCircleController * circle1;
    FriendCircleController * circle2;
    TravalController * trval5;
    AbilityHomeController * ability;
    NSMutableArray * arr = [NSMutableArray array];
    for (MenuMo * mo in self.myMenuArr) {
        if ([mo.ID isEqualToString:@"1"]) {//旅行
            trval = [TravalController new];
            trval.isInvitOrTrval = YES;
            trval.title = mo.name;
            self.trval = trval;
            [arr addObject:trval];
         }else if ([mo.ID isEqualToString:@"2"]){//娱乐
            news = [NewsListController new];
            news.title = mo.name;
            self.news = news;
            [arr addObject:news];
         }
        else if ([mo.ID isEqualToString:@"3"]){//生活
            trval3 = [ServiceHomeController new];
            trval3.title = mo.name;
            self.trval3 = trval3;
           [arr addObject:trval3];
        }
        else if ([mo.ID isEqualToString:@"4"]){//圈子
            circle1 = [FriendCircleController new];
            circle1.title = mo.name;
            circle1.flagCircle = @"QZ";
            self.circle1 = circle1;
           [arr addObject:circle1];
        }else if ([mo.ID isEqualToString:@"5"]){//视频
            circle2 = [FriendCircleController new];
            circle2.title = mo.name;
            circle2.flagCircle = @"SP";
            self.circle2 = circle2;
            [arr addObject:circle2];
        }
        else if ([mo.ID isEqualToString:@"6"]){//工作
            ability = [AbilityHomeController new];
            ability.title = mo.name;
            self.ability = ability;
            [arr addObject:ability];
        }else if ([mo.ID isEqualToString:@"7"]){//赚外快
            trval5 = [TravalController new];
            trval5.title = mo.name;
            self.trval5 = trval5;
            [arr addObject:trval5];
        }
        else if ([mo.ID isEqualToString:@"8"]){//旅行邀约
            trval2 = [TravalController new];
            trval2.isInvitOrTrval = NO;
            trval2.title = mo.name;
            self.trval2 = trval2;
            [arr addObject:trval2];
        }else if ([mo.ID isEqualToString:@"9"]){
            RecommendController * recommed = [RecommendController new];
            recommed.title = mo.name;
            [arr addObject:recommed];
            
        }else if ([mo.ID isEqualToString:@"10"]){
            FollowController * follow = [FollowController new];
            follow.title = mo.name;
            [arr addObject:follow];
        }
    } 
    return [arr copy];
}
#pragma mark ----secClick--------
-(void)secClick{
    //弹出ViewController
    SecureController *xVC = [SecureController new];
    //设置ViewController的背景颜色及透明度
    xVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:xVC];
    //设置ViewController的模态模式，即ViewController的显示方式
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    nav.view.backgroundColor = [UIColor clearColor];
    //加载模态视图
    [self presentViewController:nav animated:YES completion:^{
    }];
}
-(UIImageView *)image_security{
    if (!_image_security) {
        _image_security = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight/2+30, 120, 50)];
        _image_security.image = [UIImage imageNamed:@"secure"];
        _image_security.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secClick)];
        [_image_security addGestureRecognizer:tap];
    }
    return _image_security;
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
    if (!flag1) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [self.navigationController.navigationBar setBackgroundImage:
         [UIImage imageNamed:@"椭圆2拷贝4"] forBarMetrics:UIBarMetricsDefault];
    }else{
        self.navigationController.navigationBar.hidden= YES;
    }
}
@end
