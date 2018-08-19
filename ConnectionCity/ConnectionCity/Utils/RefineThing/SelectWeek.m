//
//  SelectWeek.m
//  ConnectionCity
//
//  Created by qt on 2018/8/19.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "SelectWeek.h"
#import "CustomButton.h"
@interface SelectWeek()
@property (nonatomic,copy)NSArray * arrWeek;
@property (nonatomic,strong) NSMutableArray * arrSelect;
@end
@implementation SelectWeek

-(void)awakeFromNib{
    [super awakeFromNib];
    self.arrSelect = [NSMutableArray array];
    self.arrWeek = @[@"2",@"3",@"4",@"5",@"6",@"7",@"1"];
}
- (IBAction)btnSureCancleClik:(UIButton *)sender {
    if (sender.tag==1) {
        
    }else{
        NSString * str1 = @"";
        NSString * str2 = @"";
        for (NSString * week in self.arrSelect) {
            str1 = [NSString stringWithFormat:@"%@,%@",week,str1];
            NSString * str3 = [week isEqualToString:@"1"]?@"周日":[week isEqualToString:@"2"]?@"周一":[week isEqualToString:@"3"]?@"周二":[week isEqualToString:@"4"]?@"周三":[week isEqualToString:@"5"]?@"周四":[week isEqualToString:@"6"]?@"周五":@"周六";
            str2 = [NSString stringWithFormat:@"%@,%@",str3,str2];
        }
        if (self.weekBlock) {
            self.weekBlock(str1, str2);
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:CLOSEANI object:nil];
}
- (IBAction)btnClick:(CustomButton *)sender {
    NSLog(@"-----%d",sender.selected);
    sender.selected = !sender.selected;
    NSString * str = self.arrWeek[sender.tag-3];
    if (sender.selected) {
        if ([self.arrSelect containsObject:str]) {
            [self.arrSelect removeObject:str];
        }
        [self.arrSelect addObject:str];
    }else{
        [self.arrSelect removeObject:str];
    }
}
@end
