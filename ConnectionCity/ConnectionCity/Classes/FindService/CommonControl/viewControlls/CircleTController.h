//
//  CircleTController.h
//  ConnectionCity
//
//  Created by umbrella on 2018/11/16.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
#import "CommentView.h"
#import "UserMo.h"
NS_ASSUME_NONNULL_BEGIN

@interface CircleTController : BaseViewController
@property (nonatomic,strong) UIView * mainView;
@property (nonatomic,strong) NSString * flagStr;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) UserMo * user;
@property (nonatomic,strong) CommentView * comment;
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@property (nonatomic,strong)NSString * userID;
@end

NS_ASSUME_NONNULL_END
