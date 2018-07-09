//
//  YTThirdPartyPay.m
//  JLTimeRent
//
//  Created by chips on 17/6/23.
//  Copyright © 2017年 YOU-TURN TECHNOLOGY CO.,LTD. All rights reserved.
//

#import "YTThirdPartyPay.h"
//#import "YTAlipayModel.h"
//#import "YTWeChatPayModel.h"
#import "APOrderInfo.h"
#import "APRSASigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import "NSString+MD5.h"


@implementation YTThirdPartyPay

#pragma mark - Pay by third party
+ (void)payByThirdPartyWithPaymet:(YTThirdPartyPayment)payment
                       dictionary:(NSDictionary *)dictionary
                         payTitle:(NSString *)payTitle
                      paymentType:(YTThirdPartyPaymentType)paymentType {
    switch (payment) {
        case YTThirdPartyPaymentAlipay: {  //支付宝支付
//            YTAlipayModel *alipayModel = [YTAlipayModel modelWithDictionary:dictionary payTitle:payTitle];
//            [[self class]p_payByAlipayWithPayNum:alipayModel.mPayNum subject:alipayModel.mSubject body:alipayModel.mBody totalFee:alipayModel.mTotalFee notifyURL:alipayModel.mNotifyURL];
            break;
        }
        case YTThirdPartyPaymentWechat: {  //微信支付
//            YTWeChatPayModel *weChatPayModel = [YTWeChatPayModel modelWithDictionary:dictionary];
//            [[self class]p_payByWeChatWithPartnerId:weChatPayModel.mPartnerid prepayId:weChatPayModel.mPrepayId appId:weChatPayModel.mAppId package:weChatPayModel.mPackage nonceStr:weChatPayModel.mNonceStr timeStamp:weChatPayModel.mTimeStamp sign:weChatPayModel.mSign paymentType:paymentType];
            break;
        }
    }
}

#pragma mark - Private method
/*
+ (void)p_payByAlipayWithPayNum:(NSString *)payNum
                        subject:(NSString *)subject
                           body:(NSString *)body
                       totalFee:(NSString *)totalFee
                      notifyURL:(NSString *)notifyURL {
    //商户PID
    NSString *partner = @"2088911702239413";
    //商户收款账户
    NSString *seller = @"laiyz@jmev.com.cn";
    //商户私钥
    NSString *privateKey = @"MIIEuwIBADANBgkqhkiG9w0BAQEFAASCBKUwggShAgEAAoIBAQCVzDBh7KpbSUnnlCIDpVZvHdbg4mlcxR7UkrOsArgi16nJnzsBhdxVV84gCsHJXWn+S0hEtwcfv0ggOONop9X52fAcbGjn8QY07K5JwJjsJtRHOro66spf3xF/FSUNU7vNtac9CStNPFkN5CD6SJ6x+Agk8D0Jqcbai9EE0cw5Ir5sJ8JQt7umHyOjpUEbUqCHlmGGRqYbGPLfa4+xB83QpElN5B+zvhFjuUEL3e0zWWVYUEB5ExKZjR6fv2AoDOlwuRGAZEDQwKsDCppL+T4d3cvKAiVlu787OurY3uaI2YB+ukcSms2FAD4xovWbek2t5p/T9Dly2yoo+r2WkzvDAgMBAAECggEAQw7HUe76TCdA2FRt7afkS5XWDZINjKQJqyuJFyWYfLCCp2mKpqHgAqxt79Yg7h3NRzM4RNqSa9nbVeFhnAYWOeUgIfk99Sbmmmahlw6K5pxzRve5Soq00bowQO2cSp0DY5FALoieQ9MSIq/PO3uq3wyjyLVq/ZptFISmqzun6qM7Z2kD3eVmZFE8ka6cryk/Cz0WJN2fKqLth6NqhmcPSOIe2SyyD0CWc9Xhi8PsX7PMM47bybQxm5+MPPktcsdTPIdX3tAXQZPDgbHjtx6n+qe2rYP6msnC9qKF6pE1bSzx/krq2Mee2rGaqKLPYOc0dJJFvlBMoiw13FlEaiU2cQKBgQDmcYRc4yebPs6DQR08d/L97gLFzr+q61rZikR+cJ9PAEdJ15o1tMLDpygzkHAwy94xTc2HHNnHiyP8srJMlDz3Y8qJlM3p77lRylVRCTVEz6E4KIscNiF7XlSndJufkG7PYwkO0XGu56JKDKxD/Mw4qo65OgV+iDmcvK0R0bgM5wKBgQCmaRHEetUuQ0NJHjb8gfQ8NMYnazH9pRraiUXVW9QbD2MFZt2HHWCCUKjPVugfvjKWWj0P83YDjth53GPF71KW3cWjUXQdqFYiQM+gRDptR1QSlOTb22UFm+VnPtqViO5+reC2qQwDYyBfPmm34zVAauVTwcrA99ol8lcxZvyCxQKBgQCONs4l+PXPZCJUdFHTqH7oYQOLCb3VgGvPxvngQia+vYBBPPJpZIWx8y3nLKNgKeCU8tv9HzvzXpY19B3/DpjVX9t1rsSpM41dwY2HdjROpAhtvO+k2G8vUJbTxS3pelw4VnkXkQAkncTVCB8j0hZCfleYTgtn/C/536K7VX7NTwJ/d5sNKisfDiFKO0N8QgEliiBkS/C//Y6tvmTrzG40BT8J7NgCYRq8Qu22Z1APhsEtmuNBADX8nJIPBYdiLuHUeprrcncY/jf/sJ7knExtsh2ST8i0tVD7SwzB1XNXqCLDSEmxOZhHCig1HD+/vGuR2rr6GTkwgYGjSaLlCJz84QKBgFBk/KXtMgxLltSoAjVLkYob/9k4wJJF4mGWloGv+xF8ZYTF1V072C3970K5vk9Lf8rAygk5HkLomQPK0TaGJTzUNg0sqkRBgijATTGH9FJnloa3NK9j9NlbaFu2DeeTJrSRFEe9YO90yAmQZNlwVMe0K4AxHG0lVChPiauA6lJr";
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.sellerID = seller;
    order.outTradeNO = payNum; //订单ID（由商家自行制定）
    order.subject = subject; //商品标题
    order.body = body; //商品描述
    order.totalFee = [NSObject yt_isDebug] ? @"0.01" : totalFee;  //商品价格
    order.notifyURL = notifyURL;

    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showURL = @"m.alipay.com";

    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];

    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"JLTimeRent" callback:^(NSDictionary *resultDic) {
            YTRLog(@"reslut = %@", resultDic);
        }];
    }
}
*/
+ (void)p_payByAlipayWithPayNum:(NSString *)payNum
                        subject:(NSString *)subject
                           body:(NSString *)body
                       totalFee:(NSString *)totalFee
                      notifyURL:(NSString *)notifyURL {
    // 重要说明
    // 这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    // 真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    // 防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = @"2018061160404056";
    
    // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    // 如果商户两个都设置了，优先使用 rsa2PrivateKey
    // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
    // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
    // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
    NSString *rsa2PrivateKey = @"MIIEuwIBADANBgkqhkiG9w0BAQEFAASCBKUwggShAgEAAoIBAQCVzDBh7KpbSUnnlCIDpVZvHdbg4mlcxR7UkrOsArgi16nJnzsBhdxVV84gCsHJXWn+S0hEtwcfv0ggOONop9X52fAcbGjn8QY07K5JwJjsJtRHOro66spf3xF/FSUNU7vNtac9CStNPFkN5CD6SJ6x+Agk8D0Jqcbai9EE0cw5Ir5sJ8JQt7umHyOjpUEbUqCHlmGGRqYbGPLfa4+xB83QpElN5B+zvhFjuUEL3e0zWWVYUEB5ExKZjR6fv2AoDOlwuRGAZEDQwKsDCppL+T4d3cvKAiVlu787OurY3uaI2YB+ukcSms2FAD4xovWbek2t5p/T9Dly2yoo+r2WkzvDAgMBAAECggEAQw7HUe76TCdA2FRt7afkS5XWDZINjKQJqyuJFyWYfLCCp2mKpqHgAqxt79Yg7h3NRzM4RNqSa9nbVeFhnAYWOeUgIfk99Sbmmmahlw6K5pxzRve5Soq00bowQO2cSp0DY5FALoieQ9MSIq/PO3uq3wyjyLVq/ZptFISmqzun6qM7Z2kD3eVmZFE8ka6cryk/Cz0WJN2fKqLth6NqhmcPSOIe2SyyD0CWc9Xhi8PsX7PMM47bybQxm5+MPPktcsdTPIdX3tAXQZPDgbHjtx6n+qe2rYP6msnC9qKF6pE1bSzx/krq2Mee2rGaqKLPYOc0dJJFvlBMoiw13FlEaiU2cQKBgQDmcYRc4yebPs6DQR08d/L97gLFzr+q61rZikR+cJ9PAEdJ15o1tMLDpygzkHAwy94xTc2HHNnHiyP8srJMlDz3Y8qJlM3p77lRylVRCTVEz6E4KIscNiF7XlSndJufkG7PYwkO0XGu56JKDKxD/Mw4qo65OgV+iDmcvK0R0bgM5wKBgQCmaRHEetUuQ0NJHjb8gfQ8NMYnazH9pRraiUXVW9QbD2MFZt2HHWCCUKjPVugfvjKWWj0P83YDjth53GPF71KW3cWjUXQdqFYiQM+gRDptR1QSlOTb22UFm+VnPtqViO5+reC2qQwDYyBfPmm34zVAauVTwcrA99ol8lcxZvyCxQKBgQCONs4l+PXPZCJUdFHTqH7oYQOLCb3VgGvPxvngQia+vYBBPPJpZIWx8y3nLKNgKeCU8tv9HzvzXpY19B3/DpjVX9t1rsSpM41dwY2HdjROpAhtvO+k2G8vUJbTxS3pelw4VnkXkQAkncTVCB8j0hZCfleYTgtn/C/536K7VX7NTwJ/d5sNKisfDiFKO0N8QgEliiBkS/C//Y6tvmTrzG40BT8J7NgCYRq8Qu22Z1APhsEtmuNBADX8nJIPBYdiLuHUeprrcncY/jf/sJ7knExtsh2ST8i0tVD7SwzB1XNXqCLDSEmxOZhHCig1HD+/vGuR2rr6GTkwgYGjSaLlCJz84QKBgFBk/KXtMgxLltSoAjVLkYob/9k4wJJF4mGWloGv+xF8ZYTF1V072C3970K5vk9Lf8rAygk5HkLomQPK0TaGJTzUNg0sqkRBgijATTGH9FJnloa3NK9j9NlbaFu2DeeTJrSRFEe9YO90yAmQZNlwVMe0K4AxHG0lVChPiauA6lJr";
    NSString *rsaPrivateKey = @"";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    APOrderInfo* order = [APOrderInfo new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: 支付宝服务器主动通知商户服务器里指定的页面http路径(本Demo仅做展示所用，商户需要配置这个参数)
    order.notify_url = notifyURL;

    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [APBizContent new];
    order.biz_content.body = body;
    order.biz_content.subject = subject;
    order.biz_content.out_trade_no = payNum; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = totalFee; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    //YTRLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    APRSASigner* signer = [[APRSASigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"JLTimeRent";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            YTRLog(@"reslut = %@", resultDic);

        }];
    }
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
