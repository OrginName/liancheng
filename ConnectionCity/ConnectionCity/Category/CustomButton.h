//
//  CustomButton.h
//  ConnectionCity
//
//  Created by umbrella on 2018/5/10.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIButton
@property (nonatomic,strong) IBInspectable UIColor * selectBackColor;//选中的背景色
@property (nonatomic,strong) IBInspectable UIColor * NOselectBackColor;//选中的背景色
@property (nonatomic,strong) IBInspectable UIColor * selectTitleColor;//选中的标题颜色
@property (nonatomic,strong) IBInspectable UIColor * NoSelectTitleColor;//未选中的标题颜色
@end
