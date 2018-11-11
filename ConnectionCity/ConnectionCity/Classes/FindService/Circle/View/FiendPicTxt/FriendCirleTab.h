//
//  FriendCirleTab.h
//  ConnectionCity
//
//  Created by qt on 2018/5/31.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentView.h"
#import "UserMo.h"
@interface FriendCirleTab : MyTab
@property (nonatomic,strong) UIView * mainView;
@property (nonatomic,strong) NSString * flagStr;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) UserMo * user;
@property (nonatomic,strong) CommentView * comment;
-(instancetype)initWithFrame:(CGRect)frame withControll:(UIViewController *)control;
//加载朋友圈列表
-(void)loadDataFriendList:(NSString *)cityCode;
@end
