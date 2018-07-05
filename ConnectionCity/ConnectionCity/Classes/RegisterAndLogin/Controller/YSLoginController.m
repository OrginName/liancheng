//
//  YSLoginController.m
//  NeckPillow
//
//  Created by YanShuang Jiang on 2018/4/22.
//  Copyright © 2018年 DKMedical. All rights reserved.
//

#import "YSLoginController.h"
#import "YSRegisterController.h"
#import "ChangePasswordController.h"
#import "AgreementController.h"
#import <RongIMKit/RongIMKit.h>
#import "privateUserInfoModel.h"
#import "RCDUtilities.h"
#import "RCDataBaseManager.h"
#import "RCDRCIMDataSource.h"
@interface YSLoginController ()<RCIMConnectionStatusDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (nonatomic,strong) NSString * nickName;
@property (nonatomic,strong) NSString * ID;
@property (nonatomic,strong) NSString * token;
@property(nonatomic, strong) NSTimer *retryTime;
@end
@implementation YSLoginController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup
- (void)initUI {
    self.loginBtn.layer.cornerRadius = 3;
}
#pragma mark - Event response
- (IBAction)eyeBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        _passwordTF.secureTextEntry = YES;
    }else{
        _passwordTF.secureTextEntry = NO;
    }
}
- (IBAction)checkBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
}
- (IBAction)serviceBtnClick:(id)sender {
    AgreementController *agreementVC = [[AgreementController alloc]init];
    agreementVC.alias = useAgreement;
    [self.navigationController pushViewController:agreementVC animated:YES];
}
- (IBAction)loginBtnClick:(id)sender {
    if ([YSTools dx_isNullOrNilWithObject:_phoneTF.text] || [YSTools dx_isNullOrNilWithObject:_passwordTF.text]) {
        [YTAlertUtil showTempInfo:@"请将信息填写完整"];
        return;
    }
    if (![YSTools isRightPhoneNumberFormat:_phoneTF.text]) {
        [YTAlertUtil showTempInfo:@"请填写正确的手机号码"];
        return;
    }
    if (!self.checkBtn.selected) {
        [YTAlertUtil showTempInfo:@"请阅读并同意服务条款"];
        return;
    }
    if (self.retryTime) {
        [self invalidateRetryTime];
    }
    
    self.retryTime = [NSTimer scheduledTimerWithTimeInterval:60
                                                      target:self
                                                    selector:@selector(retryConnectionFailed)
                                                    userInfo:nil
                                                     repeats:NO];
    //WeakSelf
    [YSNetworkTool POST:login params:@{@"loginName":_phoneTF.text,@"password":_passwordTF.text} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([YSNetworkTool isSuccessWithResp:responseObject]) {
            YSAccount *account = [YSAccount mj_objectWithKeyValues:responseObject[kData]];
            [YSAccountTool saveAccount:account];
            [self loadUserInfo];
        }else{
//            [YTAlertUtil showTempInfo:responseObject[kMessage]];
        }
    } failure:nil];
}
-(void)loadUserInfo{
    [YSNetworkTool POST:v1PrivateUserInfo params:nil showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        privateUserInfoModel *userInfoModel = [privateUserInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
        userInfoModel.ID = responseObject[@"data"][@"id"];
        self.nickName = userInfoModel.nickName;
        self.ID = userInfoModel.modelId;
        self.token = userInfoModel.rongyunToken;
        [YSAccountTool saveUserinfo:userInfoModel];
        RCUserInfo * user = [[RCUserInfo alloc] initWithUserId:userInfoModel.modelId name:userInfoModel.nickName portrait:userInfoModel.headImage]; 
        if (!user.portraitUri || user.portraitUri.length <= 0) {
            user.portraitUri = [RCDUtilities defaultUserPortrait:user];
        }
        [[RCDataBaseManager shareInstance] insertUserToDB:user];
        [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:userInfoModel.modelId];
        [RCIM sharedRCIM].currentUserInfo = user;
        [KUserDefults setObject:user.portraitUri forKey:@"userPortraitUri"];
        [KUserDefults setObject:user.name forKey:@"userNickName"];
        [KUserDefults synchronize];
        [self loginRongCloud:userInfoModel.nickName userId:userInfoModel.modelId token:self.token password:self.passwordTF.text];
       
    } failure:nil];
}

/**
 *  登录融云服务器
 *
 *  @param userName 用户名
 *  @param token    token
 *  @param password 密码
 */
- (void)loginRongCloud:(NSString *)userName
                userId:(NSString *)userId
                 token:(NSString *)token
              password:(NSString *)password{
    //登录融云服务器
    [[RCIM sharedRCIM] connectWithToken:token
                                success:^(NSString *userId) {
                                    NSLog([NSString stringWithFormat:@"token is %@  userId is %@", token, userId], nil);
                                    [self loginSuccess:userName userId:userId token:token password:password];
                                    
                                }
                                  error:^(RCConnectErrorCode status) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                          
                                          NSLog(@"RCConnectErrorCode is %ld", (long)status);
                                          [YTAlertUtil showTempInfo:@"登录失败"]; 
                                          // SDK会自动重连登录，这时候需要监听连接状态
                                          [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
                                      });
                                      //        //SDK会自动重连登陆，这时候需要监听连接状态
                                      //        [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
                                  }
                         tokenIncorrect:^{
                             NSLog(@"IncorrectToken");
                             
                         }];
}
- (void)loginSuccess:(NSString *)userName
              userId:(NSString *)userId
               token:(NSString *)token
            password:(NSString *)password {
    [self invalidateRetryTime];
    //保存默认用户
    [KUserDefults setObject:userName forKey:@"userName"];
    [KUserDefults setObject:password forKey:@"userPwd"];
    [KUserDefults setObject:token forKey:@"userToken"];
    [KUserDefults setObject:userId forKey:@"userId"];
    [KUserDefults synchronize];
    //保存“发现”的信息
//    [RCDHTTPTOOL getSquareInfoCompletion:^(NSMutableArray *result) {
//        [DEFAULTS setObject:result forKey:@"SquareInfoList"];
//        [DEFAULTS synchronize];
//    }];
    //同步群组
    [RCDDataSource syncGroups];
//    [RCDDataSource syncFriendList:userId
//                         complete:^(NSMutableArray *friends){
//                         }];
    dispatch_async(dispatch_get_main_queue(), ^{
        BaseTabBarController *mainTabBarVC = [[BaseTabBarController alloc] init];
        kWindow.rootViewController = mainTabBarVC;
    });
}
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (status == ConnectionStatus_Connected) {
            [RCIM sharedRCIM].connectionStatusDelegate =
            (id<RCIMConnectionStatusDelegate>)[UIApplication sharedApplication].delegate;
            
        } else if (status == ConnectionStatus_NETWORK_UNAVAILABLE) {
            [YTAlertUtil showTempInfo:@"当前网络不可用，请检查！"];
        } else if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
            [YTAlertUtil showTempInfo:@"您的帐号在别的设备上登录，您被迫下线！"];
        } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
            NSLog(@"Token无效");
//            self.errorMsgLb.text = @"无法连接到服务器！";
//            if (self.loginFailureTimes < 1) {
//                self.loginFailureTimes++;
//                [AFHttpTool getTokenSuccess:^(id response) {
//                    self.loginToken = response[@"result"][@"token"];
//                    self.loginUserId = response[@"result"][@"userId"];
//                    [self loginRongCloud:self.loginUserName
//                                  userId:self.loginUserId
//                                   token:self.loginToken
//                                password:self.loginPassword];
//                }
//                                    failure:^(NSError *err) {
//                                        dispatch_async(dispatch_get_main_queue(), ^{
//                                            [hud hide:YES];
//                                            NSLog(@"Token无效");
//                                            self.errorMsgLb.text = @"无法连接到服务器！";
//                                        });
//                                    }];
//            }
        } else {
            NSLog(@"RCConnectErrorCode is %zd", status);
        }
    });
}
- (void)invalidateRetryTime {
    [self.retryTime invalidate];
    self.retryTime = nil;
}
- (void)retryConnectionFailed {
    [[RCIM sharedRCIM] disconnect];
    [self invalidateRetryTime];
}
- (IBAction)forgetBtnClick:(id)sender {
    ChangePasswordController *forgetVC = [[ChangePasswordController alloc]init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}
- (IBAction)registerBtnClick:(id)sender {
    YSRegisterController *registerVC = [[YSRegisterController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}
- (IBAction)wxBtnClick:(id)sender {
    [YTAlertUtil showTempInfo:@"微信登录"];
}
- (IBAction)qqBtnClick:(id)sender {
    [YTAlertUtil showTempInfo:@"QQ登录"];
}
@end
