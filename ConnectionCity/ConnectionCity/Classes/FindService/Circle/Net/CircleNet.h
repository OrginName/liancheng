//
//  CircleNet.h
//  ConnectionCity
//
//  Created by qt on 2018/6/27.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  类型自定义
 */
typedef void (^SuccessArrBlock) (NSMutableArray * successArrValue);
typedef void (^SuccessDicBlock) (NSDictionary * successDicValue);
typedef void (^FailErrBlock) (NSError * failValue);

@interface CircleNet : NSObject
/**
 旅行旅游列表
 
 @param sucBlock 成功回调
 */
+(void)requstCirclelDic:(NSDictionary *) param flag:(NSString *)flag withSuc:(SuccessArrBlock)sucBlock FailErrBlock:(FailErrBlock)failErrBlock;
/**
 首页朋友圈我的
 
 @param sucBlock 成功回调
 */
+(void)requstHomeCirclelDic:(NSDictionary *) param withSuc:(SuccessArrBlock)sucBlock FailErrBlock:(FailErrBlock)failErrBlock;
/**
 评论发送列表
 
 @param sucBlock 成功回调
 */
+(void)requstSendPL:(NSDictionary *) param withSuc:(SuccessDicBlock)sucBlock;
/**
 评论发送列表
 @param sucBlock 成功回调
 */
+(void)requstCircleDetail:(NSDictionary *) param withSuc:(SuccessArrBlock)sucBlock;
/**
 点赞接口
 @param sucBlock 成功回调
 */
+(void)requstCircleDZ:(NSDictionary *) param withSuc:(SuccessDicBlock)sucBlock;

@end
