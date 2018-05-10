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
@protocol CustomMapDelegate <NSObject>
- (void)currentMapLocation:(NSDictionary *)locationDictionary location:(CLLocation*)location;
@end
@interface CustomMap : UIView
@property (nonatomic,strong) MAMapView * mapView;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, weak) id<CustomMapDelegate> delegate;
@end
