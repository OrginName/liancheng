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

/**
 申请加入群

 @param param 字典
 @param flag 类型判断
 @param sucBlock 成功回调
 @param failBlock 失败回调
 */
+(void)requstJoinQun:(NSDictionary *) param withFlag:(int)flag withSuc:(SuccessDicBlock)sucBlock withFailBlock:(FailErrBlock)failBlock;

/**
 同意加入群
 
 @param param 字典
 @param flag 类型判断
 @param sucBlock 成功回调
 @param failBlock 失败回调
 */
+(void)requstAgreeJoinQun:(NSDictionary *) param withFlag:(int)flag withSuc:(SuccessDicBlock)sucBlock withFailBlock:(FailErrBlock)failBlock;



/**
 公告接口

 @param param 字典
 @param sucBlok 成功返回
 */
+(void)requstNotice:(NSDictionary *)param withSuc:(SuccessDicBlock)sucBlok;
/**
 更新用户配置接口
 
 @param param 字典
 @param sucBlok 成功返回
 */
+(void)requstUserPZ:(NSDictionary *)param withSuc:(SuccessDicBlock)sucBlok;
@end
