//
//  CustomMap.m
//  ConnectionCity
//
//  Created by qt on 2018/5/9.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "CustomMap.h"
#import "CustomAnnotationView.h"
@interface CustomMap()<MAMapViewDelegate,CustomLocationDelegate,UITextFieldDelegate>
@property (nonatomic,assign) id controller;
@property (nonatomic,strong) CustomLocatiom * location;
@property (nonatomic, strong) MAPinAnnotationView * annotationView;
@property (nonatomic, strong) MAPointAnnotation * pointAnnotaiton;

@end
@implementation CustomMap

-(instancetype)initWithFrame:(CGRect)frame withControl:(id)control{
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
        self.controller = control;
        [self addSubview:self.mapView];
        self.location = [[CustomLocatiom alloc] init];
        _location.delegate = self;
 
    }
    return self;
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
            annotationView.draggable = YES;
            annotationView.calloutOffset = CGPointMake(0, -10);
            annotationView.animatesDrop = YES;
        }
        annotationView.image = [UIImage imageNamed:@"position"];
        return annotationView;
    }
    
    return nil;
}

#pragma mark -------CustomLocationDelegate------
- (void)currentLocation:(NSDictionary *)locationDictionary location:(CLLocation*)location{
    NSLog(@"%@",locationDictionary[@"addRess"]);
    //获取到定位信息，更新annotation
        if (self.pointAnnotaiton == nil)
        {
            self.pointAnnotaiton = [[MAPointAnnotation alloc] init];
            [self.pointAnnotaiton setCoordinate:location.coordinate];
            [self.mapView addAnnotation:self.pointAnnotaiton];
        }
        [self.mapView selectAnnotation:self.pointAnnotaiton animated:YES];
        [self.mapView setCenterCoordinate:location.coordinate];
        [self.mapView setZoomLevel:15.1 animated:NO];
}

- (void)locateFailure:(NSString *)message {
    
}


- (void)locating {
    
}


- (void)refuseToUsePositioningSystem:(NSString *)message {
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.mapView.frame = CGRectMake(0, 0, self.width, self.height);
    self.mapView.logoCenter = CGPointMake(CGRectGetWidth(self.bounds)-55, CGRectGetHeight(self.bounds)+55);
}


@end
