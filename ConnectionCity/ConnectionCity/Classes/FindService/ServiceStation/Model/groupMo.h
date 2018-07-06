//
//  groupMo.h
//  ConnectionCity
//
//  Created by umbrella on 2018/7/6.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"

@interface groupMo : BaseModel
proStr(ID);
proStr(name);
proStr(userId);
proStr(createTime);
proStr(logo);
proStr(notice);
proStr(type);
proStr(lng);
proStr(lat);
proArr(userList);
proStr(cityName);
proStr(cityCode);
@end
