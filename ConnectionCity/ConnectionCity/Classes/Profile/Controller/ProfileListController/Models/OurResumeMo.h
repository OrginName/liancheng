//
//  OurResumeMo.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/24.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"
#import "privateUserInfoModel.h"
#import "WorkExperienceListModel.h"
#import "educationExperienceListModel.h"

@interface OurResumeMo : BaseModel
/** <#id描述#> */
@property (nonatomic, assign) NSInteger modelId;
/** <#user描述#> */
@property (nonatomic, strong) privateUserInfoModel *user;
/** <#lng描述#> */
@property (nonatomic, assign) CGFloat lng;
/** <#lat描述#> */
@property (nonatomic, assign) CGFloat lat;
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
/** <#educationId描述#> */
@property (nonatomic, assign) NSInteger educationId;
/** <#createTime描述#> */
@property (nonatomic, copy) NSString *createTime;
/** <#updateTime描述#> */
@property (nonatomic, copy) NSString *updateTime;
/** <#educationName描述#> */
@property (nonatomic, copy) NSString *educationName;
/** <#avatar描述#> */
@property (nonatomic, copy) NSString *avatar;
/** <#salaryId描述#> */
@property (nonatomic, assign) NSInteger salaryId;
/** <#workingId描述#> */
@property (nonatomic, assign) NSInteger workingId;
/** <#introduce描述#> */
@property (nonatomic, copy) NSString *introduce;
/** <#educationExperienceList描述#> */
@property (nonatomic, strong) NSArray<educationExperienceListModel *> *educationExperienceList;
/** <#workExperienceList描述#> */
@property (nonatomic, strong) NSArray<WorkExperienceListModel *> *workExperienceList;
/** <#salaryName描述#> */
@property (nonatomic, copy) NSString *salaryName;
/** <#workingName描述#> */
@property (nonatomic, copy) NSString *workingName;

@end
