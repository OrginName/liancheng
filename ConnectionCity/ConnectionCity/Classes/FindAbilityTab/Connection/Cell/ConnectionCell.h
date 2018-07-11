//
//  ConnectionCell.h
//  ConnectionCity
//
//  Created by qt on 2018/5/20.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionMo.h"
@protocol ConnectionCellDelegate <NSObject>
@optional
- (void)btnClick:(UIButton *)btn;
@end
@interface ConnectionCell : UITableViewCell
@property (nonatomic,strong)ConnectionMo * mo;
@property (nonatomic,assign) id<ConnectionCellDelegate> cellDelegate;
@property (weak, nonatomic) IBOutlet UIButton *btn_Add;

@end
