//
//  ShowResumeCell.m
//  ConnectionCity
//
//  Created by qt on 2018/5/16.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ShowResumeCell.h"

@implementation ShowResumeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"";//对应xib中设置的identifier
    NSInteger index = 0; //xib中第几个Cell
    if (indexPath.section == 1 || indexPath.section == 2) {
        identifier = [NSString stringWithFormat:@"ShowResumeCell%d",2];
        index = 2;
    }else if(indexPath.section==0){
        if (indexPath.row==0){
            identifier = [NSString stringWithFormat:@"ShowResumeCell%d",0];
            index = 0;
        }else if (indexPath.row==1){
            identifier = [NSString stringWithFormat:@"ShowResumeCell%d",1];
            index = 1;
        }
    }else if(indexPath.section==3){
        identifier = [NSString stringWithFormat:@"ShowResumeCell%d",3];
        index = 3;
    }
    ShowResumeCell *cell = (ShowResumeCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ShowResumeCell" owner:self options:nil] objectAtIndex:index];
        
    }
    cell.lab_ProTitle.text = indexPath.section==2?@"学历：":@"职业：";
    cell.lab_introTitle.text = indexPath.section==2?@"专业：":@"描述：";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

@end
