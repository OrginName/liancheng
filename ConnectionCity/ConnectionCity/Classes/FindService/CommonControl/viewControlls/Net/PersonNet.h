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
typedef void (^FailDicBlock) (NSError * failValue);
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

/**
 获取用户图文或视频接口


 @param dic 字典
 @param block 返回内容
 */
+(void)requstPersonVideo:(NSDictionary *)dic withArr:(SuccessArrBlock)block FailDicBlock:(FailDicBlock)fail;
/**
 获取生活接口
 
 
 @param dic 字典
 @param block 返回内容
 */
+(void)requstPersonSH:(NSDictionary *)dic withArr:(SuccessArrBlock)block FailDicBlock:(FailDicBlock)fail;

@end

NS_ASSUME_NONNULL_END
