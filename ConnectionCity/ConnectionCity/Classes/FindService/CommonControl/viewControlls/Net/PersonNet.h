//
//  PersonNet.h
//  ConnectionCity
//
//  Created by umbrella on 2018/11/16.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReceMo.h"
//NS_ASSUME_NONNULL_BEGIN
/**
 *  类型自定义
 */
typedef void (^SuccessArrBlock) (NSMutableArray *  successArrValue);
typedef void (^SuccessDicBlock) (NSDictionary *  successDicValue);
typedef void (^FailDicBlock) (NSError * failValue);
typedef void (^ReceMoBlock)(ReceMo * mo);
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
/**
 获取首页广告接口 
 @param block 返回内容
 */
+(void)requstTJGGArr:(SuccessArrBlock)block FailDicBlock:(FailDicBlock)fail;
/**
 获取首页同城列表
 @param block 返回内容
 */
+(void)requstTJArr:(NSDictionary *)dic withArr:(ReceMoBlock)block FailDicBlock:(FailDicBlock)fail;

/**
 关注和取消关注
 @param block 返回内容
 */
+(void)requstGZ:(NSDictionary *)dic withArr:(SuccessDicBlock)block FailDicBlock:(FailDicBlock)fail;

/**
 练成头条接口
 @param block 返回内容
 */
+(void)requstGZArr:(SuccessArrBlock)block FailDicBlock:(FailDicBlock)fail;
/**
 新增紧急联系人
 @param block 返回内容
 */
+(void)requstAddContact:(NSDictionary *)dic withDic:(SuccessDicBlock)block FailDicBlock:(FailDicBlock)fail;
/**
 删除紧急联系人
 @param block 返回内容
 */
+(void)requstDeleContact:(NSDictionary *)dic withDic:(SuccessDicBlock)block FailDicBlock:(FailDicBlock)fail;
/**
 紧急联系人列表
 @param block 返回内容
 */
+(void)requstContactList:(NSDictionary *)dic withDic:(SuccessArrBlock)block FailDicBlock:(FailDicBlock)fail;
/**
 一键报警
 @param block 返回内容
 */
+(void)requstContactSMS:(NSDictionary *)dic withDic:(SuccessDicBlock)block FailDicBlock:(FailDicBlock)fail;
/**
 修改紧急联系人
 @param block 返回内容
 */
+(void)requstUpdateContact:(NSDictionary *)dic withDic:(SuccessDicBlock)block FailDicBlock:(FailDicBlock)fail;

/**
 修改紧急联系人
 @param block 返回内容
 */
//+(void)requstUpdateContact:(NSDictionary *)dic withDic:(SuccessDicBlock)block FailDicBlock:(FailDicBlock)fail;

@end

//NS_ASSUME_NONNULL_END

