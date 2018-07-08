//
//  DubTimeSlectorController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/8.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "DubTimeSlectorController.h"
#import "LCDatePicker.h"

@interface DubTimeSlectorController ()<LCDatePickerDelegate>
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
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 初始化UI
- (void)setUI {
    self.navigationItem.title = @"时间区间";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(complete) image:@"" title:@"完成" EdgeInsets:UIEdgeInsetsZero];
    self.startBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    self.startBtn.layer.borderWidth = 1;
    self.endBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    self.endBtn.layer.borderWidth = 1;
    [self initDate];
}
//创建日期插件
-(void)initDate{
    self.myDatePick = [[LCDatePicker alloc] initWithFrame:kScreen];
    self.myDatePick.delegate  = self;
    [self.view addSubview:self.myDatePick];
}
#pragma mark - 点击事件
- (IBAction)selectedBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    currtenTag = btn.tag;
    [self.myDatePick animateShow];
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
#pragma mark ---LCDatePickerDelegate-----
- (void)lcDatePickerViewWithPickerView:(LCDatePicker *)picker str:(NSString *)str {
    if (currtenTag==1) {
        [_startBtn setTitle:str forState:UIControlStateNormal];
    }if (currtenTag==2) {
        [_endBtn setTitle:str forState:UIControlStateNormal];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
