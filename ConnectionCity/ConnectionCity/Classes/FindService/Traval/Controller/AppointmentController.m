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
@interface AppointmentController ()<LCDatePickerDelegate,UITextFieldDelegate>
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
    [self initDate];
}
-(void)setUI{
    if ([self.str isEqualToString:@"YD"]) {
        self.lab_title1.text = @"服务价格";
        self.lab_title2.text = @"服务时间";
        self.lab_title3.text = @"服务地点";
        self.navigationItem.title = self.list.title;
        [self.image_head sd_setImageWithURL:[NSURL URLWithString:self.list.user1.headImage] placeholderImage:[UIImage imageNamed:@"no-pic"]];
        self.lab_name.text = self.list.user1.nickName;
        self.lab_Sex.image = [UIImage imageNamed:[self.list.user1.gender isEqualToString:@"0"]?@"men":@"weomen"];
        self.lab_age.text = self.list.user1.age?self.list.user1.age:@"";
        self.lab_Preson.text = [NSString stringWithFormat:@"%@ %@ %@ %@",self.list.user1.height?self.list.user1.height:@"",self.list.user1.weight?self.list.user1.weight:@"",self.list.user1.educationId?self.list.user1.educationId:@"",self.list.user1.marriage?self.list.user1.marriage:@""];
        self.lab_Servicetitle.text = self.list.title;
        self.lab_Price.text = self.list.price;
        self.lab_DY.text = self.list.typeName;
    }else{
        self.navigationItem.title = self.trval.user1.realName;
        [self.image_head sd_setImageWithURL:[NSURL URLWithString:self.trval.user1.headImage] placeholderImage:[UIImage imageNamed:@"no-pic"]];
        self.lab_name.text = self.trval.user1.realName;
        self.lab_Sex.image = [UIImage imageNamed:[self.trval.user1.gender isEqualToString:@"0"]?@"men":@"weomen"];
        self.lab_age.text = self.trval.user1.age?self.trval.user1.age:@"";
        self.lab_Preson.text = [NSString stringWithFormat:@"%@ %@ %@ %@",self.trval.user1.height?self.trval.user1.height:@"",self.trval.user1.weight?self.trval.user1.weight:@"",self.trval.user1.educationId?self.trval.user1.educationId:@"",self.trval.user1.marriage?self.trval.user1.marriage:@""];
        self.lab_Servicetitle.text = self.trval.introduce;
        self.lab_Price.text = self.trval.price;
        self.lab_DY.text = @"暂无";
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
    self.myDatePick = [[LCDatePicker alloc] initWithFrame:kScreen];
    self.myDatePick.delegate  = self;
    [self.view addSubview:self.myDatePick];
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
    
        [YSNetworkTool POST:str params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] isEqualToString:@"FAIL"]) {
                [YTAlertUtil showTempInfo:responseObject[@"message"]];
                return;
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    
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
