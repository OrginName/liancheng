//
//  CollectionObjMo.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/4.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"

@interface CollectionObjMo : BaseModel
/** <#id描述#> */
@property (nonatomic, copy) NSString *modelId;
/** <#userId描述#> */
@property (nonatomic, assign) NSInteger userId;
/** <#content描述#> */
@property (nonatomic, copy) NSString *content;
/** <#images描述#> */
@property (nonatomic, copy) NSString *images;
/** <#videos描述#> */
@property (nonatomic, copy) NSString *videos;
/** <#videoCover描述#> */
@property (nonatomic, copy) NSString *videoCover;
/** <#createTime描述#> */
@property (nonatomic, copy) NSString *createTime;
/** <#provinceName描述#> */
@property (nonatomic, copy) NSString *provinceName;
/** <#provinceCode描述#> */
@property (nonatomic, assign) NSInteger provinceCode;
/** <#cityName描述#> */
@property (nonatomic, copy) NSString *cityName;
/** <#cityCode描述#> */
@property (nonatomic, assign) NSInteger cityCode;
/** <#areaName描述#> */
@property (nonatomic, copy) NSString *areaName;
/** <#areaCode描述#> */
@property (nonatomic, copy) NSString *areaCode;
/** <#containsImage描述#> */
@property (nonatomic, assign) NSInteger containsImage;
/** <#containsVideo描述#> */
@property (nonatomic, assign) NSInteger containsVideo;
/** <#obj描述#> */
@property (nonatomic, copy) NSString *obj;

@end
