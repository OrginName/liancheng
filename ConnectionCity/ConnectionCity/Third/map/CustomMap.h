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
@protocol CustomMapDelegate <NSObject>
- (void)currentMapLocation:(NSDictionary *)locationDictionary location:(CLLocation*)location;
-(void)currentAnimatinonViewClick:(MAAnnotationView *)view;
@end
@interface CustomMap : UIView
@property (nonatomic,strong) MAMapView * mapView;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, weak) id<CustomMapDelegate> delegate;
@property (nonatomic, assign) BOOL selectAnimation;//是否默认选中该mark
@property (nonatomic,strong) NSMutableArray * Arr_Mark;
@end
