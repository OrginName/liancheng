//
//  CreatGroupController.h
//  ConnectionCity
//
//  Created by qt on 2018/6/21.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^CreatGroupBlock)(void);
@interface CreatGroupController : BaseViewController
@property (nonatomic,copy) CreatGroupBlock block;
@property (nonatomic,assign)int flag_str;//标志哪个地方跳出来的
@end
