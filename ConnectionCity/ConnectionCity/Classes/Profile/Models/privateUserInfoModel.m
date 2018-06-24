//
//  privateUserInfoModel.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/22.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "privateUserInfoModel.h"

@implementation privateUserInfoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"modelId":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"occupationCategoryName":[OccupationCategoryNameModel class]};
}

@end
