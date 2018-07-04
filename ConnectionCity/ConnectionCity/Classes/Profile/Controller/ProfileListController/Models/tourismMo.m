//
//  tourismMo.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/4.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "tourismMo.h"

@implementation tourismMo
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"Id":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"user":[privateUserInfoModel class]};
}

@end
