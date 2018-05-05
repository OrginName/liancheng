//
//  YTSystemUtil.m
//  JLTimeRent
//
//  Created by chips on 17/6/23.
//  Copyright © 2017年 YOU-TURN TECHNOLOGY CO.,LTD. All rights reserved.
//

#import "YTSystemUtil.h"
//#import "YTHttpUtil.h"
//#import <MapKit/MapKit.h>

NSString * const YTSystemUtilOpenAppUserInfoTelKey = @"YTSystemUtilOpenAppUserInfoTelKey";
static NSString * AppStoreVersion;
static NSString * const kAppStoreID = @"1239630317";

@implementation YTSystemUtil

#pragma mark - Get system info
+ (NSString *)getAppInfoWithType:(YTSystemUtilAppInfoType)type {
    NSString *infoKey;
    switch (type) {
        case YTSystemUtilAppInfoTypeVersion:
            infoKey = @"CFBundleShortVersionString";
            break;
        case YTSystemUtilAppInfoTypeName:
            infoKey = @"CFBundleDisplayName";
            break;
        case YTSystemUtilAppInfoBundleIdentifile:
            infoKey = @"CFBundleIdentifier";
    }
    NSDictionary *infoDic = [[NSBundle mainBundle]infoDictionary];
    NSString *infoValue = [infoDic objectForKey:infoKey];
    return infoValue;
}

+ (YTSystemUtilScreenInch)getIphoneInch {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGSize size4_0 = CGSizeMake(320, 568);
    CGSize size4_7 = CGSizeMake(375, 667);
    CGSize size5_5 = CGSizeMake(414, 736);
    CGSize size5_8 = CGSizeMake(375, 812);
    YTSystemUtilScreenInch inch = YTSystemUtilScreenInch4_7;
    if (screenSize.width == size4_0.width && screenSize.height == size4_0.height) {
        inch = YTSystemUtilScreenInch4_0;
    } else if (screenSize.width == size4_7.width && screenSize.height == size4_7.height) {
        inch = YTSystemUtilScreenInch4_7;
    } else if (screenSize.width == size5_5.width && screenSize.height == size5_5.height) {
        inch = YTSystemUtilScreenInch5_5;
    } else if (screenSize.width == size5_8.width && screenSize.height == size5_8.height) {
        inch = YTSystemUtilScreenInch5_8;
    }
    return inch;
}

#pragma mark - Cache
+ (NSUInteger)getCacheSize {
    NSUInteger imageCacheSize = [[SDImageCache sharedImageCache] getSize];
    return imageCacheSize/1024/1024;
}

+ (void)clearCache {
    [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{

    }];
}

@end
