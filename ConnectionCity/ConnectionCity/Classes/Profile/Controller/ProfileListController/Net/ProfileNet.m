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
+(void)requstMyService:(NSDictionary *)param ZT:(NSInteger)ZT flag:(NSInteger)flag block:(SuccessArrBlock) sucBloc withFailBlock:(FailErrorBlock)failBlock{
    NSString * url = @"";
    if (ZT==2) {
        url = flag==1?v1MyServiceOrderPublishedPage:v1MySerivceOrderRequiredPage;
    }else
        url = flag==1?v1MyTravelOrderPublishedPage:v1MyTravelOrderRequiredPage;
    NSMutableArray * arr1 = [NSMutableArray array];
    [YSNetworkTool POST:url params:param showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray * arr = responseObject[@"data"][@"content"];
        for (int i=0; i<arr.count; i++) {
            myServiceMo * service = [myServiceMo mj_objectWithKeyValues:arr[i]];
            service.obj.commentList = [ObjComment mj_objectArrayWithKeyValuesArray:service.obj.commentList];
            service.obj.comments = [ObjComment mj_objectArrayWithKeyValuesArray:service.obj.comments];
            [arr1 addObject:service];
        }
        sucBloc(arr1);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failBlock(error);
    }];
}
//服务状态更新
+(void)requstUpdateService:(NSDictionary *)param flag:(NSInteger)flag block:(SuccessDicBlock) sucBloc withFailBlock:(FailErrorBlock)failBlock{
    NSString * url = flag==2?v1ServiceUpdateOrderStatus:v1ServiceTravelUpdateOrderStatus;
    [YSNetworkTool POST:url params:param showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        sucBloc(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
//
@end
