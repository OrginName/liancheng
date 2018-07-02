//
//  AccountPageMo.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/2.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"

@interface AccountPageMo : BaseModel
/** <#userId描述#> */
@property (nonatomic, assign) NSInteger userId;
/** <#accountName描述#> */
@property (nonatomic, copy) NSString *accountName;
/** <#accountType描述#> */
@property (nonatomic, copy) NSString *accountType;
/** <#accountNumber描述#> */
@property (nonatomic, copy) NSString *accountNumber;
/** <#bankName描述#> */
@property (nonatomic, copy) NSString *bankName;
/** <#code描述#> */
@property (nonatomic, copy) NSString *code;
/** <#accountTypeName描述#> */
@property (nonatomic, copy) NSString *accountTypeName;

@end
