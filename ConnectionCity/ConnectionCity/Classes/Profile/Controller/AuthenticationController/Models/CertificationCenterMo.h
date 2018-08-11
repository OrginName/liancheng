//
//  CertificationCenterMo.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/25.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"

@interface CertificationCenterMo : BaseModel
/** <#mobileValidate描述#> */
@property (nonatomic, copy) NSString *mobileValidate;
/** <#mobile描述#> */
@property (nonatomic, copy) NSString *mobile;
/** <#mobileInfo描述#> */
@property (nonatomic, copy) NSString *mobileInfo;
/** <#identityValidate描述#> */
@property (nonatomic, copy) NSString *identityValidate;
/** <#identity描述#> */
@property (nonatomic, copy) NSString *identity;
/** <#identityInfo描述#> */
@property (nonatomic, copy) NSString *identityInfo;
/** <#skillInfo描述#> */
@property (nonatomic, copy) NSString *skillInfo;
/** <#skills描述#> */
@property (nonatomic, strong) NSArray *skillss;
@property (nonatomic, copy) NSString * isCompanyAuth;
@end
