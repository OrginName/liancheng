//
//  PayOrderController.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/26.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"

@interface PayOrderController : BaseViewController
@property (nonatomic, strong) NSString *tenderId;
@property (nonatomic, strong) NSString *orderType;
@property (nonatomic, strong) NSString *amount;
@end

