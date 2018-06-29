//
//  ServiceHomeController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/26.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ServiceHomeController.h"
#import "CustomMap.h"
#import "JFCityViewController.h"
#import "ClassificationsController.h"
#import "FilterOneController.h"
#import "ShowResumeController.h"
#import "SearchHistoryController.h"
#import "ServiceHomeNet.h"
#import "RefineView.h"
#import "PopThree.h"
#import "SendServiceController.h"
#import "CustomScro.h"
#import "CustomAnnotationView.h"
@interface ServiceHomeController ()<JFCityViewControllerDelegate,CustomMapDelegate,PopThreeDelegate,CustomScroDelegate>
@property (weak, nonatomic) IBOutlet UIView *view_Map;
@property (weak, nonatomic) IBOutlet UIButton *btn_fajianli;
@property (weak, nonatomic) IBOutlet UIView *view_fajianli;
@property (weak, nonatomic) IBOutlet UIView *view_SX;
@property (weak, nonatomic) IBOutlet UIView *view_KeyWords;
@property (nonatomic,strong) CustomMap *cusMap;
@property (nonatomic,strong) NSMutableArray * Arr_SX;
@property (nonatomic,strong) NSMutableArray * Arr_Classify;//分类数据源数组
@property (nonatomic,strong) RefineView * refine;
@property (nonatomic,strong) PopThree * pop;
@property (nonatomic,assign) NSInteger  flag;
@property (nonatomic,strong) NSMutableArray * Arr_keyWords;
@end

@implementation ServiceHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUI];
    [self loadData];
    if ([KUserDefults objectForKey:kUserCityID]!=nil) {
         [self loadServiceList:@{@"lat":[KUserDefults objectForKey:kLat],@"lng":[KUserDefults objectForKey:KLng],@"cityCode":[KUserDefults objectForKey:kUserCityID]}];
    }
    _flag = NO;
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
//关键字点击
-(void)KeyWordsClick:(UIButton *)btn{
    [YTAlertUtil showTempInfo:@"关键字点击"];
}
//发布简历按钮点击
- (IBAction)sendResume:(UIButton *)sender {
    _flag = NO;
    SendServiceController * send = [SendServiceController new];
    send.arr_receive = self.Arr_Classify;
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
            ClassificationsController * class = [ClassificationsController new];
            class.title = @"服务分类";
            class.arr_Data = self.Arr_Classify;
            class.block = ^(NSString *classifiation){
                UILabel * btn = (UILabel *)[self.view_SX viewWithTag:2];
                btn.text = classifiation;
                
            };
            class.block1 = ^(NSString *classifiationID, NSString *classifiation) {
                [self loadServiceList:@{@"lat":[KUserDefults objectForKey:kLat],@"lng":[KUserDefults objectForKey:KLng],@"cityCode":[KUserDefults objectForKey:kUserCityID],@"category":classifiationID}];
            };
            [self.navigationController pushViewController:class animated:YES];
        }
            break;
        case 3:
        {
            FilterOneController * filter = [FilterOneController new];
            filter.title = @"筛选条件";
            filter.flag_SX = 1;
            [self.navigationController pushViewController:filter animated:YES];
        }
            break;
        default:
            break;
    }
}
 
-(void)setUI{
    [super setFlag_back:YES];//设置返回按钮
    self.cusMap = [[CustomMap alloc] initWithFrame:CGRectMake(0, 0, self.view_Map.width, self.view_Map.height) ];
    self.cusMap.delegate = self;
    [self.view_Map addSubview:self.cusMap];
    [self.view_Map bringSubviewToFront:self.btn_fajianli];
    [self.view_Map bringSubviewToFront:self.view_fajianli];
    [self initNavi];
    [self initRightBarItem];
}
-(void)initNavi{
    //自定义标题视图
    UIView * nav_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    btn.tag = 99999;
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:@"服务" forState:UIControlStateNormal];
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
-(void)cityMo:(CityMo *)mo{
    [self loadServiceList:@{@"lat":mo.lat,@"lng":mo.lng,@"cityCode":mo.ID}];
    [self.cusMap.mapView setCenterCoordinate:CLLocationCoordinate2DMake([mo.lat floatValue], [mo.lng floatValue])];
    [self.cusMap.mapView setZoomLevel:15.1 animated:NO];
}
#pragma mark - CustomMapDelegate
- (void)currentMapLocation:(NSDictionary *)locationDictionary location:(CLLocation*)location{
    UILabel * btn = (UILabel *)[self.view_SX viewWithTag:1];
    btn.text = locationDictionary[@"city"];
}
//回到当前位置的按钮点击
-(void)currentLocationClick{
   [self loadServiceList:@{@"lat":[KUserDefults objectForKey:kLat],@"lng":[KUserDefults objectForKey:KLng],@"cityCode":[KUserDefults objectForKey:kUserCityID]}];
    [self.cusMap.mapView setCenterCoordinate:CLLocationCoordinate2DMake([[KUserDefults objectForKey:kLat] floatValue], [[KUserDefults objectForKey:KLng] floatValue])];
    [self.cusMap.mapView setZoomLevel:15.1 animated:NO];
}
-(void)currentAnimatinonViewClick:(MAAnnotationView *)view index:(NSInteger)indexView{
    if ([KString(@"%f", view.annotation.coordinate.latitude) isEqualToString:[KUserDefults objectForKey:kLat]]&&[KString(@"%f", view.annotation.coordinate.longitude) isEqualToString:[KUserDefults objectForKey:KLng]]) {
        [YTAlertUtil showTempInfo:@"当前点击的为自己位置"];
        return;
    }
    ShowResumeController * show = [ShowResumeController new];
    show.Receive_Type = ENUM_TypeTrval;
    show.data_Count = self.cusMap.Arr_Mark;
    show.zIndex = indexView;
    NSLog(@"当前zindex为：%ld",indexView);
    [self.navigationController pushViewController:show animated:YES];
}
//加载服务列表数据
-(void)loadServiceList:(NSDictionary *)dic{
    NSDictionary * dic1 = @{
                            @"age": @"",
                            @"areaCode": @"",
                            @"provinceCode": @"",
                            @"category": dic[@"category"]?dic[@"category"]:@"",
                            @"cityCode":dic[@"cityCode"],
                            @"distance": @"",
                            @"gender": @0,
                            @"lat": @([dic[@"lat"] floatValue]),
                            @"lng": @([dic[@"lng"] floatValue]),
                            @"userStatus": @0,
                            @"validType": @""
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
    [ServiceHomeNet requstServiceKeywords:^(NSMutableArray *successArrValue) {
        self.Arr_keyWords = successArrValue;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadketBtn:successArrValue];
        });
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden= NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_flag) {
        self.navigationController.navigationBar.hidden= YES;
    }
}
#pragma mark ---初始化关键字button加载-----
-(void)loadketBtn:(NSMutableArray *)arr{
//    for (int i=0; i<arr.count;i++) {
//        float width = [YSTools caculateTheWidthOfLableText:14 withTitle:arr[i]]+10;
//        if (width<40) {
//            width=40;
//        }
//        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(i*width, 0, width, 47)];
//        btn.tag = i+1;
//        [btn setTitle:arr[i] forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btn setBackgroundColor:[UIColor whiteColor]];
//        [btn addTarget:self action:@selector(KeyWordsClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view_KeyWords addSubview:btn];
//    }
    CustomScro * cus = [[CustomScro alloc] initWithFrame:CGRectMake(103, 52, kScreenWidth-113, 47) arr:[arr copy]];
    cus.delegate = self;
    [self.view addSubview:cus];
}
-(void)btnClick:(NSInteger)tag{
    [YTAlertUtil showTempInfo:@"热门职业点击"];
}
@end
