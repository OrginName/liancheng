//
//  AddKissController.m
//  ConnectionCity
//
//  Created by qt on 2018/8/18.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AddKissController.h"
#import "CCPPickerView.h"//选择时间00：00~00：00
#import "RefineView.h"
#import "SelectWeek.h"
#import "privateUserInfoModel.h"
@interface AddKissController ()<UITextFieldDelegate>
{
    NSString * weekIDC;
}
@property (nonatomic,strong) RefineView * refine;
@property (nonatomic,strong) SelectWeek * selectView;
@property (weak, nonatomic) IBOutlet UILabel *lab_LCH;//连城号
@property (weak, nonatomic) IBOutlet UITextField *txt_workCircle;//工作周期
@property (weak, nonatomic) IBOutlet UITextField *txt_worTime;
@property (weak, nonatomic) IBOutlet UITextField *txt_ShareRadio;//共享比例
@property (weak, nonatomic) IBOutlet UITextField *txt_TALCH;//对方的连城号
@property (weak, nonatomic) IBOutlet UIButton *btn_agree;
@property (weak, nonatomic) IBOutlet UITextField *txt_password;
@end

@implementation AddKissController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
}
-(void)initData{
    self.lab_LCH.text = [[YSAccountTool userInfo] modelId];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.tag==2) {
        CCPPickerView *pickerView = [[CCPPickerView alloc] initWithpickerViewWithCenterTitle:@"" andCancel:@"取消" andSure:@"确定"];
        
        [pickerView pickerVIewClickCancelBtnBlock:^{
            
            NSLog(@"取消");
            
        } sureBtClcik:^(NSString *leftString) {
            
            textField.text = leftString;
            
        }];
    }else if (textField.tag==1){
        self.selectView = [[[NSBundle mainBundle] loadNibNamed:@"SelectWeek" owner:nil options:nil] firstObject];
        self.selectView.frame = CGRectMake(0, 0, kScreenWidth, 170);
        self.selectView.weekBlock = ^(NSString *weekStr, NSString *weekID) {
            weekStr = weekStr.length!=0?[weekStr substringToIndex:weekStr.length-1]:@"";
            weekIDC = weekID.length!=0?[weekID substringToIndex:weekID.length-1]:@"";
            textField.text = weekStr;
            YTLog(@"%@-%@",weekStr,weekID);
        };
        self.refine = [[RefineView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) type:self.selectView];
        [self.refine alertSelectViewshow];
    }
    return NO;
}
/**
 绑定亲密账户

 @param sender btn
 */
- (IBAction)sureClick:(UIButton *)sender {
    if (sender.tag==3) {
        self.txt_password.secureTextEntry = !self.txt_password.secureTextEntry;
        return;
    }
    if ([YSTools dx_isNullOrNilWithObject:self.txt_TALCH.text]) {
        return [YTAlertUtil showTempInfo:@"请输入对方的连程号"];
    }
    if ([YSTools dx_isNullOrNilWithObject:self.txt_worTime.text]) {
        return [YTAlertUtil showTempInfo:@"请输入工作时间"];
    }
    if ([YSTools dx_isNullOrNilWithObject:self.txt_workCircle.text]) {
        return [YTAlertUtil showTempInfo:@"请输入工作周期"];
    }
    if ([YSTools dx_isNullOrNilWithObject:self.txt_ShareRadio.text]) {
        return [YTAlertUtil showTempInfo:@"请输入共享比例"];
    }
    if ([YSTools dx_isNullOrNilWithObject:self.txt_password.text]) {
        return [YTAlertUtil showTempInfo:@"请输入锁定密码"];
    }
    NSDictionary * dic = @{
                           @"closeUserId": @([self.txt_TALCH.text intValue]),
                           @"id": @([self.lab_LCH.text intValue]),
                           @"lockPassword": self.txt_password.text,
                           @"rate": @((floorf([self.txt_ShareRadio.text floatValue]*100 + 0.5))/100),
                           @"workPeriod": weekIDC,
                           @"workTime": self.txt_worTime.text
                           };
    [YSNetworkTool POST:v1usercloseaccountcreate params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end
