//
//  FriendCirleTab.h
//  ConnectionCity
//
//  Created by qt on 2018/5/31.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentView.h"
@interface FriendCirleTab : MyTab
@property (nonatomic,strong) UIView * mainView;
@property (nonatomic,strong)NSString * flagStr;
@property (nonatomic,strong) CommentView * comment;
-(instancetype)initWithFrame:(CGRect)frame withControll:(UIViewController *)control;
@end
