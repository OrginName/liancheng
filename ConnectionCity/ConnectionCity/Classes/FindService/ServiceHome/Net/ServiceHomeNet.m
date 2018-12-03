//
//  ServiceHomeNet.m
//  ConnectionCity
//
//  Created by qt on 2018/6/10.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ServiceHomeNet.h"
#import "ClassifyMo.h"
#import "ClassAttrMo.h"
#import "ServiceListMo.h"
#import "serviceListNewMo.h"
#import "YSAccountTool.h"
#import "privateUserInfoModel.h"
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
    [YSNetworkTool POST:v1ServiceList params:param showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
         if ([responseObject[@"data"] isKindOfClass:[NSArray class]]){
             NSArray * arr = [serviceListNewMo mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
             sucBlock([arr mutableCopy]);
        }else
            [YTAlertUtil showTempInfo:@"附近暂无服务"];
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
/**
 服务热门
 
 @param sucBlock 成功回调
 */
+(void)requstServiceHot:(SuccessArrBlock)sucBlock{
    [YSNetworkTool POST:keywordServiceHot params:@{} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
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
//                trval.comments = [comments mj_objectArrayWithKeyValuesArray:trval.comments];
                if ([[[YSAccountTool userInfo] modelId] isEqualToString:APPID]){
                    if (![trval.user.ID isEqualToString:@"408562"]) {
                        [arr addObject:trval];
                    }
                }else
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
                    dicItem[@"name"] = arr[i][@"name"];
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
/**
 根据userID去查询当前技能包圈子等
 
 @param param param
 @param sucBlock 成功返回
 */
+(void)requstServiceListJN:(NSDictionary *) param  withSuc:(SuccessUser)sucBlock{
    [YSNetworkTool POST:v1ServiceUserList params:param showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray * arr1 = [NSMutableArray array];
        UserMo * user = [UserMo mj_objectWithKeyValues:responseObject[@"data"]];
        for (ServiceListMo * mo in user.serviceList) {
            if ([mo.serviceCategoryName[@"name"] length]!=0) {
                [arr1 addObject:mo.serviceCategoryName[@"name"]];
            }
            NSMutableArray * arr3 = [NSMutableArray array];
            NSMutableArray * arr4 = [NSMutableArray array];
            NSMutableArray * arr5 = [NSMutableArray array];
            NSArray * arr2 = [YSTools stringToJSON:mo.property];
            for (long j=0;j<arr2.count;j++) {
                NSDictionary * dic1 = arr2[j];
                NSString * typeName = dic1[@"name"];
                [arr4 addObject:typeName];
                NSString * strName = @"";
                for (long k=0;k<[dic1[@"childs"] count];k++) {
                    NSDictionary * dic2 = dic1[@"childs"][k];
                    strName = [NSString stringWithFormat:@"%@  %@",dic2[@"name"],strName];
                }
                [arr3 addObject:strName];
            }
            for (NSDictionary * dic in mo.browserList) {
                NSString * str = dic[@"headImage"];
                if ([YSTools dx_isNullOrNilWithObject:str]) {
                    str = @"http://";
                }
                [arr5 addObject:str];
            }
            mo.propertyNameArr = [arr3 copy];
            mo.typeNameArr = [arr4 copy];
            mo.imageArr = [arr5 copy];
        }
        user.JNArr = arr1;
        sucBlock(user);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
/**
 根据userID去查询当前陪游详情
 
 @param param param
 @param sucBlock 成功返回
 */
+(void)requstPYDetail:(NSDictionary *) param  withSuc:(Successtrval)sucBlock{
    [YSNetworkTool POST:v1ServiceTravelInfo params:param showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        trvalMo * mo1 = [trvalMo mj_objectWithKeyValues:responseObject[@"data"]];
        sucBlock(mo1);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end
