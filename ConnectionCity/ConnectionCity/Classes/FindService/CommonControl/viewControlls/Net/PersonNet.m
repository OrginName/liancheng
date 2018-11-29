//
//  PersonNet.m
//  ConnectionCity
//
//  Created by umbrella on 2018/11/16.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "PersonNet.h"
#import "trvalMo.h"
#import "YLMo.h"
#import "Moment.h"
@implementation PersonNet
/**
 获取用户动态接口
 
 @param dic dic
 @param block dic
 */
+(void)requstPersonDT:(NSDictionary *)dic withDic:(SuccessDicBlock)block{
    [YSNetworkTool POST:v1UserCircleGet params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        block(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
/**
 获取用户娱乐接口
 
 @param dic dic
 @param block dic
 */
+(void)requstPersonYL:(NSDictionary *)dic withArr:(SuccessArrBlock)block{
    [YSNetworkTool POST:v1UserCircleServiceTravelPage params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray * arr = [NSMutableArray array];
        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            for (int i=0; i<[responseObject[@"data"][@"content"] count]; i++) {
                trvalMo * trval = [trvalMo mj_objectWithKeyValues:responseObject[@"data"][@"content"][i]];
                //                trval.comments = [comments mj_objectArrayWithKeyValuesArray:trval.comments];
                [arr addObject:trval];
            }
        }
        block(arr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
/**
 获取用户娱乐接口
 
 @param dic dic
 @param block dic
 */
+(void)requstPersonYL1:(NSDictionary *)dic withArr:(SuccessArrBlock)block{
    [YSNetworkTool POST:v1UserCircleServiceYulePage params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray * arr = [YLMo mj_objectArrayWithKeyValuesArray:responseObject[kData][@"content"]];
        block([arr mutableCopy]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
/**
 获取用户图文或视频接口

 @param dic 字典
 @param block 返回内容
 */
+(void)requstPersonVideo:(NSDictionary *)dic withArr:(SuccessArrBlock)block FailDicBlock:(FailDicBlock)fail{
    [YSNetworkTool POST:v1UserCircleServiceCirclePage params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray * arr = [NSMutableArray array];
        NSArray * Arr = responseObject[@"data"][@"content"];
        if (Arr.count==0) {
            //            [YTAlertUtil showTempInfo:@"暂无数据"];
        }else{
            for (int i=0; i<Arr.count; i++) {
                Moment * moment = [Moment  mj_objectWithKeyValues:Arr[i]];
                moment.ID = Arr[i][@"id"];
                NSMutableArray * commentArr = [NSMutableArray array];
                if (![YSTools dx_isNullOrNilWithObject:Arr[i][@"obj"]]) {
                    moment.userMo = [UserMo mj_objectWithKeyValues:Arr[i][@"obj"][@"user"]];
                    moment.userMo.ID = Arr[i][@"obj"][@"user"][@"id"];
                    for (int j=0; j<[Arr[i][@"obj"][@"comments"] count]; j++) {
                        Comment * comment = [Comment mj_objectWithKeyValues:Arr[i][@"obj"][@"comments"][j]];
                        comment.typeName = Arr[i][@"obj"][@"comments"][j][@"user"][@"nickName"];
                        [commentArr addObject:comment];
                    }
                }
                moment.singleWidth = 400;
                moment.singleHeight = 250;
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
        block(arr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error);
    }];
}
/**
 获取生活接口
 @param dic 字典
 @param block 返回内容
 */
+(void)requstPersonSH:(NSDictionary *)dic withArr:(SuccessArrBlock)block FailDicBlock:(FailDicBlock)fail{
    [YSNetworkTool POST:v1UserCircleServicePage params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray * arr = [YLMo mj_objectArrayWithKeyValuesArray:responseObject[kData][@"content"]];
        block([arr mutableCopy]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
/**
 获取首页广告接口 
 @param block 返回内容
 */
+(void)requstTJGGArr:(SuccessArrBlock)block FailDicBlock:(FailDicBlock)fail{
    [YSNetworkTool POST:v1BannerList params:@{} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray * arr = [NSMutableArray array];
        for (int i=0; i<[responseObject[kData] count]; i++) {
            [arr addObject:responseObject[kData][i][@"url"]];
        }
        block(arr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}
/**
 获取首页同城列表
 @param block 返回内容
 */
+(void)requstTJArr:(NSDictionary *)dic withArr:(SuccessArrBlock)block FailDicBlock:(FailDicBlock)fail{
    [YSNetworkTool POST:v1RecommendPage params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end
