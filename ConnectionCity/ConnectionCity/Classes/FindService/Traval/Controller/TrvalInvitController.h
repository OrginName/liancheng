//
//  TrvalInvitController.h
//  ConnectionCity
//
//  Created by qt on 2018/5/30.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^TrvalBlock)(void);
@interface TrvalInvitController : BaseViewController
@property (nonatomic,copy) TrvalBlock block;
@end
