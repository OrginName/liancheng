//
//  YTSideMenuModel.m
//  JLTimeRent
//
//  Created by chips on 17/6/26.
//  Copyright © 2017年 YOU-TURN TECHNOLOGY CO.,LTD. All rights reserved.
//

#import "YTSideMenuModel.h"

@implementation YTSideMenuModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        _mIcon = dictionary[@"icon"];
        _mTitle = dictionary[@"title"];
        _mClass = dictionary[@"class"];
    }
    return self;
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc]initWithDictionary:dictionary];
}

@end
