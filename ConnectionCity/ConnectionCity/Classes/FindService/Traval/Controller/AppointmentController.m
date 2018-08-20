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
#import "OurServiceController.h"
#import <PGDatePicker/PGDatePickManager.h>
//LCDatePickerDelegate
@interface AppointmentController ()<UITextFieldDelegate,PGDatePickerDelegate>
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
    [self setUI];
//    [self initDrate];
}
-(void)setUI{
    if ([self.str isEqualToString:@"YD"]) {
        self.lab_title1.text = @"服务价格";
        self.lab_title2.text = @"服务时间";
        self.lab_title3.text = @"服务地点";
        self.navigationItem.title = self.user.nickName?self.user.nickName:KString(@"用户%@", self.user.ID);
        [self.image_head sd_setImageWithURL:[NSURL URLWithString:self.user.headImage] placeholderImage:[UIImage imageNamed:@"no-pic"]];
        self.lab_name.text = self.user.nickName;
        self.lab_Sex.image = [UIImage imageNamed:[self.user.gender isEqualToString:@"0"]?@"men":@"weomen"];
        self.lab_age.text = self.user.age?self.user.age:@"";
        self.lab_Preson.text = [NSString stringWithFormat:@"%@cm %@kg %@ %@",self.user.height?self.user.height:@"-",self.user.weight?self.user.weight:@"-",self.user.educationName?self.user.educationName:@"-",self.user.marriageName?self.user.marriageName:@"-"];
        self.lab_Servicetitle.text = self.list.serviceCategoryName[@"name"]?self.list.serviceCategoryName[@"name"]:@"-";
        self.lab_Price.text = self.list.price;
        self.lab_DY.text = self.list.typeName;
    }else{
        self.navigationItem.title = self.trval.user.nickName;
        [self.image_head sd_setImageWithURL:[NSURL URLWithString:self.trval.user.headImage] placeholderImage:[UIImage imageNamed:@"no-pic"]];
        self.lab_name.text = self.trval.user.nickName;
        self.lab_Sex.image = [UIImage imageNamed:[self.trval.user.gender isEqualToString:@"0"]?@"men":@"women"];
        self.lab_age.text = self.trval.user.age?self.trval.user.age:@"";
        self.lab_Preson.text = [NSString stringWithFormat:@"%@cm %@kg %@ %@",self.trval.user.height?self.trval.user.height:@"-",self.trval.user.weight?self.trval.user.weight:@"-",self.trval.user.educationName?self.trval.user.educationName:@"-",self.trval.user.marriageName?self.trval.user.marriageName:@"-"];
        self.lab_Servicetitle.text = self.trval.introduce;
        self.lab_Price.text = self.trval.price;
        self.lab_DY.text = self.trval.priceUnit?self.trval.priceUnit:@"-";
    }
}
#define mark -----UITextFieldDelegate------
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([self.str isEqualToString:@"YD"]){
        self.txt_SumPrice.text = [NSString stringWithFormat:@"¥%.2f",[self.list.price floatValue]*[textField.text floatValue]];
    }else
        self.txt_SumPrice.text = [NSString stringWithFormat:@"¥%.2f",[self.trval.price floatValue]*[textField.text floatValue]];
    
}
//创建日期插件
-(void)initDate{
//    self.myDatePick = [[LCDatePicker alloc] initWithFrame:kScreen];
//    self.myDatePick.dateModel = UIDatePickerModeDateAndTime;
//    self.myDatePick.delegate  = self;
//    [self.view addSubview:self.myDatePick];
    
}
- (IBAction)yuyueClick:(UIButton *)sender {
    NSInteger flag;
    NSString * str=@"";
    NSDictionary * dic;
    if ([self.str isEqualToString:@"YD"]){
        flag = 0;
        str = v1ServiceCreateOrder;
        dic = @{
                @"address": self.txt_Place.text,
                @"number": @([self.txt_Num.text integerValue]),
                @"serviceId": @([self.list.ID integerValue]),
                @"serviceTime": self.txt_Time.text
                };
    }else{
        flag = 1;
        str = v1ServiceTravelOrderCreate;
        dic = @{
                @"address": self.txt_Place.text,
                @"num": @([self.txt_Num.text integerValue]),
                @"travelId": @([self.trval.ID integerValue]),
                @"startTime": self.txt_Time.text
                };
    }
        if (self.txt_Num.text.length==0) {
            [YTAlertUtil showTempInfo:@"请输入数量"];
            return;
        }
        if (self.txt_Time.text.length==0) {
            [YTAlertUtil showTempInfo:flag==0?@"请选择服务时间":@"请选择陪游时间"];
            return;
        }
        if (self.txt_Place.text.length==0) {
            [YTAlertUtil showTempInfo:flag==0?@"请输入服务地点":@"请选择陪游地点"];
            return;
        }
        WeakSelf
        [YSNetworkTool POST:str params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] isEqualToString:@"FAIL"]) {
                [YTAlertUtil showTempInfo:responseObject[@"message"]];
                return;
            }
            OurServiceController * our = [OurServiceController new];
            if ([weakSelf.str isEqualToString:@"YD"]) {
                our.inter = 1;
            }else
                our.inter = 2;
            [self.navigationController pushViewController:our animated:YES];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
}
- (IBAction)TimeClick:(id)sender {
    UIButton * btn = (UIButton *)sender;
    if (btn.tag==4) {
//        [self.myDatePick animateShow];
        [self tanDatePick];
    }else{
        EditAllController * edit = [EditAllController new];
        edit.receiveTxt = self.txt_Place.text;
        edit.block = ^(NSString *EditStr) {
            self.txt_Place.text = EditStr;
        };
        [self.navigationController pushViewController:edit animated:YES];
    }
}
//#pragma mark ---LCDatePickerDelegate-----
//- (void)lcDatePickerViewWithPickerView:(LCDatePicker *)picker str:(NSString *)str {
//    self.txt_Time.text = str;
//}
#pragma mark ---PGDatePickerDelegate-----
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents{
    self.txt_Time.text = [NSString stringWithFormat:@"%ld-%@%ld-%@%ld %@%ld:%@%ld",dateComponents.year,dateComponents.month<10?@"0":@"",dateComponents.month,dateComponents.day<10?@"0":@"",dateComponents.day,dateComponents.hour<10?@"0":@"",dateComponents.hour,dateComponents.minute<10?@"0":@"",dateComponents.minute];
}
-(void)tanDatePick{
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    //设置半透明的背景颜色
    datePickManager.isShadeBackgroud = true;
    //设置头部的背景颜色
    datePickManager.headerViewBackgroundColor = YSColor(244, 177, 113);
    datePicker.datePickerMode = PGDatePickerModeDateHourMinute;
    //设置取消按钮的字体颜色
    datePickManager.cancelButtonTextColor = [UIColor whiteColor];
    datePickManager.confirmButtonTextColor = [UIColor whiteColor];
    //    datePicker.datePickerType = PGDatePickerType2;
    datePicker.minimumDate = [NSDate date];
    datePicker.delegate = self;
    [self presentViewController:datePickManager animated:false completion:nil];
}
@end
