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
+(void)requstCirclelDic:(NSDictionary *) param withSuc:(SuccessArrBlock)sucBlock{
    [YSNetworkTool POST:v1ServiceCirclePage params:param showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray * arr = [NSMutableArray array];
        NSArray * Arr = responseObject[@"data"][@"content"];
        if (Arr.count==0) {
            [YTAlertUtil showTempInfo:@"暂无数据"];
        }else{
            for (int i=0; i<Arr.count; i++) {
                Moment * moment = [Moment  mj_objectWithKeyValues:Arr[i]];
                moment.ID = Arr[i][@"id"];
                moment.userMo = [UserMo mj_objectWithKeyValues:Arr[i][@"obj"][@"user"]];
                moment.likeCount = Arr[i][@"obj"][@"likeCount"];
                if (moment.videos.length!=0&&[moment.videos containsString:@"http"]) {
                    moment.coverImage = [UIImage thumbnailOfAVAsset:[NSURL URLWithString:moment.videos]];
                }else
                    moment.coverImage = [UIImage imageNamed:@"no-pic"];
                //            moment.singleWidth = 500;
                NSMutableArray * imageArr = [[moment.images componentsSeparatedByString:@";"] mutableCopy];
                [imageArr removeLastObject];
                moment.fileCount = [imageArr count];
                //            moment.singleHeight = 315;
                [arr addObject:moment];
            }
        }
        sucBlock(arr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
} 
@end
