//
//  orderListModel.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/8/4.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"

@interface orderListModel : BaseModel
/** <#refundAmount描述#> */
@property (nonatomic, copy) NSString *refundAmount;
/** <#ip描述#> */
@property (nonatomic, copy) NSString *ip;
/** <#tradeNo描述#> */
@property (nonatomic, copy) NSString *tradeNo;
/** <#status描述#> */
@property (nonatomic, assign) NSInteger status;
/** <#amount描述#> */
@property (nonatomic, copy) NSString *amount;
/** <#cancelUserId描述#> */
@property (nonatomic, copy) NSString *cancelUserId;
/** <#reserveUser描述#> */
@property (nonatomic, copy) NSString *reserveUser;
/** <#typeName描述#> */
@property (nonatomic, copy) NSString *typeName;
/** <#updateTime描述#> */
@property (nonatomic, copy) NSString *updateTime;
/** <#typeIndex描述#> */
@property (nonatomic, assign) NSInteger typeIndex;
/** <#payUserId描述#> */
@property (nonatomic, assign) NSInteger payUserId;
/** <#isRefund描述#> */
@property (nonatomic, copy) NSString *isRefund;
/** <#refundNo描述#> */
@property (nonatomic, copy) NSString *refundNo;
/** <#type描述#> */
@property (nonatomic, assign) NSInteger type;
/** <#id描述#> */
@property (nonatomic, copy) NSString *modelId;
/** <#providerId描述#> */
@property (nonatomic, copy) NSString *providerId;
/** <#orderNo描述#> */
@property (nonatomic, copy) NSString *orderNo;
/** <#num描述#> */
@property (nonatomic, assign) NSInteger num;
/** <#obj描述#> */
@property (nonatomic, copy) NSString *obj;
/** <#commentStatus描述#> */
@property (nonatomic, assign) NSInteger commentStatus;
/** <#serviceTime描述#> */
@property (nonatomic, copy) NSString *serviceTime;
/** <#payStatus描述#> */
@property (nonatomic, assign) NSInteger payStatus;
/** <#refundTime描述#> */
@property (nonatomic, copy) NSString *refundTime;
/** <#typeId描述#> */
@property (nonatomic, assign) NSInteger typeId;
/** <#createTime描述#> */
@property (nonatomic, copy) NSString *createTime;
/** <#remark描述#> */
@property (nonatomic, copy) NSString *remark;
/** <#finishTime描述#> */
@property (nonatomic, copy) NSString *finishTime;
/** <#address描述#> */
@property (nonatomic, copy) NSString *address;
/** <#userId描述#> */
@property (nonatomic, assign) NSInteger userId;

@end
