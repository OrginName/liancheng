//
//  PersonDTController.h
//  ConnectionCity
//
//  Created by umbrella on 2018/11/14.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
#import <YNPageViewController.h>
NS_ASSUME_NONNULL_BEGIN

@interface PersonDTController : YNPageViewController
@property (nonatomic,strong)NSString * userID;//接受到的userID
+ (instancetype)suspendCenterPageVC:(NSDictionary *)dic;
+(void)loadData;
@end

NS_ASSUME_NONNULL_END
