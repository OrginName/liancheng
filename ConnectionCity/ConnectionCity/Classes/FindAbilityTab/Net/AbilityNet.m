//
//  AbilityNet.m
//  ConnectionCity
//
//  Created by qt on 2018/6/12.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AbilityNet.h"
#import "ClassifyMo.h"
@implementation AbilityNet
+(void)requstAbilityKeyWords:(SuccessArrBlock)block{
    [YSNetworkTool POST:keywordTalentKeyword params:@{} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray * arr = [NSMutableArray array];
        for (int i=0; i<[responseObject[@"data"] count]; i++){
            [arr addObject:responseObject[@"data"][i][@"name"]];
        }
        block(arr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
+(void)requstAbilityClass:(SuccessArrBlock)block{
    [YSNetworkTool POST:dictionaryOccupationCategory params:@{} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray * arr = [NSMutableArray array];
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            for (int i=0; i<[responseObject[@"data"] count]; i++) {
                ClassifyMo * mo = [ClassifyMo mj_objectWithKeyValues:responseObject[@"data"][i]];
                mo.ID = responseObject[@"data"][i][@"id"];
                [arr addObject:mo];
            }
        }
        block(arr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end
