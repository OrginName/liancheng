//
//  Tools.m
//  Dumbbell
//
//  Created by JYS on 16/1/19.
//  Copyright © 2016年 JYS. All rights reserved.
//

#import "YSTools.h"
#import "YSLoginController.h"

@implementation YSTools
#pragma mark -
#pragma mark 倒计时
+(void)DaojiShi:(UIButton*)sender {
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [ sender setTitle:@"发送验证码" forState:UIControlStateNormal];
                sender.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout ;
            NSString *strTime;
            if(seconds == 60) {
                strTime = [NSString stringWithFormat:@"%.2d", seconds];
            } else {
                //int minutes = timeout / 60;
                seconds = timeout % 60;
                strTime = [NSString stringWithFormat:@"%.2d", seconds];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [sender setTitle:[NSString stringWithFormat:@"%@S",strTime] forState:UIControlStateNormal];
                sender.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
#pragma mark -
#pragma mark 打电话
+(void)DaDianHua:(NSString *)phone {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"ls://%@",phone]]];
}
#pragma mark -
#pragma mark 验证电话号码格式的对错
+(BOOL)isRightPhoneNumberFormat:(NSString*)phone {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,177
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|7[7-9]|4[7]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSString * G = @"^18[0-9]\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestg  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", G];
    
    if (([regextestmobile evaluateWithObject:phone] == YES)
        || ([regextestcm evaluateWithObject:phone] == YES)
        || ([regextestct evaluateWithObject:phone] == YES)
        || ([regextestcu evaluateWithObject:phone] == YES)
        || ([regextestg evaluateWithObject:phone]) == YES) {
        return YES;
    } else {
        return NO;
    }
}
#pragma mark -
#pragma mark 比较时间先后
+(NSInteger)compareDate:(NSString*)date01 withDate:(NSString*)date02 {
    NSInteger ci = 0;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dt1 = [df dateFromString:date01];
    NSDate *dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {        //date02比date01大
        case NSOrderedAscending:
            ci=1;
            break;
            //date02比date01小
        case NSOrderedDescending:
            ci=0;
            break;
            //date02=date01
        case NSOrderedSame:
            ci=0;
            break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1);
            break;
    }
    return ci;
}
#pragma mark 登录提示框
+ (void)dnegLuTiShiKuangWithVC:(UIViewController *)vc {
    [UIAlertView showAlertViewWithTitle:@"提示" message:@"登录才可使用本功能哦~" cancelButtonTitle:nil otherButtonTitles:@[@"再逛逛",@"马上登录"] onDismiss:^(long buttonIndex) {
        if (buttonIndex == -1) {
            //取消
        }else{
            //确定
            YSLoginController *loginC = [[YSLoginController alloc]init];
            [vc.navigationController pushViewController:loginC animated:YES];
        }
    } onCancel:^{
        
    }];
}
#pragma mark 功能暂未开通提示框
+ (void)gongNengZanWeiKaiTongTiShiKuangWithVC:(UIViewController *)vc {
    [UIAlertView showAlertViewWithTitle:@"提示" message:@"此功能尚未开通，敬请期待~" cancelButtonTitle:@"确定" otherButtonTitles:nil onDismiss:^(long buttonIndex) {

    } onCancel:^{
        
    }];
}
#pragma mark 判断时间是几天前几月前几年前
+ (NSString *)jitianqian:(NSString *)str {
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    //得到与当前时间差
    NSTimeInterval  timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    //标准时间和北京时间差8个小时
    //timeInterval = timeInterval - 8*60*60;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚测评过"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"测于%d分钟前",(int)temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"测于%d小时前",(int)temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"测于%d天前",(int)temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"测于%d月前",(int)temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"测于%d年前",(int)temp];
    }
    return  result;
}
#pragma mark 设置颜色的渐变(目前没有用)
- (CAGradientLayer *)shadowAsInverse {
    //使用时如下一行代码调用即可
    //[self.view.layer addSublayer:[self shadowAsInverse]];
    CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];
    newShadow.frame = CGRectMake(0, 0, kScreenWidth, 64);
    //添加渐变的颜色组合
    newShadow.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0X22C8AF].CGColor,(id)[UIColor colorWithHex:0X5CD6A8].CGColor,nil];
    return newShadow;
}
#pragma mark 弹簧效果
+ (void)tanhuangxiaoguoWithBtn:(UIButton *)btn {
    NSArray * scale = [self  btnAnimationValues:@2 toValue:@1 usingSpringWithDamping:5 initialSpringVelocity:30 duration:1];
    if (scale != nil) {
        CAKeyframeAnimation * keya = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        keya.duration = 1.f;
        NSMutableArray * muarray = [[NSMutableArray alloc] initWithCapacity:scale.count];
        for (int i=0; i<scale.count; i++)
        {
            float s = [scale[i] floatValue];
            //NSValue * value =  [NSValue valueWithCGAffineTransform:CGAffineTransformMakeScale(s, s)];
            NSValue * value =  [NSValue valueWithCATransform3D:CATransform3DMakeScale(s, s, s)];
            [muarray addObject:value];
        }
        keya.values = muarray;
        [btn.layer addAnimation:keya forKey:nil];
    }
}
+ (NSMutableArray *) btnAnimationValues:(id)fromValue toValue:(id)toValue usingSpringWithDamping:(CGFloat)damping initialSpringVelocity:(CGFloat)velocity duration:(CGFloat)duration {
    static NSMutableArray *values = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSInteger numOfPoints  = duration * 60;
        values = [NSMutableArray arrayWithCapacity:numOfPoints];
        for (NSInteger i = 0; i < numOfPoints; i++) {
            [values addObject:@(0.0)];
        }
        CGFloat d_value = [toValue floatValue] - [fromValue floatValue];
        for (NSInteger point = 0; point <numOfPoints;point++)
        {
            CGFloat x = (CGFloat)point / (CGFloat)numOfPoints;
            
            CGFloat value = [toValue floatValue] - d_value * (pow(M_E, -damping * x) * cos(velocity * x)); //1 y = 1-e^{-5x} * cos(30x)
            values[point] = @(value);
        }
    });
    return values;
}
#pragma mark 判断两个日期是不是同一天
//判断两个日期是不是同一天
+ (BOOL)isCurrentDay:(NSDate *)aDate {
    if (aDate==nil) return NO;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:aDate];
    NSDate *otherDate = [cal dateFromComponents:components];
    if([today isEqualToDate:otherDate]){
        return YES;
    }
    return NO;
}
//比较两个日期的先后
+ (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    //NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    //([currentDate compare:date8]==NSOrderedDescending [currentDate compare:date23]==NSOrderedAscending)(8:00-23:00)
    if (result == NSOrderedDescending) {//左边的操作对象大于右边的对象。
        //NSLog(@"Date1  is in the future");前边日期超过了后边日期
        return 1;
    }
    else if (result == NSOrderedAscending){//左边的操作对象小于右边的对象。
        //NSLog(@"Date1 is in the past");前边日期未超过后边日期
        return -1;
    }
    //NSLog(@"Both dates are the same");前边日期与后边日期相同
    return 0;
}
#pragma mark 判断对象是否为空
+ (BOOL)dx_isNullOrNilWithObject:(id)object {
    if (object == nil || [object isEqual:[NSNull null]]) {
        return YES;
    } else if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@""]) {
            return YES;
        } else {
            return NO;
        }
    } else if ([object isKindOfClass:[NSNumber class]]) {
        if ([object isEqualToNumber:@0]) {
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}
#pragma mark 解析字符串
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
#pragma mark 产生随机字符串
+ (NSString *)getRandomStr {
    static int kNumber = 16;
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    [resultStr appendString:[NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]*1000*1000]];
    resultStr = [resultStr MD5];
    return resultStr;
}
#pragma mark 是否为纯数字
+ (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}
#pragma mark - 传入秒得到 xx:xx:xx
+ (NSString *)getMMSSFromSS:(NSString *)totalTime {
    NSInteger seconds = [totalTime integerValue];
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
}
+(CGFloat)caculateTheWidthOfLableText:(float)font withTitle:(NSString *)title
{
    
    UIFont *font1 = [UIFont systemFontOfSize:font];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:font1,NSFontAttributeName    , nil];
    CGSize newSize = [title sizeWithAttributes:dic];
    return newSize.width;
}

+(float)cauculateHeightOfText:(NSString *)text width:(float) width font:(float)font
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    CGFloat height = ceilf(rect.size.height);
    return height;
}
@end


