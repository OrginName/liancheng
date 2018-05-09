//
//  FirstTanView.h
//  ConnectionCity
//
//  Created by umbrella on 2018/5/8.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageController.h"
//创建协议
@protocol FirstTanViewDelegate <NSObject>
- (void)sendValue:(NSString *)value; //声明协议方法
@end
@interface FirstTanView : UIView
@property (nonatomic,assign) id<FirstTanViewDelegate>delegate;
@property (nonatomic,strong) MessageController * messController;
@end
