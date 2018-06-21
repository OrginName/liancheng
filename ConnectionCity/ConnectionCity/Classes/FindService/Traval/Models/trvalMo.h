//
//  trvalMo.h
//  ConnectionCity
//
//  Created by qt on 2018/6/16.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"
#import "UserMo.h"
@interface trvalMo : BaseModel
proStr(ID);
proStr(userId);
proStr(images);//图片
proStr(cityCode);
proStr(cityName);
proStr(introduce);
proStr(price);
proStr(type);
proStr(comments);
proDic(user);
proStr(departTimeName);//出发时间
proStr(description1);//旅行说明
proStr(inviteObjectName);//邀约对象
proStr(longTimeName);//旅行时长
proStr(placeTravel);//旅行去哪
proStr(travelFeeName);//旅行话费
proStr(travelModeName);//出行方式
@property (nonatomic,strong) UserMo * user1;
@end

