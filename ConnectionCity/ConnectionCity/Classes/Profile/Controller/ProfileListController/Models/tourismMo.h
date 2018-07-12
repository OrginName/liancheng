//
//  tourismMo.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/4.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"
#import "UserMo.h"
@interface tourismMo : BaseModel
/** <#id描述#> */
@property (nonatomic, copy) NSString * Id;
/** <#userId描述#> */
@property (nonatomic, copy) NSString * userId;
/** <#images描述#> */
@property (nonatomic, copy) NSString *images;
/** <#cityCode描述#> */
@property (nonatomic, copy) NSString * cityCode;
/** <#cityName描述#> */
@property (nonatomic, copy) NSString *cityName;
/** <#introduce描述#> */
@property (nonatomic, copy) NSString *introduce;
/** <#price描述#> */
@property (nonatomic, copy) NSString *price;
/** <#type描述#> */
@property (nonatomic, copy) NSString * type;
/** <#createTime描述#> */
@property (nonatomic, copy) NSString *createTime;
/** <#comments描述#> */
@property (nonatomic, copy) NSString *comments;
/** <#user描述#> */
@property (nonatomic, strong) UserMo *user;
/** <#lng描述#> */
@property (nonatomic, copy) NSString * lng;
/** <#lat描述#> */
@property (nonatomic, copy) NSString * lat;
/** <#browseTimes描述#> */
@property (nonatomic, copy) NSString * browseTimes;
/** <#serviceCircleList描述#> */
@property (nonatomic, copy) NSString *serviceCircleList;
/** <#score描述#> */
@property (nonatomic, copy) NSString * score;
/** <#like描述#> */
@property (nonatomic, copy) NSString *like;
/** <#follow描述#> */
@property (nonatomic, copy) NSString *follow;
/** <#likeCount描述#> */
@property (nonatomic, copy) NSString * likeCount;
/** <#priceUnit描述#> */
@property (nonatomic, copy) NSString *priceUnit;

@end
