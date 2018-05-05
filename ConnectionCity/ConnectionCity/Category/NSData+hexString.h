//
//  NSData+hexString.h
//  HiBrain
//
//  Created by ly on 15/11/11.
//  Copyright © 2015年 ly. All rights reserved.
//

#import <Foundation/Foundation.h>
//NSData转十六进制字符串
@interface NSData (hexString)
- (NSString *)hexString;
+ (NSData *)convertHexStrToData:(NSString *)str;
@end
