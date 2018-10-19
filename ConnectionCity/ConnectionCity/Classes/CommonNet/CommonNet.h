//
//  CommonNet.h
//  ConnectionCity
//
//  Created by umbrella on 2018/10/10.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  类型自定义
 */
typedef void (^SuccessArrBlock) (NSMutableArray * successArrValue);
typedef void (^SuccessDicBlock) (NSDictionary * successDicValue);
typedef void (^FailDicBlock) (NSString * failValue);
@interface CommonNet : NSObject
/**
 检查版本更新
 */
+(void)CheckVersion:(BOOL)flag;
@end
