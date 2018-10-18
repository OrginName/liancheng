//
//  OrderMo.h
//  ConnectionCity
//
//  Created by qt on 2018/10/18.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"

@interface OrderMo : BaseModel
proStr(title);
proStr(ID);
proStr(userId);
proStr(industryCategoryParentId);
proStr(industryCategoryParentName);
proStr(content);
proStr(tenderImages);
proStr(tenderStartDate);
proStr(tenderEndDate);
proStr(amount);
proStr(contactName);
proStr(contactMobile);
proStr(periodAmount1);
proStr(payStatus1);
proStr(periodAmount2);
proStr(payStatus2);
proStr(periodAmount3);
proStr(payStatus3);
proStr(periodAmount4);
proStr(payStatus4);
proStr(periodAmount5);
proStr(payStatus5);
proStr(status);
proStr(depositAmount);
ProMutArr(fq);//分期数ARR
@end

@interface OrderMoFQ : BaseModel
proStr(amount);
proStr(name);
proStr(FQstatus);
@end
