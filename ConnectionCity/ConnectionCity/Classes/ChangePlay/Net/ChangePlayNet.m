//
//  ChangePlayNet.m
//  ConnectionCity
//
//  Created by qt on 2018/8/11.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ChangePlayNet.h"
#import "ClassifyMo.h"
@implementation ChangePlayNet
/**
 服务分类列表
 
 @param sucBlock 成功回调
 */
+(void)requstBWClass:(SuccessArrBlock)sucBlock{
    [YSNetworkTool POST:dictionaryTreasureCategory params:@{} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray * arr = [NSMutableArray array];
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            for (int i=0; i<[responseObject[@"data"] count]; i++) {
                ClassifyMo * mo = [ClassifyMo mj_objectWithKeyValues:responseObject[@"data"][i]];
                mo.ID = responseObject[@"data"][i][@"id"];
                [arr addObject:mo];
            }
        }
        sucBlock(arr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
/**
 发布宝物
 
 @param sucBlock 成功回调
 */
+(void)requstSendBWClass:(NSDictionary *)param sucBlock:(SuccessArrBlock)sucBlock failBlock:(FailDicBlock)failBlock{
    [YSNetworkTool POST:v1PlayTreasureCreate params:param showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end
