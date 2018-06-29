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
-(void)setMoment:(Moment *)moment{
    _moment = moment;
    if ([KString(@"%@", moment.containsVideo) isEqualToString:@"1"]) {
        self.image_first.image = moment.coverImage  ;
    }else
       [self.image_first sd_setImageWithURL:[NSURL URLWithString:[moment.images componentsSeparatedByString:@";"][0]] placeholderImage:[UIImage imageNamed:@"no-pic"]];
    NSString * strFirst = [moment.createTime componentsSeparatedByString:@" "][0];
    self.lab_Month.text = KString(@"%@月", [moment.createTime componentsSeparatedByString:@"-"][1]);
    self.lab_date.text = [strFirst componentsSeparatedByString:@"-"][2];
    self.lab_city.text = moment.cityName;
    self.lab_content.text = moment.content;
    
}
@end
