//
//  YTThirdPartyPay.h
//  JLTimeRent
//
//  Created by chips on 17/6/23.
//  Copyright © 2017年 YOU-TURN TECHNOLOGY CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 调起第三方支付接口的支付方式 */
typedef NS_ENUM(NSInteger, YTThirdPartyPayment) {
    YTThirdPartyPaymentAlipay,   //支付宝第三方支付
    YTThirdPartyPaymentWechat    //微信第三方支付
};
/** 调起第三方支付接口的支付类型 */
typedef NS_ENUM(NSInteger, YTThirdPartyPaymentType) {
    YTThirdPartyPaymentOrderPay,   //订单支付
    YTThirdPartyPaymentChargePay,   //钱包支付
    YTThirdPartyPaymentInvoicePay    //发票支付
};
/** 调起第三方支付类 */
@interface YTThirdPartyPay : NSObject

/** 调起第三方支付统一接口 */
+ (void)payByThirdPartyWithPaymet:(YTThirdPartyPayment)payment
                       dictionary:(NSDictionary *)dictionary
                         payTitle:(NSString *)payTitle
                      paymentType:(YTThirdPartyPaymentType)paymentType;


@end
