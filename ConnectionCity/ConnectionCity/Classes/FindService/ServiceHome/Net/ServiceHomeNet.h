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
 */
+(void)requstServiceList:(NSDictionary *) param withSuc:(SuccessArrBlock)sucBlock;
/**
 服务分类列表
 
 @param sucBlock 成功回调
 */
+(void)requstServiceClass:(SuccessArrBlock)sucBlock;
/**
 服务分类属性
 
 @param sucBlock 成功回调
 */
+(void)requstServiceClassAttrParam:(NSDictionary *)param succblick:(SuccessArrBlock)sucBlock;
/**
 服务关键字
 
 @param sucBlock 成功回调
 */
+(void)requstServiceKeywords:(SuccessArrBlock)sucBlock;
/**
 旅行旅游列表
 
 @param sucBlock 成功回调
 */
+(void)requstTrvalInvitDic:(NSDictionary *) param withSuc:(SuccessArrBlock)sucBlock;
/**
 旅行旅游列表
 
 @param sucBlock 成功回调
 */
+(void)requstTrvalDic:(NSDictionary *) param withSuc:(SuccessArrBlock)sucBlock;

/**
 旅行旅游添加浏览次数
 
 @param sucBlock 成功回调
 */
+(void)requstLiulanNum:(NSDictionary *) param flag:(int)flag withSuc:(SuccessArrBlock)sucBlock;


@end
