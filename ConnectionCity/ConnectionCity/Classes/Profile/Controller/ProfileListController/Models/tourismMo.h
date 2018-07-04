//
//  tourismMo.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/4.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"
#import "privateUserInfoModel.h"


@interface tourismMo : BaseModel
/** <#id描述#> */
@property (nonatomic, assign) NSInteger Id;
/** <#userId描述#> */
@property (nonatomic, assign) NSInteger userId;
/** <#images描述#> */
@property (nonatomic, copy) NSString *images;
/** <#cityCode描述#> */
@property (nonatomic, assign) NSInteger cityCode;
/** <#cityName描述#> */
@property (nonatomic, copy) NSString *cityName;
/** <#introduce描述#> */
@property (nonatomic, copy) NSString *introduce;
/** <#price描述#> */
@property (nonatomic, copy) NSString *price;
/** <#type描述#> */
@property (nonatomic, assign) NSInteger type;
/** <#createTime描述#> */
@property (nonatomic, copy) NSString *createTime;
/** <#comments描述#> */
@property (nonatomic, copy) NSString *comments;
/** <#user描述#> */
@property (nonatomic, strong) privateUserInfoModel *user;
/** <#lng描述#> */
@property (nonatomic, assign) CGFloat lng;
/** <#lat描述#> */
@property (nonatomic, assign) CGFloat lat;
/** <#browseTimes描述#> */
@property (nonatomic, assign) NSInteger browseTimes;
/** <#serviceCircleList描述#> */
@property (nonatomic, copy) NSString *serviceCircleList;
/** <#score描述#> */
@property (nonatomic, assign) NSInteger score;
/** <#like描述#> */
@property (nonatomic, copy) NSString *like;
/** <#follow描述#> */
@property (nonatomic, copy) NSString *follow;
/** <#likeCount描述#> */
@property (nonatomic, assign) NSInteger likeCount;
/** <#priceUnit描述#> */
@property (nonatomic, copy) NSString *priceUnit;

@end
