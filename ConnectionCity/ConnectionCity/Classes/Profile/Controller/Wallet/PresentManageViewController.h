//
//  PresentManageViewController.h
//  ConnectionCity
//
//  Created by umbrella on 2018/6/6.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
#import "AccountPageMo.h"

@interface PresentManageViewController : BaseViewController
@property (nonatomic, copy) void(^accountBlock)(AccountPageMo *);

@end

 
