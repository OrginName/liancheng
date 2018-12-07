//
//  GZMo.h
//  ConnectionCity
//
//  Created by qt on 2018/12/6.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"

@interface GZMo : BaseModel
proStr(ID);
proStr(mobile);
proStr(realName);
proStr(nickName);
proStr(headImage);
proStr(age);
proStr(distance);
proArr(serviceCircleList);
@end

@interface CircleListMo : BaseModel
proStr(ID);
proStr(userId);
proStr(content);
proStr(images);
proStr(createTime);
proStr(nickName);
proStr(headImage);
proStr(distance);
proDoub(rowHeight);//行高
proDoub(SJHeight);//实际行高
@property (nonatomic,assign) BOOL isOpen;//是否展开
@end
