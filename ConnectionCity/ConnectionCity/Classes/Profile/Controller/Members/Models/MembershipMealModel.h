//
//  MembershipMealModel.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/23.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"

@interface MembershipMealModel : BaseModel
/** <#id描述#> */
@property (nonatomic, copy) NSString *modelId;
/** <#logo描述#> */
@property (nonatomic, copy) NSString *logo;
/** <#remark描述#> */
@property (nonatomic, copy) NSString *remark;
/** <#membershipId描述#> */
@property (nonatomic, assign) NSInteger membershipId;
/** <#rangeNumber描述#> */
@property (nonatomic, assign) NSInteger rangeNumber;
/** <#title描述#> */
@property (nonatomic, copy) NSString *title;
/** <#price描述#> */
@property (nonatomic, copy) NSString *price;
/** <#isValid描述#> */
@property (nonatomic, assign) NSInteger isValid;
/** <#sort描述#> */
@property (nonatomic, assign) NSInteger sort;

@end
