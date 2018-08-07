//
//  friendMo.h
//  ConnectionCity
//
//  Created by qt on 2018/7/18.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"
#import "UserMo.h"
#import "privateUserInfoModel.h"
#import "groupMo.h"
@interface friendMo : BaseModel
proStr(userId);
proStr(friendId);//朋友ID
proStr(groupId);//首页群ID
proStr(teamId);//团队ID
proStr(stationId);//服务站ID
proStr(type);
proStr(des);
@property (nonatomic,strong) groupMo * group;//群组model
@property (nonatomic,strong) UserMo * user;//朋友的user
@end

