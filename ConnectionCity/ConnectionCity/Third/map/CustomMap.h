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
@interface CustomMap : UIView
@property (nonatomic,strong) MAMapView * mapView;

-(instancetype)initWithFrame:(CGRect)frame withControl:(id)control;
@end
