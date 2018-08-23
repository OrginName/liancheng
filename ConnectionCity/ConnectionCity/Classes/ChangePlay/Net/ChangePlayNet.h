//
//  ChangePlayNet.h
//  ConnectionCity
//
//  Created by qt on 2018/8/11.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  类型自定义
 */
typedef void (^SuccessArrBlock) (NSMutableArray * successArrValue);
typedef void (^SuccessDicBlock) (NSDictionary * successDicValue);
typedef void (^FailBlock) (NSError * failValue);
@interface ChangePlayNet : NSObject
/**
 宝物分类列表
 
 @param sucBlock 成功回调
 */
+(void)requstBWClass:(SuccessArrBlock)sucBlock;
/**
 发布宝物
 
 @param sucBlock 成功回调
 */
+(void)requstSendBWClass:(NSDictionary *)param sucBlock:(SuccessDicBlock)sucBlock failBlock:(FailBlock)failBlock;
/**
 宝物列表
 
 @param sucBlock 成功回调
 */
+(void)requstBWList:(NSDictionary *)param sucBlock:(SuccessArrBlock)sucBlock failBlock:(FailBlock)failBlock;
/**
 发布互换信息
 
 @param sucBlock 成功回调
 */
+(void)requstSendHH:(NSDictionary *)param sucBlock:(SuccessDicBlock)sucBlock failBlock:(FailBlock)failBlock;
/**
 身份互换信息列表
 
 @param sucBlock 成功回调
 */
+(void)requstHHList:(NSDictionary *)param sucBlock:(SuccessArrBlock)sucBlock failBlock:(FailBlock)failBlock;
@end
