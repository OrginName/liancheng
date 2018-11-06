//
//  HomeNet.m
//  ConnectionCity
//
//  Created by qt on 2018/11/4.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "HomeNet.h"
#import "MenuMo.h"
#import "YLMo.h"
@implementation HomeNet
//获取所有的菜单按钮
+(void)loadAllMeu:(SuccessArrBlock)sucBlock{
    [YSNetworkTool POST:v1MyChannelAll params:@{} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray * arr = [MenuMo mj_objectArrayWithKeyValuesArray:responseObject[kData]];
        sucBlock([arr mutableCopy]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
//获取我所有的频道
+(void)loadMyMeu:(SuccessArrBlock)sucBlock{
    [YSNetworkTool POST:v1MyChannelGet params:@{} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray * arr = [MenuMo mj_objectArrayWithKeyValuesArray:responseObject[kData]];
        sucBlock([arr mutableCopy]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
//更改频道顺序
+(void)loadUpdateMyMeu:(NSDictionary *)param withSuc:(SuccessDicBlock)sucBlock{
    [YSNetworkTool POST:v1MyChannelUpdate params:param showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        sucBlock(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
//获取娱乐list
+(void)loadYLList:(NSDictionary *)param withSuc:(SuccessArrBlock)sucBlock{
    [YSNetworkTool POST:v1ServiceYulePage params:param showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray * arr = [YLMo mj_objectArrayWithKeyValuesArray:responseObject[kData][@"content"]];
        sucBlock([arr mutableCopy]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end
