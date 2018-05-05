//
//  BaseModel.h
//  Dumbbell
//
//  Created by JYS on 16/1/19.
//  Copyright © 2016年 JYS. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ProMutArr(mutArr) @property(nonatomic,strong) NSMutableArray *mutArr;
#define proArr(arr)       @property(nonatomic,strong) NSArray *arr;
#define proMutDic(mutDic) @property(nonatomic,strong) NSMutableDictionary *mutDic;
#define proDic(dic)       @property (nonatomic,strong)  NSDictionary *dic;
#define proStr(str)       @property(nonatomic,copy) NSString *str;
#define proNumb(numb)     @property (nonatomic, strong) NSNumber *numb;
#define proInt(integer)   @property(nonatomic,assign) NSUInteger integer;
#define proDoub(doub)     @property (nonatomic, assign) double doub;

@interface BaseModel : NSObject<NSCoding>
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
