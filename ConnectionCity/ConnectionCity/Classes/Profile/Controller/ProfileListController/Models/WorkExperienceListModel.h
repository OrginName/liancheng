//
//  WorkExperienceListModel.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/24.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"
#import "OccupationCategoryNameModel.h"

@interface WorkExperienceListModel : BaseModel
/** <#id描述#> */
@property (nonatomic, assign) NSInteger modelId;
/** <#status描述#> */
@property (nonatomic, copy) NSString *status;
/** <#occupationCategoryId描述#> */
@property (nonatomic, assign) NSInteger occupationCategoryId;
/** <#createTime描述#> */
@property (nonatomic, copy) NSString *createTime;
/** <#updateTime描述#> */
@property (nonatomic, copy) NSString *updateTime;
/** <#occupationCategoryName描述#> */
@property (nonatomic, strong) OccupationCategoryNameModel *occupationCategoryName;
/** <#resumeId描述#> */
@property (nonatomic, assign) NSInteger resumeId;
/** <#companyName描述#> */
@property (nonatomic, copy) NSString *companyName;
/** <#startDate描述#> */
@property (nonatomic, copy) NSString *startDate;
/** <#endDate描述#> */
@property (nonatomic, copy) NSString *endDate;
/** <#description描述#> */
@property (nonatomic, copy) NSString *descriptions;
@end
