//
//  ServiceHomeNet.m
//  ConnectionCity
//
//  Created by qt on 2018/6/10.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ServiceHomeNet.h"
#import "ClassifyMo.h"
#import "trvalMo.h"
#import "ClassAttrMo.h"
#import "ServiceListMo.h"
@implementation ServiceHomeNet
+(void)requstConditions:(SuccessArrBlock) sucBloc withFailBlock:(FailDicBlock)failBlock{
    [YSNetworkTool POST:v1ServiceConditions params:@{} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary * dic = responseObject[@"data"];
        NSArray * arr = @[@"age",@"distance",@"gender",@"validType"];
        NSMutableArray * dataArr= [NSMutableArray array];
        for (int i=0; i<arr.count; i++) {
            NSMutableDictionary * dicItem = [NSMutableDictionary dictionary];
            NSMutableArray * arrItem = [NSMutableArray array];
            NSArray * selectArr = [YSTools stringToJSON:dic[arr[i]][@"content"]];
            for (int j=0; j<[selectArr count]; j++) {
                NSDictionary * dic1 = @{@"isSelected":j==0?@"YES":@"NO",@"title":selectArr[j][@"description"],@"ID":selectArr[j][@"value"]};
                [arrItem addObject:dic1];
                if (arrItem.count==[selectArr count]) {
                    [dicItem setObject:arrItem forKey:@"subname"];
                     dicItem[@"name"] = dic[arr[i]][@"name"];
                }
            }
            [dataArr addObject:dicItem];
        }
        sucBloc(dataArr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}
+(void)requstServiceList:(NSDictionary *) param withSuc:(SuccessArrBlock)sucBlock{
    [YSNetworkTool POST:v1ServiceList params:param showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray * arr = [NSMutableArray array];
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            for (int i=0; i<[responseObject[@"data"] count]; i++) {
                ServiceListMo * list = [ServiceListMo mj_objectWithKeyValues:responseObject[@"data"][i]];
                list.ID = responseObject[@"data"][i][@"id"];
                list.user1 = [UserMo mj_objectWithKeyValues:list.user];
                list.user1.ID = list.user[@"id"];
                list.commentList = [commentList mj_objectArrayWithKeyValuesArray:list.commentList];
                [arr addObject:list];
            }
        }else
            [YTAlertUtil showTempInfo:@"暂无数据"];
        sucBlock(arr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
+(void)requstServiceClass:(SuccessArrBlock)sucBlock{
    [YSNetworkTool POST:dictionaryServiceCategory params:@{} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray * arr = [NSMutableArray array];
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            for (int i=0; i<[responseObject[@"data"] count]; i++) {
                ClassifyMo * mo = [ClassifyMo mj_objectWithKeyValues:responseObject[@"data"][i]];
                mo.ID = responseObject[@"data"][i][@"id"];
                [arr addObject:mo];
            }
        }
        sucBlock(arr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
+(void)requstServiceKeywords:(SuccessArrBlock)sucBlock{
    [YSNetworkTool POST:keywordServiceKeyword params:@{} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray * arr = [NSMutableArray array];
        for (int i=0; i<[responseObject[@"data"] count]; i++){
            [arr addObject:responseObject[@"data"][i][@"name"]];
        }
        sucBlock(arr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
+(void)requstTrvalInvitDic:(NSDictionary *) param withSuc:(SuccessArrBlock)sucBlock{
    [YSNetworkTool POST:v1ServiceTravelPage params:param showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray * arr = [NSMutableArray array];
        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            for (int i=0; i<[responseObject[@"data"][@"content"] count]; i++) {
                trvalMo * trval = [trvalMo mj_objectWithKeyValues:responseObject[@"data"][@"content"][i]];
                trval.comments = [comments mj_objectArrayWithKeyValuesArray:trval.comments];
                [arr addObject:trval];
            }
        } 
        sucBlock(arr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
+(void)requstServiceClassAttrParam:(NSDictionary *)param succblick:(SuccessArrBlock)sucBlock{
    [YSNetworkTool POST:dictionaryServiceCategoryProperties params:param showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray * arr = responseObject[@"data"];
        NSMutableArray * dataArr = [NSMutableArray array];
        for (int i=0; i<[arr count]; i++) {
            NSMutableDictionary * dicItem = [NSMutableDictionary dictionary];
            NSMutableArray * arrItem = [NSMutableArray array];
            for (int j=0; j<[arr[i][@"childs"] count]; j++) {
                NSDictionary * dic1 = @{@"isSelected":@"NO",@"title":arr[i][@"childs"][j][@"name"],@"id":arr[i][@"childs"][j][@"id"]};
                [arrItem addObject:dic1];
                if (arrItem.count==[arr[i][@"childs"] count]) {
                    [dicItem setObject:arrItem forKey:@"subname"];
                    dicItem[@"isMulitable"] = @"1";
                    dicItem[@"name"] = i==0?@"擅长位置":i==1?@"最高段位":@"";
                }
            }
            [dataArr addObject:dicItem];
        }
        sucBlock(dataArr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
+(void)requstTrvalDic:(NSDictionary *) param withSuc:(SuccessArrBlock)sucBlock{
    [YSNetworkTool POST:v1ServiceTravelInvitePage params:param showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray * arr = [NSMutableArray array];
        for (int i=0; i<[responseObject[@"data"][@"content"] count]; i++) {
            trvalMo * mo = [trvalMo mj_objectWithKeyValues:responseObject[@"data"][@"content"][i]];
            [arr addObject:mo];
        }
        sucBlock(arr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

/**
 旅行旅游添加浏览次数
 @param param 字典
 @param flag 1:服务浏览次数 2：旅行浏览次数
 @param sucBlock 成功返回
 */
+(void)requstLiulanNum:(NSDictionary *) param flag:(int)flag withSuc:(SuccessArrBlock)sucBlock{
    NSString * url = flag==1?v1ServiceAddBrowseTimes:v1ServiceTravelAddBrowseTimes;
    [YSNetworkTool POST:url params:param showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"添加浏览次数成功");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];             
}
@end
