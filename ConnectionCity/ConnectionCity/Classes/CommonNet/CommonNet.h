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
 
 @param sucBloc 成功回调
 @param failBlock 失败回调
 */
+(void)CheckVersion;
@end
