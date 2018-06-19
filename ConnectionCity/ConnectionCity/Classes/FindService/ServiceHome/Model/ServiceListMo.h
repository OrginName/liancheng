//
//  ServiceListMo.h
//  ConnectionCity
//
//  Created by umbrella on 2018/6/19.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"
#import "trvalMo.h"
#import "UserMo.h"
@interface ServiceListMo : BaseModel
proStr(ID);
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
@property (nonatomic,strong) UserMo * user1;
proDic(user);
@end
