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
proInt(userid)
/** 用户昵称 */
proStr(useraccount)
/** 密码 */
proStr(accountpass)
/** 身份证号 */
proStr(identification)
/** 手机号 */
proStr(phone)
/** 出生日期 */
proStr(birthday)
/** 真实姓名 */
proStr(realname)
/** 最后一次检测护颈枕id */
proStr(pillowid)
/** 最后一次检测时间 */
proStr(lasttime)
/** 性别 */
proStr(gender)
/** 身高 */
proDoub(height)
/** 体重 */
proDoub(weight)
/** 头像地址 */
proStr(image)

@end
