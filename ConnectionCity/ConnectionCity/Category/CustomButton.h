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
@property (nonatomic,strong) IBInspectable UIColor * NoSelectBorderColor;//未选中的边框颜色
@property (nonatomic,strong) IBInspectable UIColor * SelectborderColor;//选中的边框颜色
@property (nonatomic,assign) IBInspectable NSInteger SelectborderWidth;//选中的边框宽度
@end
