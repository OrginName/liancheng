//
//  AddressBookController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AddressBookController.h"

@interface AddressBookController ()
@property(nonatomic, strong) RCConversationModel *tempModel;
@property(nonatomic, assign) NSUInteger index;

@property(nonatomic, assign) BOOL isClick;
- (void)updateBadgeValueForTabBarItem;
@property(nonatomic) BOOL isLoading;
@end

@implementation AddressBookController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
//更多按钮创建
-(void)more{
    [YTAlertUtil showTempInfo:@"更多"];
}
-(void)setUI{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(more) image:@"our-more" title:nil EdgeInsets:UIEdgeInsetsZero];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //设置tableView样式
    self.conversationListTableView.separatorColor = [UIColor hexColorWithString:@"dfdfdf"];
    self.conversationListTableView.tableFooterView = [UIView new];
    
    // 设置在NavigatorBar中显示连接中的提示
    self.showConnectingStatusOnNavigatorBar = YES;
    //定位未读数会话
    self.index = 0;
    //接收定位到未读数会话的通知
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
@end
