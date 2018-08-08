//
//  AddressBookController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AddressBookController.h"
#import "UITabBar+badge.h"
#import "RCDUserInfo.h"
#import "RCDChatListCell.h"
#import "RCDHttpTool.h"
#import "RCDChatViewController.h"
#import "RCDAddressBookViewController.h"
#import "RCDContactSelectedTableViewController.h"
#import "RCDSearchFriendViewController.h"
#import "RCDSearchViewController.h"
#import "CreatGroupController.h"
#import "MessageMo.h"
@interface AddressBookController ()<RCDSearchViewDelegate>
@property(nonatomic, strong) RCConversationModel *tempModel;
@property(nonatomic, assign) NSUInteger index;
@property(nonatomic, strong) UINavigationController *searchNavigationController;
@property (nonatomic,strong) NSMutableArray * arr_AllGroup;
@property (nonatomic,strong) NSString * MessStr;
@property (nonatomic,strong) NSMutableArray * arr_mess;
@property(nonatomic, assign) BOOL isClick;
- (void)updateBadgeValueForTabBarItem;
@property(nonatomic) BOOL isLoading;
@end

@implementation AddressBookController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    self.arr_AllGroup = [NSMutableArray array];
    if ([KUserDefults objectForKey:@"MESSAGEID"]==nil) {
        self.MessStr = @"";
    }else
        self.MessStr = [KUserDefults objectForKey:@"MESSAGEID"];
    self.arr_mess = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:@"MESSAGE"]];
    if (!self.arr_mess) {
        self.arr_mess = [NSMutableArray array];
    }
}
//更多按钮创建
-(void)more{
    [YTAlertUtil alertMultiWithTitle:nil message:nil style:UIAlertControllerStyleActionSheet multiTitles:@[@"发起聊天",@"创建群组",@"添加好友"] multiHandler:^(UIAlertAction *action, NSArray *titles, NSUInteger idx) {
        switch (idx) {
            case 0:
                {
                    RCDContactSelectedTableViewController *contactSelectedVC = [[RCDContactSelectedTableViewController alloc] init];
                    contactSelectedVC.forCreatingGroup = NO;
                    contactSelectedVC.isAllowsMultipleSelection = NO;
                    contactSelectedVC.titleStr = @"发起聊天";
                    [self.navigationController pushViewController:contactSelectedVC animated:YES];
                }
                break;
            case 1:
            {
                CreatGroupController * creat = [CreatGroupController new];
                creat.flag_str = 3;
                creat.blockGroup = ^{

                };
                [self.navigationController pushViewController:creat animated:YES];
            }
                break;
            case 2:
            {
                RCDSearchFriendViewController *searchFirendVC = [RCDSearchFriendViewController searchFriendViewController];
                [self.navigationController pushViewController:searchFirendVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    } cancelTitle:@"取消" cancelHandler:^(UIAlertAction *action) {
        
    } completion:nil];
    
}
-(void)setUI{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(more) image:@"our-more" title:nil EdgeInsets:UIEdgeInsetsZero];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    //设置tableView样式
    self.conversationListTableView.separatorColor = [UIColor hexColorWithString:@"dfdfdf"];
    self.conversationListTableView.tableFooterView = [UIView new];
    
    // 设置在NavigatorBar中显示连接中的提示
    self.showConnectingStatusOnNavigatorBar = YES;
    //定位未读数会话
    self.index = 0;
    //接收定位到未读数会话的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyUpdateUnreadMessageCount) name:@"UpdateNum" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(GotoNextCoversation)
                                                 name:@"GotoNextCoversation"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateForSharedMessageInsertSuccess)
                                                 name:@"RCDSharedMessageInsertSuccess"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshCell:)
                                                 name:@"RefreshConversationList"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCell:) name:@"DELETETEAM" object:nil];
//    [self checkVersion];
}
- (id)init {
    self = [super init];
    if (self) {
        //设置要显示的会话类型
        [self setDisplayConversationTypes:@[
                                            @(ConversationType_PRIVATE), @(ConversationType_DISCUSSION), @(ConversationType_APPSERVICE),
                                            @(ConversationType_PUBLICSERVICE), @(ConversationType_GROUP), @(ConversationType_SYSTEM)
                                            ]];
        
        //聚合会话类型
        [self setCollectionConversationType:@[ @(ConversationType_SYSTEM) ]];
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.translucent = NO;
    _isClick = YES;
//    [self notifyUpdateUnreadMessageCount];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNeedRefreshNotification:)
                                                 name:@"kRCNeedReloadDiscussionListNotification"
                                               object:nil];
    RCUserInfo *groupNotify = [[RCUserInfo alloc] initWithUserId:@"__system__" name:@"" portrait:nil];
    [[RCIM sharedRCIM] refreshUserInfoCache:groupNotify withUserId:@"__system__"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController.navigationBar setBackgroundImage:
     [UIImage imageNamed:@"椭圆2拷贝4"] forBarMetrics:UIBarMetricsDefault];
    
}
//由于demo使用了tabbarcontroller，当切换到其它tab时，不能更改tabbarcontroller的标题。
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"kRCNeedReloadDiscussionListNotification"
                                                  object:nil];
}
//*********************插入自定义Cell*********************//
//插入自定义会话model
- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource {
    for (int i = 0; i < dataSource.count; i++) {
        RCConversationModel *model = dataSource[i];
        //筛选请求添加好友的系统消息，用于生成自定义会话类型的cell
        if (model.conversationType == ConversationType_SYSTEM &&
            [model.lastestMessage isMemberOfClass:[RCContactNotificationMessage class]]) {
            model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        }
        if ([model.lastestMessage isKindOfClass:[RCGroupNotificationMessage class]]) {
            RCGroupNotificationMessage *groupNotification = (RCGroupNotificationMessage *)model.lastestMessage;
            if ([groupNotification.operation isEqualToString:@"Quit"]) {
                NSData *jsonData = [groupNotification.data dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dictionary =
                [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                NSDictionary *data =
                [dictionary[@"data"] isKindOfClass:[NSDictionary class]] ? dictionary[@"data"] : nil;
                NSString *nickName =
                [data[@"operatorNickname"] isKindOfClass:[NSString class]] ? data[@"operatorNickname"] : nil;
                if ([nickName isEqualToString:[RCIM sharedRCIM].currentUserInfo.name]) {
                    [[RCIMClient sharedRCIMClient] removeConversation:model.conversationType targetId:model.targetId];
                    [self refreshConversationTableViewIfNeeded];
                }
            }
        }
    }
    return dataSource;
}
/*!
 
 即将显示Cell的回调
 @param cell        即将显示的Cell
 @param indexPath   该Cell对应的会话Cell数据模型在数据源中的索引值
 这个方法可以自定义一些cell 的属性
 @discussion 您可以在此回调中修改Cell的一些显示属性。
 */
- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell

                             atIndexPath:(NSIndexPath *)indexPath{
}
//左滑删除
- (void)rcConversationListTableView:(UITableView *)tableView
                 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                  forRowAtIndexPath:(NSIndexPath *)indexPath {
    //可以从数据库删除数据
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_SYSTEM targetId:model.targetId];
    [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
    [self.conversationListTableView reloadData];
}
//高度
- (CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67.0f;
}
/**
 *  点击进入会话页面
 *
 *  @param conversationModelType 会话类型
 *  @param model                 会话数据
 *  @param indexPath             indexPath description
 */
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
//     [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeTabBarIndex" object:@0];
    [self notifyUpdateUnreadMessageCount];
    if (_isClick) {
        _isClick = NO;
        if (model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_PUBLIC_SERVICE) {
            RCDChatViewController *_conversationVC = [[RCDChatViewController alloc] init];
            _conversationVC.conversationType = model.conversationType;
            _conversationVC.targetId = KString(@"%@", model.targetId);
//            _conversationVC.userName = model.conversationTitle;
            _conversationVC.title = model.conversationTitle;
            _conversationVC.conversation = model;
            [self.navigationController pushViewController:_conversationVC animated:YES];
        }
        
        if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
            RCDChatViewController *_conversationVC = [[RCDChatViewController alloc] init];
            int a;
            if ([model.targetId containsString:@"_"]) {
                if ([[model.targetId componentsSeparatedByString:@"_"][0] isEqualToString:@"station"]) {
                    a = 2;
                }else
                    a = 1;
            }else
                a=3;
            _conversationVC.flagStr = a;
            _conversationVC.conversationType = model.conversationType;
            _conversationVC.targetId = KString(@"%@", model.targetId);;
            _conversationVC.title = model.conversationTitle;
            _conversationVC.conversation = model;
            _conversationVC.unReadMessage = model.unreadMessageCount;
            _conversationVC.enableNewComingMessageIcon = YES; //开启消息提醒
            _conversationVC.enableUnreadMessageIcon = YES;
            if (model.conversationType == ConversationType_SYSTEM) {
                _conversationVC.title = @"系统消息";
            }
            if ([model.objectName isEqualToString:@"RC:ContactNtf"]) {
                RCDAddressBookViewController *addressBookVC = [RCDAddressBookViewController addressBookViewController];
                addressBookVC.needSyncFriendList = YES;
                
                [self.navigationController pushViewController:addressBookVC animated:YES];
                return;
            }
            //如果是单聊，不显示发送方昵称
            if (model.conversationType == ConversationType_PRIVATE) {
                _conversationVC.displayUserNameInCell = NO;
            }
            [self.navigationController pushViewController:_conversationVC animated:YES];
        }
        
        //聚合会话类型，此处自定设置。
        if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION) {
            
            AddressBookController *temp = [[AddressBookController alloc] init];
            NSArray *array = [NSArray arrayWithObject:[NSNumber numberWithInt:model.conversationType]];
            [temp setDisplayConversationTypes:array];
            [temp setCollectionConversationType:nil];
            temp.isEnteredToCollectionViewController = YES;
            [self.navigationController pushViewController:temp animated:YES];
        }
        
        //自定义会话类型
        if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION) {
            RCConversationModel *model = self.conversationListDataSource[indexPath.row];
            if ([model.objectName isEqualToString:@"RC:ContactNtf"]) {
                RCDAddressBookViewController *addressBookVC = [RCDAddressBookViewController addressBookViewController];
                [self.navigationController pushViewController:addressBookVC animated:YES];
            }
        }
    }
}
//自定义cell
- (RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView
                                  cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    __block NSString *userName = nil;
    __block NSString *portraitUri = nil;
    RCContactNotificationMessage *_contactNotificationMsg = nil;
    __weak AddressBookController *weakSelf = self;
    //此处需要添加根据userid来获取用户信息的逻辑，extend字段不存在于DB中，当数据来自db时没有extend字段内容，只有userid
    if (nil == model.extend) {
        // Not finished yet, To Be Continue...
        if (model.conversationType == ConversationType_SYSTEM &&
            [model.lastestMessage isMemberOfClass:[RCContactNotificationMessage class]]) {
            _contactNotificationMsg = (RCContactNotificationMessage *)model.lastestMessage;
            if (_contactNotificationMsg.sourceUserId == nil) {
                RCDChatListCell *cell =
                [[RCDChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
                cell.lblDetail.text = @"好友请求";
                [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:portraitUri]
                              placeholderImage:[UIImage imageNamed:@"system_notice"]];
                return cell;
            }
            NSDictionary *_cache_userinfo =
            [[NSUserDefaults standardUserDefaults] objectForKey:_contactNotificationMsg.sourceUserId];
            if (_cache_userinfo) {
                userName = _cache_userinfo[@"username"];
                portraitUri = _cache_userinfo[@"portraitUri"];
            } else {
                NSDictionary *emptyDic = @{};
                [[NSUserDefaults standardUserDefaults] setObject:emptyDic forKey:_contactNotificationMsg.sourceUserId];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [RCDHTTPTOOL
                 getUserInfoByUserID:_contactNotificationMsg.sourceUserId
                 completion:^(RCUserInfo *user) {
                     if (user == nil) {
                         return;
                     }
                     RCDUserInfo *rcduserinfo_ = [RCDUserInfo new];
                     rcduserinfo_.name = user.name;
                     rcduserinfo_.userId = user.userId;
                     rcduserinfo_.portraitUri = user.portraitUri;
                     model.extend = rcduserinfo_;
                     NSDictionary *userinfoDic =
                     @{@"username" : rcduserinfo_.name, @"portraitUri" : rcduserinfo_.portraitUri};
                     [[NSUserDefaults standardUserDefaults] setObject:userinfoDic
                                                               forKey:_contactNotificationMsg.sourceUserId];
                     [[NSUserDefaults standardUserDefaults] synchronize];

                     [weakSelf.conversationListTableView
                      reloadRowsAtIndexPaths:@[ indexPath ]
                      withRowAnimation:UITableViewRowAnimationAutomatic];
                 }];
            }
        }
        
    }else if (model.conversationType == ConversationType_GROUP){
        
    }else {
        RCDUserInfo *user = (RCDUserInfo *)model.extend;
        userName = user.name;
        portraitUri = user.portraitUri;
    }
    
    RCDChatListCell *cell = [[RCDChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    NSString *operation = _contactNotificationMsg.operation;
    NSString *operationContent;
    if ([operation isEqualToString:@"Request"]) {
        operationContent = [NSString stringWithFormat:@"来自%@的好友请求", userName];
    } else if ([operation isEqualToString:@"AcceptResponse"]) {
        operationContent = [NSString stringWithFormat:@"%@通过了你的好友请求", userName];
    }
    cell.lblDetail.text = operationContent;
    [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:portraitUri]
                  placeholderImage:[UIImage imageNamed:@"system_notice"]];
    cell.labelTime.text = [RCKitUtility ConvertMessageTime:model.sentTime / 1000];
    cell.model = model;
    return cell;
}
//*********************插入自定义Cell*********************//
#pragma mark - 收到消息监听
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    __weak typeof(&*self) blockSelf_ = self;
    //处理好友请求
    RCMessage *message = notification.object;
    MessageMo * mo = [MessageMo new];
    mo.ID = message.targetId;
    mo.Type = message.conversationType;//1单 3群
    if (self.arr_mess.count!=0) {
        [self.arr_mess enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MessageMo * mo1 = (MessageMo *)obj;
            if ([mo1.ID isEqualToString:mo.ID]) {
                
            }else{
                [self.arr_mess addObject:mo];
            }
        }];
    }else
        [self.arr_mess addObject:mo];
    NSData * hotCityData = [NSKeyedArchiver archivedDataWithRootObject:self.arr_mess];
    //拼音转换太耗时，这里把第一次转换结果存到单例中
    [KUserDefults setValue:hotCityData forKey:@"MESSAGE"];
//    self.MessStr = [NSString stringWithFormat:@"%@,%@",KString(@"%ld", message.messageId),self.MessStr];
//    [KUserDefults setObject:self.MessStr forKey:@"MESSAGEID"];
//    [KUserDefults synchronize];
    if ([message.content isMemberOfClass:[RCContactNotificationMessage class]]) {
        
        if (message.conversationType != ConversationType_SYSTEM) {
            NSLog(@"好友消息要发系统消息！！！");
#if DEBUG
            @throw [[NSException alloc] initWithName:@"error" reason:@"好友消息要发系统消息！！！" userInfo:nil];
#endif
        }
        RCContactNotificationMessage *_contactNotificationMsg = (RCContactNotificationMessage *)message.content;
        if (_contactNotificationMsg.sourceUserId == nil || _contactNotificationMsg.sourceUserId.length == 0) {
            return;
        }
        //该接口需要替换为从消息体获取好友请求的用户信息
        [RCDHTTPTOOL getUserInfoByUserID:_contactNotificationMsg.sourceUserId
                              completion:^(RCUserInfo *user) {
                                  RCDUserInfo *rcduserinfo_ = [RCDUserInfo new];
                                  rcduserinfo_.name = user.name;
                                  rcduserinfo_.userId = user.userId;
                                  rcduserinfo_.portraitUri = user.portraitUri;

                                  RCConversationModel *customModel = [RCConversationModel new];
                                  customModel.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
                                  customModel.extend = rcduserinfo_;
                                  customModel.conversationType = message.conversationType;
                                  customModel.targetId = message.targetId;
                                  customModel.sentTime = message.sentTime;
                                  customModel.receivedTime = message.receivedTime;
                                  customModel.senderUserId = message.senderUserId;
                                  customModel.lastestMessage = _contactNotificationMsg;
                                  //[_myDataSource insertObject:customModel atIndex:0];

                                  // local cache for userInfo
                                  NSDictionary *userinfoDic =
                                  @{@"username" : rcduserinfo_.name, @"portraitUri" : rcduserinfo_.portraitUri};
                                  [[NSUserDefaults standardUserDefaults]
                                   setObject:userinfoDic
                                   forKey:_contactNotificationMsg.sourceUserId];
                                  [[NSUserDefaults standardUserDefaults] synchronize];

                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      //调用父类刷新未读消息数
                                      [blockSelf_ refreshConversationTableViewWithConversationModel:customModel];
                                      [blockSelf_ notifyUpdateUnreadMessageCount];

                                      //当消息为RCContactNotificationMessage时，没有调用super，如果是最后一条消息，可能需要刷新一下整个列表。
                                      //原因请查看super didReceiveMessageNotification的注释。
                                      NSNumber *left = [notification.userInfo objectForKey:@"left"];
                                      if (0 == left.integerValue) {
                                          [super refreshConversationTableViewIfNeeded];
                                      }
                                  });
                              }];
    } else {
        //调用父类刷新未读消息数
        [super didReceiveMessageNotification:notification];
    }
}
- (void)didTapCellPortrait:(RCConversationModel *)model {
    if (model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_PUBLIC_SERVICE) {
        RCDChatViewController *_conversationVC = [[RCDChatViewController alloc] init];
        _conversationVC.conversationType = model.conversationType;
        _conversationVC.targetId = model.targetId;
//        _conversationVC.userName = model.conversationTitle;
        _conversationVC.title = model.conversationTitle;
        _conversationVC.conversation = model;
        _conversationVC.unReadMessage = model.unreadMessageCount;
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }
    
    if (model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
        RCDChatViewController *_conversationVC = [[RCDChatViewController alloc] init];
        _conversationVC.conversationType = model.conversationType;
        _conversationVC.targetId = model.targetId;
//        _conversationVC.userName = model.conversationTitle;
        _conversationVC.title = model.conversationTitle;
        _conversationVC.conversation = model;
        _conversationVC.unReadMessage = model.unreadMessageCount;
        _conversationVC.enableNewComingMessageIcon = YES; //开启消息提醒
        _conversationVC.enableUnreadMessageIcon = YES;
        if (model.conversationType == ConversationType_SYSTEM) {
//            _conversationVC.userName = @"系统消息";
            _conversationVC.title = @"系统消息";
        }
        if ([model.objectName isEqualToString:@"RC:ContactNtf"]) {
            RCDAddressBookViewController *addressBookVC = [RCDAddressBookViewController addressBookViewController];
            addressBookVC.needSyncFriendList = YES;
            [self.navigationController pushViewController:addressBookVC animated:YES];
            return;
        }
        //如果是单聊，不显示发送方昵称
        if (model.conversationType == ConversationType_PRIVATE) {
            _conversationVC.displayUserNameInCell = NO;
        }
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }
    
    //聚合会话类型，此处自定设置。
    if (model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION) {
        AddressBookController *temp = [[AddressBookController alloc] init];
        NSArray *array = [NSArray arrayWithObject:[NSNumber numberWithInt:model.conversationType]];
        [temp setDisplayConversationTypes:array];
        [temp setCollectionConversationType:nil];
        temp.isEnteredToCollectionViewController = YES;
        [self.navigationController pushViewController:temp animated:YES];
    }
    //自定义会话类型
    if (model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION) {
//        RCConversationModel *model =
//        self.conversationListDataSource[indexPath.row];
        if ([model.objectName isEqualToString:@"RC:ContactNtf"]) {
            RCDAddressBookViewController *addressBookVC = [RCDAddressBookViewController addressBookViewController];
            [self.navigationController pushViewController:addressBookVC animated:YES];
        }
    }
}
- (void)notifyUpdateUnreadMessageCount {
    [self updateBadgeValueForTabBarItem];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSIndexPath *indexPath = [self.conversationListTableView indexPathForRowAtPoint:scrollView.contentOffset];
    self.index = indexPath.row;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //恢复conversationListTableView的自动回滚功能。
    self.conversationListTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)GotoNextCoversation {
    NSUInteger i;
    //设置contentInset是为了滚动到底部的时候，避免conversationListTableView自动回滚。
    self.conversationListTableView.contentInset =
    UIEdgeInsetsMake(0, 0, self.conversationListTableView.frame.size.height, 0);
    for (i = self.index + 1; i < self.conversationListDataSource.count; i++) {
        RCConversationModel *model = self.conversationListDataSource[i];
        if (model.unreadMessageCount > 0) {
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            self.index = i;
            [self.conversationListTableView scrollToRowAtIndexPath:scrollIndexPath
                                                  atScrollPosition:UITableViewScrollPositionTop
                                                          animated:YES];
            break;
        }
    }
    //滚动到起始位置
    if (i >= self.conversationListDataSource.count) {
        //    self.conversationListTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        for (i = 0; i < self.conversationListDataSource.count; i++) {
            RCConversationModel *model = self.conversationListDataSource[i];
            if (model.unreadMessageCount > 0) {
                NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                self.index = i;
                [self.conversationListTableView scrollToRowAtIndexPath:scrollIndexPath
                                                      atScrollPosition:UITableViewScrollPositionTop
                                                              animated:YES];
                break;
            }
        }
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    RCDSearchViewController *searchViewController = [[RCDSearchViewController alloc] init];
    self.searchNavigationController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    searchViewController.delegate = self;
    [self.navigationController.view addSubview:self.searchNavigationController.view];
}

- (void)onSearchCancelClick {
    [self.searchNavigationController.view removeFromSuperview];
    [self.searchNavigationController removeFromParentViewController];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self refreshConversationTableViewIfNeeded];
}
- (void)updateForSharedMessageInsertSuccess {
    [self refreshConversationTableViewIfNeeded];
}
- (void)refreshCell:(NSNotification *)notify {
    /*
     NSString *row = [notify object];
     RCConversationModel *model = [self.conversationListDataSource objectAtIndex:[row intValue]];
     model.unreadMessageCount = 0;
     NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[row integerValue] inSection:0];
     dispatch_async(dispatch_get_main_queue(), ^{
     [self.conversationListTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]
     withRowAnimation:UITableViewRowAnimationNone];
     });
     */
    [self refreshConversationTableViewIfNeeded];
}

- (void)updateBadgeValueForTabBarItem {
    __weak typeof(self) __weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [[RCIMClient sharedRCIMClient] getUnreadCount:__weakSelf.displayConversationTypeArray];
        if (count > 0) {
            //      __weakSelf.tabBarItem.badgeValue =
            //          [[NSString alloc] initWithFormat:@"%d", count];
            [__weakSelf.tabBarController.tabBar showBadgeOnItemIndex:1 badgeValue:count];
            
        } else {
            //      __weakSelf.tabBarItem.badgeValue = nil;
            [__weakSelf.tabBarController.tabBar hideBadgeOnItemIndex:1];
        }
        
    });
}
- (void)receiveNeedRefreshNotification:(NSNotification *)status {
    __weak typeof(&*self) __blockSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (__blockSelf.displayConversationTypeArray.count == 1 &&
            [__blockSelf.displayConversationTypeArray[0] integerValue] == ConversationType_DISCUSSION) {
            [__blockSelf refreshConversationTableViewIfNeeded];
        }
        
    });
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
