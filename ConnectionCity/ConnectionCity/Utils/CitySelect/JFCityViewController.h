//
//  JFCityViewController.h
//  JFFootball
//
//  Created by 张志峰 on 2016/11/21.
//  Copyright © 2016年 zhifenx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CityMo.h"

@protocol JFCityViewControllerDelegate <NSObject>
@optional
- (void)cityName:(NSString *)name;
@optional
-(void)cityMo:(CityMo *)mo;
@optional
-(void)city:(NSString *)name ID:(NSString *)ID lat:(NSString *)lat lng:(NSString *)lng;
@end

@interface JFCityViewController : BaseViewController

@property (nonatomic, weak) id<JFCityViewControllerDelegate> delegate;
@end
