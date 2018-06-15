//
//  FilterOneController.h
//  ConnectionCity
//
//  Created by umbrella on 2018/5/11.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
/**
 *  类型自定义
 */
typedef void (^ReturnValueBlock) (NSString *strValue);
@interface FilterOneController : BaseViewController
/*
 1.服务页主页
 2.
 3.
 4.
 */
@property (nonatomic,assign)NSInteger  flag_SX;//判断哪个页面跳转
@property (nonatomic,copy) ReturnValueBlock block;
@end
@interface FilterCollecRuesuableView : UICollectionReusableView
/**
 *  声明相应的数据模型属性,进行赋值操作,获取头视图或尾视图需要的数据.或者提供一个方法获取需要的数据.
 */
-(void)getSHCollectionReusableViewHearderTitle:(NSString *)title;
@end
@interface FooterView : UIView
@property (nonatomic,strong) UIButton * tmpBtn;
@end
