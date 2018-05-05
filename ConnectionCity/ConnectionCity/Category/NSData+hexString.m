//
//  NSData+hexString.m
//  HiBrain
//
//  Created by ly on 15/11/11.
//  Copyright © 2015年 ly. All rights reserved.
//

#import "NSData+hexString.h"

@implementation NSData (hexString)
//NSData转十六进制字符串
- (NSString *)hexString{
    NSMutableString *str = [[NSMutableString alloc] initWithCapacity:[self length]];
    [self enumerateByteRangesUsingBlock:^(const void * _Nonnull bytes, NSRange byteRange, BOOL * _Nonnull stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (int i = 0; i < byteRange.length; i++) {
            NSString *newHexStr = [NSString stringWithFormat:@"%x",(dataBytes[i]) & 0xff];
            if ([newHexStr length] == 2) {
                [str appendString:newHexStr];
            } else {
                [str appendFormat:@"0%@", newHexStr];
            }
        }
        
    }];
    return str;
}

+ (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    return hexData;
}
@end
