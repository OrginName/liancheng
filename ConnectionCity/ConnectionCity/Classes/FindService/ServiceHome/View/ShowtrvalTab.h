//
//  ShowtrvalTab.h
//  ConnectionCity
//
//  Created by umbrella on 2018/5/31.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceListMo.h"
#import "trvalMo.h"
@interface ShowtrvalTab : UIView
@property (nonatomic,strong)ServiceListMo *Mo;
@property (nonatomic,strong)trvalMo * MoTrval;
-(instancetype)initWithFrame:(CGRect)frame withControl:(UIViewController *)control;
@end
