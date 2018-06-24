//
//  MemberRenewalM.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/23.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"
#import "MembershipMealModel.h"

@interface MemberRenewalM : BaseModel
/** <#id描述#> */
@property (nonatomic, assign) NSInteger modelId;
/** <#name描述#> */
@property (nonatomic, copy) NSString *name;
/** <#logo描述#> */
@property (nonatomic, copy) NSString *logo;
/** <#description描述#> */
@property (nonatomic, copy) NSString *modelDescription;
/** <#remark描述#> */
@property (nonatomic, copy) NSString *remark;
/** <#membershipMeals描述#> */
@property (nonatomic, strong) NSArray<MembershipMealModel *> *membershipMeals;

@end
