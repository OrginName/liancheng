//
//  SearchHistoryController.h
//  ConnectionCity
//
//  Created by qt on 2018/5/16.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^keyWordBlock)(NSString * str);

@interface SearchHistoryController : BaseViewController
@property (nonatomic,copy) keyWordBlock block;
@property (nonatomic,strong) NSString * flagStr;
@end
