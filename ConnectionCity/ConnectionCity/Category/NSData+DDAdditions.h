//
//  NSData+DDAdditions.h
//  HEHE
//
//  Created by YanShuang Jiang on 2018/5/2.
//  Copyright © 2018年 DKMedical. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DDFileReader.h"

@interface NSData (DDAdditions)

- (NSRange) rangeOfData_dd:(NSData *)dataToFind;

@end
