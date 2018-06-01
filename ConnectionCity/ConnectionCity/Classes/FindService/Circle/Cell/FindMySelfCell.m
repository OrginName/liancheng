//
//  FindMySelfCell.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FindMySelfCell.h"

@implementation FindMySelfCell
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath{
    FindMySelfCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FindMySelfCell1"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FindMySelfCell" owner:nil options:nil][1];
    }
    return cell;
}

@end
