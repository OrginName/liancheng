//
//  AccountManageCell.m
//  ConnectionCity
//
//  Created by qt on 2018/6/6.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AccountManageCell.h"

@implementation AccountManageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath{
    NSString * str = @"";
    NSInteger index;
    if (indexPath.section==0) {
        str = @"AccountManageCell0";
        index = 0;
    }else{
        str = indexPath.row<2?@"AccountManageCel2":@"AccountManageCel3";
        index = indexPath.row<2?2:3;
    }
    AccountManageCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"AccountManageCell" owner:nil options:nil][index];
    }
    return cell;
}
@end
