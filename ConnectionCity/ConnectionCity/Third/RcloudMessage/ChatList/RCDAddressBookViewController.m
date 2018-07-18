//
//  RCDAddressBookViewController.m
//  RongCloud
//
//  Created by Liv on 14/11/11.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import "RCDAddressBookViewController.h"
#import "DefaultPortraitView.h"
#import "MBProgressHUD.h"
#import "RCDAddressBookTableViewCell.h"
#import "RCDChatViewController.h"
#import "RCDCommonDefine.h"
#import "RCDHttpTool.h"
#import "RCDNoFriendView.h"
#import "RCDPersonDetailViewController.h"
#import "RCDRCIMDataSource.h"
#import "RCDUserInfo.h"
#import "RCDataBaseManager.h"
#import "UIColor+RCColor.h"
#import "UIImageView+WebCache.h"
#import <RongIMLib/RongIMLib.h>
#include <ctype.h>
#import "friendMo.h"
@interface RCDAddressBookViewController ()<RCDAddressBookCellDelegate>
{
    int _page;
}
//#字符索引对应的user object
@property(nonatomic, strong) NSMutableArray *friends;
@property(nonatomic, strong) RCDNoFriendView *noFriendView;
@end

@implementation RCDAddressBookViewController {
    NSInteger tag;
    BOOL isSyncFriends;
}
MBProgressHUD *hud;
+ (instancetype)addressBookViewController {
    return [[self alloc] init];
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"新朋友";
    self.tableView.tableFooterView = [UIView new];
    _page = 1;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page=1;
        [self getAllData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getAllData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _needSyncFriendList = YES;
    [self getAllData];
}

//删除已选中用户
- (void)removeSelectedUsers:(NSArray *)selectedUsers {
    for (RCUserInfo *user in selectedUsers) {

        [_friends enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            RCDUserInfo *userInfo = obj;
            if ([user.userId isEqualToString:userInfo.userId]) {
                [_friends removeObject:obj];
            }
        }];
    }
}

/**
 *  initial data
 */
- (void)getAllData {
//    _friends = [NSMutableArray arrayWithArray:[[RCDataBaseManager shareInstance] getAllFriends]];
//    if (_friends.count > 0) {
//        self.hideSectionHeader = YES;
//        _friends = [self sortForFreindList:_friends];
//        tag = 0;
//        [self.tableView reloadData];
//    } else {
//        CGRect frame = CGRectMake(0, 0, RCDscreenWidth, RCDscreenHeight - 64);
//        self.noFriendView = [[RCDNoFriendView alloc] initWithFrame:frame];
//        self.noFriendView.displayLabel.text = @"暂无数据";
//        [self.view addSubview:self.noFriendView];
//        [self.view bringSubviewToFront:self.noFriendView];
//    }
//    if (isSyncFriends == NO) {
//        [RCDDataSource syncFriendList:[RCIM sharedRCIM].currentUserInfo.userId
//                             complete:^(NSMutableArray *result) {
//                                 isSyncFriends = YES;
//                                 if (result > 0) {
//                                     dispatch_async(dispatch_get_main_queue(), ^{
//                                         if (self.noFriendView != nil) {
//                                             [self.noFriendView removeFromSuperview];
//                                         }
//                                     });
//                                     [self getAllData];
//                                 }
//                             }];
//    }
    
    NSDictionary * dic = @{
                           @"pageNumber": @1,
                           @"pageSize": @50
                           };
    [YSNetworkTool POST:v1ApplicationPage params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"data"][@"content"] count]==0) {
            [YTAlertUtil showTempInfo:@"暂无数据"];
            [self endFresh];
            return;
        }
        if (_page==1) {
            [_friends removeAllObjects];
        }
        _friends = [friendMo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"content"]];
        [self.tableView reloadData];
        [self endFresh];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endFresh];
    }];
}
-(void)endFresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reusableCellWithIdentifier = @"RCDAddressBookCell";
    RCDAddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
    if (!cell) {
        cell = [[RCDAddressBookTableViewCell alloc] init];
    }
    cell.acceptBtn.tag = indexPath.row + 10000;
    friendMo *user = _friends[indexPath.row];
    cell.delegate = self;
    [cell setModel:user];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_friends count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [RCDAddressBookTableViewCell cellHeight];
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    friendMo *user = _friends[indexPath.row];
////    if ([user.status intValue] == 10 || [user.status intValue] == 11) {
////        return;
////    }
//    RCUserInfo *userInfo = [RCUserInfo new];
//    userInfo.userId = user.friendId;
//    userInfo.portraitUri = user.user.headImage;
//    userInfo.name = user.user.nickName?user.user.nickName:user.friendId;
//
//    RCDChatViewController *chatViewController = [[RCDChatViewController alloc] init];
//    chatViewController.conversationType = ConversationType_PRIVATE;
//    chatViewController.targetId = userInfo.userId;
//    chatViewController.title = userInfo.name;
//    chatViewController.displayUserNameInCell = NO;
//    chatViewController.needPopToRootView = YES;
//    [self.navigationController pushViewController:chatViewController animated:YES];
//}

- (void)acceptClick:(UIButton *)btn
{
//    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.color = [UIColor colorWithHexString:@"343637" alpha:0.5];
//    hud.labelText = @"添加好友中...";
//    [hud show:YES];
    [YTAlertUtil showHUDWithTitle:@"添加好友中..."];
    friendMo *friend = _friends[btn.tag-10000];
    WeakSelf
    [RCDHTTPTOOL processInviteFriendRequest:friend.user.ID
                                   complete:^(BOOL request) {
                                       if (request) {
                                           [YTAlertUtil hideHUD];
                                           [weakSelf.tableView.mj_header beginRefreshing];
                                           weakSelf.block();
                                           [self.navigationController popViewControllerAnimated:YES];
                                           [RCDHTTPTOOL getFriendscomplete:^(NSMutableArray *result) {
                                               
                                           }];
                                           
                                       } else {
                                           [YTAlertUtil hideHUD];
                                       }
                                   }];
}
@end
