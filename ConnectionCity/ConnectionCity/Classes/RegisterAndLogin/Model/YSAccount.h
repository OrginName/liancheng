//
//  YSAccount.h
//  dumbbell
//
//  Created by JYS on 17/3/5.
//  Copyright © 2017年 insaiapp. All rights reserved.
//

#import "BaseModel.h"

@interface YSAccount : BaseModel <NSCoding>
/** 用户id */
proStr(userId)
/** TOKEN令牌 */
proStr(token)

@end
