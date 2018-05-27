//
//  PlayDouctCell.m
//  ConnectionCity
//
//  Created by qt on 2018/5/27.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "PlayDouctCell.h"
@implementation PlayDouctCell
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath withCollArr:(NSMutableArray * )arr   {
    NSString *identifier = @"";//对应xib中设置的identifier
    NSInteger index = 0; //xib中第几个Cell
    if (arr.count==0) {
        identifier = @"PlayDouctCell0";
        index = 0;
    }else{
        identifier = @"PlayDouctCell1";
        index = 1;
    }
    PlayDouctCell *cell = (PlayDouctCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PlayDouctCell" owner:self options:nil] objectAtIndex:index];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
@end
