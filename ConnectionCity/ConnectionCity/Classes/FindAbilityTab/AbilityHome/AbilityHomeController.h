//
//  AbilityHomeController.h
//  ConnectionCity
//
//  Created by umbrella on 2018/5/9.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomMap.h"
@interface AbilityHomeController : BaseViewController
@property (nonatomic,strong) CustomMap *cusMap;
//加载简历列表数据
-(void)loadServiceList:(NSDictionary *)dic;
@end
