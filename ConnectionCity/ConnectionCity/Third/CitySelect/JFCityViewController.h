//
//  JFCityViewController.h
//  JFFootball
//
//  Created by 张志峰 on 2016/11/21.
//  Copyright © 2016年 zhifenx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@protocol JFCityViewControllerDelegate <NSObject>

- (void)cityName:(NSString *)name;

@end

@interface JFCityViewController : BaseViewController

@property (nonatomic, weak) id<JFCityViewControllerDelegate> delegate;
@end
