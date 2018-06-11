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
+(void)requstConditions:(SuccessArrBlock) sucBloc withFailBlock:(FailDicBlock)failBlock{
    [YSNetworkTool POST:v1ServiceConditions params:@{} progress:^(NSProgress *progress) {
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary * dic = responseObject[@"data"];
        NSArray * arr = @[@"age",@"distance",@"gender",@"validType"];
        NSMutableArray * dataArr= [NSMutableArray array];
        for (int i=0; i<arr.count; i++) {
            NSMutableDictionary * dicItem = [NSMutableDictionary dictionary];
            NSMutableArray * arrItem = [NSMutableArray array];
            for (int j=0; j<[dic[arr[i]] count]; j++) {
                NSDictionary * dic1 = @{@"isSelected":j==0?@"YES":@"NO",@"title":dic[arr[i]][j][@"description"]};
                [arrItem addObject:dic1];
                if (arrItem.count==[dic[arr[i]] count]) {
                    [dicItem setObject:arrItem forKey:@"subname"];
                     dicItem[@"name"] = i==0?@"年龄":i==1?@"距离":i==2?@"性别":i==3?@"类型":@"";
                }
            }
            [dataArr addObject:dicItem];
        }
        sucBloc(dataArr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}
+(void)requstServiceList:(SuccessArrBlock)csucBlock withFailBlock:(FailDicBlock)failBlock{
    [YSNetworkTool POST:v1ServiceList params:@{} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end
