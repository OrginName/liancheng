//
//  AbilityNet.h
//  ConnectionCity
//
//  Created by qt on 2018/6/12.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbilttyMo.h"
/**
 *  类型自定义
 */
typedef void (^SuccessArrBlock) (NSMutableArray * successArrValue);
typedef void (^SuccessDicBlock) (NSDictionary * successDicValue);
typedef void (^FailDicBlock) (NSString * failValue);
typedef void (^SuccessAbiltty) (AbilttyMo * user);
@interface AbilityNet : NSObject

/**
 找人才关键字

 @param block 成功返回
 */
+(void)requstAbilityKeyWords:(SuccessArrBlock)block;
/**
 找人才热门
 
 @param block 成功返回
 */
+(void)requstAbilityHot:(SuccessArrBlock)block;
/**
 行业分类
 
 @param block 成功返回
 */
+(void)requstAbilityClass:(SuccessArrBlock)block;
/**
 行业筛选
 
 @param block 成功返回
 */
+(void)requstAbilityConditions:(SuccessArrBlock)block;
/**
 赚外快 - 行业类型
 
 @param block 成功返回
 */
+(void)requstMakeMoneyClass:(SuccessArrBlock)block;
/**
 简历-附近列表

 @param param 字典
 @param block 成功数组
 */
+(void)requstAbilityConditions:(NSDictionary *)param withBlock:(SuccessArrBlock)block;
/**
 新增简历
 
 @param param 字典
 @param block 成功数组
 */
+(void)requstAddResume:(NSDictionary *)param withBlock:(SuccessDicBlock)block;
/**
新增工作经历
 
 @param param 字典
 @param block 成功数组
 */
+(void)requstAddWord:(NSDictionary *)param withBlock:(SuccessDicBlock)block;
/**
 新增教育经历
 
 @param param 字典
 @param block 成功数组
 */
+(void)requstAddEdu:(NSDictionary *)param withBlock:(SuccessDicBlock)block;

/**
 简历详情

 @param param param description
 @param block block description
 */
+(void)requstResumeDetail:(NSDictionary *)param withBlock:(SuccessAbiltty)block;
@end
