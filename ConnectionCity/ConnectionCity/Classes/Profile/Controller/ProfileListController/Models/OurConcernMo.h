//
//  OurConcernMo.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"

@interface OurConcernMo : BaseModel
/** <#id描述#> */
@property (nonatomic, copy) NSString *modelId;
/** <#userId描述#> */
@property (nonatomic, assign) NSInteger userId;
/** <#type描述#> */
@property (nonatomic, assign) NSInteger type;
/** <#typeId描述#> */
@property (nonatomic, assign) NSInteger typeId;
/** <#status描述#> */
@property (nonatomic, assign) NSInteger status;
/** <#ip描述#> */
@property (nonatomic, copy) NSString *ip;
/** <#createTime描述#> */
@property (nonatomic, copy) NSString *createTime;
/** <#updateTime描述#> */
@property (nonatomic, copy) NSString *updateTime;
/** <#obj描述#> */
@property (nonatomic, copy) NSString *obj;
/** <#isValid描述#> */
@property (nonatomic, assign) NSInteger isValid;
/** <#typeName描述#> */
@property (nonatomic, copy) NSString *typeName;

@end
