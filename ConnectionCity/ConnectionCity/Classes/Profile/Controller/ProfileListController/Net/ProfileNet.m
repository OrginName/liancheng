//
//  ProfileNet.m
//  ConnectionCity
//
//  Created by qt on 2018/7/12.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ProfileNet.h"
#import "myServiceMo.h"
@implementation ProfileNet
//发布的服务接口
+(void)requstMyService:(NSDictionary *)param flag:(NSInteger)flag block:(SuccessArrBlock) sucBloc withFailBlock:(FailErrorBlock)failBlock{
    NSString * url = flag==1?v1MyServiceOrderPublishedPage:v1MySerivceOrderRequiredPage;
    NSMutableArray * arr1 = [NSMutableArray array];
    [YSNetworkTool POST:url params:param showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray * arr = responseObject[@"data"][@"content"];
        for (int i=0; i<arr.count; i++) {
            myServiceMo * service = [myServiceMo mj_objectWithKeyValues:arr[i]];
            [arr1 addObject:service];
        }
        sucBloc(arr1);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failBlock(error);
    }];
}
//服务状态更新
+(void)requstUpdateService:(NSDictionary *)param block:(SuccessDicBlock) sucBloc withFailBlock:(FailErrorBlock)failBlock{
    [YSNetworkTool POST:v1ServiceUpdateOrderStatus params:param showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        sucBloc(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
//
@end
