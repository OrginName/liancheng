//
//  myServiceMo.m
//  ConnectionCity
//
//  Created by qt on 2018/7/15.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "myServiceMo.h"

@implementation myServiceMo
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"obj":[myServiceObj class],@"reserveUser":[UserMo class]};
}
@end
@implementation myServiceObj
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"user":[UserMo class],@"serviceCategoryName":[ServiceCategoryNameModel class]};
}
@end

