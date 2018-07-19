//
//  ServiceListMo.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/19.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ServiceListMo.h"

@implementation ServiceListMo

@end

@implementation commentList
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"user":[UserMo class]};
}
@end
