//
//  Tools.h
//  Dumbbell
//
//  Created by JYS on 16/1/19.
//  Copyright © 2016年 JYS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSTools : NSObject
#pragma mark 验证电话号码格式的对错
+(BOOL)isRightPhoneNumberFormat:(NSString*)phone;
#pragma mark 倒计时
+(void)DaojiShi:(UIButton*)sender;
#pragma mark 打电话
+(void)DaDianHua:(NSString *)phone;
#pragma mark 登录提示框
+ (void)dnegLuTiShiKuangWithVC:(UIViewController *)vc;
#pragma mark 功能暂未开通提示框
+ (void)gongNengZanWeiKaiTongTiShiKuangWithVC:(UIViewController *)vc;
#pragma mark 判断时间是几天前几月前几年前
+ (NSString *) compareCurrentTime:(NSString *)str;
#pragma mark 设置颜色的渐变
- (CAGradientLayer *)shadowAsInverse;
#pragma mark 弹簧效果
+ (void)tanhuangxiaoguoWithBtn:(UIButton *)btn;
#pragma mark 判断两个日期是不是同一天
+ (BOOL)isCurrentDay:(NSDate *)aDate;
#pragma mark 比较两个日期的先后
+ (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;
#pragma mark 判断对象是否为空
+ (BOOL)dx_isNullOrNilWithObject:(id)object;
#pragma mark 解析字符串
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSArray *)stringToJSON:(NSString *)jsonStr;
#pragma mark 产生随机字符串
+ (NSString *)getRandomStr;
#pragma mark 是否为纯数字
+ (BOOL)isNum:(NSString *)checkedNumString;
#pragma mark - 传入秒得到 xx:xx:xx
+ (NSString *)getMMSSFromSS:(NSString *)totalTime;
#pragma mark - 根据文本计算宽度
+(CGFloat)caculateTheWidthOfLableText:(float)font withTitle:(NSString *)title;
#pragma mark - 根据宽度计算高度
+(float)cauculateHeightOfText:(NSString *)text width:(float) width font:(float)font;
#pragma mark ---比较开始和结束日期0相等1开始小于结束2开始大于结束
+(NSInteger)initTimerCompare:(NSString *)startTime withEndTime:(NSString *)endTime;
#pragma mark -------- 时间戳
+(NSString *)cTimestampFromString:(NSString *)theTime;
@end






































