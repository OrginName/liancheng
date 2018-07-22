//
//  TrvalCell.h
//  ConnectionCity
//
//  Created by qt on 2018/5/30.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "trvalMo.h"
@protocol TrvalCellDelegate <NSObject>
@optional
- (void)btnSend:(UIButton *)btn;
@optional
-(void)DetailClick:(UIButton *)btn;
@end
@interface TrvalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn_send;
@property (nonatomic,assign) id<TrvalCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *btn_detail;
@property (weak, nonatomic) IBOutlet UILabel *lab_Money;
@property (weak, nonatomic) IBOutlet UILabel *lab_TrvalGoTime;
@property (weak, nonatomic) IBOutlet UILabel *lab_TrvalWay;
@property (weak, nonatomic) IBOutlet UILabel *lab_DX;
@property (weak, nonatomic) IBOutlet UILabel *lab_Trvaltime;
@property (weak, nonatomic) IBOutlet UILabel *lab_TrvalPlace;
@property (weak, nonatomic) IBOutlet UILabel *lab_Age;
@property (weak, nonatomic) IBOutlet UIImageView *image_Head;
@property (weak, nonatomic) IBOutlet UILabel *lab_SM;
@property (weak, nonatomic) IBOutlet UIImageView *image_Sex;
@property (weak, nonatomic) IBOutlet UILabel *lab_Name;
@property (weak, nonatomic) IBOutlet UILabel *lab_Time;
@property (weak, nonatomic) IBOutlet CustomtextView *txt_View;
@property (weak, nonatomic) IBOutlet UILabel *lab_headTitle;
@property (weak, nonatomic) IBOutlet UITextField *txt_Edit;
@property (nonatomic,strong) trvalMo * receive_Mo;
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath;
@end
