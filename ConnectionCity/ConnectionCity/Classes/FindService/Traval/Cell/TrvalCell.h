//
//  TrvalCell.h
//  ConnectionCity
//
//  Created by qt on 2018/5/30.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrvalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet CustomtextView *txt_View;
@property (weak, nonatomic) IBOutlet UILabel *lab_headTitle;
@property (weak, nonatomic) IBOutlet UITextField *txt_Edit;
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath;
@end
