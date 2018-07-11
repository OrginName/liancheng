//
//  YTThirdPartyPay.m
//  JLTimeRent
//
//  Created by chips on 17/6/23.
//  Copyright © 2017年 YOU-TURN TECHNOLOGY CO.,LTD. All rights reserved.
//

#import "YTThirdPartyPay.h"
#import "APOrderInfo.h"
#import "APRSASigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import "NSString+MD5.h"


@implementation YTThirdPartyPay

#pragma mark - Pay by third party
+ (void)payByThirdPartyWithPaymet:(YTThirdPartyPayment)payment
                       dictionary:(NSDictionary *)dictionary {
    switch (payment) {
        case YTThirdPartyPaymentAlipay: {  //支付宝支付
            [[self class]p_payByAlipayWithPayOrder:dictionary[@"alipayBody"]];
            break;
        }
        case YTThirdPartyPaymentWechat: {  //微信支付
//            [[self class]p_payByWeChatWithPartnerId:weChatPayModel.mPartnerid prepayId:weChatPayModel.mPrepayId appId:weChatPayModel.mAppId package:weChatPayModel.mPackage nonceStr:weChatPayModel.mNonceStr timeStamp:weChatPayModel.mTimeStamp sign:weChatPayModel.mSign paymentType:paymentType];
            break;
        }
    }
}

#pragma mark - Private method
+ (void)p_payByAlipayWithPayOrder:(NSString *)payOrder {
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:payOrder fromScheme:@"LianCheng" callback:^(NSDictionary *resultDic) {
            YTRLog(@"reslut = %@", resultDic);
        }];
}

/** 调起微信支付 */
+ (void)p_payByWeChatWithPartnerId:(NSString *)partnerId
                          prepayId:(NSString *)prepayId
                             appId:(NSString *)appId
                           package:(NSString *)package
                          nonceStr:(NSString *)nonceStr
                         timeStamp:(NSString *)timeStamp
                              sign:(NSString *)sign
                       paymentType:(YTThirdPartyPaymentType)paymentType {
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = partnerId;
    request.prepayId = prepayId;
    request.package = package;
    request.nonceStr = nonceStr;
    request.timeStamp = (UInt32)timeStamp.intValue;
    if (paymentType == YTThirdPartyPaymentInvoicePay) {
        request.sign = [[self class] createMD5SingForPay:appId partnerid:partnerId prepayid:prepayId package:package noncestr:nonceStr timestamp:(UInt32)timeStamp.intValue];
    }else{
        request.sign = sign;
    }
    [WXApi sendReq:request];
}
//生成签名
+ (NSString *)createMD5SingForPay:(NSString *)appid_key partnerid:(NSString *)partnerid_key prepayid:(NSString *)prepayid_key package:(NSString *)package_key noncestr:(NSString *)noncestr_key timestamp:(UInt32)timestamp_key {
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject:appid_key forKey:@"appid"];
    [signParams setObject:noncestr_key forKey:@"noncestr"];
    [signParams setObject:package_key forKey:@"package"];
    [signParams setObject:partnerid_key forKey:@"partnerid"];
    [signParams setObject:prepayid_key forKey:@"prepayid"];
    [signParams setObject:[NSString stringWithFormat:@"%u",(unsigned int)timestamp_key] forKey:@"timestamp"];
    
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [signParams allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (![[signParams objectForKey:categoryId] isEqualToString:@""] && ![[signParams objectForKey:categoryId] isEqualToString:@"sign"] && ![[signParams objectForKey:categoryId] isEqualToString:@"key"]) {
            [contentString appendFormat:@"%@=%@&", categoryId, [signParams objectForKey:categoryId]];
        }
    }
    //添加商户密钥key字段
    [contentString appendFormat:@"key=%@",@"ABCDEFGHIJKLMNOPQRSTUVWXYZ123456"];
    NSString *result = [[self class] md5:contentString];
    return result;
}
//MD5加密算法
+(NSString *) md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    //加密规则，因为逗比微信没有出微信支付demo，这里加密规则是参照安卓demo来得
    unsigned char result[16]= "0123456789abcdef";
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    //这里的x是小写则产生的md5也是小写，x是大写则md5是大写，这里只能用大写，逗比微信的大小写验证很逗
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end
