//
//  BidStateTools.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/15.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BidStateTools.h"

@implementation BidStateTools
+ (NSString *)stateStrWithState:(NSInteger)state {
    switch (state) {
        case 10:
        {
            return @"待付款";
            break;
        }
        case 20:
        {
            return @"已支付";
            break;
        }
        case 30:
        {
            return @"待交付";
            break;
        }
        case 40:
        {
            return @"交付中";
            break;
        }
        case 50:
        {
            return @"确认";
            break;
        }
        case 60:
        {
            return @"完成";
            break;
        }
        default:
            return @"待付款";
            break;
    }
}

@end
