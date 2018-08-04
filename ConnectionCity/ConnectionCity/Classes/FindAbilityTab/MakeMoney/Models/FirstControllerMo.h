//
//  FirstControllerMo.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/30.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"
//#import "privateUserInfoModel.h"
#import "UserMo.h"
#import "TenderRecordsMo.h"
#import "orderListModel.h"

@interface FirstControllerMo : BaseModel
/** <#provinceName描述#> */
@property (nonatomic, copy) NSString *provinceName;
/** <#periodAmount1描述#> */
@property (nonatomic, copy) NSString *periodAmount1;
/** <#tenderRecords描述#> */
@property (nonatomic, strong) NSArray<TenderRecordsMo *> *tenderRecords;
/** <#industryCategoryName描述#> */
@property (nonatomic, copy) NSString *industryCategoryName;
/** <#contactMobile描述#> */
@property (nonatomic, copy) NSString *contactMobile;
/** <#id描述#> */
@property (nonatomic, copy) NSString *modelId;
/** <#company描述#> */
@property (nonatomic, copy) NSString *company;
/** <#payStatus4描述#> */
@property (nonatomic, copy) NSString *payStatus4;
/** <#rewardAmount5描述#> */
@property (nonatomic, copy) NSString *rewardAmount5;
/** <#cityCode描述#> */
@property (nonatomic, copy) NSString *cityCode;
/** <#tenderEndDate描述#> */
@property (nonatomic, copy) NSString *tenderEndDate;
/** <#payStatus2描述#> */
@property (nonatomic, copy) NSString *payStatus2;
/** <#periodAmount4描述#> */
@property (nonatomic, copy) NSString *periodAmount4;
/** <#rewardAmount3描述#> */
@property (nonatomic, copy) NSString *rewardAmount3;
/** <#tenderStartDate描述#> */
@property (nonatomic, copy) NSString *tenderStartDate;
/** <#provinceCode描述#> */
@property (nonatomic, copy) NSString *provinceCode;
/** <#areaCode描述#> */
@property (nonatomic, copy) NSString *areaCode;
/** <#user描述#> */
@property (nonatomic, strong) UserMo *user;
/** <#industryCategoryParentName描述#> */
@property (nonatomic, copy) NSString *industryCategoryParentName;
/** <#periodAmount2描述#> */
@property (nonatomic, copy) NSString *periodAmount2;
/** <#updateTime描述#> */
@property (nonatomic, copy) NSString *updateTime;
/** <#payStatus5描述#> */
@property (nonatomic, copy) NSString *payStatus5;
/** <#industryCategoryParentId描述#> */
@property (nonatomic, copy) NSString *industryCategoryParentId;
/** <#tenderAddress描述#> */
@property (nonatomic, copy) NSString *tenderAddress;
/** <#rewardAmount1描述#> */
@property (nonatomic, copy) NSString *rewardAmount1;
/** <#periodAmount5描述#> */
@property (nonatomic, copy) NSString *periodAmount5;
/** <#lng描述#> */
@property (nonatomic, copy) NSString *lng;
/** <#status描述#> */
@property (nonatomic, copy) NSString *status;
/** <#cityName描述#> */
@property (nonatomic, copy) NSString *cityName;
/** <#payStatus3描述#> */
@property (nonatomic, copy) NSString *payStatus3;
/** <#content描述#> */
@property (nonatomic, copy) NSString *content;
/** <#rewardAmount4描述#> */
@property (nonatomic, copy) NSString *rewardAmount4;
/** <#lat描述#> */
@property (nonatomic, copy) NSString *lat;
/** <#payStatus1描述#> */
@property (nonatomic, copy) NSString *payStatus1;
/** <#createTime描述#> */
@property (nonatomic, copy) NSString *createTime;
/** <#industryCategoryId描述#> */
@property (nonatomic, copy) NSString *industryCategoryId;
/** <#tenderImages描述#> */
@property (nonatomic, copy) NSString *tenderImages;
/** <#periodAmount3描述#> */
@property (nonatomic, copy) NSString *periodAmount3;
/** <#depositAmount描述#> */
@property (nonatomic, copy) NSString *depositAmount;
/** <#areaName描述#> */
@property (nonatomic, copy) NSString *areaName;
/** <#title描述#> */
@property (nonatomic, copy) NSString *title;
/** <#contactName描述#> */
@property (nonatomic, copy) NSString *contactName;
/** <#ip描述#> */
@property (nonatomic, copy) NSString *ip;
/** <#rewardAmount2描述#> */
@property (nonatomic, copy) NSString *rewardAmount2;
/** <#amount描述#> */
@property (nonatomic, copy) NSString *amount;
/** amount描述 */
@property (nonatomic, copy) NSString *isWin;
@property (nonatomic, strong) NSArray <orderListModel *> *orderList;

@end
