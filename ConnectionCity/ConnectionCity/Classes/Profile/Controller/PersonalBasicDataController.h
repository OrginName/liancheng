//
//  PersonalBasicDataController.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/21.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
#import "UserMo.h"
@interface PersonalBasicDataController : BaseViewController
@property (nonatomic,strong)UserMo * connectionMo;//连合作人脉
@property (nonatomic,strong)NSString * flagStr;
@property (nonatomic,strong) NSMutableArray * arr_User;//数据源数组
@property (nonatomic,assign) NSInteger flag;//标识当前是第几个
@end
