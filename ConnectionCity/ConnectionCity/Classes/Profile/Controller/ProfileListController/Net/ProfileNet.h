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
@interface ProfileNet : NSObject
//发布的服务接口
+(void)requstMyService:(NSDictionary *)param flag:(NSInteger)flag block:(SuccessArrBlock) sucBloc withFailBlock:(FailDicBlock)failBlock;

@end
