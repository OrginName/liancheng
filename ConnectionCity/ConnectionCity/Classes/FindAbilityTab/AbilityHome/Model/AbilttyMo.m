//
//  AbilttyMo.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/22.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AbilttyMo.h"
@implementation AbilttyMo
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"user":[UserMo class]};
}
@end
@implementation AbilttyEducationMo

@end
@implementation AbilttyWorkMo

@end
