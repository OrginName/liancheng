//
//  myServiceMo.h
//  ConnectionCity
//
//  Created by qt on 2018/7/15.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"
#import "UserMo.h"
#import "ServiceCategoryNameModel.h"
@class myServiceObj;
@interface myServiceMo : BaseModel
proStr(ID);//当前服务ID
proStr(address);//服务地址
proStr(userId);//接单者的userID
proStr(orderNo);//订单号
proStr(serviceTime);//服务时间
proStr(num);//数量
proStr(typeName);//类型
@property (nonatomic,strong) UserMo * reserveUser;
@property (nonatomic,strong) myServiceObj * obj;
@end

@interface myServiceObj: BaseModel
proStr(ID);//
proStr(title);
proStr(introduce);
proStr(price);
proStr(content);
proStr(cityName);
proArr(commentList);//评论
proArr(comments);//评论
proStr(typeName);//单位
proStr(priceUnit);//陪游单位
proStr(userId);
@property (nonatomic,strong) UserMo * user;
@property (nonatomic,strong) ServiceCategoryNameModel * serviceCategoryName;
@end

@interface ObjComment: BaseModel
proStr(content);
proStr(ID);
proArr(replyList);//回复列表
proStr(score);
proStr(typeName);
proStr(createTime);
proStr(orderNo);
@property (nonatomic,strong) UserMo * user;
@property (nonatomic,assign) CGFloat cellHeight;
@end
