//
//  SendMomentController.h
//  ConnectionCity
//
//  Created by umbrella on 2018/6/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^SendMomentBlock)(void);
@interface SendMomentController : BaseViewController
@property (nonatomic,copy) SendMomentBlock block;

@end
