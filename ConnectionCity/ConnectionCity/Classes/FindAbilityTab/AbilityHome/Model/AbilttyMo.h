//
//  AbilttyMo.h
//  ConnectionCity
//
//  Created by umbrella on 2018/6/22.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"
#import "UserMo.h"
@class AbilttyEducationMo;
@class AbilttyWorkMo;
@interface AbilttyMo : BaseModel
proStr(avatar);//轮播
proStr(cityCode);
proStr(cityName);
proStr(educationId);
proStr(educationName);
proArr(educationExperienceList);//教育经历
proStr(ID);
proStr(introduce);
proStr(lat);
proStr(lng);
proStr(salaryName);
proStr(salaryId);
proArr(workExperienceList);//工作经历
proStr(workingId);
proStr(workingName);
proArr(user);
@property (nonatomic,strong) AbilttyWorkMo * workMo;
@property (nonatomic,strong) AbilttyEducationMo * educationMo;
@property (nonatomic,strong) UserMo * UserMo;
@end
@interface AbilttyEducationMo : BaseModel
proStr(description1);
proStr(educationId);
proStr(educationName);
proStr(endDate);
proStr(ID);
proStr(professionalId);
proStr(professionalName);
proStr(resumeId);
proStr(schoolId);
proStr(schoolName);
proStr(startDate);
proStr(status);
@end
@interface AbilttyWorkMo : BaseModel
proStr(companyName);
proArr(description1);
proStr(endDate);
proStr(ID);
proStr(occupationCategoryId);
proDic(occupationCategoryName);
proStr(resumeId);
proStr(startDate);
proStr(status);
@end

