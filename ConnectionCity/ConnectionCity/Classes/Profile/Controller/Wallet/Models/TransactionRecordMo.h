//
//  TransactionRecordMo.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/24.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"
#import "PaymentModel.h"

@interface TransactionRecordMo : BaseModel
/** <#totalIncome描述#> */
@property (nonatomic, copy) NSString *totalIncome;
/** <#totalPay描述#> */
@property (nonatomic, copy) NSString *totalPay;
/** <#payment描述#> */
@property (nonatomic, strong) NSArray<PaymentModel *> *paymentList;

@end
