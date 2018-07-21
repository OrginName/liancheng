//
//  ConnectionCell.h
//  ConnectionCity
//
//  Created by qt on 2018/5/20.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserMo.h"
@protocol ConnectionCellDelegate <NSObject>
@optional
- (void)btnClick:(UIButton *)btn;
@optional
-(void)DetailClick:(UIButton *)btn;
@end
@interface ConnectionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn_detail;
@property (weak, nonatomic) IBOutlet UIImageView *image_Head;
@property (nonatomic,strong)UserMo * mo;
@property (nonatomic,assign) id<ConnectionCellDelegate> cellDelegate;
@property (weak, nonatomic) IBOutlet UIButton *btn_Add;

@end
