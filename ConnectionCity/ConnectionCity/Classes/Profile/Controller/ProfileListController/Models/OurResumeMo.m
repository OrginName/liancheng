//
//  OurResumeMo.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/24.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "OurResumeMo.h"
#import "privateUserInfoModel.h"
#import "WorkExperienceListModel.h"
#import "educationExperienceListModel.h"

@implementation OurResumeMo
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"modelId":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"user":[privateUserInfoModel class],@"workExperienceList":[WorkExperienceListModel class],@"educationExperienceList":[educationExperienceListModel class]};
}

@end
