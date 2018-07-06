//
//  ZWCustomPointAnnotation.h
//  Bracelet
//
//  Created by 张威威 on 2017/11/17.
//  Copyright © 2017年 ShYangMiStepZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <UIKit/UIKit.h>
@interface ZWCustomPointAnnotation : NSObject <MAAnnotation>
/**
 *  大头针的位置
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
/**
 *  大头针标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  大头针的子标题
 */
@property (nonatomic, copy) NSString *subtitle;
/**
 *  商户的图片
 */
@property (nonatomic, copy) NSString *storImageUrl;

/**
 *  商户的id
 */
@property (nonatomic, copy) NSString *storID;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
@end
