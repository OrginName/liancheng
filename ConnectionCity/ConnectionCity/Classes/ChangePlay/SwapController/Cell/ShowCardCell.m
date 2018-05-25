//
//  ShowCardCell.m
//  ConnectionCity
//
//  Created by qt on 2018/5/25.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ShowCardCell.h"

@implementation ShowCardCell

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"";//对应xib中设置的identifier
    NSInteger index = 0; //xib中第几个Cell
    if (indexPath.row == 0) {
        identifier = @"ShowResumeCell0";
        index = 0;
    }else if(indexPath.row==1){
        identifier = @"ShowResumeCell1";
        index = 1;
    }
    ShowCardCell *cell = (ShowCardCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ShowCardCell" owner:self options:nil] objectAtIndex:index];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
