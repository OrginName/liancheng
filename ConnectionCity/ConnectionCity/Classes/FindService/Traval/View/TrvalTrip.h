//
//  TrvalTrip.h
//  ConnectionCity
//
//  Created by qt on 2018/5/30.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrvalTrip : UIView
@property (nonatomic,strong) UICollectionView * bollec_bottom;
@property (nonatomic,strong) NSString * cityID;
@property (nonatomic,strong)NSMutableArray * data_Arr;
@property (nonatomic,assign) NSInteger page;
-(instancetype)initWithFrame:(CGRect)frame withControl:(UIViewController *)control;
@end

@interface TrvalTripLayout : UICollectionViewFlowLayout

@end
