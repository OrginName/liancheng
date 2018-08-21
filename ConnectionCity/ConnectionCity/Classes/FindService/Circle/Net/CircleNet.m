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
    NSString * url =[flag isEqualToString:@"userFriend"]?v1ServiceCircleUserPage:[flag isEqualToString:@"HomeSend"]?v1FriendCirclePage:v1ServiceCirclePage;
    [YSNetworkTool POST:url params:param showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray * arr = [NSMutableArray array];
        NSArray * Arr = responseObject[@"data"][@"content"];
        if (Arr.count==0) {
//            [YTAlertUtil showTempInfo:@"暂无数据"];
        }else{
            for (int i=0; i<Arr.count; i++) {
                Moment * moment = [Moment  mj_objectWithKeyValues:Arr[i]];
                moment.ID = Arr[i][@"id"];
                moment.userMo = [UserMo mj_objectWithKeyValues:Arr[i][@"obj"][@"user"]];
                moment.userMo.ID = Arr[i][@"obj"][@"user"][@"id"];
                NSMutableArray * commentArr = [NSMutableArray array];
                for (int j=0; j<[Arr[i][@"obj"][@"comments"] count]; j++) {
                    Comment * comment = [Comment mj_objectWithKeyValues:Arr[i][@"obj"][@"comments"][j]];
                    comment.typeName = Arr[i][@"obj"][@"comments"][j][@"user"][@"nickName"];
                    [commentArr addObject:comment];
                }
                moment.singleWidth = 500;
                moment.singleHeight = 315;
                moment.comments = commentArr;
                moment.likeCount = Arr[i][@"obj"][@"likeCount"];
                moment.commentCount = Arr[i][@"obj"][@"commentCount"];
//                if (moment.videos.length!=0&&[moment.videos containsString:@"http"]) {
//                    moment.coverImage = [UIImage thumbnailOfAVAsset:[NSURL URLWithString:moment.videos]];
//                }else{
                if (moment.images.length!=0&&[moment.images containsString:@"http"]) {
                    if (![moment.images containsString:@";"]) {
                        moment.fileCount = 1;
                    }else{
                        NSMutableArray * imageArr = [[moment.images componentsSeparatedByString:@";"] mutableCopy];
                        NSMutableArray * imgArr = [NSMutableArray array];
                        for (NSString * str in imageArr) {
                            if (str.length!=0) {
                                [imgArr addObject:str];
                            }
                        }
                        [imageArr removeLastObject];
                        moment.fileCount = [imgArr count];
                    }
                }
                    moment.coverImage = [UIImage imageNamed:@"no-pic"];
//                }
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
    NSMutableArray * arr = [NSMutableArray array];
    [YSNetworkTool POST:v1FriendCircleMyPage params:param showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        for (int i=0; i<[responseObject[@"data"][@"content"] count]; i++) {
            Moment * mo = [Moment mj_objectWithKeyValues:responseObject[@"data"][@"content"][i]];
            mo.ID = responseObject[@"data"][@"content"][i][@"id"];
            [arr addObject:mo];
        }
        sucBlock(arr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failErrBlock(error);
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
 申请加入群
 
 @param param 字典
 @param flag 类型判断
 @param sucBlock 成功回调
 @param failBlock 失败回调
 */
+(void)requstJoinQun:(NSDictionary *) param withFlag:(int)flag withSuc:(SuccessDicBlock)sucBlock withFailBlock:(FailErrBlock)failBlock{
    NSString * url = flag==1?v1GroupApplicationAdd:flag==2?v1StationApplicationAdd:v1TeamApplicationAdd;
    [YSNetworkTool POST:url params:param showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        sucBlock(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failBlock(error);
    }];
}
/**
 同意加入群
 
 @param param 字典
 @param flag 类型判断
 @param sucBlock 成功回调
 @param failBlock 失败回调
 */
+(void)requstAgreeJoinQun:(NSDictionary *) param withFlag:(int)flag withSuc:(SuccessDicBlock)sucBlock withFailBlock:(FailErrBlock)failBlock{
//    20 qun 30team  40 station
    NSString * url = flag==20?v1GroupApplicationAgree:flag==40?v1StationApplicationAgree:v1TeamApplicationAgree;
    [YSNetworkTool POST:url params:param showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        sucBlock(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failBlock(error);
    }];
}
/**
 公告接口
 
 @param param 字典
 @param sucBlok 成功返回
 */
+(void)requstNotice:(NSDictionary *)param withSuc:(SuccessArrBlock)sucBlok{
    [YSNetworkTool POST:v1CommonNoticePage params:param showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        sucBlok(responseObject[@"data"][@"content"]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
/**
 更新用户配置接口
 
 @param param 字典
 @param sucBlok 成功返回
 */
+(void)requstUserPZ:(NSDictionary *)param withSuc:(SuccessDicBlock)sucBlok{
    NSDictionary * dic = @{
                           @"openFriendCircleNewRemind": param[@"openFriendCircleNewRemind"]?param[@"openFriendCircleNewRemind"]:@"",
                           @"openFriendVerify": param[@"openFriendVerify"]?param[@"openFriendVerify"]:@"",
                           @"openMessageVoice": param[@"openMessageVoice"]?param[@"openMessageVoice"]:@"",
                           @"openNonWifiAutoImage": param[@"openNonWifiAutoImage"]?param[@"openNonWifiAutoImage"]:@"",
                           @"openRemind": param[@"openRemind"]?param[@"openRemind"]:@"",
                           @"openSearchMobile": param[@"openSearchMobile"]?param[@"openSearchMobile"]:@"",
                           @"openSearchUserID": param[@"openSearchUserID"]?param[@"openSearchUserID"]:@"",
                           @"openShock": param[@"openShock"]?param[@"openShock"]:@"",
                           @"openStrangerViewTenPhoto": param[@"openStrangerViewTenPhoto"]?param[@"openStrangerViewTenPhoto"]:@"",
                           @"openWifiAutoUpgrade": param[@"openWifiAutoUpgrade"]?param[@"openWifiAutoUpgrade"]:@"",
                           };
    [YSNetworkTool POST:v1MyConfigUpdate params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        sucBlok(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
/**
 获取某个用户配置接口
 @param param 字典
 @param sucBlok 成功返回
 */
+(void)requstUserPZDetail:(NSDictionary *)param withSuc:(SuccessDicBlock)sucBlok{
    [YSNetworkTool POST:v1PrivateUserConfig params:param showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        sucBlok(responseObject);
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
