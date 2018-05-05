//
//  YSAccount.m
//  dumbbell
//
//  Created by JYS on 17/3/5.
//  Copyright © 2017年 insaiapp. All rights reserved.
//

#import "YSAccount.h"

@implementation YSAccount
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"accountID":@"id"};
}

MJCodingImplementation

@end
