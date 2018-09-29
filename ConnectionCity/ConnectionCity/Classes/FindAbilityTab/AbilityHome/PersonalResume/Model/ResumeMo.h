//
//  ResumeMo.h
//  ConnectionCity
//
//  Created by umbrella on 2018/5/13.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"
#import "UserMo.h"
@class WorkMo;
@interface ResumeMo : BaseModel
proStr(eduID);//学校ID
proStr(collAndcompany);//学校
proStr(proAndPro);//专业行业
proStr(XLAndIntro);//学历
proStr(satrtTime);//开始时间
proStr(endTime);//结束时间
proStr(description1);
proArr(EditArr);
proArr(CollArr);
proStr(ID);
@end

