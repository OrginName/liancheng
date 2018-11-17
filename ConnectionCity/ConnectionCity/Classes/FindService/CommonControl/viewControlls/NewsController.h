//
//  NewsController.h
//  ConnectionCity
//
//  Created by umbrella on 2018/11/16.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewsController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@property (nonatomic,strong)NSString * userID;
@property (nonatomic,strong)NSString * flag;
@end

NS_ASSUME_NONNULL_END
