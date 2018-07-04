//
//  ServiceMo.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/4.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"
#import "privateUserInfoModel.h"
#import "ServiceCategoryNameModel.h"

@interface ServiceMo : BaseModel
/** <#id描述#> */
@property (nonatomic, assign) NSInteger Id;
/** <#images描述#> */
@property (nonatomic, copy) NSString *images;
/** <#title描述#> */
@property (nonatomic, copy) NSString *title;
/** <#serviceCategoryId描述#> */
@property (nonatomic, assign) NSInteger serviceCategoryId;
/** <#property描述#> */
@property (nonatomic, copy) NSString *property;
/** <#introduce描述#> */
@property (nonatomic, copy) NSString *introduce;
/** <#price描述#> */
@property (nonatomic, copy) NSString *price;
/** <#type描述#> */
@property (nonatomic, assign) NSInteger type;
/** <#content描述#> */
@property (nonatomic, copy) NSString *content;
/** <#likeCount描述#> */
@property (nonatomic, assign) NSInteger likeCount;
/** <#browseTimes描述#> */
@property (nonatomic, assign) NSInteger browseTimes;
/** <#lng描述#> */
@property (nonatomic, assign) CGFloat lng;
/** <#lat描述#> */
@property (nonatomic, assign) CGFloat lat;
/** <#provinceName描述#> */
@property (nonatomic, copy) NSString *provinceName;
/** <#provinceCode描述#> */
@property (nonatomic, copy) NSString *provinceCode;
/** <#cityName描述#> */
@property (nonatomic, copy) NSString *cityName;
/** <#cityCode描述#> */
@property (nonatomic, copy) NSString *cityCode;
/** <#areaName描述#> */
@property (nonatomic, copy) NSString *areaName;
/** <#areaCode描述#> */
@property (nonatomic, copy) NSString *areaCode;
/** <#createTime描述#> */
@property (nonatomic, copy) NSString *createTime;
/** <#user描述#> */
@property (nonatomic, strong) privateUserInfoModel *user;
/** <#properties描述#> */
@property (nonatomic, copy) NSString *properties;
/** <#serviceCircleList描述#> */
@property (nonatomic, copy) NSString *serviceCircleList;
/** <#score描述#> */
@property (nonatomic, assign) NSInteger score;
/** <#commentList描述#> */
@property (nonatomic, copy) NSString *commentList;
/** <#like描述#> */
@property (nonatomic, copy) NSString *like;
/** <#follow描述#> */
@property (nonatomic, copy) NSString *follow;
/** <#serviceCategoryName描述#> */
@property (nonatomic, strong) ServiceCategoryNameModel *serviceCategoryName;
/** <#typeName描述#> */
@property (nonatomic, copy) NSString *typeName;

@end
