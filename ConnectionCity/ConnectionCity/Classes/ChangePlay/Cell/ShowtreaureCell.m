//
//  ShowtreaureCell.m
//  ConnectionCity
//
//  Created by qt on 2018/5/25.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ShowtreaureCell.h"

@implementation ShowtreaureCell

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"ShowtreaureCell%ld",indexPath.row];
    NSInteger index = indexPath.row;
    ShowtreaureCell *cell = (ShowtreaureCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ShowtreaureCell" owner:self options:nil] objectAtIndex:index];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
