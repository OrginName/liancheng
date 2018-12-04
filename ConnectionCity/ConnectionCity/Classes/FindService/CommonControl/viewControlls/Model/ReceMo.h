//
//  ReceMo.h
//  ConnectionCity
//
//  Created by qt on 2018/12/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"
#import "UserMo.h"
@interface ReceMo : BaseModel
proArr(activityList);//显示活动列表
proArr(bannerList);//广告列表
proArr(hotServiceList);//热门服务列表
proArr(nearbyPage);//附近动态
ProMutArr(circleList);//附近的人的圈子列表
@end

@interface ActivityMo : BaseModel
proStr(ID);
proStr(sort);
proStr(title);
proStr(url);
@end

@interface HotServiceMo : BaseModel
proStr(ID);
proStr(browseTimes);
proStr(cityCode);
proStr(cityName);
proStr(images);
proStr(introduce);
proStr(price);
proStr(typeName);
proStr(userId);
@property (nonatomic,strong)UserMo * user;
@end

@interface NearByMo : BaseModel
proStr(ID);
proStr(backgroundImage);
proStr(distance);
proStr(headImage);
proStr(genderName);
proStr(realName);
proStr(gender);
proStr(age);
proStr(nickName);
proArr(serviceCircleList);//朋友圈列表
proArr(serviceCircleListMo);//朋友圈列表Model
@end


@interface TTMo : BaseModel
proStr(ID);
proStr(title);
proStr(userId);
proStr(nickName);
proStr(headImage);
proStr(providerId);
proStr(providerNickName);
proStr(providerHeadImage);
proStr(createTime);
proStr(XSStr);//拼接好要显示字符 
@end


