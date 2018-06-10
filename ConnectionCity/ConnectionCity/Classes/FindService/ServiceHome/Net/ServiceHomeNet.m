//
//  ServiceHomeNet.m
//  ConnectionCity
//
//  Created by qt on 2018/6/10.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ServiceHomeNet.h"
//#import "YSNetworkTool.h"
@implementation ServiceHomeNet
+(void)requstConditions:(SuccessDicBlock) sucBloc withFailBlock:(FailDicBlock)failBlock{
    [YSNetworkTool POST:v1ServiceConditions params:@{} progress:^(NSProgress *progress) {
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary * dic = responseObject[@"data"];
        NSArray * arr = @[@"age",@"distance",@"gender",@"validType"];
        NSMutableArray * dataArr= [NSMutableArray array];
        for (int i=0; i<arr.count; i++) {
            NSMutableDictionary * dicItem = [NSMutableDictionary dictionary];
            for (int j=0; j<[dic[arr[i]] count]; j++) {
                NSDictionary * dic = @{@"isSelected":@"YES",@"title":dic[arr[i]][j]};
                dicItem[@"subname"] = [NSArray arrayWithObject: dic];
                dicItem[@"name"] = i==0?@"":i==1?@"":i==2?@"":i==3?@"":@"";
            }
            [dataArr addObject:dicItem];
        }
        sucBloc(dic);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}
@end
