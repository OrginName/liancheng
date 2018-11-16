//
//  PersonNet.m
//  ConnectionCity
//
//  Created by umbrella on 2018/11/16.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "PersonNet.h"
#import "trvalMo.h"
#import "YLMo.h"
@implementation PersonNet
/**
 获取用户动态接口
 
 @param dic dic
 @param block dic
 */
+(void)requstPersonDT:(NSDictionary *)dic withDic:(SuccessDicBlock)block{
    [YSNetworkTool POST:v1UserCircleGet params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        block(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
/**
 获取用户娱乐接口
 
 @param dic dic
 @param block dic
 */
+(void)requstPersonYL:(NSDictionary *)dic withArr:(SuccessArrBlock)block{
    [YSNetworkTool POST:v1UserCircleServiceTravelPage params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray * arr = [NSMutableArray array];
        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            for (int i=0; i<[responseObject[@"data"][@"content"] count]; i++) {
                trvalMo * trval = [trvalMo mj_objectWithKeyValues:responseObject[@"data"][@"content"][i]];
                //                trval.comments = [comments mj_objectArrayWithKeyValuesArray:trval.comments];
                [arr addObject:trval];
            }
        }
        block(arr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
/**
 获取用户娱乐接口
 
 @param dic dic
 @param block dic
 */
+(void)requstPersonYL1:(NSDictionary *)dic withArr:(SuccessArrBlock)block{
    [YSNetworkTool POST:v1UserCircleServiceYulePage params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray * arr = [YLMo mj_objectArrayWithKeyValuesArray:responseObject[kData][@"content"]];
        block([arr mutableCopy]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end
