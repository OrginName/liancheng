//
//  CustomLocatiom.h
//  ConnectionCity
//
//  Created by qt on 2018/5/9.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>
@protocol CustomLocationDelegate <NSObject>
@optional
/// 定位中
- (void)locating;
@optional
/**
 当前位置
 
 @param locationDictionary 位置信息字典
 */
- (void)currentLocation:(NSDictionary *)locationDictionary location:(CLLocation*)location;

/**
 拒绝定位后回调的代理
 
 @param message 提示信息
 */
@optional
- (void)refuseToUsePositioningSystem:(NSString *)message;

/**
 定位失败回调的代理
 
 @param message 提示信息
 */
@optional
- (void)locateFailure:(NSString *)message;

@end

@interface CustomLocatiom : NSObject
@property (nonatomic, weak) id<CustomLocationDelegate> delegate;
- (void)startUpdatingLocation;
- (void)cleanUpAction;
@end
