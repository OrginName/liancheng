//
//  RCDHttpTool.m
//  RCloudMessage
//
//  Created by Liv on 15/4/15.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDHttpTool.h"
#import "RCDGroupInfo.h"
#import "RCDRCIMDataSource.h"
#import "RCDUserInfo.h"
#import "RCDUserInfoManager.h"
#import "RCDUtilities.h"
#import "RCDataBaseManager.h"
#import "SortForTime.h"

@implementation RCDHttpTool

+ (RCDHttpTool *)shareInstance {
    static RCDHttpTool *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
        instance.allGroups = [NSMutableArray new];
        instance.allFriends = [NSMutableArray new];
    });
    return instance;
}

//创建群组
- (void)createGroupWithGroupName:(NSString *)groupName
                 GroupMemberList:(NSArray *)groupMemberList
                        complete:(void (^)(NSString *))userId {
//    [AFHttpTool createGroupWithGroupName:groupName
//        groupMemberList:groupMemberList
//        success:^(id response) {
//            if ([response[@"code"] integerValue] == 200) {
//                NSDictionary *result = response[@"result"];
//                userId(result[@"id"]);
//            } else {
//                userId(nil);
//            }
//        }
//        failure:^(NSError *err) {
//            userId(nil);
//        }];
}

//设置群组头像
- (void)setGroupPortraitUri:(NSString *)portraitUri groupId:(NSString *)groupId flag:(int)flag name:(NSString *)name notice:(NSString *)notice complete:(void (^)(BOOL))result {
    NSString * str = flag==1?v1TalentTeamUpdate:flag==2?v1ServiceStationUpdate:v1UserGroupUpdate;
    NSString * str1 = groupId;
    if (flag>0&&flag<3) {
        str1 = [groupId componentsSeparatedByString:@"_"][1];
    }
    NSDictionary * dic = @{};
    if (portraitUri.length!=0) {
        dic = @{
                @"areaCode": @([[KUserDefults objectForKey:kUserCityID] integerValue]),
                @"id": @([str1 integerValue]),
                @"lat": @([[KUserDefults objectForKey:kLat] integerValue]),
                @"lng": @([[KUserDefults objectForKey:KLng] integerValue]),
                @"logo": portraitUri,
                @"name": name
                };
    }else if (name.length!=0){
        dic = @{
                @"areaCode": @([[KUserDefults objectForKey:kUserCityID] integerValue]),
                @"id": @([str1 integerValue]),
                @"lat": @([[KUserDefults objectForKey:kLat] integerValue]),
                @"lng": @([[KUserDefults objectForKey:KLng] integerValue]),
                @"name": name
                };
    }else if (notice.length!=0){
        dic = @{
                @"areaCode": @([[KUserDefults objectForKey:kUserCityID] integerValue]),
                @"id": @([str1 integerValue]),
                @"lat": @([[KUserDefults objectForKey:kLat] integerValue]),
                @"lng": @([[KUserDefults objectForKey:KLng] integerValue]),
                @"name": name,
                @"notice": notice
                };
    }
    [YSNetworkTool POST:str params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([KString(@"%@", responseObject[@"code"]) isEqualToString:@"SUCCESS"]) {
                            result(YES);
                        } else {
                            result(NO);
                        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        result(NO);
    }];
}

//根据id获取单个群组
- (void)getGroupByID:(NSString *)groupID flag:(int)flag successCompletion:(void (^)(RCDGroupInfo *group))completion {
    NSString * str = flag==1?v1TalentTeamInfo:flag==2?v1ServiceStationInfo:v1UserGroupInfo;
    NSString * str1 = groupID;
    if (flag>0&&flag<3) {
        str1 = [groupID componentsSeparatedByString:@"_"][1];
    }
    [YSNetworkTool POST:str params:@{@"id": str1} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        NSDictionary * result;
        if (flag==2) {
            result = responseObject[@"data"][@"serviceStation"];
        }else if (flag==3){
            result = responseObject[@"data"][@"group"];
        }else{
           result = responseObject[@"data"][@"team"];
        }
        if (result && [code isEqualToString:@"SUCCESS"]) {
            RCDGroupInfo *group = [[RCDGroupInfo alloc] init];
            group.groupId = [result[@"groupId"] description];
            group.groupType = flag;
            group.groupName = [result[@"name"] description];
            group.portraitUri = [result objectForKey:@"logo"]?[result objectForKey:@"logo"]:@"";
            if ([group.portraitUri isKindOfClass:[NSString class]]) {
                if (group.portraitUri.length <= 0) {
                    group.portraitUri = [RCDUtilities defaultGroupPortrait:group];
                }
            }
            group.creatorId = result[@"userId"];
            group.introduce = result[@"notice"];
            NSString * str = flag==3?@"groupUserCount":flag==2?@"serviceStationUserCount":@"teamUserCount";
            group.number = KString(@"%@", responseObject[@"data"][str]);
            group.maxNumber = [result objectForKey:@"max_number"]?[result objectForKey:@"max_number"]:@"1000";
            group.creatorTime = [result objectForKey:@"createTime"];
//            if (![[result objectForKey:@"deletedAt"] isKindOfClass:[NSNull class]]) {
//                group.isDismiss = @"YES";
//            } else {
                group.isDismiss = @"NO";
//            }
            [[RCDataBaseManager shareInstance] insertGroupToDB:group];
            if ([KString(@"%@", group.groupId) isEqualToString:groupID] && completion) {
                completion(group);
            } else if (completion) {
                completion(nil);
            }
        }else {
            if (completion) {
                completion(nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        RCDGroupInfo *group = [[RCDataBaseManager shareInstance] getGroupByGroupId:groupID];
        if (!group.portraitUri || group.portraitUri.length <= 0) {
            group.portraitUri = [RCDUtilities defaultGroupPortrait:group];
        }
        completion(group);
    }];
}

//根据userId获取单个用户信息
- (void)getUserInfoByUserID:(NSString *)userID completion:(void (^)(RCUserInfo *user))completion {
    RCUserInfo *userInfo = [[RCDataBaseManager shareInstance] getUserByUserId:userID];
    if (!userInfo) {
        [YSNetworkTool POST:v1PrivateUserUserinfo params:@{@"id":userID} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
            if (responseObject) {
                NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
                if ([code isEqualToString:@"SUCCESS"]) {
                    NSDictionary *dic = responseObject[@"data"];
                    RCUserInfo *user = [RCUserInfo new];
                    user.userId = [dic[@"id"] description];
                    user.name = [dic[@"nickName"] isKindOfClass:[NSNull class]]?user.userId:dic[@"nickName"];
                    user.portraitUri = [dic[@"headImage"] isKindOfClass:[NSNull class]]?dic[@"headImage"]:@"";
                    if ([YSTools dx_isNullOrNilWithObject:user.portraitUri] || user.portraitUri.length <= 0) {
                        user.portraitUri = [RCDUtilities defaultUserPortrait:user];
                    }
                    [[RCDataBaseManager shareInstance] insertUserToDB:user];
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(user);
                        });
                    }
                } else {
                    RCUserInfo *user = [RCUserInfo new];
                    user.userId = userID;
                    user.name = [NSString stringWithFormat:@"name%@", userID];
                    user.portraitUri = [RCDUtilities defaultUserPortrait:user];
                    
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(user);
                        });
                    }
                }
            } else {
                RCUserInfo *user = [RCUserInfo new];
                user.userId = userID;
                user.name = [NSString stringWithFormat:@"name%@", userID];
                user.portraitUri = [RCDUtilities defaultUserPortrait:user];
                
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(user);
                    });
                }
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"getUserInfoByUserID error");
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    RCUserInfo *user = [RCUserInfo new];
                    user.userId = userID;
                    user.name = [NSString stringWithFormat:@"name%@", userID];
                    user.portraitUri = [RCDUtilities defaultUserPortrait:user];
                    
                    completion(user);
                });
            }
        }];
    }else {
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!userInfo.portraitUri || userInfo.portraitUri.length <= 0) {
                    userInfo.portraitUri = [RCDUtilities defaultUserPortrait:userInfo];
                }
                completion(userInfo);
            });
        }
    }
}

//设置用户头像上传到demo server
- (void)setUserPortraitUri:(NSString *)portraitUri complete:(void (^)(BOOL))result {
//    [AFHttpTool setUserPortraitUri:portraitUri
//        success:^(id response) {
//            if ([response[@"code"] intValue] == 200) {
//                result(YES);
//            } else {
//                result(NO);
//            }
//        }
//        failure:^(NSError *err) {
//            result(NO);
//        }];
}

//获取当前用户所在的所有群组信息
- (void)getMyGroupsWithBlock:(void (^)(NSMutableArray *result))block {
//    [AFHttpTool getMyGroupsSuccess:^(id response) {
//        NSArray *allGroups = response[@"result"];
//        NSMutableArray *tempArr = [NSMutableArray new];
//        if (allGroups) {
//            NSMutableArray *groups = [NSMutableArray new];
//            [[RCDataBaseManager shareInstance] clearGroupfromDB];
//            for (NSDictionary *dic in allGroups) {
//                NSDictionary *groupInfo = dic[@"group"];
//                RCDGroupInfo *group = [[RCDGroupInfo alloc] init];
//                group.groupId = [groupInfo objectForKey:@"id"];
//                group.groupName = [groupInfo objectForKey:@"name"];
//                group.portraitUri = [groupInfo objectForKey:@"portraitUri"];
//                if (!group.portraitUri || group.portraitUri.length == 0) {
//                    group.portraitUri = [RCDUtilities defaultGroupPortrait:group];
//                }
//                group.creatorId = [groupInfo objectForKey:@"creatorId"];
//                //                group.introduce = [dic objectForKey:@"introduce"];
//                if (!group.introduce) {
//                    group.introduce = @"";
//                }
//                group.number = [groupInfo objectForKey:@"memberCount"];
//                group.maxNumber = @"500";
//                if (!group.number) {
//                    group.number = @"";
//                }
//                if (!group.maxNumber) {
//                    group.maxNumber = @"";
//                }
//                [tempArr addObject:group];
//                group.isJoin = YES;
//                [groups addObject:group];
//                //        dispatch_async(
//                //            dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                //              [[RCDataBaseManager shareInstance] insertGroupToDB:group];
//                //            });
//            }
//            [[RCDataBaseManager shareInstance] insertGroupsToDB:groups
//                                                       complete:^(BOOL result) {
//                                                           if (result == YES) {
//                                                               if (block) {
//                                                                   block(tempArr);
//                                                               }
//                                                           }
//                                                       }];
//        } else {
//            block(nil);
//        }
//    }
//        failure:^(NSError *err) {
//            NSMutableArray *tempArr = [[RCDataBaseManager shareInstance] getAllGroup];
//            for (RCDGroupInfo *group in tempArr) {
//                if (!group.portraitUri || group.portraitUri.length <= 0) {
//                    group.portraitUri = [RCDUtilities defaultGroupPortrait:group];
//                }
//            }
//            block(tempArr);
//        }];
}

//根据groupId获取群组成员信息
- (void)getGroupMembersWithGroupId:(NSString *)groupId flag:(int)flag Block:(void (^)(NSMutableArray *result))block {
    __block NSMutableArray *tempArr = [NSMutableArray new];
    NSString * str = flag==1?v1TalentTeamInfo:flag==2?v1ServiceStationInfo:v1UserGroupInfo;
    NSString * str1 = groupId;
    if (flag>0&&flag<3) {
        str1 = [groupId componentsSeparatedByString:@"_"][1];
    }
    [YSNetworkTool POST:str params:@{@"id":str1} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([KString(@"%@", responseObject[@"code"]) isEqualToString:@"SUCCESS"]) {
            NSArray * members;
            if (flag==2) {
                members = responseObject[@"data"][@"serviceStation"][@"users"];
            }else if (flag==3){
                members = responseObject[@"data"][@"group"][@"users"];
            }else{
                members = responseObject[@"data"][@"team"][@"users"];
            }
            for (int i=0; i<[members count]; i++) {
                NSDictionary * dic = members[i];
                RCDUserInfo *member = [[RCDUserInfo alloc] init];
                member.userId = [dic[@"id"] description];
                member.name = [dic[@"nickName"] isKindOfClass:[NSNull class]]?member.userId:[dic[@"nickName"] description];
                member.portraitUri =[dic[@"headImage"] isKindOfClass:[NSNull class]]?@"":dic[@"headImage"];
                member.updatedAt = dic[@"createdAt"]?dic[@"createdAt"]:@"";
                member.displayName = [dic[@"nickName"] description];
                if (!member.portraitUri || member.portraitUri <= 0) {
                    member.portraitUri = [RCDUtilities defaultUserPortrait:member];
                }
                [tempArr addObject:member];
            }
            
        }
        //按加成员入群组时间的升序排列
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            SortForTime *sort = [[SortForTime alloc] init];
            tempArr = [sort sortForUpdateAt:tempArr order:NSOrderedDescending];
            [[RCDataBaseManager shareInstance] insertGroupMemberToDB:tempArr
                                                             groupId:groupId
                                                            complete:^(BOOL result) {
                                                                if (result == YES) {
                                                                    if (block) {
                                                                        block(tempArr);
                                                                    }
                                                                }
                                                            }];
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil);
    }];
}
//加入群组(暂时没有用到这个接口)
- (void)joinGroupWithGroupId:(NSString *)groupID complete:(void (^)(BOOL))result {
//    [AFHttpTool joinGroupWithGroupId:groupID
//        success:^(id response) {
//            if ([response[@"code"] integerValue] == 200) {
//                result(YES);
//            } else {
//                result(NO);
//            }
//        }
//        failure:^(NSError *err) {
//            result(NO);
//        }];
}

//添加群组成员
- (void)addUsersIntoGroup:(NSString *)groupID flag:(int)flag usersId:(NSMutableArray *)usersId complete:(void (^)(BOOL))result {
    NSString * url = flag==1?v1TalentTeamBatchSign:flag==2?v1ServiceStationBatchsign:v1UserGroupBatchSign;
    NSString * str1 = groupID;
    if (flag>0&&flag<3) {
        str1 = [groupID componentsSeparatedByString:@"_"][1];
    }
    [YSNetworkTool POST:url params:@{@"groupId":str1,@"userIds":usersId} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([KString(@"%@", responseObject[@"code"]) isEqualToString:@"SUCCESS"]) {
            result(YES);
        }else
            result(NO);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        result(NO);
    }];
}

//将用户踢出群组
- (void)kickUsersOutOfGroup:(NSString *)groupID flag:(int)flag usersId:(NSMutableArray *)usersId complete:(void (^)(BOOL))result {
//     我的
    NSString * str = flag==1?v1TalentTeamBatchSignOut:flag==2?v1ServiceStationBatchSignOut:v1UserGroupBatchSignOut;
    NSString * str1 = groupID;
    if (flag>0&&flag<3) {
        str1 = [groupID componentsSeparatedByString:@"_"][1];
    }
    [YSNetworkTool POST:str params:@{@"groupId":str1,@"userIds":usersId} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([KString(@"%@", responseObject[@"code"]) isEqualToString:@"SUCCESS"]) {
            result(YES);
        }else
         result(NO);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        result(NO);
    }];
}
//退出群组
- (void)quitGroupWithGroupId:(NSString *)groupID flag:(int)a complete:(void (^)(BOOL))result {
    NSString * url = a==1?v1TalentTeamSignOut:a==2?v1ServiceStationSignOut:v1UserGroupSignout;
    NSString * str1 = groupID;
    if (a>0&&a<3) {
        str1 = [groupID componentsSeparatedByString:@"_"][1];
    }
    [YSNetworkTool POST:url params:@{@"id":str1} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([KString(@"%@", responseObject[@"code"]) isEqualToString:@"SUCCESS"]) {
                            result(YES);
                        } else {
                            result(NO);
                        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        result(NO);
    }];
}

//解散群组
- (void)dismissGroupWithGroupId:(NSString *)groupID flag:(int)flag complete:(void (^)(BOOL))result {
    NSString * url = flag ==1?v1TalentTeamDelete:flag==2?v1ServiceStationDelete:v1UserGroupDelete;
    NSString * str1 = groupID;
    if (flag>0&&flag<3) {
        str1 = [groupID componentsSeparatedByString:@"_"][1];
    }
    [YSNetworkTool POST:url params:@{@"id":str1} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([KString(@"%@", responseObject[@"code"]) isEqualToString:@"SUCCESS"]) {
            result(YES);
        }else{
            result(NO);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        result(NO);
    }];
}

//修改群组名称
- (void)renameGroupWithGoupId:(NSString *)groupID groupName:(NSString *)groupName complete:(void (^)(BOOL))result {
//    [AFHttpTool renameGroupWithGroupId:groupID
//        GroupName:groupName
//        success:^(id response) {
//            if ([response[@"code"] integerValue] == 200) {
//                result(YES);
//            } else {
//                result(NO);
//            }
//        }
//        failure:^(NSError *err) {
//            result(NO);
//        }];
}

- (void)getSquareInfoCompletion:(void (^)(NSMutableArray *result))completion {
//    [AFHttpTool getSquareInfoSuccess:^(id response) {
//        if ([response[@"code"] integerValue] == 200) {
//            completion(response[@"result"]);
//        } else {
//            completion(nil);
//        }
//    }
//        Failure:^(NSError *err) {
//            completion(nil);
//        }];
}

- (void)getFriendscomplete:(void (^)(NSMutableArray *))friendList {
    NSMutableArray *list = [NSMutableArray new];
    [YSNetworkTool POST:v1MyContacts params:@{} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if (((NSArray *)responseObject[@"data"]).count == 0) {
            friendList(nil);
            return;
        }
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if (friendList) {
            if ([code isEqualToString:@"SUCCESS"]) {
                [_allFriends removeAllObjects];
                NSArray *regDataArray = responseObject[@"data"];
                [[RCDataBaseManager shareInstance] clearFriendsData];
                NSMutableArray *userInfoList = [NSMutableArray new];
                NSMutableArray *friendInfoList = [NSMutableArray new];
                for (int i = 0; i < regDataArray.count; i++) {
                    NSDictionary *dic = [regDataArray objectAtIndex:i];
                    if ([dic isKindOfClass:[NSDictionary class]] &&
                        ![KString(@"%@", dic[@"id"]) isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
                        RCDUserInfo *userInfo = [RCDUserInfo new];
                        userInfo.userId = [dic[@"id"] description];
                        userInfo.portraitUri =[dic[@"headImage"] isKindOfClass:[NSNull class]]?@"":[dic[@"headImage"] description];
                        userInfo.displayName = [dic[@"nickName"] description];
                        if (!userInfo.portraitUri || userInfo.portraitUri <= 0) {
                            userInfo.portraitUri = [RCDUtilities defaultUserPortrait:userInfo];
                        }
                        userInfo.friendRemark = [dic[@"friendRemark"] description];
                        userInfo.backGroundImage = dic[@"backgroundImage"];
                        userInfo.mobilePhone = [dic[@"mobile"] description];
                        if ([[dic[@"cityName"] description] containsString:@"null"]) {
                            userInfo.cityName = @"";
                        }else
                        userInfo.cityName = [dic[@"cityName"] description];
                        userInfo.genderName = dic[@"genderName"];
                        userInfo.sign = dic[@"sign"];
                        userInfo.status = [NSString stringWithFormat:@"%@", [dic objectForKey:@"status"]];
                        userInfo.updatedAt = [NSString stringWithFormat:@"%@", [dic objectForKey:@"updatedAt"]];
                        NSString * str = @"";
                        if ([userInfo.friendRemark containsString:@"null"]||userInfo.friendRemark.length==0) {
                            if ([userInfo.displayName containsString:@"null"]||userInfo.displayName.length==0) {
                                str = userInfo.userId;
                            }else
                                str = userInfo.displayName;
                        }else
                            str = userInfo.friendRemark;
                        userInfo.name = str;
                        [list addObject:userInfo];
                        [_allFriends addObject:userInfo];
                        
                        RCUserInfo *user = [RCUserInfo new];
                        user.userId = userInfo.userId;
                        user.name = dic[@"nickName"];
                        user.portraitUri = dic[@"headImage"];
                        if (!user.portraitUri || user.portraitUri <= 0) {
                            user.portraitUri = [RCDUtilities defaultUserPortrait:user];
                        }
                        [userInfoList addObject:user];
                        [friendInfoList addObject:userInfo];
                    }
                }
                [[RCDataBaseManager shareInstance] insertUserListToDB:userInfoList
                                                             complete:^(BOOL result){
                                                                 
                                                             }];
                [[RCDataBaseManager shareInstance]
                 insertFriendListToDB:friendInfoList
                 complete:^(BOOL result) {
                     if (result == YES) {
                         dispatch_async(dispatch_get_main_queue(), ^(void) {
                             friendList(list);
                         });
                     }
                 }];
            } else {
                friendList(list);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (friendList) {
            NSMutableArray *cacheList =
            [[NSMutableArray alloc] initWithArray:[[RCDataBaseManager shareInstance] getAllFriends]];
            for (RCDUserInfo *userInfo in cacheList) {
                if (!userInfo.portraitUri || userInfo.portraitUri <= 0) {
                    userInfo.portraitUri = [RCDUtilities defaultUserPortrait:userInfo];
                }
            }
            friendList(cacheList);
        }
    }];
}

- (void)searchUserByPhone:(NSString *)phone complete:(void (^)(NSMutableArray *))userList {
    NSMutableArray *list = [NSMutableArray new]; 
    [YSNetworkTool POST:v1PrivateUserSearch params:@{@"keyword":KString(@"%@", phone)} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if (userList && [KString(@"%@", responseObject[@"code"]) isEqualToString:@"SUCCESS"]){
            id result = responseObject[@"data"];
            if ([result respondsToSelector:@selector(intValue)])
                return;
            if ([result respondsToSelector:@selector(objectForKey:)]) {
                RCDUserInfo *userInfo = [RCDUserInfo new];
                userInfo.userId = [result[@"id"] isKindOfClass:[NSNull class]]?@"":[result[@"id"] description];
                userInfo.name = [result[@"nickName"] isKindOfClass:[NSNull class]]?userInfo.userId:[result[@"nickName"] description];
                userInfo.portraitUri = [result[@"headImage"] isKindOfClass:[NSNull class]]?@"":[result[@"headImage"] description];
                if (!userInfo.portraitUri || userInfo.portraitUri <= 0) {
                    userInfo.portraitUri = [RCDUtilities defaultUserPortrait:userInfo];
                }
                [list addObject:userInfo];
                userList(list);
            }
        } else if (userList) {
            userList(nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        userList(nil);
    }];
}

- (void)requestFriend:(NSString *)userId complete:(void (^)(BOOL))result {
    [YSNetworkTool POST:v1ApplicationAdd params:@{@"friendId":userId} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            result(YES);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (result) {
            result(NO);
        }
    }];
}

- (void)processInviteFriendRequest:(NSString *)userId complete:(void (^)(BOOL))result {
    [YSNetworkTool POST:v1ApplicationAgree params:@{@"id":userId} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([KString(@"%@", responseObject[@"code"]) isEqualToString:@"SUCCESS"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
            });
        }else{
            result(NO);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        result(NO);
    }];
}

- (void)AddToBlacklist:(NSString *)userId complete:(void (^)(BOOL result))result {
//    [AFHttpTool addToBlacklist:userId
//        success:^(id response) {
//            NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
//            if (result && [code isEqualToString:@"200"]) {
//                result(YES);
//            } else if (result) {
//                result(NO);
//            }
//        }
//        failure:^(NSError *err) {
//            if (result) {
//                result(NO);
//            }
//        }];
}

- (void)RemoveToBlacklist:(NSString *)userId complete:(void (^)(BOOL result))result {
//    [AFHttpTool removeToBlacklist:userId
//        success:^(id response) {
//            NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
//            if (result && [code isEqualToString:@"200"]) {
//                result(YES);
//            } else if (result) {
//                result(NO);
//            }
//        }
//        failure:^(NSError *err) {
//            if (result) {
//                result(NO);
//            }
//        }];
}

- (void)getBlacklistcomplete:(void (^)(NSMutableArray *))blacklist {
//    [AFHttpTool getBlacklistsuccess:^(id response) {
//        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
//        if (blacklist && [code isEqualToString:@"200"]) {
//            NSMutableArray *result = response[@"result"];
//            blacklist(result);
//        } else if (blacklist) {
//            blacklist(nil);
//        }
//    }
//        failure:^(NSError *err) {
//            if (blacklist) {
//                blacklist(nil);
//            }
//        }];
}

- (void)updateName:(NSString *)userName success:(void (^)(id response))success failure:(void (^)(NSError *err))failure {
//    [AFHttpTool updateName:userName
//        success:^(id response) {
//            success(response);
//        }
//        failure:^(NSError *err) {
//            failure(err);
//        }];
}

- (void)updateUserInfo:(NSString *)userID
               success:(void (^)(RCDUserInfo *user))success
               failure:(void (^)(NSError *err))failure {
    [YSNetworkTool POST:v1PrivateUserUserinfo params:@{@"id":userID} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([KString(@"%@", responseObject[@"code"]) isEqualToString:@"SUCCESS"]) {
            NSDictionary *dic = responseObject[@"data"];
            RCUserInfo *user = [RCUserInfo new];
            user.userId = [dic[@"id"] description];
            user.name = [dic[@"nickName"] isKindOfClass:[NSNull class]]?user.userId:dic[@"nickName"];
            NSString *portraitUri = [dic[@"headImage"] isKindOfClass:[NSNull class]]?@"":dic[@"headImage"];
            if (!portraitUri || portraitUri.length <= 0) {
                portraitUri = [RCDUtilities defaultUserPortrait:user];
            }
            user.portraitUri = portraitUri;
            [[RCDataBaseManager shareInstance] insertUserToDB:user];
            
            RCDUserInfo *Details = [[RCDataBaseManager shareInstance] getFriendInfo:userID];
            if (Details == nil) {
                Details = [[RCDUserInfo alloc] init];
            }
            Details.friendRemark = [dic[@"friendRemark"] description];
            Details.mobilePhone = [dic[@"mobile"] description];
            Details.cityName = [dic[@"cityName"] description];
            Details.backGroundImage = [dic[@"backgroundImage"] description];
            Details.sign = [dic[@"sign"] description];
            Details.isFriend = [dic[@"isFriend"] description];
            Details.cityName = [dic[@"cityName"] description];
            Details.genderName = dic[@"genderName"];
            Details.sign = dic[@"sign"];
            Details.status = [NSString stringWithFormat:@"%@", [dic objectForKey:@"status"]];
            Details.updatedAt = [NSString stringWithFormat:@"%@", [dic objectForKey:@"updatedAt"]];
            NSString * str = @"";
            if ([Details.friendRemark containsString:@"null"]||Details.friendRemark.length==0) {
                if ([Details.displayName containsString:@"null"]||Details.displayName.length==0) {
                    str = Details.userId;
                }else
                    str = Details.displayName;
            }else
                str = Details.friendRemark;
            Details.name = str;
            Details.portraitUri = portraitUri;
            Details.displayName = Details.name;
            [[RCDataBaseManager shareInstance] insertFriendToDB:Details];
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(Details);
                });
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
 
}

- (void)uploadImageToQiNiu:(NSString *)userId
                 ImageData:(NSData *)image
                   success:(void (^)(NSString *url))success
                   failure:(void (^)(NSError *err))failure {
}

- (void)getVersioncomplete:(void (^)(NSDictionary *))versionInfo {
//    [AFHttpTool getVersionsuccess:^(id response) {
//        if (response) {
//            NSDictionary *iOSResult = response[@"iOS"];
//            NSString *sealtalkBuild = iOSResult[@"build"];
//            NSString *applistURL = iOSResult[@"url"];
//
//            NSDictionary *result;
//            NSString *currentBuild = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//
//            NSDate *currentBuildDate = [self stringToDate:currentBuild];
//            NSDate *buildDtate = [self stringToDate:sealtalkBuild];
//            NSTimeInterval secondsInterval = [currentBuildDate timeIntervalSinceDate:buildDtate];
//            if (secondsInterval < 0) {
//                result =
//                    [NSDictionary dictionaryWithObjectsAndKeys:@"YES", @"isNeedUpdate", applistURL, @"applist", nil];
//            } else {
//                result = [NSDictionary dictionaryWithObjectsAndKeys:@"NO", @"isNeedUpdate", nil];
//            }
//            versionInfo(result);
//        }
//    }
//        failure:^(NSError *err) {
//            versionInfo(nil);
//        }];
}
- (NSDate *)stringToDate:(NSString *)build {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
    NSDate *date = [dateFormatter dateFromString:build];
    return date;
}

//设置好友备注
- (void)setFriendDisplayName:(NSString *)friendId displayName:(NSString *)displayName complete:(void (^)(BOOL))result {
//    [AFHttpTool setFriendDisplayName:friendId
//        displayName:displayName
//        success:^(id response) {
//            if ([response[@"code"] integerValue] == 200) {
//                result(YES);
//            } else {
//                result(NO);
//            }
//        }
//        failure:^(NSError *err) {
//            result(NO);
//        }];
}

//获取用户详细资料
- (void)getFriendDetailsWithFriendId:(NSString *)friendId
                             success:(void (^)(RCDUserInfo *user))success
                             failure:(void (^)(NSError *err))failure {
    [YSNetworkTool POST:v1PrivateUserUserinfo params:@{@"id":friendId} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([KString(@"%@", responseObject[@"code"]) isEqualToString:@"SUCCESS"]) {
            NSDictionary * dic = responseObject[@"data"];
            RCUserInfo *user = [RCUserInfo new];
            user.userId = [dic[@"id"] description];
            user.name = [dic[@"nickName"] isKindOfClass:[NSNull class]]?user.userId:dic[@"nickName"];
            NSString *portraitUri = [dic[@"headImage"] isKindOfClass:[NSNull class]]?@"":dic[@"headImage"];
            if ([portraitUri isKindOfClass:[NSNull class]]||!portraitUri || (![portraitUri isKindOfClass:[NSNull class]]&&portraitUri.length <= 0)) {
                portraitUri = [RCDUtilities defaultUserPortrait:user];
            }
            user.portraitUri = portraitUri;
            [[RCDataBaseManager shareInstance] insertUserToDB:user];
            RCDUserInfo *Details = [[RCDataBaseManager shareInstance] getFriendInfo:friendId];
            if (Details == nil) {
                Details = [[RCDUserInfo alloc] init];
            }
            Details.userId = user.userId;
            Details.name = [dic[@"nickName"] isKindOfClass:[NSNull class]]?user.userId:dic[@"nickName"];;
            Details.portraitUri = portraitUri;
            Details.displayName = Details.name;
            [[RCDataBaseManager shareInstance] insertFriendToDB:Details];
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(Details);
                });
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);

    }];
}

@end
