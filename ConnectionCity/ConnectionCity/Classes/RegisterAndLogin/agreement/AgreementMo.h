//
//  AgreementMo.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"

@interface AgreementMo : BaseModel
/** <#id描述#> */
@property (nonatomic, copy) NSString *modelId;
/** <#alias描述#> */
@property (nonatomic, copy) NSString *alias;
/** <#title描述#> */
@property (nonatomic, copy) NSString *title;
/** <#image描述#> */
@property (nonatomic, copy) NSString *image;
/** <#description描述#> */
@property (nonatomic, copy) NSString *descriptions;
/** <#content描述#> */
@property (nonatomic, copy) NSString *content;
/** <#url描述#> */
@property (nonatomic, copy) NSString *url;
/** <#priority描述#> */
@property (nonatomic, assign) NSInteger priority;
/** <#status描述#> */
@property (nonatomic, assign) NSInteger status;
/** <#createTime描述#> */
@property (nonatomic, copy) NSString *createTime;
/** <#updateTime描述#> */
@property (nonatomic, copy) NSString *updateTime;

@end
