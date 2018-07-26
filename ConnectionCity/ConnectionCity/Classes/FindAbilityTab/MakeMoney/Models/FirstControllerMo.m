//
//  FirstControllerMo.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/30.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FirstControllerMo.h"

@implementation FirstControllerMo
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"modelId":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"user":[UserMo class],@"tenderRecords":[TenderRecordsMo class]};
}

@end
