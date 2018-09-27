//
//  ShowtrvalTab.h
//  ConnectionCity
//
//  Created by umbrella on 2018/5/31.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceListMo.h"
#import "UserMo.h"
#import "trvalMo.h"
#import "serviceListNewMo.h"
@interface ShowtrvalTab : UIView
@property (nonatomic,assign)NSInteger JNIndex;//当前点击的第几个技能包
@property (nonatomic,strong)serviceListNewMo *Mo;
@property (nonatomic,strong)trvalMo * MoTrval;
-(instancetype)initWithFrame:(CGRect)frame withControl:(UIViewController *)control;
@end
