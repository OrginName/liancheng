//
//  ClassificationsController.h
//  ConnectionCity
//
//  Created by umbrella on 2018/5/10.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^BlockString)(NSString * classifiation);
@interface ClassificationsController : BaseViewController
@property (nonatomic, copy) BlockString block;
@end
