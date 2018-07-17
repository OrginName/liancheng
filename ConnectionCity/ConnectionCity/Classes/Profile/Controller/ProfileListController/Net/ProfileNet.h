//
//  ProfileNet.h
//  ConnectionCity
//
//  Created by qt on 2018/7/12.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  类型自定义
 */
typedef void (^SuccessArrBlock) (NSMutableArray * successArrValue);
typedef void (^SuccessDicBlock) (NSDictionary * successDicValue);
typedef void (^FailDicBlock) (NSString * failValue);
typedef void (^FailErrorBlock) (NSError * error);
@interface ProfileNet : NSObject
//发布的服务接口
+(void)requstMyService:(NSDictionary *)param ZT:(NSInteger)ZT flag:(NSInteger)flag block:(SuccessArrBlock) sucBloc withFailBlock:(FailErrorBlock)failBlock;
//服务状态更新
+(void)requstUpdateService:(NSDictionary *)param flag:(NSInteger)flag block:(SuccessDicBlock) sucBloc withFailBlock:(FailErrorBlock)failBlock;
//v1ServiceUpdateOrderStatus
@end
