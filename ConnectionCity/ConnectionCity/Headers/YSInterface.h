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
#define HOSTURL @"https://api.lian-cheng.com"

//#define HOSTURL @"https://api.lian-cheng.com:8081"

#define QINIUURL @"http://img.lian-cheng.com/"

#define baseUrl  @"http://m.lian-cheng.com"

//APP更新链接
//itms-apps://itunes.apple.com/cn/app/id1329918420?mt=8
static NSString * const v1CheckVersionUrl = @"";

#pragma mark ----- 首页-------
//发现 -发布朋友圈
static NSString * const v1FriendCircleCreate = @"/v1/friend-circle/create";
//发现 -删除朋友圈
static NSString * const v1FriendCircleDelete = @"/v1/friend-circle/delete";
//发现 -朋友圈详情
static NSString * const v1FriendCircleInfo = @"/v1/friend-circle/info";
//发现 -朋友圈列表
static NSString * const v1FriendCirclePage = @"/v1/friend-circle/page";
//发现 -朋友圈我的
static NSString * const v1FriendCircleMyPage = @"/v1/friend-circle/my/page";
//发现 -朋友圈我的
static NSString * const v1FriendCircleUpdate = @"/v1/friend-circle/update";
//首页 - 右上角消息
static NSString * const v1CommonMessagePage = @"/v1/common/message/page";
//首页 - 通知公告
static NSString * const v1CommonNoticePage = @"/v1/common/notice/page";


#pragma mark ----我的-------
//加入黑名单
static NSString * const v1MyBlackCreate = @"/v1/my/black/create";
//添加好友
static NSString * const v1MyAdd = @"/v1/my/add";
//查找用户
static NSString * const v1PrivateUserSearch = @"/v1/private/user/search";
//好友申请
static NSString * const v1ApplicationAdd = @"/v1/application/add";
//同意好友申请
static NSString * const v1ApplicationAgree = @"/v1/application/agree";
//好友申请
static NSString * const v1ApplicationPage = @"/v1/application/page";
//通讯录黑名单
static NSString * const v1MyBlackPage = @"/v1/my/black/page";

#pragma mark ----首页Qun-------
//首页  更新群
static NSString * const v1UserGroupUpdate = @"/v1/user/group/update";
//首页  创建群
static NSString * const v1UserGroupCreate = @"/v1/user/group/create";
//首页  批量加入群
static NSString * const v1UserGroupBatchSign = @"/v1/user/group/batch-sign";
//首页  批量退出
static NSString * const v1UserGroupBatchSignOut = @"/v1/user/group/batch-sign-out";
//首页  解散群
static NSString * const v1UserGroupDelete = @"/v1/user/group/delete";
//首页  群详情
static NSString * const v1UserGroupInfo = @"/v1/user/group/info";
//首页  我加入的群
static NSString * const v1UserGroupJoinList = @"/v1/user/group/join/list";
//首页  我的群
static NSString * const v1UserGroupMyList = @"/v1/user/group/my/list";
//首页  附近的群
static NSString * const v1UserGroupNearbyList = @"/v1/user/group/nearby/list";
//首页  加入群
static NSString * const v1UserGroupSign = @"/v1/user/group/sign";
//首页  退出群
static NSString * const v1UserGroupSignout = @"/v1/user/group/sign-out";
//首页  申请加入群
static NSString * const v1GroupApplicationAdd = @"/v1/group/application/add";
//首页  同意加入群
static NSString * const v1GroupApplicationAgree = @"/v1/group/application/agree";
//首页  申请加入群的列表
static NSString * const v1GroupApplicationPage = @"/v1/group/application/page";


#pragma mark - 登录、注册、短信验证
//短信验证
static NSString * const smsVerificationCode = @"/sms/verification-code";
//注册
static NSString * const registerUrl = @"/register";
//登录
static NSString * const login = @"/login";
//微信QQ授权登陆接口
static NSString * const auth = @"/auth";
//找回密码
static NSString * const passwordForget = @"/password/forget";

#pragma mark - 协议条款
//协议条款
static NSString * const pageInfo = @"/page/info";
//关于我们
static NSString * const about = @"about";
//连程使用协议
static NSString * const useAgreement = @"use-agreement";
//连程号码规则
static NSString * const connectRule = @"connect-rule";
//连程用户行为规范
static NSString * const userBehaviorStandard = @"user-behavior-standard";
//连程服务协议
static NSString * const serviceAgreement = @"service-agreement";
//连程会员服务协议
static NSString * const userServiceAgreement = @"user-service-agreement";
//连程充值协议
static NSString * const rechargeAgreement = @"recharge-agreement";
//连程服务保障
static NSString * const serviceGuarantee = @"service-guarantee";
//连程审核规范
static NSString * const auditStandards = @"audit-standards";
//连程隐私协议
static NSString * const privacyAgreement = @"privacy-agreement";
//商务合作
static NSString * const cooperation = @"cooperation";
//年费
static NSString * const annualFee = @"annual-fee";
//功能
static NSString * const function = @"function";



#pragma mark - 用户接口
//获取svip套餐详情
static NSString * const v1MembershipSvipInfo = @"/v1/membership/svip/info";
//rechargeVip
static NSString * const v1MembershipSvipRecharge = @"/v1/membership/svip/recharge";
//用户svip详情
static NSString * const v1MembershipUserSvip = @"/v1/membership/user/svip";
//修改密码
static NSString * const v1PrivateUserChangePassword = @"/v1/private/user/change-password";
//获取用户信息
static NSString * const v1PrivateUserInfo = @"/v1/private/user/info";
//附近的人
static NSString * const v1PrivateUserNearbyList = @"/v1/private/user/nearby/list";
//首页-附近的人
static NSString * const v1PrivateUserHomeList = @"/v1/private/user/home/list";

//用户更新
static NSString * const v1PrivateUserUpdate = @"/v1/private/user/update";
//查找用户信息
static NSString * const v1PrivateUserUserinfo = @"/v1/private/user/user-info";

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

#pragma mark --人才-团队之家------
//团队详情
static NSString * const v1TalentTeamInfo = @"/v1/talent/team/info";
//附近的团队
static NSString * const v1TalentTeamNearbyList = @"/v1/talent/team/nearby/list";
//我创建的团队列表
static NSString * const v1TalentTeamMyList = @"/v1/talent/team/my/list";
//我创建的团队解散
static NSString * const v1TalentTeamDelete = @"/v1/talent/team/delete";
//我加入的团队列表
static NSString * const v1TalentTeamJoinList = @"/v1/talent/team/join/list";
//我加入的团队列表
static NSString * const v1TalentTeamCreate = @"/v1/talent/team/create";
//批量加入团队成员
static NSString * const v1TalentTeamBatchSign = @"/v1/talent/team/batch-sign";
//批量退出
static NSString * const v1TalentTeamBatchSignOut = @"/v1/talent/team/batch-sign-out";
//更新团队
static NSString * const v1TalentTeamUpdate = @"/v1/talent/team/update";
//退出团队
static NSString * const v1TalentTeamSignOut = @"v1/talent/team/sign-out";
//申请加入团队
static NSString * const v1TeamApplicationAdd = @"/v1/team/application/add";
//同意加入团队
static NSString * const v1TeamApplicationAgree = @"/v1/team/application/agree";
//申请加入团队的列表
static NSString * const v1TeamApplicationPage = @"/v1/team/application/page";

#pragma mark - 人才-简历
//筛选条件
static NSString * const v1TalentResumeConditions = @"/v1/talent/resume/conditions";
//简历列表
static NSString * const v1TalentResumeList = @"/v1/talent/resume/list";
//删除教育简历
static NSString * const v1TalentResumeEducationDelete = @"/v1/talent/resume/education/delete";
//新增简历
static NSString * const v1TalentResumeCreate = @"/v1/talent/resume/create";
//新增简历-教育经历
static NSString * const v1TalentResumeEducationCreate = @"/v1/talent/resume/education/create";

//删除教育经历
static NSString * const v1TalentResumeWorkDelete = @"/v1/talent/resume/work/delete";
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
//删除简历-工作经历
static NSString * const v1TalentResumeDelete = @"/v1/talent/resume/delete";

#pragma mark - 人才-赚外快
//评论
static NSString * const v1TalentTenderCommentCreate = @"/v1/talent/tender/comment/create";
//关注接单
static NSString * const v1TalentTenderFollowCreate = @"/v1/talent/tender/follow/create";
//接单发布
static NSString * const v1TalentTenderCreate = @"/v1/talent/tender/create";
//修改接单
static NSString * const v1TalentTenderUpdate = @"/v1/talent/tender/update";
//赚外快-删除接单
static NSString * const v1TalentTenderDelete = @"/v1/talent/tender/delete";
//赚外快-保证金
static NSString * const v1TalentTenderDepositList = @"/v1/talent/tender/deposit/page";
//接单详情
static NSString * const v1TalentTenderDetail = @"/v1/talent/tender/detail";
//赚外快-创建订单（支付全额/分期/保证金）
static NSString * const v1TalentTenderorderCreate = @"/v1/talent/tender/order/create";
//赚外快（分页）
static NSString * const v1TalentTenderPage = @"/v1/talent/tender/page";
//赚外快-任务管理（分页）
static NSString * const v1TalentTenderMyPage = @"/v1/talent/tender/my/page";
//赚外快-抢单
static NSString * const v1TalentTenderRecordCreate = @"/v1/talent/tender/record/create";
//赚外快-抢单人
static NSString * const v1TalentTenderRecordList = @"/v1/talent/tender/record/page";
//赚外快-赏金托管
static NSString * const v1TalentTenderRewardList = @"/v1/talent/tender/reward/page";
//赚外快-中单人
static NSString * const v1TalentTenderWinRecordList = @"/v1/talent/tender/win-record/page";
//赚外快-足迹
static NSString * const v1TalentTenderFootPrintPage = @"/v1/talent/tender/foot-print/page";
//赚外快-中标
static NSString * const v1TalentTenderRecordWin = @"/v1/talent/tender/record/win";
//招标订单状态更新
static NSString * const v1TalentTenderUpdateOrderStatus = @"/v1/talent/tender/update-order-status";
//我的中单
static NSString * const v1TalentTenderMyWinPage = @"/v1/talent/tender/my-win/page";



#pragma mark - 关键字信息
//换着玩关键字
static NSString * const keywordPlayKeyword = @"/keyword/play-keyword";
//找服务关键字
static NSString * const keywordServiceKeyword = @"/keyword/service-keyword";
//找人才关键字
static NSString * const keywordTalentKeyword = @"/keyword/talent-keyword";
//找服务热门
static NSString * const keywordServiceHot = @"/keyword/service-hot";
//找人才热门
static NSString * const keywordTalentHot = @"/keyword/talent-hot";
//换着玩热门
static NSString * const keywordPlayHot = @"/keyword/play-hot";


#pragma mark - 数据字典
//区域树状列表
static NSString * const dictionaryAreaTreeList = @"/dictionary/area/tree-list";
//全部字典
static NSString * const dictionaryDictionaryAll = @"/dictionary/dictionary/all";
//学历
static NSString * const dictionaryEducation = @"/dictionary/education";
//行业分类
static NSString * const dictionaryOccupationCategory = @"/dictionary/occupation-category";
//赚外快-行业分类
static NSString * const dictionaryIndustryCategory = @"/dictionary/industry-category";
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
//服务圈子删除
static NSString * const v1ServiceCircleDelete = @"/v1/service-circle/delete";
//服务圈列表分页
static NSString * const v1ServiceCirclePage = @"/v1/service-circle/page";
//服务圈列表编辑
static NSString * const v1ServiceCircleUpdate = @"/v1/service-circle/update";
//服务圈列表编辑
static NSString * const v1ServiceCircleUserPage = @"/v1/service-circle/user/page";


#pragma mark - 服务
//添加评论
static NSString * const v1CommonCommentCreate = @"/v1/common/comment/create";
//添加收藏
static NSString * const v1CommonCollectCreate = @"/v1/common/collect/create";
//添加点赞
static NSString * const v1CommonCommentAddlike = @"/v1/common/comment/add-like";
//添加浏览次数
static NSString * const v1ServiceAddBrowseTimes = @"/v1/service/add-browse-times";
//添加评论回复
static NSString * const v1CommonCommentReplay = @"//v1/common/comment/replay";

//服务约单
static NSString * const v1ServiceCreateOrder = @"/v1/service/create-order";
//筛选条件
static NSString * const v1ServiceConditions = @"/v1/service/conditions";
//新增服务
static NSString * const v1ServiceCreate = @"/v1/service/create";
//服务详情
static NSString * const v1ServiceDetail = @"/v1/service/detail";
//根据userID 获取服务详情
static NSString * const v1ServiceUserList = @"/v1/service/user/list";
//服务列表
static NSString * const v1ServiceList = @"/v1/service/list";


#pragma mark - 服务-旅游
//服务-陪游订单状态更新
static NSString * const v1ServiceTravelUpdateOrderStatus = @"/v1/service/travel/update-order-status";
//服务-发布陪游
static NSString * const v1ServiceTravelAddBrowseTimes = @"/v1/service/travel/add-browse-times";
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
//更新群信息
static NSString * const v1ServiceStationUpdate= @"/v1/service/station/update";
//批量删除成员
static NSString * const v1ServiceStationBatchSignOut= @"/v1/service/station/batch-sign-out";
//删除服务站
static NSString * const v1ServiceStationDelete= @"/v1/service/station/delete";
//加入服务站
static NSString * const v1ServiceStationBatchsign = @"/v1/service/station/batch-sign";
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
//申请加入服务站
static NSString * const v1StationApplicationAdd = @"/v1/station/application/add";
//同意加入服务站
static NSString * const v1StationApplicationAgree = @"/v1/station/application/agree";
//同意加入服务站
static NSString * const v1StationApplicationPage = @"/v1/station/application/page";

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
//个人中心-我发布的服务
static NSString * const v1MyServiceOrderPublishedPage = @"/v1/my/service-order/published/page";
//个人中心-我下单的服务
static NSString * const v1MySerivceOrderRequiredPage = @"/v1/my/serivce-order/required/page";
//个人中心-服务状态更新
static NSString * const v1ServiceUpdateOrderStatus = @"/v1/service/update-order-status";

#pragma mark - 我的 - My Controller
//个人中心-服务评价
static NSString * const v1MyCommentPage = @"/v1/my/comment/page";
//我的-通讯录
static NSString * const v1MyContacts = @"/v1/my/contacts";
//个人中心-我的玩家-我和别人换
static NSString * const v1MyExchangePage = @"/v1/my/exchange/page";
//个人中心-我的关注
static NSString * const v1MyFollowPage = @"/v1/my/follow/page";
//个人中心-我的发布-身份互换
static NSString * const v1MyIdentityPage = @"/v1/my/identity/page";
//个人中心-我的玩家-别人和我换
static NSString * const v1MyOrthersExchangePage = @"/v1/my/orthers/exchange/page";
//个人中心-我的发布-简历
static NSString * const v1MyResumePage = @"/v1/my/resume/page";
//个人中心-我的发布-服务
static NSString * const v1MyServicePage = @"/v1/my/service/page";
//个人中心-我的发布-邀约
static NSString * const v1MyTravelInvitePage = @"/v1/my/travel-invite/page";
//个人中心-我发布的旅游
static NSString * const v1MyTravelOrderPublishedPage = @"/v1/my/travel-order/published/page";
//个人中心-我下单的旅游
static NSString * const v1MyTravelOrderRequiredPage = @"/v1/my/travel-order/required/page";
//个人中心-我的发布-旅行
static NSString * const v1MyTravelPage = @"/v1/my/travel/page";
//个人中心-我的发布-宝物
static NSString * const v1MyTreasurePage = @"/v1/my/treasure/page";
//全部菜单按钮
static NSString * const v1MyChannelAll = @"/v1/my/channel/all";
//获取我的频道
static NSString * const v1MyChannelGet = @"/v1/my/channel/get";
//更新频道顺序
static NSString * const v1MyChannelUpdate = @"/v1/my/channel/update";

//服务-删除旅游邀约
static NSString * const v1ServiceTravelDeleteInvite = @"/v1/service/travel/delete-invite";
//服务-删除陪旅行
static NSString * const v1ServiceTravelDeleteTravel = @"/v1/service/travel/delete-travel";
//服务-删除服务
static NSString * const v1ServiceDelete = @"/v1/service/delete";

#pragma mark - 个人中心-认证中心
//个人中心-认证中心
static NSString * const v1MyAuthInfo = @"/v1/my/auth/info";
//个人中心-身份认证
static NSString * const v1MyAuthUseridentityAuthCreate = @"/v1/my/auth/user-identity-auth/create";
//个人中心-认证中心-认证手机
static NSString * const v1MyAuthUsermobileAuthCreate = @"/v1/my/auth/user-mobile-auth/create";
//个人中心-认证中心-发起技能认证
static NSString * const v1MyAuthUserskillAuthCreate = @"/v1/my/auth/user-skill-auth/create";
//个人中心-认证中心-认证技能列表
static NSString * const v1MyAuthUserskillAuthList = @"/v1/my/auth/user-skill-auth/list";
//个人中心-认证中心-企业认证
static NSString * const v1MyAuthUserCompanyAuthCreate = @"/v1/my/auth/user-company-auth/create";

//个人中心-我的收藏
static NSString * const v1MyCollectPage = @"/v1/my/collect/page";
#pragma mark - 我的钱包
//兑换服币
static NSString * const v1UserWalletExchange = @"/v1/user/wallet/exchange";
//钱包首页-详情
static NSString * const v1UserWalletInfo = @"/v1/user/wallet/info";
//钱包-流水
static NSString * const v1UserWalletPaymentPage = @"/v1/user/wallet/payment/page";
//钱包-充值
static NSString * const v1UserWalletRecharge = @"/v1/user/wallet/recharge";
//钱包-提现
static NSString * const v1UserWalletWithdraw = @"/v1/user/wallet/withdraw";
//钱包-提现管理-添加提现方式
static NSString * const v1UserWalletWithdrawAccountAdd = @"/v1/user/wallet/withdraw/account/add";
//钱包-提现管理-提现账户列表
static NSString * const v1UserWalletWithdrawAccountPage = @"/v1/user/wallet/withdraw/account/page";
#pragma mark - 支付
//统一支付接口
static NSString * const v1Pay = @"/v1/pay";
//查询接口
static NSString * const v1PayCheck = @"/v1/pay/check";


#pragma mark ------宝物------------

//发布宝物
static NSString * const v1PlayTreasureCreate = @"/v1/play/treasure/create";
//宝物详情
static NSString * const v1PlayTreasureDetail = @"/v1/play/treasure/detail";
//玩拼柜交换
static NSString * const v1PlayTreasureExchange = @"/v1/play/treasure/exchange";
//宝物列表
static NSString * const v1PlayTreasureList = @"/v1/play/treasure/list";
//玩拼柜-上加
static NSString * const v1PlayTreasurePutOffShelves = @"/v1/play/treasure/put-off-shelves";
///玩拼柜-下架
static NSString * const v1PlayTreasurePutOnShelves = @"/v1/play/treasure/put-on-shelves";
//换着玩宝物-添加浏览次数
static NSString * const v1PlayTreasureAddBrowseTimes = @"/v1/play/treasure/add-browse-times";
///换着玩宝物-点赞
static NSString * const v1PlayTreasureAddLikeCount = @"/v1/play/treasure/add-like-count";
//玩品柜-用户确认, id为订单Id，当订单装填为10,20,30时可调用
static NSString * const v1PlayTreasureConfirm = @"/v1/play/treasure/confirm";
///玩品柜-发起补差价
static NSString * const v1PlayTreasureCompensationPrice = @"/v1/play/treasure/compensation-price";
///发布身份互换
static NSString * const v1PlayIdentityCreate = @"/v1/play/identity/create";
//身份互换详情
static NSString * const v1PlayIdentityDetail = @"/v1/play/identity/detail";
//身份互换列表
static NSString * const v1PlayIdentityPage = @"/v1/play/identity/page";
//创建发烧友
static NSString * const v1PlayFeverCreate = @"/v1/play/fever/create";
//发烧友详情
static NSString * const v1PlayFeverInfo = @"/v1/play/fever/info";
//获取附近，我的，我加入的发烧友
static NSString * const v1PlayFeverRelationToMeList = @"/v1/play/fever/relation-to-me/list";
//加入发烧友
static NSString * const v1PlayFeverSignIn = @"/v1/play/fever/sign-in";
//退出发烧友
static NSString * const v1PlayFeverSignOut = @"/v1/play/fever/sign-out";
#pragma mark -   ------添加有奖反馈-------
//添加有奖反馈
static NSString * const v1FeedbackCreate = @"/v1/feedback/create";
#pragma mark -   ------亲密账户-------
//个人流水统计
static NSString * const v1usercloseaccountbilldate = @"/v1/user/close/account/bill/date";
//月度流水统计
static NSString * const v1usercloseaccountbillmonth = @"/v1/user/close/account/bill/month";
//年度流水统计
static NSString * const v1usercloseaccountbillyear = @"/v1/user/close/account/bill/year";
//修改锁定密码
static NSString * const v1usercloseaccountchangpwd = @"/v1/user/close/account/chang-pwd";
//忘记锁定密码
static NSString * const v1UserCloseAccountForget = @"/v1/user/close/account/forget";
//添加亲密账户
static NSString * const v1usercloseaccountcreate = @"/v1/user/close/account/create";
//删除亲密账户
static NSString * const v1usercloseaccountdelete = @"/v1/user/close/account/delete";
//我开通的亲密账户
static NSString * const v1usercloseaccountlist = @"/v1/user/close/account/list";
//我被开通的亲密账户
static NSString * const v1usercloseaccountopenedlist = @"/v1/user/close/account/opened/list";
//我的流水汇总
static NSString * const v1usercloseaccountorderstatistics = @"/v1/user/close/account/order/statistics";
//我的流水汇总
static NSString * const v1UserCloseAccountBillStatistics = @"/v1/user/close/account/bill/statistics";

//修改亲密账户
static NSString * const v1usercloseaccountupdate = @"/v1/user/close/account/update";
//亲密账户详情
static NSString * const v1UserCloseAccountGet = @"/v1/user/close/account/get";

//公工接口
//关注
static NSString * const v1CommonFollowCreate = @"/v1/common/follow/create";
//删除单条评论
static NSString * const v1CommonCommentDelete = @"/v1/common/comment/delete";
//全部申请列表（分页，含好友申请，群申请，团队申请，服务站申请
static NSString * const v1ApplicationPageAll = @"/v1/application/page/all";
//当前用户配置列表
static NSString * const v1MyConfigGet = @"/v1/my/config/get";
//更新用户配置列表
static NSString * const v1MyConfigUpdate = @"/v1/my/config/update";
//获取某个用户配置列表
static NSString * const v1PrivateUserConfig = @"/v1/private/user/config";
//获取版本号
static NSString * const v1AppVersion = @"/v1/app/version";


#endif /* YSInterface_h */




