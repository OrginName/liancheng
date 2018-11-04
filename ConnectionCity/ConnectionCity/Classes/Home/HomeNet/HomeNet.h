//
//  HomeNet.h
//  ConnectionCity
//
//  Created by qt on 2018/11/4.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  类型自定义
 */
typedef void (^SuccessArrBlock) (NSMutableArray * successArrValue);
typedef void (^SuccessDicBlock) (NSDictionary * successDicValue);
typedef void (^FailDicBlock) (NSString * failValue);
@interface HomeNet : NSObject
//获取所有的菜单按钮
+(void)loadAllMeu:(SuccessArrBlock)sucBlock;
//获取我所有的频道
+(void)loadMyMeu:(SuccessArrBlock)sucBlock;
//更改频道顺序
+(void)loadUpdateMyMeu:(NSDictionary *)param withSuc:(SuccessArrBlock)sucBlock;
@end
