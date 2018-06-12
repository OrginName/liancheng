//
//  CityMo.h
//  ConnectionCity
//
//  Created by umbrella on 2018/6/12.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"

@interface CityMo : BaseModel

proStr(ID);//ID
proStr(parentId);//
proStr(initial);//首字母
proStr(name);//城市
proStr(fullName);//城市全名
proStr(lat);//经度
proStr(lng);//纬度
proStr(pinyin);//拼音
proStr(cidx);
proArr(childs);//区县数组
@end
