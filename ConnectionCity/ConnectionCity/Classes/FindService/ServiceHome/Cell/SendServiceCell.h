//
//  SendServiceCell.h
//  ConnectionCity
//
//  Created by qt on 2018/5/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SendServiceCellDelegate <NSObject>
@optional
- (void)selectedItem:(NSInteger)tag;
@optional
- (void)selectedAgree:(UIButton *)btn;
@end
@interface SendServiceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lab_title;
@property (weak, nonatomic) IBOutlet UITextField *txt_Placeholder;
@property (weak, nonatomic) IBOutlet UIButton *btn_agree;
@property (nonatomic,assign) id<SendServiceCellDelegate>delegate;
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath;
@end
