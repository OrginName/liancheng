//
//  YSAccountTool.m
//  dumbbell
//
//  Created by JYS on 17/3/5.
//  Copyright © 2017年 insaiapp. All rights reserved.
//

#import "YSAccountTool.h"
#import "YSAccount.h"
#import "YSLoginController.h"
#import "BaseTabBarController.h"
#import "UserMo.h"
#define YSAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

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
+ (void)saveUser:(UserMo *)user {
    //保存账号
    [NSKeyedArchiver archiveRootObject:user toFile:YSAccountFile];
}
+ (void)deleteAccount {
    //删除账号
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:YSAccountFile]) {
        [fileManager removeItemAtPath:YSAccountFile error:nil];
    }
}

@end
