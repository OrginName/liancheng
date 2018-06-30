//
//  TenderRecordsMo.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/30.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"
#import "privateUserInfoModel.h"

@interface TenderRecordsMo : BaseModel
/** <#id描述#> */
@property (nonatomic, copy) NSString *modelId;
/** <#tenderId描述#> */
@property (nonatomic, assign) NSInteger tenderId;
/** <#user描述#> */
@property (nonatomic, strong) privateUserInfoModel *user;
/** <#createTime描述#> */
@property (nonatomic, copy) NSString *createTime;
/** <#updateTime描述#> */
@property (nonatomic, copy) NSString *updateTime;
/** <#isWin描述#> */
@property (nonatomic, assign) NSInteger isWin;
/** <#amount描述#> */
@property (nonatomic, copy) NSString *amount;
/** <#score描述#> */
@property (nonatomic, assign) NSInteger score;

@end
