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
proStr(typeName);//单位
@property (nonatomic,strong) UserMo * user;
@property (nonatomic,strong) ServiceCategoryNameModel * serviceCategoryName;
@end
