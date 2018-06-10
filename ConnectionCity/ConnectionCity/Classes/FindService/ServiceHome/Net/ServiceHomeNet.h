//
//  ServiceHomeNet.h
//  ConnectionCity
//
//  Created by qt on 2018/6/10.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  类型自定义
 */
typedef void (^SuccessArrBlock) (NSMutableArray * successArrValue);
typedef void (^SuccessDicBlock) (NSDictionary * successDicValue);
typedef void (^FailDicBlock) (NSString * failValue);
@interface ServiceHomeNet : NSObject

/**
 筛选条件

 @param sucBloc 成功回调
 @param failBlock 失败回调
 */
+(void)requstConditions:(SuccessDicBlock) sucBloc withFailBlock:(FailDicBlock)failBlock;
@end
