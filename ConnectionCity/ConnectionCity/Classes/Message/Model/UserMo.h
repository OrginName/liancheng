//
//  UserMo.h
//  ConnectionCity
//
//  Created by umbrella on 2018/6/19.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"

@interface UserMo : BaseModel<NSCoding> 
proStr(age);
proStr(isBlack);
proStr(isMobileAuth);//手机认证
proStr(isSkillAuth);//技能认证
proStr(isIdentityAuth);//身份证认证
proStr(isFriend);//是否是好友
proStr(commonFriendCount);//共同好友数
proStr(areaCode);
proStr(areaName);
proStr(backgroundImage);
proStr(balance);
proStr(cityCode);
proStr(cityName);
proStr(distance);
proStr(educationId);
proStr(friendRemark);
proStr(educationName);
proStr(gender);
proStr(sign);
proStr(headImage);
proStr(height);
proStr(ID);
proStr(lat);
proStr(lng);
proStr(loginTime);
proStr(mobile);
proStr(nickName);
proStr(occupationCategoryId);
proDic(occupationCategoryName);
proStr(status);
proStr(weight);
proStr(realName);
proStr(marriage);
proStr(marriageName);

@end
