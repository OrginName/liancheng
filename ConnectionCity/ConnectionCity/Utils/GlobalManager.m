//
//  GlobalManager.m
//  dumbbell
//
//  Created by JYS on 16/4/2.
//  Copyright © 2016年 insaiapp. All rights reserved.
//

#import "GlobalManager.h"

@implementation GlobalManager
+ (GlobalManager *)globalManagerShare {
    static GlobalManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[GlobalManager alloc]init];
    });
    return manager;
}
- (BOOL)isOrNoLogin {
    if (kAccount) {
        //登陆过
        return YES;
    }else{
        //未登录
        return NO;
    }
}
@end
