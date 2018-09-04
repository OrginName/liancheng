//
//  MapController.m
//  ConnectionCity
//
//  Created by qt on 2018/9/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "MapController.h"
#import "CustomMap.h"
#import "JZLocationConverter.h"
@import MapKit;//ios7 使用苹果自带的框架使用@import导入则不用在Build Phases 导入框架了
@import CoreLocation;
@interface MapController ()<MAMapViewDelegate>
@property (nonatomic,strong) CustomMap * cusMap;
@property (nonatomic,strong) NSMutableArray * arr;
@property (nonatomic,strong) MAMapView * map1;
@end

@implementation MapController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.cusMap = [[CustomMap alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    [self.view addSubview:self.cusMap];
//
    MAMapView * map = [[MAMapView alloc] init];
    map.showsUserLocation = YES;
    map.userTrackingMode = MAUserTrackingModeFollow;
    map.showsCompass= NO;
    map.zoomEnabled = NO;
    map.showsScale= NO;  //设置成NO表示不显示比例尺；YES表示显示比例尺
    ///把地图添加至view
    map.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    //        map.zoomEnabled = NO;
    map.delegate = self;
    self.map1 = map;
    [map setCenterCoordinate:self.colld];
    map.zoomLevel = 15.1;
    [self.view addSubview:map];
    MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
    a1.coordinate = self.colld;
    [self.map1 addAnnotation:a1];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(SendClick) image:@"our-more" title:@"" EdgeInsets:UIEdgeInsetsZero];
    self.arr = [NSMutableArray array];
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com/"]]){
        [self.arr addObject:@"苹果地图"];
    }
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [self.arr addObject:@"百度地图"];
    }
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]){
        [self.arr addObject:@"腾讯地图"];
    }
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
        [self.arr addObject:@"高德地图"];
    }
}
#pragma mark - MAMapView Delegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    static NSString *customReuseIndetifier = @"customReuseIndetifier";
    MAAnnotationView *annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
    if (annotationView == nil)
    {
        annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
        // must set to NO, so we can show the custom callout view.
        annotationView.canShowCallout = NO;
//        annotationView.draggable = YES;
        annotationView.image = [UIImage imageNamed:@"index-dw"];
        //            annotationView.calloutOffset = CGPointMake(0, 0);
    }
   
    return annotationView;
}
-(void)SendClick{
    [YTAlertUtil alertMultiWithTitle:nil message:nil style:UIAlertControllerStyleActionSheet multiTitles:self.arr multiHandler:^(UIAlertAction *action, NSArray *titles, NSUInteger idx) {
        if ([titles[idx] isEqualToString:@"苹果地图"]) {
            CLLocationCoordinate2D desCoordinate = self.colld;
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:desCoordinate addressDictionary:nil]];
            toLocation.name = @"终点";//可传入目标地点名称
            [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                           launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        }
        if ([titles[idx] isEqualToString:@"百度地图"]){
            CLLocationCoordinate2D desCoordinate = [JZLocationConverter gcj02ToBd09:self.colld];//火星坐标转化为百度坐标
            NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=%f,%f&mode=driving&src=com.LC.CC", desCoordinate.latitude, desCoordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSLog(@"%@",urlString);
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
        if ([titles[idx] isEqualToString:@"高德地图"]) {
            CLLocationCoordinate2D desCoordinate = self.colld;
            
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&sname=%@&did=BGVIS2&dlat=%f&dlon=%f&dev=0&m=0&t=0",@"我的位置",desCoordinate.latitude, desCoordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//@"我的位置"可替换为@"终点名称"
            NSLog(@"%@",urlString);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
        if ([titles[idx] isEqualToString:@"高德地图"]) {
            CLLocationCoordinate2D desCoordinate = self.colld;
            NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&from=我的位置&to=%@&tocoord=%f,%f&policy=1&referer=%@", @"终点名称", desCoordinate.latitude, desCoordinate.longitude, self.name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSLog(@"%@",urlString);
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
    } cancelTitle:@"取消" cancelHandler:^(UIAlertAction *action) {
        
    } completion:nil];
}
@end
