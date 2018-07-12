//
//  ProfileNet.m
//  ConnectionCity
//
//  Created by qt on 2018/7/12.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ProfileNet.h"

@implementation ProfileNet
//发布的服务接口
+(void)requstMyService:(NSDictionary *)param flag:(NSInteger)flag block:(SuccessArrBlock) sucBloc withFailBlock:(FailDicBlock)failBlock{
    NSString * url = flag==1?v1MyServiceOrderPublishedPage:v1MySerivceOrderRequiredPage;
    [YSNetworkTool POST:url params:param showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end
