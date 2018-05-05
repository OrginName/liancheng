//
//  YTSystemUtil.h
//  JLTimeRent
//
//  Created by chips on 17/6/23.
//  Copyright © 2017年 YOU-TURN TECHNOLOGY CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

FOUNDATION_EXPORT NSString * const YTSystemUtilOpenAppUserInfoTelKey;

/** app信息类型 */
typedef NS_ENUM(NSInteger, YTSystemUtilAppInfoType) {
    YTSystemUtilAppInfoTypeVersion,  //获取App版本号
    YTSystemUtilAppInfoTypeName,     //获取App显示名称
    YTSystemUtilAppInfoBundleIdentifile,   // 获取App Bundle ID
};

/** 当前iPhone屏幕尺寸 */
typedef NS_ENUM(NSInteger, YTSystemUtilScreenInch) {
    YTSystemUtilScreenInch4_0 = 0,  //4.0
    YTSystemUtilScreenInch4_7,  //4.7
    YTSystemUtilScreenInch5_5,  //5.5
    YTSystemUtilScreenInch5_8   //5.8
};

/** 打开系统App的类型 */
typedef NS_ENUM(NSInteger, YTSystemUtilOpenAppType) {
    YTSystemUtilOpenAppTypeSetting,       //设置 App
    YTSystemUtilOpenAppTypeAppStore,      //AppStore App
    YTSystemUtilOpenAppTypeAppStoreRank,  //AppStore评分 App
    YTSystemUtilOpenAppTypeTel            //拨打电话 App
};

/** 系统工具类 */
@interface YTSystemUtil : NSObject

/** 获取App信息 */
+ (NSString *)getAppInfoWithType:(YTSystemUtilAppInfoType)type;

/** 获取当前手机尺寸(4.0、4.7、5.5) */
+ (YTSystemUtilScreenInch)getIphoneInch;

/** 获取当前app缓存大小(单位:MB) */
+ (NSUInteger)getCacheSize;

/** 清除当前app缓存 */
+ (void)clearCache;

@end
