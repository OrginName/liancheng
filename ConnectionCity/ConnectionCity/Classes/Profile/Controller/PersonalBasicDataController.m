//
//  PersonalBasicDataController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/21.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "PersonalBasicDataController.h"
#import "EditAllController.h"
#import "RCDChatViewController.h"
#import "RCDHttpTool.h"
#import "RCDChatViewController.h"
#import "CircleNet.h"
#import "privateUserInfoModel.h"
#import "FriendCircleController.h"
#import "ZoomImage.h"
@interface PersonalBasicDataController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scro_View;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_View;
@property (weak, nonatomic) IBOutlet UIView *view_Phone;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_phone;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutMu;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;
@property (weak, nonatomic) IBOutlet UILabel *introduceLab;
@property (weak, nonatomic) IBOutlet UILabel *lcNumLab;
@property (weak, nonatomic) IBOutlet UILabel *beiZhuLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIView *view_btn;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageBtn;
@property (weak, nonatomic) IBOutlet UIView *view_Image;
@property (weak, nonatomic) IBOutlet UIButton *btn_BZ;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_Btn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_view;
@property (weak, nonatomic) IBOutlet UIView *view_leftRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_jia;
@end
@implementation PersonalBasicDataController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    if (self.arr_User.count==0) {
        [self setConnectionMo:self.connectionMo];
        self.view_leftRight.hidden = YES;
        self.layout_view.constant = 0;
    }else{
        UserMo * user = self.arr_User[self.flag];
        [self setConnectionMo:user];
    }
    if ([self.flagStr isEqualToString:@"BLACKLIST"]) {
        self.view_btn.hidden = YES;
        self.btn_BZ.userInteractionEnabled = NO;
    }
}
-(void)loadFriendList{
    WeakSelf
    [YSNetworkTool POST:v1PrivateUserUserinfo params:@{@"id":self.connectionMo.ID} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray * arr = responseObject[@"data"][@"serviceCircleList"];
        NSMutableArray * arr1 = [NSMutableArray array];
        for (int i=0; i<(arr.count>4?4:arr.count); i++) {
            NSDictionary * dic = arr[i];
            if ([dic[@"images"] isKindOfClass:[NSString class]]&&[dic[@"images"] description]!=0) {
                NSString * url =[dic[@"images"] componentsSeparatedByString:@";"][0];
                [arr1 addObject:url];
            }
        }
        [weakSelf loadData:[arr1 copy]];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

-(void)setConnectionMo:(UserMo *)connectionMo{
    _connectionMo = connectionMo;
    if (_connectionMo!=nil) {
        [self.backgroundImage sd_setImageWithURL:[NSURL URLWithString:connectionMo.backgroundImage] placeholderImage:[UIImage imageNamed:@"2"]];
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:[connectionMo.headImage description]] placeholderImage:[UIImage imageNamed:@"our-center-1"]];
        self.sexImage.image =[UIImage imageNamed:[[connectionMo.gender description] isEqualToString:@"1"]?@"men":@"women"];
        self.nickNameLab.text = connectionMo.nickName?connectionMo.nickName:[connectionMo.ID description];
        self.introduceLab.text = connectionMo.sign?connectionMo.sign:@"";
        self.lcNumLab.text = [connectionMo.ID description];
        if ([[connectionMo.ID description] isEqualToString:[[YSAccountTool userInfo] modelId]]) {
            self.view_Phone.hidden = NO;
            self.layout_phone.constant = 50;
            self.layout_View.constant = 280;
            if (self.arr_User.count==0) {
               self.view_leftRight.hidden = YES;
               self.layout_view.constant = 0;
                self.view_btn.hidden = YES;
                self.layout_Btn.constant = 0;
            }else{
                self.layoutMu.constant = (kScreenWidth-50)/2-40;
            }
        }
        self.phoneNumLab.text = [connectionMo.mobile description];
        self.addressLab.text = [connectionMo.cityName description];
        if ([[connectionMo.isFriend description] isEqualToString:@"1"]) {
            self.layoutMu.constant = (kScreenWidth-50)/2-40;
        }else if(![[connectionMo.ID description] isEqualToString:[[YSAccountTool userInfo] modelId]]){
            self.layoutMu.constant = self.layout_jia.constant-40;
        }
        self.beiZhuLab.text = connectionMo.friendRemark?connectionMo.friendRemark:connectionMo.nickName;
        if (connectionMo.serviceCircleList.count!=0) {
            NSMutableArray * arr1 = [NSMutableArray array];
            for (int i=0; i<(connectionMo.serviceCircleList.count>4?4:connectionMo.serviceCircleList.count); i++) {
                NSDictionary * dic = connectionMo.serviceCircleList[i];
                if (![YSTools dx_isNullOrNilWithObject:dic[@"images"]]) {
                    NSString * url = [dic[@"images"] componentsSeparatedByString:@";"][0];
                    [arr1 addObject:url];
                }
            }
            [self loadData:[arr1 copy]];
        }else{
            [self loadFriendList];
        }
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //关闭自适应
    if (@available(iOS 11.0, *)) {
        self.scro_View.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //设置导航透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    //去掉导航栏底部的黑线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:
     [UIImage imageNamed:@"椭圆2拷贝4"] forBarMetrics:UIBarMetricsDefault];
}
#pragma mark - setup
- (void)setUI {
    self.navigationItem.title = @"基础资料";
    _headImage.layer.cornerRadius = 27;
    _headImage.clipsToBounds = YES;
}
#pragma ----------头像点击放大----------
- (IBAction)ZomIn:(UIButton *)sender {
    [ZoomImage showImage:self.headImage];
}
#pragma mark - 点击事件
- (IBAction)sendMessageBtnClick:(id)sender {
    UIButton * btn = (UIButton *)sender;
    if (btn.tag==1) {
        if ([self.flagStr isEqualToString:@"CHAT"]) {
            [CircleNet requstUserPZDetail:@{@"id":self.connectionMo.ID} withSuc:^(NSDictionary *successDicValue) {
                NSString * str = [successDicValue[@"data"][@"openSearchUserID"] description];
                if ([str isEqualToString:@"1"]) {
                    [RCDHTTPTOOL requestFriend:self.connectionMo.ID complete:^(BOOL result) {
                        if (result) {
                            [YTAlertUtil showTempInfo:@"好友申请已发送"];
                        }
                    }];
                }else{
                    [YTAlertUtil alertSingleWithTitle:@"连程" message:@"对方已关闭通过连程号添加好友" defaultTitle:@"确定" defaultHandler:^(UIAlertAction *action) {
                        
                    } completion:nil];
                }
            }];
        }else{
            [RCDHTTPTOOL requestFriend:self.connectionMo.ID complete:^(BOOL result) {
                if (result) {
                    [YTAlertUtil showTempInfo:@"好友申请已发送"];
                }
            }];
        }
    }else{
        if ([[self.connectionMo.isBlack description] isEqualToString:@"1"]) {
            return [YTAlertUtil showTempInfo:@"您已在对方的黑名单中,暂不能聊天"];
        }
        RCDChatViewController *chatViewController = [[RCDChatViewController alloc] init];
        chatViewController.conversationType = ConversationType_PRIVATE;
        
        chatViewController.targetId = [self.connectionMo.ID description];
        NSString *title;
        if ([KString(@"%@", self.connectionMo.ID) isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
            title = [RCIM sharedRCIM].currentUserInfo.name;
        } else {
//            if (self.friendInfo.displayName.length > 0) {
//                title = self.friendInfo.displayName;
//            } else {
            title = self.connectionMo.nickName?self.connectionMo.nickName:self.connectionMo.ID;
//            }
        }
        chatViewController.title = title;
//        chatViewController.needPopToRootView = YES;
        chatViewController.displayUserNameInCell = NO;
        [self.navigationController pushViewController:chatViewController animated:YES];
    }
}
- (IBAction)beizhuBtnClick:(id)sender {
    if (![[self.connectionMo.isFriend description] isEqualToString:@"1"]) {
        return [YTAlertUtil showTempInfo:@"对方还不是您的好友,不能修改"];
    }
    EditAllController * edit = [EditAllController new];
    edit.receiveTxt = self.beiZhuLab.text;
    WeakSelf
    edit.block = ^(NSString * str){
        weakSelf.beiZhuLab.text = str;
        [weakSelf updateBeiZhu:str];
    };
    [self.navigationController pushViewController:edit animated:YES];
}
#pragma ------------好友动态---------------------
- (IBAction)btn_friendDT:(UIButton *)sender {
    FriendCircleController * friend = [FriendCircleController new];
    friend.user = self.connectionMo;
    [self.navigationController pushViewController:friend animated:YES];
}
#pragma ------------上一个 下一个---------------------
- (IBAction)nextAndReturn:(UIButton *)sender {
    switch (sender.tag) {
        case 3:
            {
                self.flag--;
                if (self.flag<0) {
                    self.flag=0;
                    return [YTAlertUtil showTempInfo:@"再往前没有了"];
                }
                UserMo * user = self.arr_User[self.flag];
                [self setConnectionMo:user];
            }
            break;
        case 4:
        {
            self.flag++;
            if (self.flag>self.arr_User.count-1) {
                self.flag=self.arr_User.count-1;
                return [YTAlertUtil showTempInfo:@"再往后没有了"];
            }
            UserMo * user = self.arr_User[self.flag];
            [self setConnectionMo:user];
        }
            break;
        default:
            break;
    }
}
-(void)updateBeiZhu:(NSString *)str{
    if (str.length==0) {
        return;
    }
    NSDictionary * dic = @{
                           @"friendId": self.connectionMo.ID,
                           @"remark":str
                           };
    [YSNetworkTool POST:@"/v1/my/update-remark" params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
-(void)loadData:(NSArray *)arr{
    for (int i=0; i<arr.count; i++) {
        float width = 50;
        float kpadding = (self.view_Image.width-width*4-15)/2;
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(kpadding+i*(width+5),1, width, width)];
        [image sd_setImageWithURL:[NSURL URLWithString:arr[i]] placeholderImage:[UIImage imageNamed:@"no-pic"]];
        [self.view_Image addSubview:image];
    }
     
}
@end
