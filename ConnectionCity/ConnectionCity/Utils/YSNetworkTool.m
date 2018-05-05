//
//  YSNetworkTool.m
//  dumbbell
//
//  Created by JYS on 17/3/8.
//  Copyright © 2017年 insaiapp. All rights reserved.
//

#import "YSNetworkTool.h"

/** 请求失败提示 */
static NSString * const kRequestFalseMessage = @"无网络连接，请稍后重试";
/** 服务器异常提示信息 */
NSString * const YTHttpUtilServerErrorMsg = @"连接服务器超时";
NSString * const YTHttpUtilResponseIsSuccess = @"IsSuccess";
NSString * const YTHttpUtilResponseMessage = @"Message";
NSString * const YTHttpUtilResponseCode = @"Code";
NSString * const YTHttpUtilResponseData = @"Data";

@implementation YSNetworkTool
/** 返回已配置过的AFHTTPSessionManager */
+ (AFHTTPSessionManager *)manager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",@"image/gif", nil];
    manager.requestSerializer.timeoutInterval = 10;
    return manager;
}

#pragma mark - POST
+ (void)POST:(NSString *)url
      params:(NSDictionary *)params
    progress:(YTHttpUtilProgress)progress
     success:(YTHttpUtilSuccess)success
     failure:(YTHttpUtilFailure)failure {
    AFHTTPSessionManager *manager = [[self class] manager];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",HOSTURL,url] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        progress ? progress(uploadProgress) : nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [YTAlertUtil hideHUD];
        [[self class] p_logRequestDataWithURL:url params:params response:responseObject];
        success ? success(task, responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self class]p_handleRequestFailure:nil];
        [YTAlertUtil showTempInfo:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        failure ? failure(task, error) : nil;
    }];
}
+ (void)POSTData:(NSString *)url
          params:(NSDictionary *)params
        progress:(YTHttpUtilProgress)progress
         success:(YTHttpUtilSuccess)success
         failure:(YTHttpUtilFailure)failure{
    AFHTTPSessionManager *manager = [[self class] manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager POST:[NSString stringWithFormat:@"%@%@",HOSTURL,url] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        progress ? progress(uploadProgress) : nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [YTAlertUtil hideHUD];
        [[self class] p_logRequestDataWithURL:url params:params response:responseObject];
        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        success ? success(task, result) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self class]p_handleRequestFailure:nil];
        [YTAlertUtil showTempInfo:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        failure ? failure(task, error) : nil;
    }];
}
#pragma mark - GET
+ (void)GET:(NSString *)url
     params:(NSDictionary *)params
   progress:(YTHttpUtilProgress)progress
    success:(YTHttpUtilSuccess)success
    failure:(YTHttpUtilFailure)failure {
    AFHTTPSessionManager *manager = [[self class]manager];
    
    [manager GET:[NSString stringWithFormat:@"%@%@",HOSTURL,url] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        progress ? progress(uploadProgress) : nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [YTAlertUtil hideHUD];
        [[self class]p_logRequestDataWithURL:url params:params response:responseObject];
        success ? success(task, responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self class]p_handleRequestFailure:nil];
        [YTAlertUtil showTempInfo:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        failure ? failure(task, error) : nil;
    }];
}
+ (void)GETData:(NSString *)url
         params:(NSDictionary *)params
       progress:(YTHttpUtilProgress)progress
        success:(YTHttpUtilSuccess)success
        failure:(YTHttpUtilFailure)failure {
    AFHTTPSessionManager *manager = [[self class]manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager GET:[NSString stringWithFormat:@"%@%@",HOSTURL,url] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        progress ? progress(uploadProgress) : nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [YTAlertUtil hideHUD];
        [[self class]p_logRequestDataWithURL:url params:params response:responseObject];
        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        success ? success(task, result) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self class]p_handleRequestFailure:nil];
        [YTAlertUtil showTempInfo:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        failure ? failure(task, error) : nil;
    }];
}
#pragma mark - UploadImage
+ (void)uploadImageWithUrl:(NSString *)url
                    params:(NSDictionary *)params
                  imageArr:(NSArray<UIImage *> *)imageArr
                  progress:(YTHttpUtilProgress)progress
                   success:(YTHttpUtilSuccess)success
                   failure:(YTHttpUtilFailure)failure {
    AFHTTPSessionManager *manager = [[self class]manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@%@",HOSTURL,url] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [imageArr enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *data = UIImageJPEGRepresentation(image, 0.7);
            NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
            NSString *fileName = [NSString stringWithFormat:@"%.0f.png", timestamp];
            [formData appendPartWithFileData:data name:@"image" fileName:fileName mimeType:@"image/png"];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress ? progress(uploadProgress) : nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [YTAlertUtil hideHUD];
        [[self class]p_logRequestDataWithURL:url params:params response:responseObject];
        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        success ? success(task, result) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self class]p_handleRequestFailure:nil];
        [YTAlertUtil showTempInfo:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        failure ? failure(task, error) : nil;
    }];
}
#pragma mark - Private method
/** 处理请求失败 */
+ (void)p_handleRequestFailure:(YTHttpUtilFailure)failure {
    [YTAlertUtil hideHUD];
}
/** 打印请求和响应内容 */
+ (void)p_logRequestDataWithURL:(NSString *)url
                         params:(NSDictionary *)params
                       response:(id)response {
    YTRLog(@"url:%@\tparams:%@\tresponse:%@", url, params, response);
}

@end
