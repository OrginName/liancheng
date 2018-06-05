//
//  OurPlayCell.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "OurPlayCell.h"

@implementation OurPlayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath currentTag:(NSInteger)tag{
    NSString * str = @"";
    NSInteger index;
    if (tag==1) {
        str = @"OurPlayCell0";
        index = 0;
    }else{
        str = @"OurPlayCell1";
        index = 1;
    }
    OurPlayCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"OurPlayCell" owner:nil options:nil][index];
    }
    return cell;
}
@end
