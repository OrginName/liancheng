//
//  TravelInvite.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/4.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "TravelInvite.h"

@implementation TravelInvite
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"Id":@"id",@"descriptionS":@"description"};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"user":[privateUserInfoModel class]};
}

@end
