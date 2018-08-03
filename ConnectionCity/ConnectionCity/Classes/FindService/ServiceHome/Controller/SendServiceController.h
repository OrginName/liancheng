//
//  SendServiceController.h
//  ConnectionCity
//
//  Created by qt on 2018/5/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^refreshBlock)(void);
@interface SendServiceController : BaseViewController
@property (nonatomic,strong) NSMutableArray * arr_receive;
@property (nonatomic,copy) refreshBlock refreshBlock;
@end
