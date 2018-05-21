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
@interface MessageController ()<JFCityViewControllerDelegate,MAMapViewDelegate, AMapLocationManagerDelegate,CustomMapDelegate>
{
    BOOL flag;
}
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
@property (nonatomic,strong) RefineView * refine;
@property (nonatomic,strong) FirstTanView * first;
@property (nonatomic,strong)CustomMap * cusMap;
@end

@implementation MessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self setUI];
    flag = NO;
}
//导航左按钮我的点击
-(void)MyselfClick{
    [YTAlertUtil showTempInfo:@"正在认真开发..."];
}
//导航右侧按钮点击
-(void)MessageClick{
    [YTAlertUtil showTempInfo:@"正在认真开发..."];

}
//天生我才必有用的按钮点击
- (IBAction)btn_TS:(UIButton *)sender {
    self.first = [[[NSBundle mainBundle] loadNibNamed:@"FirstTanView" owner:nil options:nil] lastObject];
    self.first.frame = CGRectMake(20, 0, kScreenWidth-40, 310);
    self.first.messController = self;
    self.refine = [[RefineView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) type:self.first];
    [self.refine alertSelectViewshow];
    flag = NO;
}
//获取当前自己的位置并设为中心点
- (IBAction)btn_UserLocation:(UIButton *)sender {
    [self.mapView setCenterCoordinate:self.pointAnnotaiton.coordinate];
    [self.mapView setZoomLevel:15.1 animated:NO];
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
        self.view_line.x = sender.x-20;
    }];
    switch (sender.tag) {
        case 1:
        {
            BaseOneTabController * one = [[BaseOneTabController alloc] init];
            [self.navigationController pushViewController:one animated:YES];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"TABBAR" object:nil];
//
        }
            
            break;
        case 2:
        {
            BaseChangeTabController * one = [[BaseChangeTabController alloc] init];
            [self.navigationController pushViewController:one animated:YES];
        }
            break;
        case 3:
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
-(void)setUI{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(MyselfClick) image:@"people" title:@"" EdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
     self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(MessageClick) image:@"index-dope" title:@"" EdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
    self.navigationItem.leftBarButtonItem.badgeValue=self.navigationItem.rightBarButtonItem.badgeValue = @" ";
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
    self.cusMap = [[CustomMap alloc] initWithFrame:CGRectMake(0, 0, self.view_Map.width, self.view_Map.height)];
    self.cusMap.selectAnimation = YES;
    [self.view_Map addSubview:self.cusMap];
    self.cusMap.delegate = self;
    [self.view_Map bringSubviewToFront:self.btn_mapUserLocation];
    [self.view_Map bringSubviewToFront:self.view_notice];
    [self.view_Map bringSubviewToFront:self.view_userLocation];
}
- (void)currentMapLocation:(NSDictionary *)locationDictionary location:(CLLocation*)location{
    self.lab_Location.text =locationDictionary[@"addRess"];
    UIButton * btn = (UIButton *)[self.navigationItem.titleView viewWithTag:99999];
    [btn setTitle:locationDictionary[@"city"] forState:UIControlStateNormal];
}
//-(void)initMapView{
//    ///初始化地图
//    self.mapView = [[MAMapView alloc] initWithFrame:self.view_Map.bounds];
//    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
////    self.mapView.showsUserLocation = YES;
////    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
//    self.mapView.showsCompass= NO;
//    self.mapView.logoCenter = CGPointMake(CGRectGetWidth(self.view_Map.bounds)-55, CGRectGetHeight(self.view_Map.bounds)+55);
//    self.mapView.showsScale= NO;  //设置成NO表示不显示比例尺；YES表示显示比例尺
//    self.mapView.delegate = self;
//    ///把地图添加至view
//    [self.view_Map addSubview:self.mapView];
//    [self configLocationManager];
//}
//#pragma mark - Action Handle
//
//- (void)configLocationManager
//{
//    self.locationManager = [[AMapLocationManager alloc] init];
//    self.locationManager.delegate = self;
//    //设置不允许系统暂停定位
//    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
//    //设置允许在后台定位
////    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
//    //设置允许连续定位逆地理
//    [self.locationManager setLocatingWithReGeocode:YES];
//    [self.locationManager startUpdatingLocation];
////    if ([AMapLocationManager headingAvailable] == YES)
////    {
////        [self.locationManager startUpdatingHeading];
////    }
//}
//
//#pragma mark - AMapLocationManager Delegate
//
//- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
//{
//    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
//}
//
//- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
//{
//    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f, reGeocode:%@}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy, reGeocode.formattedAddress);
//    if (reGeocode.formattedAddress.length!=0) {
//        [self cleanUpAction];
//    }
//    //获取到定位信息，更新annotation
//    if (self.pointAnnotaiton == nil)
//    {
//        self.pointAnnotaiton = [[MAPointAnnotation alloc] init];
//        [self.pointAnnotaiton setCoordinate:location.coordinate];
//        [self.mapView addAnnotation:self.pointAnnotaiton];
//    }
//    [self.mapView selectAnnotation:self.pointAnnotaiton animated:YES];
//    [self.mapView setCenterCoordinate:location.coordinate];
//    [self.mapView setZoomLevel:15.1 animated:NO];
//    self.lab_Location.text =reGeocode.formattedAddress;
//    UIButton * btn = (UIButton *)[self.navigationItem.titleView viewWithTag:99999];
//    [btn setTitle:reGeocode.city forState:UIControlStateNormal];
//}
//
// //停止定位
//- (void)cleanUpAction
//{
//    [self.locationManager stopUpdatingLocation];
//    [self.locationManager setDelegate:nil];
//}
//- (BOOL)amapLocationManagerShouldDisplayHeadingCalibration:(AMapLocationManager *)manager
//{
//    return YES;
//}

//- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
//{
//    if (_annotationView != nil)
//    {
//        CGFloat angle = newHeading.trueHeading*M_PI/180.0f + M_PI - _annotationViewAngle;
//        NSLog(@"################### heading : %f - %f", newHeading.trueHeading, newHeading.magneticHeading);
//        _annotationViewAngle = newHeading.trueHeading*M_PI/180.0f + M_PI;
//        _heading = newHeading;
//        _annotationView.transform =  CGAffineTransformRotate(_annotationView.transform ,angle);
//    }
//}

//#pragma mark - MAMapView Delegate
//
//- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[MAPointAnnotation class]])
//    {
//        static NSString *customReuseIndetifier = @"customReuseIndetifier";
//       CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
//
//        if (annotationView == nil)
//        {
//            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
//            // must set to NO, so we can show the custom callout view.
//            annotationView.canShowCallout = NO;
//            annotationView.draggable = YES;
//            annotationView.calloutOffset = CGPointMake(0, -10);
//            annotationView.animatesDrop = YES;
//        }
//        annotationView.image = [UIImage imageNamed:@"position"];
//        return annotationView;
//    }
//
//    return nil;
//}
#pragma mark - JFCityViewControllerDelegate
- (void)cityName:(NSString *)name {
    UIButton * btn = (UIButton *)[self.navigationItem.titleView viewWithTag:99999];
   [btn setTitle:name forState:UIControlStateNormal];
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
//- (void)willMoveToParentViewController:(UIViewController*)parent{
//    [super willMoveToParentViewController:parent];
//    NSLog(@"%s,%@",__FUNCTION__,parent);
//}
//- (void)didMoveToParentViewController:(UIViewController*)parent{
//    [super didMoveToParentViewController:parent];
//    NSLog(@"%s,%@",__FUNCTION__,parent);
//    //    [self.tabBarController.navigationController popViewControllerAnimated:YES];
//}
-(void)dealloc{
//    [self cleanUpAction];
}
@end
