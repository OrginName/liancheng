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
@interface friendMo : BaseModel

proStr(userId);
proStr(friendId);
@property (nonatomic,strong)UserMo * user;//朋友的user
@end
