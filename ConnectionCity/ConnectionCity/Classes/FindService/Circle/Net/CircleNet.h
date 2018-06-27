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
typedef void (^FailDicBlock) (NSString * failValue);

@interface CircleNet : NSObject
/**
 旅行旅游列表
 
 @param sucBlock 成功回调
 */
+(void)requstCirclelDic:(NSDictionary *) param withSuc:(SuccessArrBlock)sucBlock;

@end
