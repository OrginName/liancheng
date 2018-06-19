//
//  AppointmentController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/31.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AppointmentController.h"
#import "LCDatePicker.h"
#import "EditAllController.h"
@interface AppointmentController ()<LCDatePickerDelegate>
@property (nonatomic,strong) LCDatePicker * myDatePick;
@property (weak, nonatomic) IBOutlet UILabel *lab_title1;
@property (weak, nonatomic) IBOutlet UILabel *lab_title2;
@property (weak, nonatomic) IBOutlet UILabel *lab_title3;
@property (weak, nonatomic) IBOutlet UIImageView *image_head;
@property (weak, nonatomic) IBOutlet UILabel *lab_name;
@property (weak, nonatomic) IBOutlet UILabel *lab_Preson;
@property (weak, nonatomic) IBOutlet UILabel *lab_age;
@property (weak, nonatomic) IBOutlet UIImageView *lab_Sex;
@property (weak, nonatomic) IBOutlet UILabel *lab_Servicetitle;
@property (weak, nonatomic) IBOutlet UILabel *lab_Price;
@property (weak, nonatomic) IBOutlet UILabel *lab_DY;
@property (weak, nonatomic) IBOutlet UITextField *txt_Num;
@property (weak, nonatomic) IBOutlet UITextField *txt_Time;
@property (weak, nonatomic) IBOutlet UITextField *txt_Place;
@property (weak, nonatomic) IBOutlet UITextField *txt_SumPrice;

@end

@implementation AppointmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.list.title;
    [self setUI];
    [self initDate];
}
-(void)setUI{
    if ([self.str isEqualToString:@"YD"]) {
        self.lab_title1.text = @"服务价格";
        self.lab_title2.text = @"服务时间";
        self.lab_title3.text = @"服务地点";
    }
}
//创建日期插件
-(void)initDate{
    self.myDatePick = [[LCDatePicker alloc] initWithFrame:kScreen];
    self.myDatePick.delegate  = self;
    [self.view addSubview:self.myDatePick];
}
- (IBAction)yuyueClick:(UIButton *)sender {
    
}
- (IBAction)TimeClick:(id)sender {
    UIButton * btn = (UIButton *)sender;
    if (btn.tag==4) {
        [self.myDatePick animateShow];
    }else{
        EditAllController * edit = [EditAllController new];
        edit.block = ^(NSString *EditStr) {
            self.txt_Place.text = EditStr;
        };
        [self.navigationController pushViewController:edit animated:YES];
    }
    
}
#pragma mark ---LCDatePickerDelegate-----
- (void)lcDatePickerViewWithPickerView:(LCDatePicker *)picker str:(NSString *)str {
    self.txt_Time.text = str;
}
@end
