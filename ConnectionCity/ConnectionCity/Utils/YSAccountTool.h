//
//  YSAccountTool.h
//  dumbbell
//
//  Created by JYS on 17/3/5.
//  Copyright © 2017年 insaiapp. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YSAccount;
@class privateUserInfoModel;
@class OccupationCategoryNameModel;

@interface YSAccountTool : NSObject
/** 取出当前账号 */
+ (YSAccount *)account;
/** 保存账号 */
+ (void)saveAccount:(YSAccount *)account;
/** 删除账号 */
+ (void)deleteAccount;

/** 取出当前用户信息 */
+ (privateUserInfoModel *)userInfo;
/** 保存用户信息 */
+ (void)saveUserinfo:(privateUserInfoModel *)userInfo;
/** 删除用户信息 */
+ (void)deleteUserinfo;
@end
