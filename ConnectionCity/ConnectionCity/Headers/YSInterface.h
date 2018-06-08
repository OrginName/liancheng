//
//  YSInterface.h
//  dumbbell
//
//  Created by JYS on 16/3/10.
//  Copyright © 2016年 insaiapp. All rights reserved.
//

#ifndef YSInterface_h
#define YSInterface_h


//主机地址
//#define HOSTURL @"https://api.lc.test.cn-apps.com:8080"
#define HOSTURL @"http://210.16.185.211:8080"


#pragma mark - 登录、注册、短信验证
//短信验证
static NSString * const smsVerificationCode = @"/sms/verification-code";
//注册
static NSString * const registerUrl = @"/register";
//登录
static NSString * const login = @"/login";
#pragma mark - 用户接口
//修改密码
static NSString * const v1PrivateUserChangePassword = @"/v1/private/user/change-password";
//获取用户信息
static NSString * const v1PrivateUserInfo = @"/v1/private/user/info";
//附近的人
static NSString * const v1PrivateUserNearbyList = @"/v1/private/user/nearby/list";
//用户更新
static NSString * const v1PrivateUserUpdate = @"/v1/private/user/update";
#pragma mark - 用户-关注
//添加关注
static NSString * const v1UserFollowAdd = @"/v1/user/follow/add";
//取消关注
static NSString * const v1UserFollowCancel = @"/v1/user/follow/cancel";
//关注列表（分页）
static NSString * const v1UserFollowPage = @"/v1/user/follow/page";
#pragma mark - 人才-人脉
//添加好友
static NSString * const v1TalentConnectionAdd = @"/v1/talent/connection/add";
//人脉-同乡好友列表（分页）
static NSString * const v1TalentConnectionCityPage = @"/v1/talent/connection/city/page";
//人脉-校友好友列表（分页）
static NSString * const v1TalentConnectionEducationPage = @"/v1/talent/connection/education/page";
//人脉-同行好友列表（分页）
static NSString * const v1TalentConnectionOccupationPage = @"/v1/talent/connection/occupation/page";


#pragma mark - 人才-简历

#pragma mark - 人才-赚外快

#pragma mark - 关键字信息

#pragma mark - 数据字典

#pragma mark - 服务

#pragma mark - 服务-旅游

#pragma mark - 服务-服务站





#endif /* YSInterface_h */




