//
//  YLMo.m
//  ConnectionCity
//
//  Created by qt on 2018/11/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "YLMo.h"
@implementation YLMo
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"user":[UserMo class]};
}
@end
