//
//  CustomMap.m
//  ConnectionCity
//
//  Created by qt on 2018/5/9.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "CustomMap.h"
#import "CustomAnnotationView.h"
#import "AbilttyMo.h"
#import "CityMo.h"
@interface CustomMap()<MAMapViewDelegate,CustomLocationDelegate,UITextFieldDelegate>
@property (nonatomic,assign) id controller;
@property (nonatomic,strong) CustomLocatiom * location;
@property (nonatomic, strong) MAPinAnnotationView * annotationView;
@property (nonatomic, strong) MAPointAnnotation * pointAnnotaiton;
@property (nonatomic,strong) UIButton * btn_location;
@end
@implementation CustomMap
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        ///初始化地图
        ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
        
        MAMapView * map = [[MAMapView alloc] init];
//        map.showsUserLocation = YES;
//        map.userTrackingMode = MAUserTrackingModeFollow;
        map.showsCompass= NO;
        map.showsScale= NO;  //设置成NO表示不显示比例尺；YES表示显示比例尺
        ///把地图添加至view
        map.delegate = self;
        self.mapView = map;
        [self addSubview:self.mapView];
        self.location = [[CustomLocatiom alloc] init];
        _location.delegate = self;
        
        UIButton * btn = [[UIButton alloc] init];
        [btn setBackgroundImage:[UIImage imageNamed:@"Location"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
        self.btn_location = btn;
        [self addSubview:btn];
//        [self initAnnotations];
    }
    return self;
}
//定位当前自己位置
-(void)locationClick{
    [self.mapView setCenterCoordinate:self.pointAnnotaiton.coordinate];
    [self.mapView setZoomLevel:15.1 animated:NO];
    if (self.delegate && [self.delegate respondsToSelector:@selector(currentLocationClick)]) {
        [self.delegate currentLocationClick];
    }
}
#pragma mark - MAMapView Delegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
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
//        annotationView.portraitImageView.image = [UIImage imageNamed:@"1"];
        NSString * url = @"";
        if ([self.Arr_Mark[annotationView.zIndex] isKindOfClass:[ServiceListMo class]]) {
            url = [[self.Arr_Mark[annotationView.zIndex] user1] headImage];
        }else{
            url = [[self.Arr_Mark[annotationView.zIndex] userMo] headImage];
        }
        [annotationView.portraitImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"no-pic"]];
       
        return annotationView;
    }
    return nil;
}

/**
 选中当前点击mark的代理

 @param mapView mapView description
 @param view view description
 */
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    if ([self.delegate respondsToSelector:@selector(currentAnimatinonViewClick:)]) {
        [self.delegate currentAnimatinonViewClick:view];
    }
}
#pragma mark -------CustomLocationDelegate------
- (void)currentLocation:(NSDictionary *)locationDictionary location:(CLLocation*)location{
    NSLog(@"%@",locationDictionary[@"addRess"]);
    [KUserDefults setObject:locationDictionary[@"city"] forKey:kUserCity];
    [KUserDefults setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:kLat];
    [KUserDefults setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:KLng];
    [KUserDefults synchronize];
    [self loadCityData];
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
        [self.mapView setCenterCoordinate:location.coordinate];
        [self.mapView setZoomLevel:15.1 animated:NO];
        [self.mapView addAnnotations:self.annotations];
    if ([self.delegate respondsToSelector:@selector(currentMapLocation:location:)]) {
        [self.delegate currentMapLocation:locationDictionary location:location];
        }
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
                NSLog(@"324231421342342134213");
                [KUserDefults setValue:mo.ID forKey:kUserCityID];
                return;
            }
            if (![mo.fullName containsString:@"市"]) {
                for (int j=0; j<[mo.childs count]; j++) {
                    CityMo * mo1 = [CityMo mj_objectWithKeyValues:mo.childs[j]];
                    mo1.ID = responseObject[@"data"][j][@"id"];
                    if ([mo1.fullName isEqualToString:city]) {
                        NSLog(@"1qweqweqweqwe");
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

//用户拒绝定位
- (void)refuseToUsePositioningSystem:(NSString *)message {
    [YTAlertUtil showTempInfo:@""];
}
-(void)setArr_Mark:(NSMutableArray *)Arr_Mark{
    _Arr_Mark = Arr_Mark;
     self.annotations = [NSMutableArray array];
    [Arr_Mark enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MAPointAnnotation *a1;
        if ([obj isKindOfClass:[ServiceListMo class]]) {
            ServiceListMo * list = (ServiceListMo *)obj;
            a1 = [[MAPointAnnotation alloc] init];
            a1.coordinate = CLLocationCoordinate2DMake([list.lat doubleValue], [list.lng doubleValue]);
            a1.title = list.ID;
        }else if ([obj isKindOfClass:[AbilttyMo class]]){
            AbilttyMo * abilt = (AbilttyMo *)obj;
            a1 = [[MAPointAnnotation alloc] init];
            a1.coordinate = CLLocationCoordinate2DMake([abilt.lat doubleValue], [abilt.lng doubleValue]);
            a1.title = abilt.ID;
        }   
        self.annotationView.zIndex = idx;
        [self.annotations addObject:a1];
    }];
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
    self.mapView.frame = CGRectMake(0, 0, self.width, self.height);
    self.mapView.logoCenter = CGPointMake(-30, 1000);
    self.btn_location.frame = CGRectMake(kScreenWidth-50, 10, 40, 40);
}

/**
 是否默认选中当前mark

 @param selectAnimation BOOl
 */
-(void)setSelectAnimation:(BOOL)selectAnimation{
    _selectAnimation = selectAnimation;
}
@end
