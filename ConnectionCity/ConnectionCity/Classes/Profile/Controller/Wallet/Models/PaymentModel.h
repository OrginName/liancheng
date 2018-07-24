//
//  PaymentModel.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/24.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"

@interface PaymentModel : BaseModel
/** <#id描述#> */
@property (nonatomic, copy) NSString *modelId;
/** <#userId描述#> */
@property (nonatomic, copy) NSString *userId;
/** <#orderNo描述#> */
@property (nonatomic, copy) NSString *orderNo;
/** <#tradeNo描述#> */
@property (nonatomic, copy) NSString *tradeNo;
/** <#tradeSubject描述#> */
@property (nonatomic, copy) NSString *tradeSubject;
/** <#tradeBody描述#> */
@property (nonatomic, copy) NSString *tradeBody;
/** <#type描述#> */
@property (nonatomic, copy) NSString *type;
/** <#description描述#> */
@property (nonatomic, copy) NSString *descriptionModel;
/** <#amount描述#> */
@property (nonatomic, copy) NSString *amount;
/** <#status描述#> */
@property (nonatomic, copy) NSString *status;
/** <#createTime描述#> */
@property (nonatomic, copy) NSString *createTime;
/** <#payMethod描述#> */
@property (nonatomic, copy) NSString *payMethod;
/** <#remark描述#> */
@property (nonatomic, copy) NSString *remark;
/** <#payAccount描述#> */
@property (nonatomic, copy) NSString *payAccount;

@end
