//
//  MemberRenewalM.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/23.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "MemberRenewalM.h"

@implementation MemberRenewalM
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"modelId":@"id",@"modelDescription":@"description"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"membershipMeals":[MembershipMealModel class]};
}

@end
