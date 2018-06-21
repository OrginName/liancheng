//
//  AppointmentController.h
//  ConnectionCity
//
//  Created by umbrella on 2018/5/31.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
#import "ServiceListMo.h"
#import "trvalMo.h"
@interface AppointmentController : BaseViewController
@property (nonatomic,strong) NSString * str;//YD  PY
@property (nonatomic,strong)ServiceListMo * list;
@property (nonatomic,strong)trvalMo * trval;
@end
