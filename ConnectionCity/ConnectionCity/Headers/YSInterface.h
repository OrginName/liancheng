//
//  YSInterface.h
//  dumbbell
//
//  Created by JYS on 16/3/10.
//  Copyright © 2016年 insaiapp. All rights reserved.
//

#ifndef YSInterface_h
#define YSInterface_h


//主机地址
//#define HOSTURL @"https://api.lc.test.cn-apps.com:8080"
#define HOSTURL @"http://210.16.185.211:8080"
#define QINIUURL @"http://panixgsjz.bkt.clouddn.com/"

#pragma mark - 登录、注册、短信验证
//短信验证
static NSString * const smsVerificationCode = @"/sms/verification-code";
//注册
static NSString * const registerUrl = @"/register";
//登录
static NSString * const login = @"/login";
#pragma mark - 用户接口
//获取svip套餐详情
static NSString * const membershipSvipInfo = @"/membership/svip/info";
//rechargeVip
static NSString * const membershipSvipRecharge = @"/membership/svip/recharge";
//用户svip详情
static NSString * const membershipUserSvip = @"/membership/user/svip";
//修改密码
static NSString * const v1PrivateUserChangePassword = @"/v1/private/user/change-password";
//获取用户信息
static NSString * const v1PrivateUserInfo = @"/v1/private/user/info";
//附近的人
static NSString * const v1PrivateUserNearbyList = @"/v1/private/user/nearby/list";
//用户更新
static NSString * const v1PrivateUserUpdate = @"/v1/private/user/update";
#pragma mark - 用户-关注
//添加关注
static NSString * const v1UserFollowAdd = @"/v1/user/follow/add";
//取消关注
static NSString * const v1UserFollowCancel = @"/v1/user/follow/cancel";
//关注列表（分页）
static NSString * const v1UserFollowPage = @"/v1/user/follow/page";
#pragma mark - 人才-人脉
//添加好友
static NSString * const v1TalentConnectionAdd = @"/v1/talent/connection/add";
//人脉-同乡好友列表（分页）
static NSString * const v1TalentConnectionCityPage = @"/v1/talent/connection/city/page";
//人脉-校友好友列表（分页）
static NSString * const v1TalentConnectionEducationPage = @"/v1/talent/connection/education/page";
//人脉-同行好友列表（分页）
static NSString * const v1TalentConnectionOccupationPage = @"/v1/talent/connection/occupation/page";
#pragma mark - 人才-简历
//筛选条件
static NSString * const v1TalentResumeConditions = @"/v1/talent/resume/conditions";
//简历列表
static NSString * const v1TalentResumeList = @"/v1/talent/resume/list";
//新增简历
static NSString * const v1TalentResumeCreate = @"/v1/talent/resume/create";
//新增简历-教育经历
static NSString * const v1TalentResumeEducationCreate = @"/v1/talent/resume/education/create";
//修改简历-教育经历
static NSString * const v1TalentResumeEducationUpdate = @"/v1/talent/resume/education/update";
//简历详情
static NSString * const v1TalentResumeInfo = @"/v1/talent/resume/info";
//修改简历
static NSString * const v1TalentResumeUpdate = @"/v1/talent/resume/update";
//新增简历-工作经历
static NSString * const v1TalentResumeWorkCreate = @"/v1/talent/resume/work/create";
//修改简历-工作经历
static NSString * const v1TalentResumeWorkUpdate = @"/v1/talent/resume/work/update";
#pragma mark - 人才-赚外快
//评论
static NSString * const v1TalentTenderCommentCreate = @"/v1/talent/tender/comment/create";
//招标发布
static NSString * const v1TalentTenderCreate = @"/v1/talent/tender/create";
//赚外快-保证金
static NSString * const v1TalentTenderDepositList = @"/v1/talent/tender/deposit/list";
//招标详情
static NSString * const v1TalentTenderDetail = @"/v1/talent/tender/detail";
//关注招标
static NSString * const v1TalentTenderFollowCreate = @"/v1/talent/tender/follow/create";
//赚外快-投标
static NSString * const v1TalentTenderRecordCreate = @"/v1/talent/tender/record/create";
//赚外快-投标人
static NSString * const v1TalentTenderRecordList = @"/v1/talent/tender/record/list";
//赚外快-中标人
static NSString * const v1TalentTenderWinRecordList = @"/v1/talent/tender/win-record/list";
#pragma mark - 关键字信息
//换着玩关键字
static NSString * const keywordPlayKeyword = @"/keyword/play-keyword";
//找服务关键字
static NSString * const keywordServiceKeyword = @"/keyword/service-keyword";
//找人才关键字
static NSString * const keywordTalentKeyword = @"/keyword/talent-keyword";
#pragma mark - 数据字典
//区域树状列表
static NSString * const dictionaryAreaTreeList = @"/dictionary/area/tree-list";
//全部字典
static NSString * const dictionaryDictionaryAll = @"/dictionary/dictionary/all";
//学历
static NSString * const dictionaryEducation = @"/dictionary/education";
//职业分类
static NSString * const dictionaryOccupationCategory = @"/dictionary/occupation-category";
//专业
static NSString * const dictionaryProfessional = @"/dictionary/professional";
//薪资
static NSString * const dictionarySalary = @"/dictionary/salary";
//学校
static NSString * const dictionarySchool = @"/dictionary/school";
//服务分类
static NSString * const dictionaryServiceCategory = @"/dictionary/service-category";
static NSString * const dictionaryServiceCategoryProperties = @"/dictionary/service-category-properties";
//宝物分类
static NSString * const dictionaryTreasureCategory = @"/dictionary/treasure-category";
#pragma mark - 服务圈子
//服务发布圈子
static NSString * const v1ServiceCircleCreate = @"/v1/service-circle/create";
//服务圈子详情
static NSString * const v1ServiceCircleInfo = @"/v1/service-circle/info";
//服务圈列表分页
static NSString * const v1ServiceCirclePage = @"/v1/service-circle/page";
#pragma mark - 服务
//添加点赞
static NSString * const v1ServiceAddLike = @"/v1/service/add-like";
//添加浏览次数
static NSString * const v1ServiceServiceIdAddBrowseTimes = @"/v1/service/{serviceId}/add-browse-times";
//服务约单
static NSString * const v1ServiceCreateOrder = @"/v1/service/create-order";
//筛选条件
static NSString * const v1ServiceConditions = @"/v1/service/conditions";
//新增服务
static NSString * const v1ServiceCreate = @"/v1/service/create";
//服务详情
static NSString * const v1ServiceDetail = @"/v1/service/detail";
//服务列表
static NSString * const v1ServiceList = @"/v1/service/list";
#pragma mark - 服务-旅游
//服务-发布陪游
static NSString * const v1ServiceTravelCreate = @"/v1/service/travel/create";
//服务-陪游详情
static NSString * const v1ServiceTravelInfo = @"/v1/service/travel/info";
//服务-发布邀约
static NSString * const v1ServiceTravelInviteCreate = @"/v1/service/travel/invite/create";
//服务-邀约详情
static NSString * const v1ServiceTravelInviteInfo = @"/v1/service/travel/invite/info";
//服务-邀约列表（分页）
static NSString * const v1ServiceTravelInvitePage = @"/v1/service/travel/invite/page";
//服务-陪游约单
static NSString * const v1ServiceTravelOrderCreate = @"/v1/service/travel/order/create";
//服务-旅游列表（分页）
static NSString * const v1ServiceTravelPage = @"/v1/service/travel/page";
#pragma mark - 服务-服务站
//创建服务站
static NSString * const v1ServiceStationCreate = @"/v1/service/station/create";
//服务站详情
static NSString * const v1ServiceStationInfo = @"/v1/service/station/info";
//我加入的站点列表
static NSString * const v1ServiceStationJoinList = @"/v1/service/station/join/list";
//我的站点列表
static NSString * const v1ServiceStationMyList = @"/v1/service/station/my/list";
//附近的服务站
static NSString * const v1ServiceStationNearbyList = @"/v1/service/station/nearby/list";
//获取附近，我的，我加入的站点
static NSString * const v1ServiceStationRelationToMeList = @"/v1/service/station/relation-to-me/list";
//加入服务站
static NSString * const v1ServiceStationSign = @"/v1/service/station/sign";
//退出服务站
static NSString * const v1ServiceStationSignOut = @"/v1/service/station/sign-out";
#pragma mark - 个人中心-认证中心
//个人中心-认证中心
static NSString * const myAuthAuth = @"/my/auth/auth";
//个人中心-认证中心-证书认证
static NSString * const myAuthAuthCertificate = @"/my/auth/auth/certificate";
//个人中心-认证中心-身份认证
static NSString * const myAuthAuthIdCard = @"/my/auth/auth/id-card";
//个人中心-认证中心-认证手机
static NSString * const myAuthAuthMobile = @"/my/auth/auth/mobile";
//个人中心-身份认证
static NSString * const myAuthUserIdentityAuthCreate = @"/my/auth/user-identity-auth/create";
//个人中心-技能认证
static NSString * const myAuthUserSkillAuthCreate = @"/my/auth/user-skill-auth/create";
#pragma mark - 我的 - My Controller
//个人中心-服务评价
//我的-通讯录
//个人中心-我的玩家-我和别人换
//个人中心-我的关注
//个人中心-我的发布-身份互换
//个人中心-我的玩家-别人和我换
//个人中心-我的发布-简历
//个人中心-我下单的服务
//个人中心-我发布的服务
//个人中心-我的发布-服务
//个人中心-我的发布-邀约
//个人中心-我发布的旅游
//个人中心-我下单的旅游
//个人中心-我的发布-旅行
//个人中心-我的发布-宝物
static NSString * const v1MyTreasurePage = @"/v1/my/treasure/page";










#endif /* YSInterface_h */




