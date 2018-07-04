//
//  ServiceCategoryNameModel.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/4.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"

@interface ServiceCategoryNameModel : BaseModel
/** <#name描述#> */
@property (nonatomic, copy) NSString *name;
/** <#parentName描述#> */
@property (nonatomic, copy) NSString *parentName;

@end
