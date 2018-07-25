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
proStr(title);
proStr(type);
proStr(typeName);
proStr(sendUserId);
proStr(ID);
@property (nonatomic,strong)UserMo * user;
@end
