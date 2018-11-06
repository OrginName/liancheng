//
//  EditMenuController.h
//  ConnectionCity
//
//  Created by qt on 2018/11/4.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"

@interface EditMenuController : BaseViewController
/**
 *返回调整好的标签数组
 **/
@property (nonatomic, copy) void(^dataBlock)(void);
@end
