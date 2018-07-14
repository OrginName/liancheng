//
//  ConsultativeNegotiationCell.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/26.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstallmentMo.h"
@class ConsultativeNegotiationCell;

@protocol ConsultativeNegotiationCellDelegate <NSObject>
- (void)consultativeNegotiationCell:(ConsultativeNegotiationCell *)cell selectedBtn:(UIButton *)btn;

@end

@interface ConsultativeNegotiationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextField *dataTF;
@property (nonatomic, strong) InstallmentMo *model;
@property (nonatomic, weak) id<ConsultativeNegotiationCellDelegate> delegate;

@end




@interface JFSearchView : UIView

/** 搜索结果*/
@property (nonatomic, strong) NSMutableArray *resultMutableArray;
@end
