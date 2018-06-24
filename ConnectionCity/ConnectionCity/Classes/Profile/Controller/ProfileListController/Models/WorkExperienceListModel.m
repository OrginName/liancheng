//
//  WorkExperienceListModel.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/24.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "WorkExperienceListModel.h"

@implementation WorkExperienceListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"modelId":@"id",@"descriptions":@"description"};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"occupationCategoryName":[OccupationCategoryNameModel class]};
}

@end
