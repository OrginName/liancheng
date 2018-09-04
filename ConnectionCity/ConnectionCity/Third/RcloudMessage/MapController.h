//
//  MapController.h
//  ConnectionCity
//
//  Created by qt on 2018/9/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface MapController : BaseViewController
@property (nonatomic,assign) CLLocationCoordinate2D  colld;
@property (nonatomic,strong) NSString * name;
@end
