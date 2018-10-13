//
//  AccontManageController.m
//  ConnectionCity
//
//  Created by qt on 2018/6/6.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AccontManageController.h"
#import "AccountManageCell.h"
#import "YSLoginController.h"
#import "RCDataBaseManager.h"
#import "privateUserInfoModel.h"
#import <RongIMKit/RongIMKit.h>
#import "privateUserInfoModel.h"
#import "RCDUtilities.h"
#import "RCDataBaseManager.h"
#import "RCDRCIMDataSource.h"
#import <JPUSHService.h>
@interface AccontManageController ()<UITableViewDelegate,UITableViewDataSource,RCIMConnectionStatusDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@property (nonatomic,assign)NSInteger  selectRow;
@property (nonatomic,assign)NSInteger  selectRow1;
@property (nonatomic, strong) NSArray *accountArr;
@property(nonatomic, strong) NSTimer *retryTime;
@property (nonatomic,strong) NSString * nickName;
@property (nonatomic,strong) NSString * ID;
@property (nonatomic,strong) NSString * token;
@end
@implementation AccontManageController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.navigationItem.title  = @"账号管理";
//    [kDefaults setObject: @[@{@"account": @"13525006051",@"psd":@"123456"},@{@"account": @"13525006051",@"psd":@"123456"}] forKey:KAccountManager];
//    [kDefaults removeObjectForKey:KAccountManager];
    self.accountArr = [kDefaults objectForKey:KAccountManager];
    self.selectRow = 9999;
    self.selectRow1 = [[KUserDefults objectForKey:@"Online"] integerValue]?[[KUserDefults objectForKey:@"Online"] integerValue]:0;
    NSString * status = [[YSAccountTool userInfo] status];
    if ([status isEqualToString:@"0"]) {
        _selectRow1 = 0;
    }else{
        _selectRow1 = 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return _accountArr.count + 1;
    }else
        return 3;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountManageCell * cell = [AccountManageCell tempTableViewCellWith:tableView indexPath:indexPath];
    AccountManageCell * addcell = [tableView dequeueReusableCellWithIdentifier:@"AccountManageCell"];
    if (!addcell) {
        addcell = [[NSBundle mainBundle] loadNibNamed:@"AccountManageCell" owner:nil options:nil][1];
    }
    if (indexPath.row < _accountArr.count) {
        NSDictionary *dic = _accountArr[indexPath.row];
        if ([[dic objectForKey:@"id"] isEqualToString:kAccount.userId]) {
            _selectRow = indexPath.row;
        }
    }
    if(indexPath.section==0&&indexPath.row<_accountArr.count) {
        //重用机制，如果选中的行正好要重用
        if( indexPath.row ==_selectRow)
        {
            cell.iamge_Select.image = [UIImage imageNamed:@"our-chose"];
        } else {
            cell.iamge_Select.image = [UIImage imageNamed:@""];
        }
        NSDictionary *dic = _accountArr[indexPath.row];
        cell.accountLab.text = [dic objectForKey:@"id"];
    }
    if (indexPath.section==1) {
        //重用机制，如果选中的行正好要重用
        if( indexPath.row ==_selectRow1)
        {
            cell.image_onLine.selected = YES;
        } else {
            cell.image_onLine.selected = NO;
        }
        cell.currentCountLab.text = indexPath.row==0?@"在线状态":@"隐身状态";
    }
    if (indexPath.section==0&&indexPath.row==_accountArr.count) {
        return addcell;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.0001f;
    }else
        return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==1) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        view.backgroundColor = YSColor(239, 239, 239);
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 40)];
        lab.text = @"设置在线状态";
        lab.textColor = YSColor(69, 69, 69);
        lab.font = [UIFont systemFontOfSize:14];
        [view addSubview:lab];
        return view;
    }else
        return [UIView new];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==_accountArr.count) {
        //[YTAlertUtil showTempInfo:@"退出登录"];
        [YSAccountTool deleteAccount];
        [KUserDefults removeObjectForKey:@"userToken"];
        [KUserDefults removeObjectForKey:@"userCookie"];
        [KUserDefults removeObjectForKey:@"isLogin"];
        [KUserDefults synchronize];
        [[RCDataBaseManager shareInstance] closeDBForDisconnect];
        [[RCIMClient sharedRCIMClient] logout];
        //[[RCIMClient sharedRCIMClient]disconnect:NO];
        
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.cn.rongcloud.im.share"];
        [userDefaults removeObjectForKey:@"Cookie"];
        [userDefaults synchronize];
        YSLoginController *loginVC = [[YSLoginController alloc]init];
        BaseNavigationController * base = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        [kWindow setRootViewController:base];
    } else if (indexPath.section==0&&indexPath.row < _accountArr.count) {
        if(indexPath.row !=  _selectRow) {
            _selectRow= indexPath.row;
            [self loginBtnClick:_accountArr[indexPath.row]];
        }
    }else if (indexPath.section==1&&indexPath.row<2){
        if(indexPath.row !=  _selectRow1) {
            _selectRow1= indexPath.row;
            [self.tab_Bottom reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            [self updateUseLat:_selectRow1==0?1:2];
        }
    }else if (indexPath.section==1&&indexPath.row==2){
        [YTAlertUtil alertDualWithTitle:@"连程" message:@"是否要退出当前账号" style:UIAlertControllerStyleAlert cancelTitle:@"否" cancelHandler:^(UIAlertAction *action) {
            
        } defaultTitle:@"是" defaultHandler:^(UIAlertAction *action) {
            [YSAccountTool deleteAccount];
            [KUserDefults removeObjectForKey:@"userToken"];
            [KUserDefults removeObjectForKey:@"userCookie"];
            [KUserDefults removeObjectForKey:@"isLogin"];
            [KUserDefults synchronize];
            [[RCDataBaseManager shareInstance] closeDBForDisconnect];
            [[RCIMClient sharedRCIMClient] logout];
            //[[RCIMClient sharedRCIMClient]disconnect:NO];
            
            NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.cn.rongcloud.im.share"];
            [userDefaults removeObjectForKey:@"Cookie"];
            [userDefaults synchronize];
            YSLoginController *loginVC = [[YSLoginController alloc]init];
            BaseNavigationController * base = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
            [kWindow setRootViewController:base];
        } completion:nil];
    }
}
#pragma mark ------
-(void)updateUseLat:(NSInteger)a{
    NSDictionary * dic = @{
                           @"status": @(a)
                           };
    [YSNetworkTool POST:v1PrivateUserUpdate params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        privateUserInfoModel *userInfoModel = [privateUserInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
        [YSAccountTool saveUserinfo:userInfoModel];
        [KUserDefults setObject:KString(@"%ld", (long)a) forKey:@"Online"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)loginBtnClick:(NSDictionary *)dic {
    [KUserDefults removeObjectForKey:@"userToken"];
    [KUserDefults removeObjectForKey:@"userCookie"];
    [KUserDefults removeObjectForKey:@"isLogin"];
    [KUserDefults synchronize];
    [[RCDataBaseManager shareInstance] closeDBForDisconnect];
    [[RCIMClient sharedRCIMClient] logout];
    //[[RCIMClient sharedRCIMClient]disconnect:NO];
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.cn.rongcloud.im.share"];
    [userDefaults removeObjectForKey:@"Cookie"];
    [userDefaults synchronize];
    self.retryTime = [NSTimer scheduledTimerWithTimeInterval:60
                                                      target:self
                                                    selector:@selector(retryConnectionFailed)
                                                    userInfo:nil
                                                     repeats:NO];
    WeakSelf
    [YSNetworkTool POST:login params:@{@"loginName":[dic objectForKey:@"account"],@"password":[dic objectForKey:@"psd"],@"status":@"1"} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([YSNetworkTool isSuccessWithResp:responseObject]) {
            [JPUSHService setAlias:[responseObject[@"data"][@"userId"] description] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                NSLog(@"别名设置为%ld---%@",(long)iResCode,iAlias);
            } seq:10000];
            YSAccount *account = [YSAccount mj_objectWithKeyValues:responseObject[kData]];
            [YSAccountTool saveAccount:account];
            [weakSelf loadUserInfo:dic];
        }else{
            [YTAlertUtil showTempInfo:responseObject[kMessage]];
        }
    } failure:nil];
}
-(void)loadUserInfo:(NSDictionary *)dic{
    [YSNetworkTool POST:v1PrivateUserInfo params:nil showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        privateUserInfoModel *userInfoModel = [privateUserInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
        userInfoModel.ID = responseObject[@"data"][@"id"];
        self.nickName = userInfoModel.nickName;
        self.ID = userInfoModel.modelId;
        self.token = userInfoModel.rongyunToken;
        [YSAccountTool saveUserinfo:userInfoModel];
        [self loginRongCloud:userInfoModel.nickName userId:userInfoModel.modelId token:self.token password:[dic objectForKey:@"psd"] dic:dic];
        RCUserInfo * user = [[RCUserInfo alloc] initWithUserId:userInfoModel.modelId name:userInfoModel.nickName?userInfoModel.nickName:userInfoModel.modelId portrait:userInfoModel.headImage];
        if ([YSTools dx_isNullOrNilWithObject:user.portraitUri] || user.portraitUri.length <= 0) {
            user.portraitUri = [RCDUtilities defaultUserPortrait:user];
        }
        [[RCDataBaseManager shareInstance] insertUserToDB:user];
        [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:userInfoModel.modelId];
        [RCIM sharedRCIM].currentUserInfo = user;
        [KUserDefults setObject:user.portraitUri forKey:@"userPortraitUri"];
        [KUserDefults setObject:user.name forKey:@"userNickName"];
        [KUserDefults synchronize];
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
              password:(NSString *)password
                   dic:(NSDictionary *)dic{
    //登录融云服务器
    WeakSelf
    [[RCIM sharedRCIM] connectWithToken:token
                                success:^(NSString *userId) {
                                    NSLog([NSString stringWithFormat:@"token is %@  userId is %@", token, userId], nil);
                                    [self loginSuccess:userName userId:userId token:token password:password dic:dic];
                                    
                                }
                                  error:^(RCConnectErrorCode status) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          
                                          NSLog(@"RCConnectErrorCode is %ld", (long)status);
                                          [YTAlertUtil showTempInfo:@"登录失败"];
                                          // SDK会自动重连登录，这时候需要监听连接状态
                                          [[RCIM sharedRCIM] setConnectionStatusDelegate:weakSelf];
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
            password:(NSString *)password
                 dic:(NSDictionary *)dic{
    [self invalidateRetryTime];
    //保存默认用户
    [KUserDefults setObject:userName forKey:@"userName"];
    [KUserDefults setObject:password forKey:@"userPwd"];
    [KUserDefults setObject:token forKey:@"userToken"];
    [KUserDefults setObject:userId forKey:@"userId"];
    //删除旧账号存储的信息
    [kDefaults removeObjectForKey:@"cellCntentText"];
    [kDefaults removeObjectForKey:@"citymooo"];
    [kDefaults synchronize];

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
    WeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
//        UIWindow *win = [[UIApplication sharedApplication].windows objectAtIndex:0];
        [KUserDefults setObject:[dic objectForKey:@"account"] forKey:@"userPhone"];
        [KUserDefults synchronize];
//        BaseTabBarController *mainTabBarVC = [[BaseTabBarController alloc] init];
//        win.rootViewController = mainTabBarVC;
        [YTAlertUtil showTempInfo:@"切换成功"];
        [weakSelf.tab_Bottom reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MYADDRESSBOOK" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOADSERVICELIST" object:nil];
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
@end
