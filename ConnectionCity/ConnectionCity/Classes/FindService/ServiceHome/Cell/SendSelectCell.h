//
//  SendSelectCell.h
//  ConnectionCity
//
//  Created by qt on 2018/5/29.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendSelectCell : UIView
@property (nonatomic,strong) NSMutableArray * arrData;
@property (nonatomic, strong) NSMutableArray * dataArr;
@end

@interface SendCollecRuesuableView : UICollectionReusableView
/**
 *  声明相应的数据模型属性,进行赋值操作,获取头视图或尾视图需要的数据.或者提供一个方法获取需要的数据.
 */
-(void)getSHCollectionReusableViewHearderTitle:(NSString *)title;
@end
