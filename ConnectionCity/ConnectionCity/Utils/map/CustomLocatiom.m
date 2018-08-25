//
//  CustomLocatiom.m
//  ConnectionCity
//
//  Created by qt on 2018/5/9.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "CustomLocatiom.h"
#import <MAMapKit/MAMapKit.h>
@interface CustomLocatiom()<AMapLocationManagerDelegate>

@property (nonatomic, strong) AMapLocationManager * locationManager;
@end
@implementation CustomLocatiom
- (instancetype)init {
    if (self = [super init]) {
        [self configLocationManager];
    }
    return self;
}
#pragma mark - Action Handle

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    //设置允许在后台定位
    //    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    //设置允许连续定位逆地理
    [self.locationManager setLocatingWithReGeocode:YES];
    [self.locationManager startUpdatingLocation];
    //    if ([AMapLocationManager headingAvailable] == YES)
    //    {
    //        [self.locationManager startUpdatingHeading];
    //    }
}

- (void)startUpdatingLocation {
    [self.locationManager startUpdatingLocation];
    self.locationManager.delegate = self;
}
#pragma mark - AMapLocationManager Delegate

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
    if ([error code] == kCLErrorDenied) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(refuseToUsePositioningSystem:)]) {
            [self.delegate refuseToUsePositioningSystem:@"已拒绝使用定位系统"];
        }
    }
    if ([error code] == kCLErrorLocationUnknown) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(locateFailure:)]) {
                [self.delegate locateFailure:@"无法获取位置信息"];
            }
        });
    }
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
//    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f, reGeocode:%@}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy, reGeocode.formattedAddress);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(locating)]) {
            [self.delegate locating];
        }
    });
    if (reGeocode.formattedAddress.length!=0) {
        NSDictionary *location1 = @{@"city":reGeocode.city,@"addRess":reGeocode.formattedAddress};
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(currentLocation:location:)]) {
                [self.delegate currentLocation:location1 location:location];
            }
//        });
//        [self cleanUpAction];
    }
    
//    self.lab_Location.text =reGeocode.formattedAddress;
//    UIButton * btn = (UIButton *)[self.navigationItem.titleView viewWithTag:99999];
//    [btn setTitle:reGeocode.city forState:UIControlStateNormal];
}

//停止定位
- (void)cleanUpAction
{
    [self.locationManager stopUpdatingLocation];
    [self.locationManager setDelegate:nil];
}
@end
