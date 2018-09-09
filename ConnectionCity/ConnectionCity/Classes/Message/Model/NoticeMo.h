//
//  NoticeMo.h
//  ConnectionCity
//
//  Created by qt on 2018/7/25.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"
#import "UserMo.h"
@interface NoticeMo : BaseModel
proStr(isImportant);
proStr(isValid);
proStr(receiveUserId);
proStr(title);//滚动标题
proStr(type);
proStr(typeName);
proStr(sendUserId);
proStr(ID);
proStr(content);
proStr(url);//跳转链接
@property (nonatomic,strong)UserMo * user;
@end
