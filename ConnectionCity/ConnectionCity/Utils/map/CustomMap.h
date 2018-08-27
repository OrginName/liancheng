//
//  CustomMap.h
//  ConnectionCity
//
//  Created by qt on 2018/5/9.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "CustomLocatiom.h"
#import "ServiceListMo.h"
#import "CustomAnnotationView.h"
#import "ZWCustomPointAnnotation.h"
@protocol CustomMapDelegate <NSObject>
@optional
- (void)currentMapLocation:(NSDictionary *)locationDictionary location:(CLLocation*)location;
@optional
-(void)currentAnimatinonViewClick:(CustomAnnotationView *)view annotation:(ZWCustomPointAnnotation *)annotation;
@optional
-(void)currentLocationClick:(CLLocationCoordinate2D)location;
@optional//拖动地图的中心点坐标
-(void)dragCenterLocation:(CLLocationCoordinate2D)location;
@end
@interface CustomMap : UIView
@property (nonatomic,strong) MAMapView * mapView;
@property (nonatomic,strong) CustomLocatiom * location;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, weak) id<CustomMapDelegate> delegate;
@property (nonatomic, assign) BOOL selectAnimation;//是否默认选中该mark
@property (nonatomic,strong) NSMutableArray * Arr_Mark;
-(void)locationClick;

@end
