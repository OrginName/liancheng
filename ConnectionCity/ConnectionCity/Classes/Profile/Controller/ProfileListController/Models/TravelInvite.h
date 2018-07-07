//
//  TravelInvite.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/4.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"
#import "privateUserInfoModel.h"

@interface TravelInvite : BaseModel
/** <#id描述#> */
@property (nonatomic, copy) NSString *Id;
/** <#userId描述#> */
@property (nonatomic, copy) NSString *userId;
/** <#placeTravel描述#> */
@property (nonatomic, copy) NSString *placeTravel;
/** <#startTime描述#> */
@property (nonatomic, copy) NSString *startTime;
/** <#description描述#> */
@property (nonatomic, copy) NSString *descriptionS;
/** <#cityCode描述#> */
@property (nonatomic, copy) NSString *cityCode;
/** <#cityName描述#> */
@property (nonatomic, copy) NSString *cityName;
/** <#inviteObject描述#> */
@property (nonatomic, copy) NSString *inviteObject;
/** <#departTime描述#> */
@property (nonatomic, copy) NSString *departTime;
/** <#longTime描述#> */
@property (nonatomic, copy) NSString *longTime;
/** <#travelMode描述#> */
@property (nonatomic, copy) NSString *travelMode;
/** <#travelFee描述#> */
@property (nonatomic, copy) NSString *travelFee;
/** <#createTime描述#> */
@property (nonatomic, copy) NSString *createTime;
/** <#user描述#> */
@property (nonatomic, strong) privateUserInfoModel *user;
/** <#inviteObjectName描述#> */
@property (nonatomic, copy) NSString *inviteObjectName;
/** <#departTimeName描述#> */
@property (nonatomic, copy) NSString *departTimeName;
/** <#longTimeName描述#> */
@property (nonatomic, copy) NSString *longTimeName;
/** <#travelModeName描述#> */
@property (nonatomic, copy) NSString *travelModeName;
/** <#travelFeeName描述#> */
@property (nonatomic, copy) NSString *travelFeeName;

@end
