//
//  SortCollProController.h
//  ConnectionCity
//
//  Created by qt on 2018/7/8.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
#import "RCDTableView.h"
#import <RongIMLib/RongIMLib.h>
#import <UIKit/UIKit.h>
#import "ShoolOREduMo.h"
typedef void (^schoolBlock)(ShoolOREduMo * mo);
@interface SortCollProController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate>
@property(nonatomic, strong) UISearchBar *searchFriendsBar;
@property(nonatomic, strong) RCDTableView *friendsTabelView;

@property(nonatomic, strong) NSDictionary *allFriendSectionDic;

@property(nonatomic, strong) NSArray *seletedUsers;

@property(nonatomic, strong) NSString *titleStr;

@property(nonatomic, copy) schoolBlock block;
@property (nonatomic,strong) NSString * url;
@end
