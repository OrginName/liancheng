//
//  SendSelectCell.h
//  ConnectionCity
//
//  Created by qt on 2018/5/29.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SendSelectCellDelegate <NSObject>
// 由于这里没有任何修饰词所以是默认的代理方法，切记默认的代理方法，如果遵守了协议那就必须实现
@optional
- (void)selectedItemButton:(NSMutableArray *)arr;
@end

@interface SendSelectCell : UIView
@property (nonatomic,strong) NSMutableArray * arrData;
@property (nonatomic,assign) id<SendSelectCellDelegate>delegate;
@end

@interface SendCollecRuesuableView : UICollectionReusableView
/**
 *  声明相应的数据模型属性,进行赋值操作,获取头视图或尾视图需要的数据.或者提供一个方法获取需要的数据.
 */
-(void)getSHCollectionReusableViewHearderTitle:(NSString *)title;
-(void)getSHCollectionReusableViewlab_ismulitable:(NSString *)title;
@end
