//
//  CollectionMo.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/4.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "CollectionMo.h"

@implementation CollectionMo
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"modelId":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"obj":[CollectionObjMo class]};
}

@end
