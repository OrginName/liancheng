//
//  DubTimeSlectorController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/8.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "DubTimeSlectorController.h"
#import "LCDatePicker.h"
#import <PGDatePickManager.h>
//LCDatePickerDelegate
@interface DubTimeSlectorController ()<PGDatePickerDelegate>
{
    NSInteger currtenTag;
}
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;
@property (nonatomic, strong) LCDatePicker * myDatePick;

@end

@implementation DubTimeSlectorController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
#pragma mark - 初始化UI
- (void)setUI {
    self.navigationItem.title = @"时间区间";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(complete) image:@"" title:@"完成" EdgeInsets:UIEdgeInsetsZero];
    self.startBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    self.startBtn.layer.borderWidth = 1;
    self.endBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    self.endBtn.layer.borderWidth = 1;
//    [self initDate];
}
//创建日期插件
//-(void)initDate{
//    self.myDatePick = [[LCDatePicker alloc] initWithFrame:kScreen];
//    self.myDatePick.delegate  = self;
//    [self.view addSubview:self.myDatePick];
//}
#pragma mark - 点击事件
- (IBAction)selectedBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    currtenTag = btn.tag;
//    [self.myDatePick animateShow];
    [self tanDatePick];
}
-(void)complete{
    if ([_startBtn.titleLabel.text isEqualToString:@"请选择开始时间"]||[_startBtn.titleLabel.text isEqualToString:@"请选择结束时间"]) {
        [YTAlertUtil showTempInfo:@"请选择时间"];
        return;
    }
    if (_timeBlock) {
        _timeBlock(_startBtn.titleLabel.text,_endBtn.titleLabel.text);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//#pragma mark ---LCDatePickerDelegate-----
//- (void)lcDatePickerViewWithPickerView:(LCDatePicker *)picker str:(NSString *)str {
//    if (currtenTag==1) {
//        [_startBtn setTitle:str forState:UIControlStateNormal];
//    }if (currtenTag==2) {
//        [_endBtn setTitle:str forState:UIControlStateNormal];
//    }
//}
#pragma mark ---- PGDatePickerDelegate-----
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %ld", (long)dateComponents.year);
    NSString * str = [NSString stringWithFormat:@"%ld-%@%ld-%@%ld",(long)dateComponents.year,dateComponents.month<10?@"0":@"",(long)dateComponents.month,dateComponents.day<10?@"0":@"",(long)dateComponents.day];
    if (currtenTag==1) {
        [_startBtn setTitle:str forState:UIControlStateNormal];
    }if (currtenTag==2) {
        [_endBtn setTitle:str forState:UIControlStateNormal];
    }
}
-(void)tanDatePick{
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    //设置半透明的背景颜色
    datePickManager.isShadeBackgroud = true;
    //设置头部的背景颜色
    datePickManager.headerViewBackgroundColor = YSColor(244, 177, 113);
    datePicker.datePickerMode = PGDatePickerModeDate;
    //设置取消按钮的字体颜色
    datePickManager.cancelButtonTextColor = [UIColor whiteColor];
    datePickManager.confirmButtonTextColor = [UIColor whiteColor];
    //    datePicker.datePickerType = PGDatePickerType2;
//    datePicker.maximumDate = [NSDate date];
    datePicker.delegate = self;
    [self presentViewController:datePickManager animated:false completion:nil];
}
@end
