//
//  ShowTrvalCell.h
//  ConnectionCity
//
//  Created by umbrella on 2018/5/31.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceListMo.h"
@protocol ShowTrvalCellDelegate <NSObject>
@optional;
-(void)btnClick:(NSInteger)tag;
@end
@interface ShowTrvalCell : UITableViewCell
@property (nonatomic,strong)ServiceListMo * list;
@property (weak, nonatomic) IBOutlet UIButton *btn_wight;//婚姻
@property (weak, nonatomic) IBOutlet UIButton *btn_weight;
@property (weak, nonatomic) IBOutlet UIImageView *image_sex;
@property (weak, nonatomic) IBOutlet UILabel *lab_Age;
@property (weak, nonatomic) IBOutlet UILabel *lab_Title;
@property (weak, nonatomic) IBOutlet UIButton *btn_city;
@property (weak, nonatomic) IBOutlet UIButton *btn_height;
@property (weak, nonatomic) IBOutlet UIButton *btn_coll;
@property (weak, nonatomic) IBOutlet UILabel *lab_DTNum;
@property (weak, nonatomic) IBOutlet UILabel *lab_ServiceTitle;
@property (weak, nonatomic) IBOutlet UILabel *lab_DW;//段位和位置
@property (weak, nonatomic) IBOutlet UILabel *lab_price;
@property (weak, nonatomic) IBOutlet UILabel *lab_PriceDY;
@property (weak, nonatomic) IBOutlet UILabel *lab_Des;
@property (weak, nonatomic) IBOutlet UILabel *lab_LLNum;//浏览次数
@property (weak, nonatomic) IBOutlet UIImageView *imgae_Comment;
@property (weak, nonatomic) IBOutlet UILabel *lab_commentTitle;
@property (weak, nonatomic) IBOutlet UILabel *lab_Comment;
@property (weak, nonatomic) IBOutlet UILabel *lab_HF;//回复
@property (weak, nonatomic) IBOutlet UILabel *lab_CommentTime;

@property(nonatomic,assign) id<ShowTrvalCellDelegate>delegate;
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath;
@end
