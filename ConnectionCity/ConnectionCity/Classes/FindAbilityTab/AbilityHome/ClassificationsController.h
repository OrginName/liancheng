//
//  ClassificationsController.h
//  ConnectionCity
//
//  Created by umbrella on 2018/5/10.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
#import "ClassifyMo.h"
typedef void(^BlockString)(NSString * classifiation);
@interface ClassificationsController : BaseViewController
@property (nonatomic, copy) BlockString block;
@property (nonatomic,strong)NSMutableArray * arr_Data;
@end

 
