//
//  SendMomentController.h
//  ConnectionCity
//
//  Created by umbrella on 2018/6/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
#import "Moment.h"
typedef void (^SendMomentBlock)(void);
@interface SendMomentController : BaseViewController
@property (nonatomic,strong)NSString * flagStr;//区分是首页发布还是服务圈子发布
@property (nonatomic,copy) SendMomentBlock block;
@property (nonatomic,strong) NSString * receive_flag;
@property (nonatomic,strong) Moment * receive_Moment;
@end
