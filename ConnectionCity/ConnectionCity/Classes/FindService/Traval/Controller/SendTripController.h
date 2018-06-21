//
//  SendTripController.h
//  ConnectionCity
//
//  Created by umbrella on 2018/5/31.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^TrvalBlock)(void);
@interface SendTripController : BaseViewController
@property (nonatomic,copy) TrvalBlock block;
@end
