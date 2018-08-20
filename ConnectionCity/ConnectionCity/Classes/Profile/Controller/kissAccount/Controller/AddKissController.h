//
//  AddKissController.h
//  ConnectionCity
//
//  Created by qt on 2018/8/18.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^refreshData)(void);
@interface AddKissController : BaseViewController
@property (nonatomic,copy) refreshData blockData;

@end
