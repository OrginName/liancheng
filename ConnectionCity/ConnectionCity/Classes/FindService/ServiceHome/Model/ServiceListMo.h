//
//  ServiceListMo.h
//  ConnectionCity
//
//  Created by umbrella on 2018/6/19.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"
#import "UserMo.h"
@interface ServiceListMo : BaseModel
proArr(propertyNameArr);//每个type下的property名字
proArr(typeNameArr);//每个type
proStr(ID);
proStr(likeCount);
proStr(images);
proStr(title);
proStr(serviceCategoryId);
proStr(property);
proStr(introduce);
proStr(price);
proStr(type);
proStr(content);
proStr(lng);
proStr(lat);
proStr(cityName);
proStr(cityCode);
proStr(areaName);
proStr(areaCode);
proStr(typeName);
proStr(browseTimes);
proDic(user);
proArr(commentList);
proArr(comments);
proStr(score);
proDic(serviceCategoryName);
proArr(serviceCircleList);//圈子
proArr(browserList);//浏览访客List
proStr(browserCount);//访客数
proStr(orderCount);//应邀订单数
proArr(imageArr);//浏览的访客图片数
@property (nonatomic,strong) UserMo * user1;
@end

@interface commentList : BaseModel
proStr(ID);
proStr(userId);
proStr(score);
proStr(content);
proStr(createTime);
proArr(replyList);//回复列表
@property (nonatomic,assign)CGFloat cellHeight;
@property (nonatomic,strong)UserMo * user;
@end

