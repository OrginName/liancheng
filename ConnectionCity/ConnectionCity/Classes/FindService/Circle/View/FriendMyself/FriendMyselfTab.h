//
//  FriendMyselfTab.h
//  ConnectionCity
//
//  Created by umbrella on 2018/6/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendMyselfTab : MyTab
@property (nonatomic,strong)NSString * flagStr;
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withControll:(UIViewController *)control;
@end
