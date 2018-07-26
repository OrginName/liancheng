//
//  AbilityHomeController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/9.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AbilityHomeController.h"
#import "CustomMap.h"
#import "JFCityViewController.h"
#import "ClassificationsController.h"
#import "FilterOneController.h"
#import "ShowResumeController.h"
#import "SearchHistoryController.h"
#import "RefineView.h"
#import "PopThree.h"
#import "AbilityNet.h"
#import "CustomScro.h"
#import "AbilttyMo.h"

@interface AbilityHomeController ()<JFCityViewControllerDelegate,CustomMapDelegate,PopThreeDelegate,CustomScroDelegate>
@property (weak, nonatomic) IBOutlet UIView *view_Map;
@property (weak, nonatomic) IBOutlet UIButton *btn_fajianli;
@property (weak, nonatomic) IBOutlet UIView *view_fajianli;
@property (weak, nonatomic) IBOutlet UIView *view_SX;
@property (weak, nonatomic) IBOutlet UIView *view_keyWords;
@property (nonatomic,strong) CustomMap *cusMap;
@property (nonatomic,strong) RefineView * refine;
@property (nonatomic,strong) PopThree * pop;
@property (nonatomic,assign) NSInteger  flag;
@property (nonatomic,strong) NSMutableArray * arr_Class;
@end

@implementation AbilityHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self initData];
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
     _flag=NO;
    SearchHistoryController * search = [SearchHistoryController new];
    search.flagStr = @"FIND";
    WeakSelf
    search.block = ^(NSString *str) {
        [weakSelf loadServiceList:@{@"lat":[KUserDefults objectForKey:kLat],@"lng":[KUserDefults objectForKey:KLng],@"cityID":[KUserDefults objectForKey:kUserCityID],@"keyword":str}];
    };
    [self.navigationController pushViewController:search animated:YES];
}

//发布简历按钮点击
- (IBAction)sendResume:(UIButton *)sender {
    _flag = NO;
    [self.navigationController pushViewController:[self rotateClass:@"ResumeController"] animated:YES];
}
//PopThreeDelegate声明协议方法
- (void)sendValue:(NSInteger )tag{
    _flag = YES;
    if (tag==2||tag==3) {
        NSString * str = tag==2?@"BaseFindServiceTabController":@"BaseChangeTabController";
        [self.navigationController pushViewController:[super rotateClass:str] animated:YES];
    }
}
//顶部三个筛选按钮的点击
- (IBAction)btn_SX:(UIButton *)sender {
    _flag=NO;
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
            class.title = @"职业分类";
            class.arr_Data = self.arr_Class;
            class.block = ^(NSString *classifiation){
                UILabel * btn = (UILabel *)[self.view_SX viewWithTag:2];
                btn.text = classifiation;
            };
            class.block1 = ^(NSString *classifiationID, NSString *classifiation) {
                [self loadServiceList:@{@"lat":[KUserDefults objectForKey:kLat],@"lng":[KUserDefults objectForKey:KLng],@"cityID":[KUserDefults objectForKey:kUserCityID],@"category":classifiationID}];
            };
            [self.navigationController pushViewController:class animated:YES];
        }
            break;
        case 3:
        {
            FilterOneController * filter = [FilterOneController new];
            filter.title = @"筛选条件";
            filter.flag_SX = 2;
            filter.block = ^(NSDictionary *strDic) {
                [self loadServiceList:@{@"cityID":[KUserDefults objectForKey:kUserCityID],@"lat":[KUserDefults objectForKey:kLat],@"lng":[KUserDefults objectForKey:KLng],
                                        @"salary":strDic[@"2"],
                                        @"education":strDic[@"1"],
                                        @"work":strDic[@"0"]
                                        }];
            };
            [self.navigationController pushViewController:filter animated:YES];
        }
            break;
        default:
            break;
    }
}
//关键字点击
-(void)KeyWordsClick:(UIButton *)btn{
    [YTAlertUtil showTempInfo:@"关键字点击"];
}
#pragma mark ----初始化加载数据（开始）------
-(void)initData{
    [self loadServiceList:@{@"cityID":[KUserDefults objectForKey:kUserCityID],@"lat":[KUserDefults objectForKey:kLat],@"lng":[KUserDefults objectForKey:KLng]}];
//    热门职业加载
    [AbilityNet requstAbilityKeyWords:^(NSMutableArray *successArrValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadketBtn:successArrValue];
        });
    }];
    //    加载分类数据
    [AbilityNet requstAbilityClass:^(NSMutableArray *successArrValue) {
        self.arr_Class = successArrValue;
    }];

}
//加载简历列表数据
-(void)loadServiceList:(NSDictionary *)dic{
    NSDictionary * dic1 = @{
                            @"lat": @([dic[@"lat"] floatValue]),
                            @"lng": @([dic[@"lng"] floatValue]),
                            @"category": dic[@"category"]?dic[@"category"]:@"",
                            @"cityCode":dic[@"cityID"],
                            @"salary": @([dic[@"salary"]?dic[@"salary"]:@"" integerValue]),
                            @"education": @([dic[@"education"]?dic[@"education"]:@"" integerValue]),
                            @"work": @([dic[@"work"]?dic[@"work"]:@"" integerValue]),
                            @"keyword":dic[@"keyword"]?dic[@"keyword"]:@""
                            };
    //    加载服务列表
    [AbilityNet requstAbilityConditions:dic1 withBlock:^(NSMutableArray *successArrValue) {
        self.cusMap.Arr_Mark = successArrValue;
    }];
}
#pragma mark ----初始化加载数据（结束）------
-(void)setUI{
    [super setFlag_back:YES];
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
    [btn setTitle:@"人才" forState:UIControlStateNormal];
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
    UILabel * btn = (UILabel *)[self.view_SX viewWithTag:1];
    btn.text = name;
    [self loadServiceList:@{@"lat":lat,@"lng":lng,@"cityCode":ID}];
    [self.cusMap.mapView setCenterCoordinate:CLLocationCoordinate2DMake([lat floatValue], [lng floatValue])];
    [self.cusMap.mapView setZoomLevel:15.1 animated:NO];
}
#pragma mark - CustomMapDelegate
- (void)currentMapLocation:(NSDictionary *)locationDictionary location:(CLLocation*)location{
    UILabel * btn = (UILabel *)[self.view_SX viewWithTag:1];
    btn.text = locationDictionary[@"city"];
}
-(void)currentAnimatinonViewClick:(CustomAnnotationView *)view annotation:(ZWCustomPointAnnotation *)annotation {
    if ([annotation isKindOfClass:[ZWCustomPointAnnotation class]]) {
        ShowResumeController * show = [ShowResumeController new];
        show.Receive_Type = ENUM_TypeResume;
        show.data_Count = self.cusMap.Arr_Mark;
        __block NSUInteger index = 0;
        [show.data_Count enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            AbilttyMo * abilt = (AbilttyMo *)obj;
            if (annotation.title == abilt.ID) {
                index = idx;
                *stop = YES;
            }
        }];
        show.zIndex = index;
        NSLog(@"当前zindex为：%ld",index);
        [self.navigationController pushViewController:show animated:YES];
    }else{
        [YTAlertUtil showTempInfo:@"当前点击的为自己位置"];
    }
}
//回到当前位置的按钮点击
-(void)currentLocationClick{
    [self loadServiceList:@{@"lat":[KUserDefults objectForKey:kLat],@"lng":[KUserDefults objectForKey:KLng],@"cityID":[KUserDefults objectForKey:kUserCityID]}];
    [self.cusMap.mapView setCenterCoordinate:CLLocationCoordinate2DMake([[KUserDefults objectForKey:kLat] floatValue], [[KUserDefults objectForKey:KLng] floatValue])];
    [self.cusMap.mapView setZoomLevel:15.1 animated:NO];
}
-(void)cityMo:(CityMo *)mo{
    [self loadServiceList:@{@"lat":mo.lat,@"lng":mo.lng,@"cityID":mo.ID}];
    [self.cusMap.mapView setCenterCoordinate:CLLocationCoordinate2DMake([mo.lat floatValue], [mo.lng floatValue])];
    [self.cusMap.mapView setZoomLevel:15.1 animated:NO];
}
#pragma mark ---初始化关键字button加载-----
-(void)loadketBtn:(NSMutableArray *)arr{
    CustomScro * cus = [[CustomScro alloc] initWithFrame:CGRectMake(103, 52, kScreenWidth-113, 47) arr:[arr copy]];
    cus.delegate = self;
    [self.view addSubview:cus];
}
-(void)btnClick:(UIButton *)tag{
    [self loadServiceList:@{@"lat":[KUserDefults objectForKey:kLat],@"lng":[KUserDefults objectForKey:KLng],@"cityID":[KUserDefults objectForKey:kUserCityID],@"keyword":tag.titleLabel.text}];
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
@end
