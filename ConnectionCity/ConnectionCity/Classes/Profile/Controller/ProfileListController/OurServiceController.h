//
//  OurServiceController.h
//  ConnectionCity
//
//  Created by umbrella on 2018/6/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^blockStr)(NSInteger a);
@interface OurServiceController : BaseViewController
@property (nonatomic,assign) NSInteger inter;//区分是我的服务还是旅行
@property (nonatomic,copy)blockStr block;
@property (nonatomic,strong)NSDictionary * receiveDic;
@end

@interface leftView : UIView

@end

@interface rightView : UIView

@end
