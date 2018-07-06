//
//  ZWCustomPointAnnotation.m
//  Bracelet
//
//  Created by 张威威 on 2017/11/17.
//  Copyright © 2017年 ShYangMiStepZhang. All rights reserved.
//

#import "ZWCustomPointAnnotation.h"

@implementation ZWCustomPointAnnotation
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize coordinate = _coordinate;
@synthesize storImageUrl = _storImageUrl;
@synthesize storID = _storID;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init])
    {
        self.coordinate = coordinate;
    }
    return self;
}
@end
