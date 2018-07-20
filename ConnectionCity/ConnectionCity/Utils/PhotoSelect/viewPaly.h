//
//  viewPaly.h
//  ConnectionCity
//
//  Created by umbrella on 2018/7/13.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPlayer.h"
@interface viewPaly : UIView
@property (nonatomic,strong)NSString * url;
// 原始Frame
@property (nonatomic,assign) CGRect originRect;
// 过程Frame
@property (nonatomic,assign) CGRect contentRect;
// 点击大图(关闭预览)
@property (nonatomic, copy) void (^tapBigView)(void);
@property (nonatomic,strong)CustomPlayer * playView;
-(void)animateShow;
@end
