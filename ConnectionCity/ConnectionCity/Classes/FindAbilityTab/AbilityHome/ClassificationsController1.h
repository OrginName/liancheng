//
//  ClassificationsController1.h
//  ConnectionCity
//
//  Created by qt on 2018/8/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^BlockString)(NSString * classifiation);
typedef void(^BlockID)(NSString * classifiationID,NSString * classifiation);
@interface ClassificationsController1 : BaseViewController
@property (nonatomic, copy) BlockString block;
@property (nonatomic, copy) BlockID block1;
@property (nonatomic,strong)NSMutableArray * arr_Data;
@end
