//
//  trvalMo.h
//  ConnectionCity
//
//  Created by qt on 2018/6/16.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"
@class userMo;
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
@property (nonatomic,strong) userMo * user1;
@end

@interface userMo : BaseModel
proStr(ID);
proStr(mobile);
proStr(realName);
proStr(nickName);
proStr(headImage);
proStr(age);
proStr(status);
proStr(gender);
proStr(lng);
proStr(lat);
proStr(cityCode);
@end
