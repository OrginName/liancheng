//
//  PayOrderController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/26.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "PayOrderController.h"
#import "AllDicMo.h"
#import "HCCountdown.h"
#import "InstallmentMo.h"

@interface PayOrderController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIView *pintView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UIButton *wxPayBtn;
@property (nonatomic, strong) UIButton *lastBtn;
@property (nonatomic, strong) HCCountdown *countdown;
@property (nonatomic) long nowTimeSp;
@property (nonatomic) long fiveMinuteSp;

@end

@implementation PayOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    
    _countdown = [[HCCountdown alloc] init];
    
    //现在时间
    NSDate *datenow = [NSDate date];
    
    //获取当前时间的时间戳 long
    long timeSpam = [_countdown timeStampWithDate:datenow];
    
    //获取当前时间 NSSting
    NSString *timeStr = [_countdown getNowTimeString];
    
    //时间戳转时间
    NSString *timeStrWithSpam = [_countdown dateWithTimeStamp:timeSpam];
    
    NSLog(@"timeSpam = %ld", timeSpam);
    NSLog(@"timeDate = %@", timeStr);
    NSLog(@"timeStrWithSpam = %@", timeStrWithSpam);
    
    //创建倒计时的UI
//    [self createHeaderView];
    [self getNowTimeSP:@"订单成功"];

    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayNotice:) name:NOTI_ALI_PAY_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxNotice:) name:NOTI_WEI_XIN_PAY_SUCCESS object:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_ALI_PAY_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_WEI_XIN_PAY_SUCCESS object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    //控制器释放的时候一点要停止计时器，以免再次进入发生错误
    [_countdown destoryTimer];
}
- (void) didInBackground: (NSNotification *)notification {
    
    NSLog(@"倒计时进入后台");
    [_countdown destoryTimer];
    
}

- (void) willEnterForground: (NSNotification *)notification {
    
    NSLog(@"倒计时进入前台");
    [self getNowTimeSP:@""];  //进入前台重新获取当前的时间戳，在进行倒计时， 主要是为了解决app退到后台倒计时停止的问题，缺点就是不能防止用户更改本地时间造成的倒计时错误
    
}
- (void) getNowTimeSP: (NSString *) string {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY年MM月dd日HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成NSString
    NSString *currentTimeString_1 = [formatter stringFromDate:datenow];
    NSDate *applyTimeString_1 = [formatter dateFromString:currentTimeString_1];
    _nowTimeSp = (long long)[applyTimeString_1 timeIntervalSince1970];
    
    if ([string isEqualToString:@"订单成功"]) {
        
        NSTimeInterval time = 5 * 60;//5分钟后的秒数
        NSDate *lastTwoHour = [datenow dateByAddingTimeInterval:time];
        NSString *currentTimeString_2 = [formatter stringFromDate:lastTwoHour];
        NSDate *applyTimeString_2 = [formatter dateFromString:currentTimeString_2];
        _fiveMinuteSp = (long)[applyTimeString_2 timeIntervalSince1970];
        
    }
    
    //时间戳进行倒计时
    long startLong = _nowTimeSp;
    long finishLong = _fiveMinuteSp;
    [self startLongLongStartStamp:startLong longlongFinishStamp:finishLong];
    
    NSLog(@"currentTimeString_1 = %@", currentTimeString_1);
    NSLog(@"_nowTimeSp = %ld", _nowTimeSp);
    NSLog(@"_fiveMinuteSp = %ld", _fiveMinuteSp);
    
}
///此方法用两个时间戳做参数进行倒计时
-(void)startLongLongStartStamp:(long)strtL longlongFinishStamp:(long) finishL {
    __weak __typeof(self) weakSelf= self;
    
    NSLog(@"second = %ld, minute = %ld", strtL, finishL);
    
    [_countdown countDownWithStratTimeStamp:strtL finishTimeStamp:finishL completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
        
        [weakSelf refreshUIDay:day hour:hour minute:minute second:second];
    }];
}

-(void)refreshUIDay:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second{
    
    NSString *str_1 = [NSString stringWithFormat:@"%ld", second];
    NSString *str_2 = [NSString stringWithFormat:@"%ld", minute];
    
    if (second == 0 && minute == 0) {
        
        [_countdown destoryTimer];
        WeakSelf
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"支付超时,请重新下单" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"重新下单" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    NSString *minuteStr = [NSString stringWithFormat:@"%.2ld",(long)[str_2 integerValue]];
    NSString *secondStr = [NSString stringWithFormat:@"%.2ld",(long)[str_1 integerValue]];
    self.timeLab.text = [NSString stringWithFormat:@"支付剩余时间：%@:%@",minuteStr,secondStr];
}

#pragma mark - setup
- (void)initUI {
    self.confirmBtn.layer.cornerRadius = 3;
    self.pintView.layer.cornerRadius = 4;
    self.pintView.clipsToBounds = YES;
    self.amountLab.text = _amount;
    self.lastBtn = _wxPayBtn;
    self.navigationItem.title = @"支付订单";
}
#pragma mark - 点击事件
- (IBAction)confirmBtnClick:(id)sender {
    [self v1TalentTenderorderCreate];
}
- (IBAction)selectedBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    _lastBtn.selected = !_lastBtn.selected;
    _lastBtn = btn;
}

#pragma mark - 接口请求
//赚外快-创建订单（支付全额/分期/保证金）
- (void)v1TalentTenderorderCreate {
    if (_lastBtn==nil) {
        [YTAlertUtil showTempInfo:@"请选择支付方式"];
        return;
    }
    InstallmentMo *mo0 = self.dataArr[1][0];
    InstallmentMo *mo1 = self.dataArr[1][1];
    InstallmentMo *mo2 = self.dataArr[1][2];
    InstallmentMo *mo3 = self.dataArr[1][3];
    InstallmentMo *mo4 = self.dataArr[1][4];

    NSDictionary *dic = @{@"payTypeId": _orderType,@"tenderId":_tenderId,@"periodAmount1": mo0.data,@"periodAmount2": mo1.data,@"periodAmount3": mo2.data,@"periodAmount4": mo3.data,@"periodAmount5": mo4.data,};

    WeakSelf
    [YSNetworkTool POST:v1TalentTenderorderCreate params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        if (weakSelf.lastBtn.tag==100) {
            //[YTThirdPartyPay v1Pay:@{@"orderNo": responseObject[kData],@"payType":kBalance}];
            [weakSelf v1Pay:@{@"orderNo": responseObject[kData],@"payType":kBalance}];
        }else if (weakSelf.lastBtn.tag==101) {
            [YTThirdPartyPay v1Pay:@{@"orderNo": responseObject[kData],@"payType":kWechat}];
        }else if(weakSelf.lastBtn.tag==102){
            [YTThirdPartyPay v1Pay:@{@"orderNo": responseObject[kData],@"payType":kAlipay}];
        }
        
    } failure:nil];
}
- (void)v1Pay:(NSDictionary *)dic {
    WeakSelf
    [YSNetworkTool POST:v1Pay params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([kBalance isEqualToString:dic[@"payType"]]) {
            [YTAlertUtil alertSingleWithTitle:@"提示" message:@"支付成功" defaultTitle:@"确定" defaultHandler:^(UIAlertAction *action) {
                [kDefaults removeObjectForKey:@"cellCntentText"];
                [kDefaults removeObjectForKey:@"citymooo"];
                [kDefaults synchronize];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            } completion:nil];
        }else if ([kAlipay isEqualToString:dic[@"payType"]]) {
        }else if([kWechat isEqualToString:dic[@"payType"]]){
        }
    } failure:nil];
}
#pragma mark - alipayNotice
- (void)alipayNotice:(NSNotification *)notification {
    if ([[notification.userInfo objectForKey:@"status"] isEqualToString:@"success"]) {
        //支付成功
        WeakSelf
        [YTAlertUtil alertSingleWithTitle:@"提示" message:@"支付成功" defaultTitle:@"确定" defaultHandler:^(UIAlertAction *action) {
            [kDefaults removeObjectForKey:@"cellCntentText"];
            [kDefaults removeObjectForKey:@"citymooo"];
            [kDefaults synchronize];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        } completion:nil];
    }else if ([[notification.userInfo objectForKey:@"status"] isEqualToString:@"failure"]) {
        //支付失败
        WeakSelf
        [YTAlertUtil alertSingleWithTitle:@"提示" message:@"支付失败" defaultTitle:@"确定" defaultHandler:^(UIAlertAction *action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } completion:nil];
    }
}
- (void)wxNotice:(NSNotification *)notification {
    if ([[notification.userInfo objectForKey:@"status"] isEqualToString:@"success"]) {
        //支付成功
        WeakSelf
        [YTAlertUtil alertSingleWithTitle:@"提示" message:@"支付成功" defaultTitle:@"确定" defaultHandler:^(UIAlertAction *action) {
            [kDefaults removeObjectForKey:@"cellCntentText"];
            [kDefaults removeObjectForKey:@"citymooo"];
            [kDefaults synchronize];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        } completion:nil];
    }else if ([[notification.userInfo objectForKey:@"status"] isEqualToString:@"failure"]) {
        //支付失败
        WeakSelf
        [YTAlertUtil alertSingleWithTitle:@"提示" message:@"支付失败" defaultTitle:@"确定" defaultHandler:^(UIAlertAction *action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } completion:nil];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

