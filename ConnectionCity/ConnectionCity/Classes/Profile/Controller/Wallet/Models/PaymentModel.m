//
//  PaymentModel.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/24.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "PaymentModel.h"

@implementation PaymentModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"modelId":@"id",@"descriptionModel":@"description"};
}

@end
