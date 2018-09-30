//
//  trvalMo.m
//  ConnectionCity
//
//  Created by qt on 2018/6/16.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "trvalMo.h"

@implementation trvalMo
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id",@"description1":@"description"};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"user":[UserMo class],@"userVO":[UserMo class],@"comments":[comments class]};
}
@end

@implementation comments
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"user":[UserMo class]};
}
@end
