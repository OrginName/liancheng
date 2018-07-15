//
//  ZBJFViewController.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
#import "CityMo.h"

@interface ZBJFViewController : BaseViewController
@property (nonatomic, strong) NSMutableArray *cellCntentText;
@property (nonatomic, strong) NSString *zbjeStr;
@property (nonatomic, strong) CityMo *mo;
@property (nonatomic,strong) NSString * receive_flag;
@property (nonatomic, strong) NSString *tenderId;

@end
