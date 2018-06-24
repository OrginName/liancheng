//
//  YSAccountTool.m
//  dumbbell
//
//  Created by JYS on 17/3/5.
//  Copyright © 2017年 insaiapp. All rights reserved.
//

#import "YSAccountTool.h"
#import "YSAccount.h"
#import "privateUserInfoModel.h"
#import "OccupationCategoryNameModel.h"
//#import "YSLoginController.h"
//#import "BaseTabBarController.h"
//#import "UserMo.h"
#define YSAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]
#define YSUserinfoFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfo.data"]

@implementation YSAccountTool
+ (YSAccount *)account {
    //取出账号
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:YSAccountFile]) {
        return [NSKeyedUnarchiver unarchiveObjectWithFile:YSAccountFile];
    }
    return nil;
}
+ (void)saveAccount:(YSAccount *)account {
    //保存账号
    [NSKeyedArchiver archiveRootObject:account toFile:YSAccountFile];
}
+ (void)deleteAccount {
    //删除账号
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:YSAccountFile]) {
        [fileManager removeItemAtPath:YSAccountFile error:nil];
    }
}


/** 取出当前用户信息 */
+ (privateUserInfoModel *)userInfo {
    //取出当前用户信息
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:YSUserinfoFile]) {
        return [NSKeyedUnarchiver unarchiveObjectWithFile:YSUserinfoFile];
    }
    return nil;
}
/** 保存用户信息 */
+ (void)saveUserinfo:(privateUserInfoModel *)userInfo {
    //保存用户信息
    [NSKeyedArchiver archiveRootObject:userInfo toFile:YSUserinfoFile];
}
/** 删除用户信息 */
+ (void)deleteUserinfo {
    //删除用户信息
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:YSUserinfoFile]) {
        [fileManager removeItemAtPath:YSUserinfoFile error:nil];
    }
}

@end
