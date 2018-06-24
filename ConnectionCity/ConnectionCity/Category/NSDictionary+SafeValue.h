//
//  NSDictionary+SafeValue.h
//  MiddleEast
//
//  Created by JackAndney on 2018/1/1.
//  Copyright © 2018年 international. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SafeValue)

- (BOOL)safeBoolForKey:(NSString *)key;
- (BOOL)safeBoolForKeyPath:(NSString *)keyPath;

- (int)safeIntForKey:(NSString *)key;
- (int)safeIntForKeyPath:(NSString *)keyPath;

- (NSInteger)safeIntegerForKey:(NSString *)key;
- (NSInteger)safeIntegerForKeyPath:(NSString *)keyPath;

- (double)safeDoubleForKey:(NSString *)key;
- (double)safeDoubleForKeyPath:(NSString *)keyPath;

- (CGFloat)safeFloatForKey:(NSString *)key;
- (CGFloat)safeFloatForKeyPath:(NSString *)keyPath;

- (NSDictionary *)safeDictForKey:(NSString *)key;
- (NSDictionary *)safeDictForKeyPath:(NSString *)keyPath;

- (NSString *)safeStringForKey:(NSString *)key;
- (NSString *)safeStringForKeyPath:(NSString *)keyPath;

- (NSArray *)safeArrayForKey:(NSString *)key;
- (NSArray *)safeArrayForKeyPath:(NSString *)keyPath;


- (NSInteger)safeStatusCodeForKey:(NSString *)key;// 状态码： 为空时，默认值为NSIntegerMax

@end
