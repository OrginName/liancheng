//
//  CustomMap.m
//  ConnectionCity
//
//  Created by qt on 2018/5/9.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "CustomMap.h"
#import "CustomAnnotationView.h"
#import "ZWCustomPointAnnotation.h"
#import "AbilttyMo.h"
#import "CityMo.h"
#import "privateUserInfoModel.h"
#import "AbilttyMo.h"
#import "serviceListNewMo.h"
@interface CustomMap()<MAMapViewDelegate,CustomLocationDelegate,UITextFieldDelegate>{
    CLLocation * currentLocation;
    NSInteger flag;
}
@property (nonatomic,assign) id controller;
@property (nonatomic, strong) CustomAnnotationView * annotationView;
@property (nonatomic, strong) MAPointAnnotation * pointAnnotaiton;
@property (nonatomic,strong) UIImageView * image_Mark;
@end
@implementation CustomMap
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) { 
        ///初始化地图
        ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
        MAMapView * map = [[MAMapView alloc] init];
        map.showsUserLocation = YES;
        map.userTrackingMode = MAUserTrackingModeFollow;
        map.showsCompass= NO;
        map.showsScale= NO;  //设置成NO表示不显示比例尺；YES表示显示比例尺
        ///把地图添加至view
//        map.zoomEnabled = NO;
        map.delegate = self;
        map.maxZoomLevel = 15.1;
        self.mapView = map;
        [self addSubview:self.mapView];
        self.location = [[CustomLocatiom alloc] init];
        _location.delegate = self;
        UIButton * btn = [[UIButton alloc] init];
        [btn setBackgroundImage:[UIImage imageNamed:@"Location"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
        self.btn_location = btn;
        [self addSubview:btn];
        [self addSubview:self.image_Mark]; 
        flag=0;
    }
    return self;
}
//定位当前自己位置 
-(void)locationClick{
    [self.location startUpdatingLocation];
    if(self.mapView.userLocation.updating && self.mapView.userLocation.location) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
        [self.mapView setZoomLevel:15.1 animated:NO];
        if (self.delegate && [self.delegate respondsToSelector:@selector(currentLocationClick:)]) {
            [self.delegate currentLocationClick:self.mapView.userLocation.location.coordinate];
        }
    }
//    CLLocationCoordinate2D coor = self.mapView.userLocation.location.coordinate;
//    KString(@"%f", coor.latitude)
//    KString(@"%f", coor.longitude)
//    [KUserDefults objectForKey:kUserCityID]
    [KUserDefults setObject:@"" forKey:YLat];
    [KUserDefults setObject:@"" forKey:YLng];
    [KUserDefults setObject:@"" forKey:YCode];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CityNameN" object:nil];
//    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(31.299472,121.103438);
//    [self.mapView setCenterCoordinate:coor];
//    [self.mapView setZoomLevel:15.1 animated:NO];
}
#pragma mark - MAMapView Delegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    static NSString *customReuseIndetifier = @"customReuseIndetifier";
    CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
    if (annotationView == nil)
    {
        annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
        // must set to NO, so we can show the custom callout view.
        annotationView.canShowCallout = NO;
//            annotationView.draggable = YES;
//            annotationView.calloutOffset = CGPointMake(0, 0);
    }
    self.annotationView = annotationView;
    if ([annotation isKindOfClass:[MAUserLocation class]]||[annotation isKindOfClass:[CustomLocatiom class]]) {
        [annotationView.portraitImageView sd_setImageWithURL:[NSURL URLWithString:[[YSAccountTool userInfo]headImage]] placeholderImage:[UIImage imageNamed:@"logo1"]];
    }else{
        if ([annotation isKindOfClass:[ZWCustomPointAnnotation class]]) {
             ZWCustomPointAnnotation *pointAnnotation = (ZWCustomPointAnnotation*)annotation;
            //在这里,直接将请求回来的商户图片地址复制给calloutview的imageview
            //关键是需要拿到弹出视图的iamge对象,我才可以对其进行赋值
            [annotationView.portraitImageView sd_setImageWithURL:[NSURL URLWithString:pointAnnotation.storImageUrl] placeholderImage:[UIImage imageNamed:@"logo1"]];
        }
    }
    return annotationView;
}
/**
 选中当前点击mark的代理
 @param mapView mapView description
 @param view view description
 */
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    NSLog(@"%f",view.annotation.coordinate.latitude);
//    if ([self.annotationView isKindOfClass:[MAUserLocation class]]) {
//        [YTAlertUtil showTempInfo:@"当前点击的为自己位置"];
//        return;
//    }
//
//    if ([view isKindOfClass:[CustomAnnotationView class]]) {
        if (_delegate && [_delegate respondsToSelector:@selector(currentAnimatinonViewClick:annotation:)] ) {
            [_delegate currentAnimatinonViewClick:(CustomAnnotationView *)view annotation:(ZWCustomPointAnnotation *)view.annotation];
        }
        [mapView deselectAnnotation:view.annotation animated:YES];
//    }
}
#pragma mark -------CustomLocationDelegate------
- (void)currentLocation:(NSDictionary *)locationDictionary location:(CLLocation*)location{
    currentLocation = location;
    NSLog(@"%@",locationDictionary[@"addRess"]);
    [KUserDefults setObject:locationDictionary[@"city"] forKey:kUserCity];
    [KUserDefults setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:kLat];
    [KUserDefults setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:KLng];
    NSString * address;
    if ([locationDictionary[@"addRess"] length]>20) {
        address = [[locationDictionary[@"addRess"] componentsSeparatedByString:@"市"][1] componentsSeparatedByString:@"("][0];
    }else{
        address = locationDictionary[@"addRess"];
    } 
    [KUserDefults setObject:address forKey:KUserAddress];
    [KUserDefults synchronize];
    [self loadCityData];
    [self updateUseLat];
    //获取到定位信息，更新annotation
        if (self.pointAnnotaiton == nil)
        {
            self.pointAnnotaiton = [[MAPointAnnotation alloc] init];
            [self.pointAnnotaiton setCoordinate:location.coordinate];
            [self.mapView addAnnotation:self.pointAnnotaiton];
        }
        if (self.selectAnimation) {
            [self.mapView selectAnnotation:self.pointAnnotaiton animated:YES];
        }
    NSString * lat = [KUserDefults objectForKey:YLat];
    NSString * lng = [KUserDefults objectForKey:YLng];
    if ([lat length]!=0&&[lng length]!=0) {
        CLLocationCoordinate2D coords = CLLocationCoordinate2DMake([lat floatValue],[lng floatValue]);//纬度，经度
        [self.mapView setCenterCoordinate:coords];
    }else{
       [self.mapView setCenterCoordinate:location.coordinate];
    } 
        [self.mapView setZoomLevel:14.1 animated:NO];
        [self.mapView addAnnotations:self.annotations];
    if ([self.delegate respondsToSelector:@selector(currentMapLocation:location:)]) {
        [self.delegate currentMapLocation:locationDictionary location:location];
        }
}
////拒绝定位
//- (void)refuseToUsePositioningSystem:(NSString *)message{
//    [YTAlertUtil alertSingleWithTitle:@"连程" message:message defaultTitle:@"前往开启" defaultHandler:^(UIAlertAction *action) {
//        NSURL *url = [[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString];
//        if( [[UIApplication sharedApplication] canOpenURL:url]) {
//            [[UIApplication sharedApplication] openURL:url];
//        }
//    } completion:nil];
//}
#pragma mark ------
-(void)updateUseLat{
    NSDictionary * dic = @{
                           @"lat": @([[KUserDefults objectForKey:kLat]floatValue]),
                           @"lng": @([[KUserDefults objectForKey:KLng]floatValue]),
                           };
    [YSNetworkTool POST:v1PrivateUserUpdate params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
-(void)loadCityData{
    if ([KUserDefults objectForKey:kUserCityID]!=nil) {
        //        NSString * str = [KUserDefults objectForKey:kUserCityID];
        return;
    }
    [YSNetworkTool POST:dictionaryAreaTreeList params:@{} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        if (![responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            [YTAlertUtil showTempInfo:@"暂无数据"];
            return;
        }
        NSString * city = [KUserDefults objectForKey:kUserCity];
        for (int i=0; i<[responseObject[@"data"] count]; i++) {
            CityMo * mo = [CityMo mj_objectWithKeyValues:responseObject[@"data"][i]];
            mo.ID = responseObject[@"data"][i][@"id"];
            if ([mo.fullName isEqualToString:city]) {
                [KUserDefults setValue:mo.ID forKey:kUserCityID];
                return;
            }
            if (![mo.fullName containsString:@"市"]) {
                for (int j=0; j<[mo.childs count]; j++) {
                    CityMo * mo1 = [CityMo mj_objectWithKeyValues:mo.childs[j]];
                    mo1.ID = responseObject[@"data"][j][@"id"];
                    if ([mo1.fullName isEqualToString:city]) {
                        [KUserDefults setValue:mo1.ID forKey:kUserCityID];                        
                        return;
                    }
                }
            }else{
                
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
//定位失败
- (void)locateFailure:(NSString *)message {
    [YTAlertUtil showTempInfo:@"定位失败"];
}

//正在定位
- (void)locating {
    
}
-(void)setArr_Mark:(NSMutableArray *)Arr_Mark{
    _Arr_Mark = Arr_Mark;
    [self.mapView removeAnnotations:[self.annotations copy]];
    [self.annotations removeAllObjects];
    self.annotations = [NSMutableArray array];
    [Arr_Mark enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZWCustomPointAnnotation *pointAnnotation = [[ZWCustomPointAnnotation alloc] init];
        if ([obj isKindOfClass:[serviceListNewMo class]]) {
            serviceListNewMo * list = (serviceListNewMo *)obj;
            if (![list.ID isEqualToString:[[YSAccountTool userInfo]modelId]]) {
                CLLocationCoordinate2D coor ;
                float a = (float)(rand() % 100) /10000;
                coor.latitude = [list.lat floatValue]+a;
                coor.longitude = [list.lng floatValue];
                pointAnnotation.coordinate = coor;
                pointAnnotation.title = list.ID;
                pointAnnotation.storImageUrl = list.headImage;
            }
        }
        if (pointAnnotation) {
            [self.annotations addObject:pointAnnotation];
        } 
        self.annotationView.zIndex = idx;
    }];
    [self.mapView addAnnotations:self.annotations];
}
- (void)mapView:(MAMapView *)mapView mapWillZoomByUser:(BOOL)wasUserAction{
    if (wasUserAction) {
        [self.location cleanUpAction];
    } 
}
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if (currentLocation==nil) {
        return;
    }
    MACoordinateRegion region;
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    region.center= centerCoordinate;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(dragCenterLocation:)]) {
        [self.delegate dragCenterLocation:centerCoordinate];
    }
    NSLog(@" regionDidChangeAnimated %f,%f",centerCoordinate.latitude, centerCoordinate.longitude);
}
#pragma mark - Initialization
- (void)initAnnotations
{
    self.annotations = [NSMutableArray array];
    CLLocationCoordinate2D coordinates[10] = {
        {39.992520, 116.336170},
        {39.992520, 116.336170},
        {39.998293, 116.352343},
        {40.004087, 116.348904},
        {40.001442, 116.353915},
        {39.989105, 116.353915},
        {39.989098, 116.360200},
        {39.998439, 116.360201},
        {39.979590, 116.324219},
        {39.978234, 116.352792}};
    
    for (int i = 0; i < 10; ++i)
    {
        MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
        a1.coordinate = coordinates[i];
        a1.title      = [NSString stringWithFormat:@"anno: %d", i];
        [self.annotations addObject:a1];
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.mapView.frame = self.frame;
    self.mapView.logoCenter = CGPointMake(-1000, 1000);
    self.btn_location.frame = CGRectMake(kScreenWidth-50, 10, 40, 40);
//    self.image_Mark.center = self.center;
    self.image_Mark.frame = CGRectMake((self.width-6)/2, (self.height-25)/2, 15, 25);
}
-(UIImageView *)image_Mark{
    if (!_image_Mark) {
        _image_Mark = [[UIImageView alloc] init];
//        _image_Mark.frame = CGRectMake(kScreenWidth/2-7, (kScreenHeight-64-100)/2-12, 15, 25);
        _image_Mark.image = [UIImage imageNamed:@"position-1"];
    }
    return _image_Mark;
}
/**
 是否默认选中当前mark
 @param selectAnimation BOOl
 */
-(void)setSelectAnimation:(BOOL)selectAnimation{
    _selectAnimation = selectAnimation;
}
@end
