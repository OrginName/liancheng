//
//  TrvalTrip.h
//  ConnectionCity
//
//  Created by qt on 2018/5/30.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrvalTrip : UIView
@property (nonatomic,strong) MyCollectionView * bollec_bottom;
@property (nonatomic,strong) NSString * cityID;
@property (nonatomic,strong)NSMutableArray * data_Arr;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSDictionary * dic;
-(instancetype)initWithFrame:(CGRect)frame withControl:(UIViewController *)control;
-(void)loadData:(NSDictionary *)dic;
@end

@interface TrvalTripLayout : UICollectionViewFlowLayout

@end
