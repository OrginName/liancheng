//
//  TransactionRecordMo.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/24.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "TransactionRecordMo.h"

@implementation TransactionRecordMo
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"paymentList":@"payment"};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"paymentList":[PaymentModel class]};
}

@end
