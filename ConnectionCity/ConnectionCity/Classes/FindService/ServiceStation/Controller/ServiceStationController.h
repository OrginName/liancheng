//
//  ServiceStationController.h
//  ConnectionCity
//
//  Created by qt on 2018/5/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"

@interface ServiceStationController : BaseViewController

@end

//新建自定义类 扩充tagId属性 记录区号
@interface ZYButton : UIButton

@property (assign, nonatomic) NSInteger tagId;

@end
