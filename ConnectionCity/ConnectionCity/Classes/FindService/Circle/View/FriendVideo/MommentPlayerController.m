//
//  MommentPlayerController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "MommentPlayerController.h"
#import <IQKeyboardManager.h>
#import "CustomPlayer.h"
#import "Utility.h"
#import "AllDicMo.h"
#import "CircleNet.h"
#import "EvaluationController.h"
#import "RCDChatViewController.h"
#import "PersonalBasicDataController.h"
#import "ServiceListController.h"
#import "privateUserInfoModel.h"
#import "ServiceHomeNet.h"
#import "ShowResumeController.h"
@interface MommentPlayerController ()<LPAVPlayerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lab_Zan;
@property (weak, nonatomic) IBOutlet UILabel *like_Zan;
@property (weak, nonatomic) IBOutlet UIButton *btn_PL;
@property (weak, nonatomic) IBOutlet UIImageView *imageBg;
@property (weak, nonatomic) IBOutlet UIImageView *image_head;
@property (weak, nonatomic) IBOutlet UILabel *lab_title;
@property (weak, nonatomic) IBOutlet UILabel *lab_SubTitle;
@property (weak, nonatomic) IBOutlet UILabel *lab_time;
@property (weak, nonatomic) IBOutlet UIButton *btn_Zan;
@property (weak, nonatomic) IBOutlet UIButton *btn_like;
@property (weak, nonatomic) IBOutlet UIButton *btn_moment;
@property (weak, nonatomic) IBOutlet UIView *view_Zan;
@property (weak, nonatomic) IBOutlet UIView *view_Like;
@property (weak, nonatomic) IBOutlet UIView *view_moment;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_zan;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_PL;
@property (weak, nonatomic) IBOutlet UIButton *btn_YD;
@property (nonatomic,strong) CustomPlayer * playView;
@property (nonatomic,strong) UIView * mainView;
@end

@implementation MommentPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setMoment:self.moment];
}
-(void)setUI{
    self.navigationItem.title = @"服务圈视频";
    [self.view addSubview:self.playView];
    UIBarButtonItem * itemJB = [UIBarButtonItem itemWithTarget:self action:@selector(JB) image:@"" title:@"举报" EdgeInsets:UIEdgeInsetsZero];
    UIBarButtonItem * itemFX = [UIBarButtonItem itemWithTarget:self action:@selector(ShareBtn) image:@"share-1" title:@"" EdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    if ([[[YSAccountTool userInfo] modelId] isEqualToString:APPID]) {
        self.navigationItem.rightBarButtonItems = @[itemFX,itemJB];
    }else{
        self.navigationItem.rightBarButtonItem = itemFX;
    }
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 40)];
    view.backgroundColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.view addSubview:view];
    self.mainView = view;
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, view.width-65, view.height-10)];
    textField.tag=10;
    textField.font = [UIFont systemFontOfSize:14];
    textField.placeholder = @"请输入评论内容";
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [view addSubview:textField];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-50, 0, 40, view.height)];
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    if (![[self.moment.userMo.ID description] isEqualToString:[[YSAccountTool userInfo]modelId]]) {
        self.layout_zan.constant = 100;
        self.view_moment.hidden = YES;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPoint:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)JB{
    [YTAlertUtil alertDualWithTitle:@"温馨提示" message:@"是否要举报该用户" style:UIAlertControllerStyleAlert cancelTitle:@"否" cancelHandler:^(UIAlertAction *action) {
        
    } defaultTitle:@"是" defaultHandler:^(UIAlertAction *action) {
        [YTAlertUtil showHUDWithTitle:@"举报中..."];
        int64_t delayInSeconds = 1+arc4random()%2; // 延迟的时间
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [YTAlertUtil hideHUD];
            [YTAlertUtil showTempInfo:@"举报成功,平台将会在24小时之内给出回复"];
        });
    } completion:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //写入这个方法后,这个页面将没有这种效果
    [IQKeyboardManager sharedManager].enable = NO;
//    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    WeakSelf
    [CircleNet requstCircleDetail:@{@"id":self.moment.ID} withSuc:^(Moment *mo) {
        if ([mo.userMo.isFriend isEqualToString:@"1"]||[mo.userMo.ID isEqualToString:[[YSAccountTool userInfo] modelId]]) {
            weakSelf.layout_PL.constant = 10;
            weakSelf.btn_YD.hidden = YES;
        }
    }];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}
#pragma mark ----发送按钮-----
-(void)btnClicked{
    NSArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:KAllDic]];
     UITextField * txt  = (UITextField*)[self.mainView viewWithTag:10];
    if (txt.text.length==0) {
        [YTAlertUtil showTempInfo:@"请输入评论内容"];
        return;
    }
    AllContentMo * mo = [arr[5] contentArr][4];
    NSDictionary * dic = @{
                           @"content": txt.text,
                           @"score": @0,
                           @"type": @([mo.value integerValue]),
                           @"typeId": @([self.moment.ID integerValue])
                           };
    [CircleNet requstSendPL:dic withSuc:^(NSDictionary *successDicValue) {
        [txt resignFirstResponder];
        [self.btn_PL setTitle:KString(@"评论(%ld)", [self.moment.commentCount integerValue]+1) forState:UIControlStateNormal];
    }];
}
- (IBAction)TanClick:(UIButton *)sender {
    UITextField * txt  = (UITextField*)[self.mainView viewWithTag:10];
    txt.text = @"";
    [txt becomeFirstResponder];
   
}
// 收缩键盘
-(void)dismissKeyBoard:(NSNotification *)notification
{
    [self kebordY:notification flag:1];
}
// 根据键盘状态，调整_mainView的位置
- (void) changeContentViewPoint:(NSNotification *)notification{
    [self kebordY:notification flag:2];
}
-(void)kebordY:(NSNotification *)notification flag:(int)a{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;  // 得到键盘弹出后的键盘视图所在y坐标
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        _mainView.center = CGPointMake(_mainView.center.x,   a==1?keyBoardEndY+20:keyBoardEndY-64-20);   // keyBoardEndY的坐标包括了状态栏的高度，要减去
    }];
}
-(void)setMoment:(Moment *)moment{
    _moment = moment;
    [self.imageBg sd_setImageWithURL:[NSURL URLWithString:moment.videoCover] placeholderImage:[UIImage imageNamed:@"no-pic"]];
    [self.image_head sd_setImageWithURL:[NSURL URLWithString:moment.userMo.headImage] placeholderImage:[UIImage imageNamed:@"no-pic"]];
    self.lab_title.text = moment.userMo.nickName;
    self.lab_SubTitle.text = moment.content;
    self.lab_time.text = [YSTools compareCurrentTime:moment.createTime];
    [self.btn_PL setTitle:KString(@"评论(%@)", moment.commentCount) forState:UIControlStateNormal];
    self.lab_Zan.text = KString(@"%@", moment.likeCount);
    self.like_Zan.text = KString(@"%@", moment.likeCount);
}
//分享
-(void)ShareBtn{
    [YSShareTool share];
}
- (IBAction)BtnClcik:(UIButton *)sender {
    if (sender.tag==5) {
        NSDictionary * dic1 = @{
                                @"cityCode":self.moment.userMo.cityCode?self.self.moment.userMo.cityCode:@"",
                                @"lat": @([self.moment.userMo.lat floatValue]),
                                @"lng": @([self.moment.userMo.lng floatValue]),
                                @"userId":self.moment.userMo.ID
                                };
        //    加载服务列表
        [ServiceHomeNet requstServiceList:dic1 withSuc:^(NSMutableArray *successArrValue) {
            if (successArrValue.count==0) {
                return [YTAlertUtil showTempInfo:@"该用户暂无服务"];
            }
            ShowResumeController * show = [ShowResumeController new];
            show.Receive_Type = ENUM_TypeTrval;
            show.data_Count = successArrValue;
            show.flag = @"1";
            __block NSUInteger index = 0;
            show.zIndex = index;
            [self.navigationController pushViewController:show animated:YES];
        }];
//        ServiceListController * servist = [ServiceListController new];
//        servist.user = self.moment.userMo;
//        [self.navigationController pushViewController:servist animated:YES];
    }
    if (sender.tag==4) {
        if ([self.btn_PL.titleLabel.text isEqualToString:@"评论(0)"]) {
            return [YTAlertUtil showTempInfo:@"暂无评论信息"];
        }
        EvaluationController * ev = [EvaluationController new];
        ev.block = ^{
            self.block();
        };
        ev.moment = self.moment;
        [self.navigationController pushViewController:ev animated:YES];
    }
}
#pragma ---------个人详情----------
- (IBAction)btn_ppersonDetail:(UIButton *)sender {
    PersonalBasicDataController * person = [PersonalBasicDataController new];
    Moment * moment = self.moment;
    person.connectionMo = moment.userMo;
    [self.navigationController pushViewController:person animated:YES];
}
#pragma -------play---------
- (IBAction)palyBtnClcik:(UIButton *)sender {
    self.imageBg.hidden = YES;
    self.playView.hidden = NO;
    [self.playView setupPlayerWith:[NSURL URLWithString:self.moment.videos]];
    [self.view bringSubviewToFront:self.image_head];
    [self.view bringSubviewToFront:self.lab_title];
    [self.view bringSubviewToFront:self.lab_SubTitle];
    [self.view bringSubviewToFront:self.lab_time];
    [self.view bringSubviewToFront:self.view_Zan];
    [self.view bringSubviewToFront:self.view_moment];
    [self.view bringSubviewToFront:self.view_Like];
}
// 数据刷新
- (void)refreshDataWith:(NSTimeInterval)totalTime Progress:(NSTimeInterval)currentTime LoadRange:(NSTimeInterval)loadTime{
    
}
// 状态/错误 提示
- (void)promptPlayerStatusOrErrorWith:(LPAVPlayerStatus)status{
    
}
//几个按钮点击、点赞、收藏、私信
- (IBAction)BtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            [self dianzanClick];
        }
            break;
        case 2:
        {
            [self likeClick];
        }
            break;
        case 3:
        {
            [self sixinClick];
        }
            break;
        default:
            break;
    }
}
//点赞
-(void)dianzanClick{
//    [YTAlertUtil showTempInfo:@"点赞"];
    NSArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:KAllDic]];
    AllContentMo * mo = [arr[5] contentArr][4];;
    [YSNetworkTool POST:v1CommonCommentAddlike params:@{@"typeId":@([self.moment.ID integerValue]),@"type":mo.value,@"commentedUserId":[[YSAccountTool userInfo] modelId]} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [YTAlertUtil showTempInfo:responseObject[@"message"]];
        self.lab_Zan.text =  [responseObject[@"data"]description];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
//收藏
-(void)likeClick{
    NSArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:KAllDic]];
    AllContentMo * mo = [arr[4] contentArr][1];
    [YSNetworkTool POST:v1CommonCollectCreate params:@{@"typeId":@([self.moment.ID integerValue]),@"type":mo.value} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) { 
        [YTAlertUtil showTempInfo:responseObject[@"message"]];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
//私信
-(void)sixinClick{
//    RCDChatViewController *chatViewController = [[RCDChatViewController alloc] init];
//    chatViewController.conversationType = ConversationType_PRIVATE;
//    NSString *title,*ID,*name;
//    ID = [self.moment.userId description];
//    name = self.moment.userMo.nickName;
//    chatViewController.targetId = ID;
//    if ([ID isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
//        title = [RCIM sharedRCIM].currentUserInfo.name;
//    } else {
//        title = name;
//    }
//    chatViewController.title = title;
//    chatViewController.displayUserNameInCell = NO;
//    [self.navigationController pushViewController:chatViewController animated:YES];
    WeakSelf
    [YTAlertUtil alertDualWithTitle:@"连程" message:@"是否要删除当前视频" style:UIAlertControllerStyleAlert cancelTitle:@"否" cancelHandler:^(UIAlertAction *action) {
        
    } defaultTitle:@"是" defaultHandler:^(UIAlertAction *action) {
         [weakSelf ClearAll];
    } completion:nil];
   
}
-(void)ClearAll{
//    NSString * url = [self.flagStr isEqualToString:@"HomeSend"]?v1FriendCircleDelete:v1ServiceCircleDelete;
    WeakSelf
    [YSNetworkTool POST:v1ServiceCircleDelete params:@{@"id":self.moment.ID} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        weakSelf.block();
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [YTAlertUtil showTempInfo:@"删除成功"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
-(CustomPlayer *)playView{
    if (!_playView) {
        _playView = [[CustomPlayer alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, kScreenHeight-145)];
        _playView.hidden = YES;
    }
    return _playView;
}
@end
