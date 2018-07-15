//
//  OurServiceCell.h
//  ConnectionCity
//
//  Created by umbrella on 2018/6/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myServiceMo.h"
@protocol CellClickDelegate <NSObject>
@optional
- (void)cellBtnClick:(UITableViewCell *)cell;
@end
@interface OurServiceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn_status;
@property (nonatomic,strong)myServiceMo * mo;
@property (nonatomic,assign)id <CellClickDelegate>delegate;
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath currentTag:(NSInteger)tag;
@end
