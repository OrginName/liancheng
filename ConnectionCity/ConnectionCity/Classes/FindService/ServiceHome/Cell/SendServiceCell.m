//
//  SendServiceCell.m
//  ConnectionCity
//
//  Created by qt on 2018/5/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "SendServiceCell.h"
@interface SendServiceCell()
{
    UIButton * _tmpBtn;
}
@end
@implementation SendServiceCell
static NSArray * arr_Str;
+(void)initialize{
//    @{@"title":@"服务标题",@"placeholder":@"填写你可以赚钱的服务技能"},
    arr_Str = @[@{@"title":@"服务类别",@"placeholder":@"请选择服务类别"},@{@"title":@"服务介绍",@"placeholder":@"介绍你自己的服务优势"},@{@"title":@"服务价格",@"placeholder":@"填写价格"}];
}
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"";
    NSInteger index = 0;
    if (indexPath.section!=3&&indexPath.section!=4) {
        identifier = @"SendServiceCell0";
        index = 0;
    }else if (indexPath.section==3){
        identifier = @"SendServiceCell1";
        index = 1;
    }else if (indexPath.section==4){
        identifier = @"SendServiceCell2";
        index = 2;
    } 
    SendServiceCell *cell = (SendServiceCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SendServiceCell" owner:self options:nil] objectAtIndex:index];
    }
    if (indexPath.section!=3&&indexPath.section!=4){
        cell.lab_title.text = arr_Str[indexPath.section][@"title"];
        cell.txt_Placeholder.placeholder = arr_Str[indexPath.section][@"placeholder"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (IBAction)priceTypeClcik:(UIButton *)sender {
    if (sender.tag!=3) {
        UIButton * btn = (UIButton *)[self viewWithTag:1];
        btn.selected = NO;
    }
    if (_tmpBtn == nil){
        sender.selected = YES;
        _tmpBtn = sender;
    }
    if (_tmpBtn !=nil &&_tmpBtn == sender){
        sender.selected = YES;
    } else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
    }
    if ([self.delegate respondsToSelector:@selector(selectedItem:)]) {
        [self.delegate selectedItem:sender.tag];
    }
}
- (IBAction)btnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(selectedAgree:)]) {
        [self.delegate selectedAgree:sender];
    }
}

@end
