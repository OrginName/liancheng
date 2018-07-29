//
//  privateUserInfoModel.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/22.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"
#import "OccupationCategoryNameModel.h"

@interface privateUserInfoModel : BaseModel<NSCoding>
/** <#id描述#> */
@property (nonatomic, copy) NSString *modelId;
/** <#mobile描述#> */
@property (nonatomic, copy) NSString *mobile;
/** <#realName描述#> */
@property (nonatomic, copy) NSString *realName;
/** <#nickName描述#> */
@property (nonatomic, copy) NSString *nickName;
/** <#pinyin描述#> */
@property (nonatomic, copy) NSString *pinyin;
/** <#headImage描述#> */
@property (nonatomic, copy) NSString *headImage;
/** <#backgroundImage描述#> */
@property (nonatomic, copy) NSString *backgroundImage;
/** <#age描述#> */
@property (nonatomic, copy) NSString *age;
/** <#status描述#> */
@property (nonatomic, copy) NSString *status;
/** <#gender描述#> */
@property (nonatomic, assign) NSInteger gender;
/** <#lng描述#> */
@property (nonatomic, assign) NSInteger lng;
/** <#lat描述#> */
@property (nonatomic, assign) NSInteger lat;
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
/** <#height描述#> */
@property (nonatomic, copy) NSString *height;
/** <#weight描述#> */
@property (nonatomic, copy) NSString *weight;
/** <#marriage描述#> */
@property (nonatomic, copy) NSString *marriage;
/** <#educationId描述#> */
@property (nonatomic, copy) NSString *educationId;
/** <#occupationCategoryId描述#> */
@property (nonatomic, assign) NSInteger occupationCategoryId;
/** <#sign描述#> */
@property (nonatomic, copy) NSString *sign;
/** <#registerTime描述#> */
@property (nonatomic, copy) NSString *registerTime;
/** <#registerIp描述#> */
@property (nonatomic, copy) NSString *registerIp;
/** <#loginTime描述#> */
@property (nonatomic, copy) NSString *loginTime;
/** <#loginIp描述#> */
@property (nonatomic, copy) NSString *loginIp;
/** <#balance描述#> */
@property (nonatomic, assign) NSInteger balance;
/** <#fb描述#> */
@property (nonatomic, copy) NSString *fb;
/** <#createTime描述#> */
@property (nonatomic, copy) NSString *createTime;
/** <#updateTime描述#> */
@property (nonatomic, copy) NSString *updateTime;
/** <#distance描述#> */
@property (nonatomic, copy) NSString *distance;
/** <#isIdentityAuth描述#> */
@property (nonatomic, copy) NSString *isIdentityAuth;
/** <#isSkillAuth描述#> */
@property (nonatomic, copy) NSString *isSkillAuth;
/** <#isMobileAuth描述#> */
@property (nonatomic, copy) NSString *isMobileAuth;
/** <#educationName描述#> */
@property (nonatomic, copy) NSString *educationName;
/** <#educationName描述#> */
@property (nonatomic, copy) NSString *email;
/** <#genderName描述#> */
@property (nonatomic, copy) NSString *genderName;
/** <#statusName描述#> */
@property (nonatomic, copy) NSString *statusName;
/** <#marriageName描述#> */
@property (nonatomic, copy) NSString *marriageName;
@property (nonatomic, copy) NSString *isFriend;

proStr(rongyunToken);//融云token

/** <#occupationCategoryName描述#> */
@property (nonatomic, strong) OccupationCategoryNameModel *occupationCategoryName;
proStr(ID);
@end
