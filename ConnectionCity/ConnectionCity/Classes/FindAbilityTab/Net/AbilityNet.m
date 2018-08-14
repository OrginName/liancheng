//
//  AbilityNet.m
//  ConnectionCity
//
//  Created by qt on 2018/6/12.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AbilityNet.h"
#import "ClassifyMo.h"
#import "AbilttyMo.h"
@implementation AbilityNet
+(void)requstAbilityKeyWords:(SuccessArrBlock)block{
    [YSNetworkTool POST:keywordTalentKeyword params:@{} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray * arr = [NSMutableArray array];
        for (int i=0; i<[responseObject[@"data"] count]; i++){
            [arr addObject:responseObject[@"data"][i][@"name"]];
        }
        block(arr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
+(void)requstAbilityHot:(SuccessArrBlock)block{
    [YSNetworkTool POST:keywordTalentHot params:@{} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray * arr = [NSMutableArray array];
        for (int i=0; i<[responseObject[@"data"] count]; i++){
            [arr addObject:responseObject[@"data"][i][@"name"]];
        }
        block(arr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
+(void)requstAbilityClass:(SuccessArrBlock)block{
    [YSNetworkTool POST:dictionaryOccupationCategory params:@{} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray * arr = [NSMutableArray array];
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            for (int i=0; i<[responseObject[@"data"] count]; i++) {
                ClassifyMo * mo = [ClassifyMo mj_objectWithKeyValues:responseObject[@"data"][i]];
                mo.ID = responseObject[@"data"][i][@"id"];
                [arr addObject:mo];
            }
        }
        block(arr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
/**
 职业筛选
 
 @param block 成功返回
 */
+(void)requstAbilityConditions:(SuccessArrBlock)block{
    [YSNetworkTool POST:v1TalentResumeConditions params:@{} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary * dic = responseObject[@"data"];
        NSArray * arr = @[@"education",@"work",@"salary"];
        NSMutableArray * dataArr= [NSMutableArray array];
        for (int i=0; i<arr.count; i++) {
            NSMutableDictionary * dicItem = [NSMutableDictionary dictionary];
            NSMutableArray * arrItem = [NSMutableArray array];
            NSArray * arr1 = [YSTools stringToJSON:dic[arr[i]][@"content"]];
             dicItem[@"name"] = dic[arr[i]][@"name"];
            for (int j=0; j<[arr1 count]; j++) {
                NSDictionary * dic1 = @{@"isSelected":j==0?@"YES":@"NO",@"title":arr1[j][@"description"],@"ID":arr1[j][@"value"]};
                [arrItem addObject:dic1];
                if (arrItem.count==[arr1 count]) {
                    [dicItem setObject:arrItem forKey:@"subname"];
                }
            }
            [dataArr addObject:dicItem];
        }
        block(dataArr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
/**
 赚外快 - 行业类型
 
 @param block 成功返回
 */
+(void)requstMakeMoneyClass:(SuccessArrBlock)block{
    [YSNetworkTool POST:dictionaryIndustryCategory params:@{} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray * arr = [NSMutableArray array];
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            for (int i=0; i<[responseObject[@"data"] count]; i++) {
                ClassifyMo * mo = [ClassifyMo mj_objectWithKeyValues:responseObject[@"data"][i]];
                mo.ID = responseObject[@"data"][i][@"id"];
                [arr addObject:mo];
            }
        }
        block(arr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
/**
 简历-附近列表
 
 @param param 字典
 @param block 成功数组
 */
+(void)requstAbilityConditions:(NSDictionary *)param withBlock:(SuccessArrBlock)block{
    [YSNetworkTool POST:v1TalentResumeList params:param showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
//        if ([responseObject[@"data"] count]==0) {
//            [YTAlertUtil showTempInfo:@"附件暂无简历"];
//            return;
//        }
        NSMutableArray * arr = [NSMutableArray array];
        NSMutableArray * arr1 = [NSMutableArray array];
        NSMutableArray * arr2 = [NSMutableArray array];
        for (int i=0; i<[responseObject[@"data"] count]; i++) {
            AbilttyMo * mo = [AbilttyMo mj_objectWithKeyValues:responseObject[@"data"][i]];
            mo.ID = responseObject[@"data"][i][@"id"];
            mo.userMo = [UserMo mj_objectWithKeyValues:mo.user];
            mo.userMo.ID = mo.user[@"id"];
            for (int j=0; j<mo.workExperienceList.count; j++) {
                AbilttyWorkMo * workMo = [AbilttyWorkMo mj_objectWithKeyValues:mo.workExperienceList[j]];
                workMo.ID = mo.workExperienceList[j][@"id"];
                workMo.description1 = mo.workExperienceList[j][@"description"];
                [arr1 addObject:workMo];
            }
            if (mo.educationExperienceList.count!=0) {
                for (int k=0; k<mo.educationExperienceList.count; k++) {
                    AbilttyEducationMo * educationMo = [AbilttyEducationMo mj_objectWithKeyValues:mo.educationExperienceList[k]];
                    educationMo.ID = mo.educationExperienceList[k][@"id"];
                    educationMo.description1 = mo.educationExperienceList[k][@"description"];
                    [arr2 addObject:educationMo];
                }
            }
            mo.WorArr = arr1;
            mo.EduArr = arr2;
            [arr addObject:mo];
        }
        block(arr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
/**
 新增工作经历
 
 @param param 字典
 @param block 成功数组
 */
+(void)requstAddWord:(NSDictionary *)param withBlock:(SuccessDicBlock)block{
    [YSNetworkTool POST:v1TalentResumeWorkCreate params:param showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        block(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
+(void)requstAddEdu:(NSDictionary *)param withBlock:(SuccessDicBlock)block{
    [YSNetworkTool POST:v1TalentResumeEducationCreate params:param showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        block(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
/**
 新增简历
 
 @param param 字典
 @param block 成功数组
 */
+(void)requstAddResume:(NSDictionary *)param withBlock:(SuccessDicBlock)block{
    [YSNetworkTool POST:v1TalentResumeCreate params:param showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        [YTAlertUtil showTempInfo:responseObject[@"message"]];
        block(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [YTAlertUtil hideHUD];
    }];
}
@end
