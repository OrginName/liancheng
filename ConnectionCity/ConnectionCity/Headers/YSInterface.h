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

//0、短信验证
static NSString * const smsVerificationCode = @"/sms/verification-code";
//1、注册
static NSString * const registerUrl = @"/register";
//2、登录
static NSString * const login = @"/login";
//3、修改密码
static NSString * const v1PrivateUserChangePassword = @"/v1/private/user/change-password";
//4、获取用户信息
static NSString * const v1PrivateUserInfo = @"/v1/private/user/info";
//5、附近的人
static NSString * const v1PrivateUserNearbyList = @"/v1/private/user/nearby/list";
//6、update
static NSString * const v1PrivateUserUpdate = @"/v1/private/user/update";
//7、添加关注
static NSString * const v1UserFollowAdd = @"/v1/user/follow/add";
//8、取消关注
static NSString * const v1UserFollowCancel = @"/v1/user/follow/cancel";
//9、关注列表（分页）
static NSString * const v1UserFollowPage = @"/v1/user/follow/page";
//10、
//11、
//12、
//13、
//14、
//15、
//16、
//17、
//18、
//19、
//20、
//21、
//22、
//23、
//24、
//25、


#endif /* YSInterface_h */




