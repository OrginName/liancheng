//
//  KissModel.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/8/18.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"
#import "UserMo.h"
@interface KissModel : BaseModel
proStr(closeUserId)
proStr(createTime)
proStr(modelId)
proDoub(incomeAmount)
proStr(lockPassword)
proStr(rate)
proStr(updateTime)
proStr(userId)
proStr(workPeriod)
proStr(workTime)
proStr(accountCount);//开通人数
proStr(totalAmount);//总收益
@property (nonatomic,strong) UserMo * user;
@end
