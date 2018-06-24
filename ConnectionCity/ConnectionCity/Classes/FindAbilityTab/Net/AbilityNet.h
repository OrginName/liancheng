//
//  AbilityNet.h
//  ConnectionCity
//
//  Created by qt on 2018/6/12.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  类型自定义
 */
typedef void (^SuccessArrBlock) (NSMutableArray * successArrValue);
typedef void (^SuccessDicBlock) (NSDictionary * successDicValue);
typedef void (^FailDicBlock) (NSString * failValue);
@interface AbilityNet : NSObject

/**
 找人才关键字

 @param block 成功返回
 */
+(void)requstAbilityKeyWords:(SuccessArrBlock)block;
/**
 职业分类
 
 @param block 成功返回
 */
+(void)requstAbilityClass:(SuccessArrBlock)block;
/**
 职业筛选
 
 @param block 成功返回
 */
+(void)requstAbilityConditions:(SuccessArrBlock)block;


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
@end
