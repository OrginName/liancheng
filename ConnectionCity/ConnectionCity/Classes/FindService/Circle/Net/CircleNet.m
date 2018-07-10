//
//  CircleNet.m
//  ConnectionCity
//
//  Created by qt on 2018/6/27.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "CircleNet.h"
#import "Moment.h"
@implementation CircleNet
/**
 旅行旅游列表
 @param sucBlock 成功回调
 */
+(void)requstCirclelDic:(NSDictionary *) param flag:(NSString *)flag withSuc:(SuccessArrBlock)sucBlock FailErrBlock:(FailErrBlock)failErrBlock{
    NSString * url = [flag isEqualToString:@"HomeSend"]?v1FriendCirclePage:v1ServiceCirclePage;
    [YSNetworkTool POST:url params:param showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray * arr = [NSMutableArray array];
        NSArray * Arr = responseObject[@"data"][@"content"];
        if (Arr.count==0) {
            [YTAlertUtil showTempInfo:@"暂无数据"];
        }else{
            for (int i=0; i<Arr.count; i++) {
                Moment * moment = [Moment  mj_objectWithKeyValues:Arr[i]];
                moment.ID = Arr[i][@"id"];
                moment.userMo = [UserMo mj_objectWithKeyValues:Arr[i][@"obj"][@"user"]];
                NSMutableArray * commentArr = [NSMutableArray array];
                for (int j=0; j<[Arr[i][@"obj"][@"comments"] count]; j++) {
                    Comment * comment = [Comment mj_objectWithKeyValues:Arr[i][@"obj"][@"comments"][j]];
                    comment.userMo = [UserMo mj_objectWithKeyValues:Arr[i][@"obj"][@"comments"][j][@"user"]];
                    comment.ID = Arr[i][@"obj"][@"comments"][j][@"id"];
                    [commentArr addObject:comment];
                }
                moment.singleWidth = 500;
                moment.singleHeight = 315;
                moment.comments = commentArr;
                moment.likeCount = Arr[i][@"obj"][@"likeCount"];
                moment.commentCount = Arr[i][@"obj"][@"commentCount"];
                if (moment.videos.length!=0&&[moment.videos containsString:@"http"]) {
                    moment.coverImage = [UIImage thumbnailOfAVAsset:[NSURL URLWithString:moment.videos]];
                }else{
                    moment.coverImage = [UIImage imageNamed:@"no-pic"];
                    NSMutableArray * imageArr = [[moment.images componentsSeparatedByString:@";"] mutableCopy];
                    [imageArr removeLastObject];
                    moment.fileCount = [imageArr count];
                }
                [arr addObject:moment];
            }
            
        }
        sucBlock(arr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failErrBlock(error);
    }];
}
/**
 首页朋友圈我的
 
 @param sucBlock 成功回调
 */
+(void)requstHomeCirclelDic:(NSDictionary *) param withSuc:(SuccessArrBlock)sucBlock FailErrBlock:(FailErrBlock)failErrBlock{
    [YSNetworkTool POST:v1FriendCircleMyPage params:param showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


/**
 评论发送列表
 
 @param sucBlock 成功回调
 */
+(void)requstSendPL:(NSDictionary *) param withSuc:(SuccessDicBlock)sucBlock{
    [YSNetworkTool POST:v1CommonCommentCreate params:param showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        sucBlock(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
/**
 圈子详情
 @param sucBlock 成功回调
 */
+(void)requstCircleDetail:(NSDictionary *) param withSuc:(SuccessArrBlock)sucBlock{
    [YSNetworkTool POST:v1ServiceCircleInfo params:param showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray * arr1 = [NSMutableArray array];
        Moment * momet = [Moment mj_objectWithKeyValues:responseObject[@"data"]];
        momet.ID = responseObject[@"data"][@"id"];
        momet.commentCount = responseObject[@"data"][@"obj"][@"commentCount"];
        momet.likeCount = responseObject[@"data"][@"obj"][@"likeCount"];
        NSArray * arr = responseObject[@"data"][@"obj"][@"comments"];
        for (int i=0; i<arr.count; i++) {
            Comment * comment = [Comment mj_objectWithKeyValues:arr[i]];
            [arr1 addObject:comment];
        }
        sucBlock(arr1);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
/**
 点赞接口
 @param sucBlock 成功回调
 */
+(void)requstCircleDZ:(NSDictionary *) param withSuc:(SuccessDicBlock)sucBlock{
    [YSNetworkTool POST:v1CommonCommentAddlike params:param showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        sucBlock(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


/**
 *  根据图片url获取图片尺寸
 */
+(CGSize)getImageSizeWithURL:(id)URL{
    NSURL * url = nil;
    if ([URL isKindOfClass:[NSURL class]]) {
        url = URL;
    }
    if ([URL isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:URL];
    }
    if (!URL) {
        return CGSizeZero;
    }
    CGImageSourceRef imageSourceRef =     CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGFloat width = 0, height = 0;
    if (imageSourceRef) {
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
        if (imageProperties != NULL) {
            CFNumberRef widthNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
            }
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
            }
            CFRelease(imageProperties);
        }
        CFRelease(imageSourceRef);
    }
    return CGSizeMake(width, height);
}
@end
