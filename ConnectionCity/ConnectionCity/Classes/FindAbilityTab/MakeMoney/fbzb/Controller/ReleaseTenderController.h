//
//  ReleaseTenderController.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/22.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
#import "PhotoSelect.h"
#import "CityMo.h"

@interface ReleaseTenderController : BaseViewController
@property (nonatomic, strong) NSMutableArray *cellCntentText;
@property (nonatomic, strong) CityMo *citymo;
@property (nonatomic, strong) PhotoSelect * photo;
@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic, strong) NSMutableArray *Arr_Url;
@property (nonatomic,strong) NSString * receive_flag;

@end
