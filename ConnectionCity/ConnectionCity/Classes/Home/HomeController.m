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
#import "SendMomentController.h"
@interface HomeController ()<JFCityViewControllerDelegate>
{
    BOOL flag;
    NSInteger currentIndexHome;
}
@property (nonatomic,strong) TravalController * trval;
@property (nonatomic,strong) TravalController * trval2;
@property (nonatomic,strong) ServiceHomeController * trval3;
@property (nonatomic,strong) NewsListController * news;
@property (nonatomic,strong) FriendCircleController * circle1;
@property (nonatomic,strong) FriendCircleController * circle2;
@property (nonatomic,strong) TravalController * trval5;
@property (nonatomic,strong) AbilityHomeController * ability;
@property (nonatomic,strong)NSMutableArray * myMenuArr;
@end

@implementation HomeController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    flag = NO;
    self.myMenuArr  = [NSMutableArray array];
    [self initData];
    
}
-(void)initData{
    WeakSelf
    [HomeNet loadMyMeu:^(NSMutableArray *successArrValue) {
        weakSelf.myMenuArr = successArrValue;
        [weakSelf setUI];
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
    //必要的设置, 如果没有设置可能导致内容显示不正常
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示遮盖
    style.showCover = NO;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    // 显示附加的按钮
    style.showExtraButton = YES;
    style.titleFont = [UIFont systemFontOfSize:16];
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
        flag = NO;
        EditMenuController * edit = [EditMenuController new];
        edit.dataBlock = ^{
            [weakSelf initData];
        };
        [weakSelf.navigationController presentViewController:edit animated:YES completion:nil];
    };
    scrollPageView.Index = ^(NSInteger currentIndex) {
        NSLog(@"当前index为：%ld",currentIndex);
        currentIndexHome = currentIndex;
    };
    [self.view addSubview:scrollPageView];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(MyselfClick) image:@"people" title:@"" EdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(MessageClick) image:@"icon_home_camera" title:@"" EdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
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
    [btn setTitle:@"首页" forState:UIControlStateNormal];
    [btn setTitleColor:KFontColor forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"Arrow-xia1"] forState:UIControlStateNormal];
    [btn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:5];
    [btn addTarget:self action:@selector(AddressClick:) forControlEvents:UIControlEventTouchUpInside];
    [nav_view addSubview:btn];
    self.navigationItem.titleView = nav_view;
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
    flag = NO;
    [self.navigationController pushViewController:[super rotateClass:@"ProfileTwoController"] animated:YES];
}
//导航右侧按钮点击
-(void)MessageClick{
    flag = NO;
    MenuMo * mo = self.myMenuArr[currentIndexHome];
    if ([mo.ID isEqualToString:@"1"]) {
        SendTripController * invit = [SendTripController new];
        invit.block = ^{
            [self.trval.trval.bollec_bottom.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:invit animated:YES];
    }else if ([mo.ID isEqualToString:@"2"]){
        
    }else if ([mo.ID isEqualToString:@"3"]){
        
    }else if ([mo.ID isEqualToString:@"4"]){
        SendMomentController * send = [SendMomentController new];
        send.block = ^{
            [self.circle1.frendTab.mj_header beginRefreshing]; 
        };
        send.flagStr = @"HomeSend";
        [self.navigationController pushViewController:send animated:YES];
    }else if ([mo.ID isEqualToString:@"5"]){
        SendMomentController * send = [SendMomentController new];
        send.block = ^{
            [self.circle2.frendVedio.mj_header beginRefreshing];
         };
        send.flagStr = @"SP";
        [self.navigationController pushViewController:send animated:YES];
    }else if ([mo.ID isEqualToString:@"6"]){
        
    }else if ([mo.ID isEqualToString:@"8"]){
        TrvalInvitController * invit = [TrvalInvitController new];
        invit.block = ^{
            [self.trval2.tab_Bottom.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:invit animated:YES];
    }
    NSLog(@"当前index%ld",currentIndexHome);
}
#pragma mark - JFCityViewControllerDelegate
- (void)cityName:(NSString *)name {
    UIButton * btn = (UIButton *)[self.navigationItem.titleView viewWithTag:99999];
    [btn setTitle:name forState:UIControlStateNormal];
}
-(void)city:(NSString *)name ID:(NSString *)ID lat:(NSString *)lat lng:(NSString *)lng{
    UIButton * btn = (UIButton *)[self.navigationItem.titleView viewWithTag:99999];
    [btn setTitle:name forState:UIControlStateNormal];
    
}
-(void)cityMo:(CityMo *)mo{
    
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
        }
    } 
    return [arr copy];
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
@end
