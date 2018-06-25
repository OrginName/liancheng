//
//  AllDicMo.h
//  ConnectionCity
//
//  Created by qt on 2018/6/25.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"
@interface AllDicMo : BaseModel<NSCoding>

proStr(ID);
proStr(code);
proStr(name);
proStr(content);
ProMutArr(contentArr);
@end

@interface AllContentMo : BaseModel<NSCoding>
proStr(value);
proStr(description1);
@end
