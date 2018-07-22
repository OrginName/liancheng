//
//  RCDChatViewController.h
//  RCloudMessage
//
//  Created by Liv on 15/3/13.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "groupMo.h"
#import "UserMo.h"
#import "RCDUserInfo.h"
@interface RCDChatViewController : RCConversationViewController
@property (nonatomic,assign) int flagStr;
@property (nonatomic,strong) UserMo * user;
@property (nonatomic,strong) RCDUserInfo * userInfo;
@property(nonatomic, copy) NSString *groupName;
/**
 *  会话数据模型
 */
@property(strong, nonatomic) RCConversationModel *conversation;
@property (nonatomic,strong) groupMo * group1;
@property BOOL needPopToRootView;
- (UIView *)loadEmoticonView:(NSString *)identify index:(int)index;
@end
