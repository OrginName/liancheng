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
+(void)requstConditions:(SuccessArrBlock) sucBloc withFailBlock:(FailDicBlock)failBlock;

/**
 服务首页列表

 @param csucBlock 成功回调
 @param failBlock 失败回调
 */
+(void)requstServiceList:(SuccessArrBlock)csucBlock withFailBlock:(FailDicBlock)failBlock;
/**
 服务分类列表
 
 @param sucBlock 成功回调
 */
+(void)requstServiceClass:(SuccessArrBlock)sucBlock;
/**
 服务关键字
 
 @param sucBlock 成功回调
 */
+(void)requstServiceKeywords:(SuccessArrBlock)sucBlock;
/**
 旅行邀约列表
 
 @param sucBlock 成功回调
 */
+(void)requstTrvalInvitDic:(NSDictionary *) param withSuc:(SuccessArrBlock)sucBlock;
@end
