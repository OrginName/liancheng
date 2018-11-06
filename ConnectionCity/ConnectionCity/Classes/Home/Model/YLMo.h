//
//  YLMo.h
//  ConnectionCity
//
//  Created by qt on 2018/11/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"
#import "UserMo.h"
@interface YLMo : BaseModel
proStr(areaCode);
proStr(browseTimes);
proStr(cityCode);
proStr(cityName);
proStr(content);
proStr(ID);
proStr(images);
proStr(introduce);
proStr(likeCount);
proStr(price);
proStr(property);
proStr(serviceCategoryId);
proDic(serviceCategoryName);
proStr(typeName);
proStr(type);
proStr(userId);
@property (nonatomic,strong) UserMo * user;
@end
