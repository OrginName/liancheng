//
//  FilterOneController.h
//  ConnectionCity
//
//  Created by umbrella on 2018/5/11.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"

@interface FilterOneController : BaseViewController
@end


@interface FilterCollecRuesuableView : UICollectionReusableView
/**
 *  声明相应的数据模型属性,进行赋值操作,获取头视图或尾视图需要的数据.或者提供一个方法获取需要的数据.
 */
-(void)getSHCollectionReusableViewHearderTitle:(NSString *)title;
@end
@interface FooterView : UIView
{
    UIButton * _tmpBtn;
}
@end
