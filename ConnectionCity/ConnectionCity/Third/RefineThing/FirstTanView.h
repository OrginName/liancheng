//
//  FirstTanView.h
//  ConnectionCity
//
//  Created by umbrella on 2018/5/8.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageController.h"
#import "CustomtextView.h"
typedef void (^ReturnBlock) (NSString * txt);
//创建协议
@protocol FirstTanViewDelegate <NSObject>
@optional
- (void)sendValue:(NSString *)value; //声明协议方法
@end
@interface FirstTanView : UIView
@property (weak, nonatomic) IBOutlet CustomtextView *txt_view;
@property (weak, nonatomic) IBOutlet UIButton *btn_TJ;
@property (nonatomic,assign) id<FirstTanViewDelegate>delegate;
@property (nonatomic,strong) MessageController * messController;
@property (nonatomic,copy) ReturnBlock block;
@end
