//
//  ServiceHomeController.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/26.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMap.h"

@interface ServiceHomeController : BaseViewController
@property (nonatomic,strong) CustomMap *cusMap;

-(void)loadServiceList:(NSDictionary *)dic;
@end
