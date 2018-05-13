//
//  EditAllController.h
//  ConnectionCity
//
//  Created by umbrella on 2018/5/13.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^EditBlock)(NSString * EditStr);
@interface EditAllController : BaseViewController
@property (nonatomic, copy) EditBlock block;
@end
