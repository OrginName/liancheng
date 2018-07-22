//
//  RCDPrivateSettingsTableViewController.m
//  RCloudMessage
//
//  Created by Jue on 16/5/18.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import "RCDPrivateSettingsTableViewController.h"
#import "DefaultPortraitView.h"
#import "RCDBaseSettingTableViewCell.h"
#import "RCDHttpTool.h"
#import "RCDPrivateSettingsCell.h"
#import "RCDPrivateSettingsUserInfoCell.h"
#import "RCDSearchHistoryMessageController.h"
#import "RCDSettingBaseViewController.h"
#import "RCDataBaseManager.h"
#import "UIColor+RCColor.h"
#import "UIImageView+WebCache.h"
#import "RCDUIBarButtonItem.h"
#import "FirstTanView.h"
#import "EditAllController.h"
#import "privateUserInfoModel.h"
static NSString *CellIdentifier = @"RCDBaseSettingTableViewCell";
@interface RCDPrivateSettingsTableViewController ()
@property (nonatomic,strong) RCDUserInfo * userInfo;
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation RCDPrivateSettingsTableViewController {
    NSString *portraitUrl;
    NSString *nickname;
    BOOL enableNotification;
    RCConversation *currentConversation;
}
+ (instancetype)privateSettingsTableViewController {
    return [[[self class] alloc] init];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天详情";
    [self.view addSubview:self.tableView];
    FirstTanView * tan = [[NSBundle mainBundle] loadNibNamed:@"FirstTanView" owner:nil options:nil][3];
    tan.userInfo = self.userInfo1;
    self.tableView.tableHeaderView = tan;
    [self.tableView reloadData];
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"our-more"]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(rightBarButtonItemClicked)];

    
}
-(void)rightBarButtonItemClicked{
    privateUserInfoModel* model = [YSAccountTool userInfo];
    NSString * arr = @"";
    if (![[self.userId description] isEqualToString:model.modelId]) {
        if ([[self.userInfo1.isFriend description] isEqualToString:@"1"]) {
            arr = @"加入黑名单";
        }else{
            arr = @"加为好友";
        }
    }
    WeakSelf
    [YTAlertUtil alertDualWithTitle:nil message:nil style:UIAlertControllerStyleActionSheet cancelTitle:@"取消" cancelHandler:^(UIAlertAction *action) {
        
    } defaultTitle:arr defaultHandler:^(UIAlertAction *action) {
        if ([action.title isEqualToString:@"加入黑名单"]) {
            [weakSelf joinBlacklist];
        }else{
            [weakSelf AddFriend];
        }
    } completion:nil];
}
-(void)AddFriend{
    [RCDHTTPTOOL requestFriend:self.userId complete:^(BOOL result) {
        if (result) {
            [YTAlertUtil showTempInfo:@"好友申请已发送"];
        }
    }];
}
-(void)joinBlacklist{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //黑名单
        hud.labelText = @"正在加入黑名单";
        [[RCIMClient sharedRCIMClient] addToBlacklist:self.userId
                                              success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hide:YES];
                                                  });
                                               
                                              }
                        error:^(RCErrorCode status) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                    [hud hide:YES];
                    [YTAlertUtil showTempInfo:@"加入失败"];
                            });
                                                }];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    switch (section) {
    case 0:
        rows = 4;
        break;

    case 1:
        rows = 1;
        break;

    case 2:
        rows = 3;
        break;
    default:
        break;
    }
    return rows;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 43.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCDBaseSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[RCDBaseSettingTableViewCell alloc] init];
    }
    privateUserInfoModel * model = [YSAccountTool userInfo];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if (indexPath.row==0) {
            [cell setCellStyle:DefaultStyle_RightLabel_WithoutRightArrow];
            cell.leftLabel.text = @"连程号";
            cell.rightLabel.text = self.userId;
        }else if (indexPath.row==1){
            [cell setCellStyle:DefaultStyle_RightLabel];
            cell.leftLabel.text = @"设置备注";
            cell.rightLabel.text = @"";
        }else if (indexPath.row==2){
            [cell setCellStyle:DefaultStyle_RightLabel_WithoutRightArrow];
            cell.leftLabel.text = @"电话号码";
            cell.rightLabel.text =[[model.modelId description] isEqualToString:self.userId]?model.mobile:self.userInfo1.mobilePhone;
        }else{
            [cell setCellStyle:DefaultStyle_RightLabel_WithoutRightArrow];
            cell.leftLabel.text = @"所在地区";
            cell.rightLabel.text = [[model.modelId description] isEqualToString:self.userId]?model.cityName:self.userInfo1.cityName;
        }
        return cell;
    }
    if (indexPath.section == 1) {
        RCDBaseSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[RCDBaseSettingTableViewCell alloc] init];
        }
        cell.leftLabel.text = @"查找聊天记录";
        [cell setCellStyle:DefaultStyle];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 2) {
        switch (indexPath.row) {
        case 0: {
            [cell setCellStyle:SwitchStyle];
            cell.leftLabel.text = @"消息免打扰";
            cell.switchButton.hidden = NO;
            cell.switchButton.on = !enableNotification;
            [cell.switchButton removeTarget:self
                                     action:@selector(clickIsTopBtn:)
                           forControlEvents:UIControlEventValueChanged];

            [cell.switchButton addTarget:self
                                  action:@selector(clickNotificationBtn:)
                        forControlEvents:UIControlEventValueChanged];

        } break;

        case 1: {
            [cell setCellStyle:SwitchStyle];
            cell.leftLabel.text = @"会话置顶";
            cell.switchButton.hidden = NO;
            cell.switchButton.on = currentConversation.isTop;
            [cell.switchButton addTarget:self
                                  action:@selector(clickIsTopBtn:)
                        forControlEvents:UIControlEventValueChanged];
        } break;

        case 2: {
            [cell setCellStyle:SwitchStyle];
            cell.leftLabel.text = @"清除聊天记录";
            cell.switchButton.hidden = YES;
        } break;

        default:
            break;
        }

        return cell;
    }
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RCDBaseSettingTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section==0&&indexPath.row==1) {
        if (![[self.userInfo1.isFriend description] isEqualToString:@"1"]) {
            return [YTAlertUtil showTempInfo:@"对方还不是您的好友,不能修改"];
        }
        EditAllController * edit = [EditAllController new];
        WeakSelf
        edit.block = ^(NSString * str){
            cell.rightLabel.text = str;
            [weakSelf updateBeiZhu:str];
        };
        [self.navigationController pushViewController:edit animated:YES];
    }
    if (indexPath.section == 1) {
        RCDSearchHistoryMessageController *searchViewController = [[RCDSearchHistoryMessageController alloc] init];
        searchViewController.conversationType = ConversationType_PRIVATE;
        searchViewController.targetId = self.userId;
        [self.navigationController pushViewController:searchViewController animated:YES];
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 2) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定清除聊天记录？"
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:@"确定"
                                                            otherButtonTitles:nil];

            [actionSheet showInView:self.view];
            actionSheet.tag = 100;
        }
    }
}
-(void)updateBeiZhu:(NSString *)str{
    if (str.length==0) {
        return;
    }
    NSDictionary * dic = @{
                           @"friendId": self.userInfo1.userId,
                           @"remark":str
                           };
    [YSNetworkTool POST:@"/v1/my/update-remark" params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [YTAlertUtil showTempInfo:@"修改成功"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 100) {
        if (buttonIndex == 0) {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            RCDPrivateSettingsCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            UIActivityIndicatorView *activityIndicatorView =
                [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            float cellWidth = cell.bounds.size.width;
            UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(cellWidth - 50, 15, 40, 40)];
            [loadingView addSubview:activityIndicatorView];
            dispatch_async(dispatch_get_main_queue(), ^{
                [activityIndicatorView startAnimating];
                [cell addSubview:loadingView];
            });
            __weak typeof(self) weakSelf = self;
            
            NSArray *latestMessages = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_PRIVATE targetId:_userId count:1];
            if (latestMessages.count > 0) {
                RCMessage *message = (RCMessage *)[latestMessages firstObject];
                [[RCIMClient sharedRCIMClient]clearRemoteHistoryMessages:ConversationType_PRIVATE
                                                                targetId:_userId
                                                              recordTime:message.sentTime
                                                                 success:^{
                                                                     [[RCIMClient sharedRCIMClient] deleteMessages:ConversationType_PRIVATE
                                                                                                          targetId:_userId
                                                                                                           success:^{
                                                                                                               [weakSelf performSelectorOnMainThread:@selector(clearCacheAlertMessage:)
                                                                                                                                          withObject:@"清除聊天记录成功！"
                                                                                                                                       waitUntilDone:YES];
                                                                                                               [[NSNotificationCenter defaultCenter] postNotificationName:@"ClearHistoryMsg" object:nil];
                                                                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                                   [loadingView removeFromSuperview];
                                                                                                               });
                                                                                                           }
                                                                                                             error:^(RCErrorCode status) {
                                                                                                                 
                                                                                                             }];
                                                                 }
                                                                   error:^(RCErrorCode status) {
                                                                       [weakSelf performSelectorOnMainThread:@selector(clearCacheAlertMessage:)
                                                                                                  withObject:@"清除聊天记录失败！"
                                                                                               waitUntilDone:YES];
                                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                                           [loadingView removeFromSuperview];
                                                                       });
                                                                   }];
            }

            [[NSNotificationCenter defaultCenter] postNotificationName:@"ClearHistoryMsg" object:nil];
        }
    }
}

- (void)clearCacheAlertMessage:(NSString *)msg {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - 本类的私有方法
- (void)startLoadView {
    currentConversation = [[RCIMClient sharedRCIMClient] getConversation:ConversationType_PRIVATE targetId:self.userId];
    [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:ConversationType_PRIVATE
                                                            targetId:self.userId
                                                             success:^(RCConversationNotificationStatus nStatus) {
                                                                 enableNotification = NO;
                                                                 if (nStatus == NOTIFY) {
                                                                     enableNotification = YES;
                                                                 }
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                     [self.tableView reloadData];
                                                                 });
                                                             }
                                                               error:^(RCErrorCode status){

                                                               }];

    [self loadUserInfo:self.userId];
}

- (void)loadUserInfo:(NSString *)userId {
    if (![userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        self.userInfo = [[RCDataBaseManager shareInstance] getFriendInfo:userId];
    }
}

- (void)clickNotificationBtn:(id)sender {
    UISwitch *swch = sender;
    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_PRIVATE
                                                            targetId:self.userId
                                                           isBlocked:swch.on
                                                             success:^(RCConversationNotificationStatus nStatus) {

                                                             }
                                                               error:^(RCErrorCode status){

                                                               }];
}

- (void)clickIsTopBtn:(id)sender {
    UISwitch *swch = sender;
    [[RCIMClient sharedRCIMClient] setConversationToTop:ConversationType_PRIVATE targetId:self.userId isTop:swch.on];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = HEXCOLOR(0xf0f0f6);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self startLoadView];
    //关闭自适应
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //设置导航透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    //去掉导航栏底部的黑线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:
     [UIImage imageNamed:@"椭圆2拷贝4"] forBarMetrics:UIBarMetricsDefault];
}
@end
