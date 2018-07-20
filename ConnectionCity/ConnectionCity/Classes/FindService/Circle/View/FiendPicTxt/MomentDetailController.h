//
//  MomentDetailController.h
//  ConnectionCity
//
//  Created by umbrella on 2018/6/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
#import "Moment.h"
typedef void(^BtnDeleteBlock)(void);
@interface MomentDetailController : BaseViewController
@property (nonatomic,strong) NSString * flagStr;
@property (nonatomic,strong)Moment * receiveMo;
@property (nonatomic,copy)BtnDeleteBlock block;
@end

typedef void(^BtnClickBlock)(void);
typedef void(^BtnSaveBlock)(void);
@interface MomentDetailView : UIView
@property (nonatomic,strong)Moment * receiveMo;
@property (nonatomic,copy)BtnClickBlock Btnblock;
@property (nonatomic,copy)BtnSaveBlock saveBlock;
@end
