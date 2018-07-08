//
//  DubTimeSlectorController.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/8.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"

@interface DubTimeSlectorController : BaseViewController
@property (nonatomic, copy) void (^timeBlock)(NSString *startTime,NSString *endTime);

@end
