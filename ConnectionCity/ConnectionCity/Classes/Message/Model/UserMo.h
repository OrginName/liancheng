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
proStr(isCompanyAuth);
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
proStr(resumeId);//简历ID
ProMutArr(JNArr);//技能包数组
proArr(serviceCircleList);//当前好友的服务圈
ProMutArr(serviceList);//当前人的服务列表
ProMutArr(resumeList);//当前人的简历列表
proStr(hasResume);//是否有简历
proStr(hasService);//是否有服务
@end
