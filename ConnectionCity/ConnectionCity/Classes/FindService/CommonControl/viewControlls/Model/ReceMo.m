//
//  ReceMo.m
//  ConnectionCity
//
//  Created by qt on 2018/12/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ReceMo.h"

@implementation ReceMo

@end

@implementation ActivityMo
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
@end

@implementation HotServiceMo
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"user":[UserMo class]};
}
@end

@implementation NearByMo
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
@end

@implementation TTMo
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
@end
