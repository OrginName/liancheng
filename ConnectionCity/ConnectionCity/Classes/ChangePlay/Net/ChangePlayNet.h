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
typedef void (^FailDicBlock) (NSString * failValue);
@interface ChangePlayNet : NSObject
/**
 服务分类列表
 
 @param sucBlock 成功回调
 */
+(void)requstBWClass:(SuccessArrBlock)sucBlock;
@end
