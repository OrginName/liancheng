//
//  YSShareTool.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/13.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

@interface YSShareTool : NSObject
+(void)share;
+(void)share:(SSDKPlatformType)type;

@end
