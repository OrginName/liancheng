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
@end
