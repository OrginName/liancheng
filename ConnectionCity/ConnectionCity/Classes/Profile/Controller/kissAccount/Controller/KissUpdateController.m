//
//  KissUpdateController.m
//  ConnectionCity
//
//  Created by qt on 2018/8/19.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "KissUpdateController.h"
#import <PGDatePickManager.h>
#import "ForgetPasswordView.h"
#import <UIView+TYAlertView.h>
#import "CCPPickerView.h"//选择时间00：00~00：00
#import "RefineView.h"
#import "SelectWeek.h"
@interface KissUpdateController ()
{
    NSString * weekIDC;
}
@property (nonatomic,strong) RefineView * refine;
@property (nonatomic,strong) SelectWeek * selectView;
@property (weak, nonatomic) IBOutlet UILabel *lab_nickName;
@property (weak, nonatomic) IBOutlet UILabel *lab_LCH;
@property (weak, nonatomic) IBOutlet UITextField *txt_weekCircle;
@property (weak, nonatomic) IBOutlet UITextField *txt_workTime;
@property (weak, nonatomic) IBOutlet UITextField *txt_shareRadio;
@property (weak, nonatomic) IBOutlet UITextField *txt_password;
@end
@implementation KissUpdateController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInitData];
}
-(void)setInitData{
    self.lab_nickName.text = self.model.user.nickName?self.model.user.nickName:self.model.user.ID?self.model.user.ID:@"-";
    self.lab_LCH.text = [self.model.closeUserId description];
    NSArray * arr = [self.model.workPeriod componentsSeparatedByString:@","];
    NSArray * arr1 = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    for (long i=arr.count-1; i>=0; i--) {
        NSString * str = arr1[[arr[i] intValue]-1];
        self.txt_weekCircle.text = [NSString stringWithFormat:@"%@,%@",str,self.txt_weekCircle.text];
    }
    self.txt_workTime.text = self.model.workTime;
    self.txt_shareRadio.text = KString(@"%.2f", [self.model.rate floatValue]*100);
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
        };
        self.refine = [[RefineView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) type:self.selectView];
        [self.refine alertSelectViewshow];
    }
    return NO;
}
- (IBAction)btnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 1://忘记密码
            {
                ForgetPasswordView * shareView = [ForgetPasswordView createViewFromNib:0];
                shareView.modelR = self.model;
                // use UIView Category
                [shareView showInWindow];
            }
            break;
        case 2://重置密码
            {
                ForgetPasswordView * shareView = [ForgetPasswordView createViewFromNib:1];
                shareView.modelR = self.model;
                // use UIView Category
                [shareView showInWindow];
            }
            break;
        case 3://确认修改
            {
                if ([YSTools dx_isNullOrNilWithObject:self.txt_workTime.text]) {
                    return [YTAlertUtil showTempInfo:@"请输入工作时间"];
                }
                if ([YSTools dx_isNullOrNilWithObject:self.txt_weekCircle.text]) {
                    return [YTAlertUtil showTempInfo:@"请输入工作周期"];
                }
                if ([YSTools dx_isNullOrNilWithObject:self.txt_shareRadio.text]||[self.txt_shareRadio.text floatValue]<1||[self.txt_shareRadio.text floatValue]>100) {
                    return [YTAlertUtil showTempInfo:@"请输入正确的共享比例(1~100)"];
                }
                if ([YSTools dx_isNullOrNilWithObject:self.txt_password.text]) {
                    return [YTAlertUtil showTempInfo:@"请输入锁定密码"];
                }
                [self loadData];
            }
            break;
        case 4:{
            self.txt_password.secureTextEntry = !self.txt_password.secureTextEntry;
        }
            break;
        default:
            break;
    }
}
//提交更新亲密账户数据
-(void)loadData{
    NSDictionary * dic = @{
                           @"closeUserId": @([self.model.closeUserId intValue]),
                           @"id": @([self.model.modelId intValue]),
                           @"lockPassword": self.txt_password.text,
                           @"rate": @((floorf([self.txt_shareRadio.text floatValue] + 0.5))/100),
                           @"workPeriod": weekIDC.length==0?self.model.workPeriod:weekIDC,
                           @"workTime": self.txt_workTime.text
                           };
    [YSNetworkTool POST:v1usercloseaccountupdate params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDear" object:nil];
        UIViewController * controller = self.navigationController.viewControllers[2];
        [self.navigationController popToViewController:controller animated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end
