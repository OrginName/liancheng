//
//  CollectionMo.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/4.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"
#import "CollectionObjMo.h"

@interface CollectionMo : BaseModel
/** <#id描述#> */
@property (nonatomic, copy) NSString *modelId;
/** <#userId描述#> */
@property (nonatomic, assign) NSInteger userId;
/** <#type描述#> */
@property (nonatomic, assign) NSInteger type;
/** <#typeId描述#> */
@property (nonatomic, assign) NSInteger typeId;
/** <#ip描述#> */
@property (nonatomic, copy) NSString *ip;
/** <#createTime描述#> */
@property (nonatomic, copy) NSString *createTime;
/** <#updateTime描述#> */
@property (nonatomic, copy) NSString *updateTime;
/** <#obj描述#> */
@property (nonatomic, strong) CollectionObjMo *obj;
/** <#isValid描述#> */
@property (nonatomic, assign) NSInteger isValid;
/** <#typeName描述#> */
@property (nonatomic, copy) NSString *typeName;

@end
