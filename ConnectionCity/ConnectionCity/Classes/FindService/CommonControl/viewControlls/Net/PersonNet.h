//
//  PersonNet.h
//  ConnectionCity
//
//  Created by umbrella on 2018/11/16.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *  类型自定义
 */
typedef void (^SuccessArrBlock) (NSMutableArray * successArrValue);
typedef void (^SuccessDicBlock) (NSDictionary * successDicValue);
typedef void (^FailDicBlock) (NSString * failValue);
@interface PersonNet : NSObject


/**
 获取用户动态接口

 @param dic dic
 @param block dic
 */
+(void)requstPersonDT:(NSDictionary *)dic withDic:(SuccessDicBlock)block;
/**
 获取用户旅行接口
 
 @param dic dic
 @param block dic
 */
+(void)requstPersonYL:(NSDictionary *)dic withArr:(SuccessArrBlock)block;
/**
 获取用户娱乐接口
 
 @param dic dic
 @param block dic
 */
+(void)requstPersonYL1:(NSDictionary *)dic withArr:(SuccessArrBlock)block;

@end

NS_ASSUME_NONNULL_END
