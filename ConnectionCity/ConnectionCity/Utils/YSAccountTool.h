//
//  YSAccountTool.h
//  dumbbell
//
//  Created by JYS on 17/3/5.
//  Copyright © 2017年 insaiapp. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YSAccount;

@interface YSAccountTool : NSObject
/** 取出当前账号 */
+ (YSAccount *)account;
/** 保存账号 */
+ (void)saveAccount:(YSAccount *)account;
/** 删除账号 */
+ (void)deleteAccount;

@end
