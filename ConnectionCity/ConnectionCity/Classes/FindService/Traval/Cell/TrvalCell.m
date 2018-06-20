//
//  TrvalCell.m
//  ConnectionCity
//
//  Created by qt on 2018/5/30.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "TrvalCell.h"
@interface TrvalCell()
@property (weak, nonatomic) IBOutlet UILabel *lab_title;

@end
static NSArray * arr_title;
@implementation TrvalCell
+(void)initialize{
    [super initialize];
    arr_title = @[@"旅行去哪",@"邀约对象",@"出发时间",@"旅行时长",@"出行方式",@"旅行花费"];
}
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath {
    NSString * str = @"";
    NSInteger a = 0;
    if (indexPath.section!=2) {
        str = @"TrvalCell2";
        a=2;
    }else{
        str = @"TrvalCell3";
        a=3;
    }
    TrvalCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TrvalCell" owner:nil options:nil][a];
        if (indexPath.section==0) {
            cell.lab_title.text = arr_title[indexPath.row];
        }else if (indexPath.section==1){
            cell.lab_title.text = arr_title[indexPath.row+2];
        } 
        
    }
    return cell;
}

@end
