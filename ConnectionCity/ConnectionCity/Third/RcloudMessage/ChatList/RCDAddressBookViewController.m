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
#import "CircleNet.h"
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
        self.friends = [NSMutableArray array];
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
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page=1;
        [self getAllData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getAllData];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _needSyncFriendList = YES;
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
    NSDictionary * dic = @{
                           @"pageNumber": @(_page),
                           @"pageSize": @50
                           };
    [YSNetworkTool POST:v1ApplicationPageAll params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if (_page==1) {
            [_friends removeAllObjects];
        }
        _page++;
        NSArray * array = @[@"userGroupApplications",@"userFriendApplications",@"teamUserApplications",@"serviceStationUserApplications"];
        NSArray * array1 = @[@"20",@"100",@"30",@"40"];
        NSArray * array2 = @[@"申请加为好友",@"申请加入群"];
        for (int i=0; i<array.count; i++) {
            for (NSDictionary * dic in responseObject[@"data"][array[i]][@"content"]) {
                friendMo * friend = [friendMo mj_objectWithKeyValues:dic];
                friend.type = array1[i];
                if ([array[i] isEqualToString:@"userFriendApplications"]) {
                    friend.des = array2[0];
                }else
                    friend.des = array2[1];
                [_friends addObject:friend];
            }
        }
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
    friendMo *friend = _friends[btn.tag-10000];
    if ([friend.type isEqualToString:@"100"]) {
        [YTAlertUtil showHUDWithTitle:@"添加好友中..."];
        WeakSelf
        [RCDHTTPTOOL processInviteFriendRequest:friend.user.ID
                                       complete:^(BOOL request) {
                                           if (request) {
                                               [YTAlertUtil hideHUD];
                                               [weakSelf.tableView.mj_header beginRefreshing];
                                               weakSelf.block();
                                               [[RCIMClient sharedRCIMClient] getBlacklistStatus:friend.user.ID success:^(int bizStatus) {
                                                   if (bizStatus==0) {
                                                       [[RCIMClient sharedRCIMClient] removeFromBlacklist:friend.user.ID success:^{
                                                           
                                                       } error:^(RCErrorCode status) {
                                                           
                                                       }];
                                                   }
                                               } error:^(RCErrorCode status) {
                                                   
                                               }]; [self.navigationController popViewControllerAnimated:YES];
                                               [RCDHTTPTOOL getFriendscomplete:^(NSMutableArray *result) {
                                                   
                                               }];
                                               
                                           } else {
                                               [YTAlertUtil hideHUD];
                                           }
                                       }];
    }else{
        NSString * str = @"";
        str = [friend.type isEqualToString:@"20"]?friend.groupId:[friend.type isEqualToString:@"30"]?friend.teamId:friend.stationId;
        WeakSelf
        [CircleNet requstAgreeJoinQun:@{@"groupId":str,@"memberUserId": friend.userId} withFlag:[friend.type intValue] withSuc:^(NSDictionary *successDicValue) {
            _page=1;
            [weakSelf getAllData];
        } withFailBlock:^(NSError *failValue) {
        }];
    }
   
}
@end
