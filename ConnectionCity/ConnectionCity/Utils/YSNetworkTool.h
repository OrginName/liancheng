//
//  YSNetworkTool.h
//  dumbbell
//
//  Created by JYS on 17/3/8.
//  Copyright © 2017年 insaiapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTAlertUtil.h"

FOUNDATION_EXPORT NSString * const YTHttpUtilServerErrorMsg;
FOUNDATION_EXPORT NSString * const YTHttpUtilResponseIsSuccess;
FOUNDATION_EXPORT NSString * const YTHttpUtilResponseMessage;
FOUNDATION_EXPORT NSString * const YTHttpUtilResponseCode;
FOUNDATION_EXPORT NSString * const YTHttpUtilResponseData;

/** 刷新类型 */
typedef NS_ENUM(NSInteger, YTHttpUtilRefreshType) {
    YTHttpUtilRefreshTypeFirst = 0,  //第一次加载
    YTHttpUtilRefreshTypeDropDown = 1,  //下拉刷新
    YTHttpUtilRefreshTypePull = 2  //上拉加载
};

/** 请求成功block typedef */
typedef void (^YTHttpUtilSuccess)(NSURLSessionDataTask * task,id responseObject);
/** 请求失败block typedef */
typedef void (^YTHttpUtilFailure)(NSURLSessionDataTask * task, NSError * error);
/** 上传或者下载的进度block typedef */
typedef void (^YTHttpUtilProgress)(NSProgress *progress);
typedef void(^YTHttpUtilNetworkStatusHandler)(void);

/** 封装AFNetWorking的网络请求工具类 */
@interface YSNetworkTool : NSObject

/** POST请求,结果为JSON类型*/
+ (void)POST:(NSString *)url
      params:(NSDictionary *)params
     showHud:(BOOL)showHud
     success:(YTHttpUtilSuccess)success
     failure:(YTHttpUtilFailure)failure;
/** POST请求,结果为NSData类型*/
+ (void)POSTData:(NSString *)url
          params:(NSDictionary *)params
         showHud:(BOOL)showHud
         success:(YTHttpUtilSuccess)success
         failure:(YTHttpUtilFailure)failure;
/** GET请求,结果为JSON类型*/
+ (void)GET:(NSString *)url
     params:(NSDictionary *)params
    showHud:(BOOL)showHud
    success:(YTHttpUtilSuccess)success
    failure:(YTHttpUtilFailure)failure;
/** GET请求,结果为NSData类型*/
+ (void)GETData:(NSString *)url
         params:(NSDictionary *)params
        showHud:(BOOL)showHud
        success:(YTHttpUtilSuccess)success
        failure:(YTHttpUtilFailure)failure;
/** 上传图片 */
+ (void)uploadImageWithUrl:(NSString *)url
                    params:(NSDictionary *)params
                  imageArr:(NSArray<UIImage *> *)imageArr
                  progress:(YTHttpUtilProgress)progress
                   success:(YTHttpUtilSuccess)success
                   failure:(YTHttpUtilFailure)failure;
/** 开始监听网络状态 */
+ (void)startMonitorNetwork;

/** 停止网络监控 */
+ (void)stopMonitorNetwork;

/** 处理有网络连接和无网络连接 */
+ (void)handleNetworkStatusWithConnected:(YTHttpUtilNetworkStatusHandler)connected
                              disconnect:(YTHttpUtilNetworkStatusHandler)disconnect;
/** 显示无网络信息 */
+ (BOOL)connectedAndShowDisconnectInfo;
/** 服务器返回是否成功的字段 */
+ (BOOL)isSuccessWithResp:(id)response;
@end
