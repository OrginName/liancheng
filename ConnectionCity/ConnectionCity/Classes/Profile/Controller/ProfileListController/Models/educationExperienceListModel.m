//
//  educationExperienceListModel.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/24.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "educationExperienceListModel.h"

@implementation educationExperienceListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"description1":@"description",@"ID":@"id"};
}
@end
