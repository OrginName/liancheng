//
//  NSDictionary+SafeValue.m
//  MiddleEast
//
//  Created by JackAndney on 2018/1/1.
//  Copyright © 2018年 international. All rights reserved.
//

#import "NSDictionary+SafeValue.h"

#define NotNullCondition (value && value != [NSNull null])


@implementation NSDictionary (SafeValue)

- (BOOL)safeBoolForKey:(NSString *)key {
    id value = [self valueForKey:key];
    return NotNullCondition ? [value boolValue] : NO;
}

- (BOOL)safeBoolForKeyPath:(NSString *)keyPath {
    id value = [self valueForKey:keyPath];
    return NotNullCondition ? [value boolValue] : NO;
}

- (int)safeIntForKey:(NSString *)key {
    id value = [self valueForKey:key];
    return NotNullCondition ? [value intValue] : 0;
}

- (int)safeIntForKeyPath:(NSString *)keyPath {
    id value = [self valueForKey:keyPath];
    return NotNullCondition ? [value intValue] : 0;
}

- (NSInteger)safeIntegerForKey:(NSString *)key {
    id value = [self valueForKey:key];
    return NotNullCondition ? [value integerValue] : 0;
}

- (NSInteger)safeIntegerForKeyPath:(NSString *)keyPath {
    id value = [self valueForKey:keyPath];
    return NotNullCondition ? [value integerValue] : 0;
}

- (double)safeDoubleForKey:(NSString *)key {
    id value = [self valueForKey:key];
    return NotNullCondition ? [value doubleValue] : 0.0f;
}

- (double)safeDoubleForKeyPath:(NSString *)keyPath {
    id value = [self valueForKey:keyPath];
    return NotNullCondition ? [value doubleValue] : 0.0f;
}

- (CGFloat)safeFloatForKey:(NSString *)key {
    id value = [self valueForKey:key];
    return NotNullCondition ? [value floatValue] : 0.0f;
}

- (CGFloat)safeFloatForKeyPath:(NSString *)keyPath {
    id value = [self valueForKey:keyPath];
    return NotNullCondition ? [value floatValue] : 0.0f;
}

/****************************************************************/

- (NSString *)safeStringForKey:(NSString *)key {
    id value = [self valueForKey:key];
    if ([value isKindOfClass:[NSString class]] && [value length]>0) {
        if ([value isEqualToString:@"null"] || [value isEqualToString:@"(null)"] || [value isEqualToString:@"<null>"]) {
            return @"";
        }else {
            return value;
        }
    }else if ([value isKindOfClass:[NSNumber class]] && [value stringValue].length) {
        return [value stringValue];
    }
    return @"";
}

- (NSString *)safeStringForKeyPath:(NSString *)keyPath {
    id value = [self valueForKey:keyPath];
    if ([value isKindOfClass:[NSString class]] && [value length]) {
        if ([value isEqualToString:@"null"] || [value isEqualToString:@"(null)"] || [value isEqualToString:@"<null>"]) {
            return @"";
        }else {
            return value;
        }
    }else if ([value isKindOfClass:[NSNumber class]] && [value stringValue].length) {
        return [value stringValue];
    }
    return @"";
}

- (NSDictionary *)safeDictForKey:(NSString *)key {
    id value = [self valueForKey:key];
    return [value isKindOfClass:[NSDictionary class]] ? value : [NSDictionary dictionary];
}

- (NSDictionary *)safeDictForKeyPath:(NSString *)keyPath {
    id value = [self valueForKey:keyPath];
    return [value isKindOfClass:[NSDictionary class]] ? value : [NSDictionary dictionary];
}

- (NSArray *)safeArrayForKey:(NSString *)key {
    id value = [self valueForKey:key];
    return [value isKindOfClass:[NSArray class]] ? value : [NSArray array];
}

- (NSArray *)safeArrayForKeyPath:(NSString *)keyPath {
    id value = [self valueForKey:keyPath];
    return [value isKindOfClass:[NSArray class]] ? value : [NSArray array];
}


/****************************************************************/

- (NSInteger)safeStatusCodeForKey:(NSString *)key {// 状态码： 为空时，默认值为NSIntegerMax
    id value = [self valueForKey:key];
    return NotNullCondition ? [value integerValue] : NSIntegerMax;
}

@end
