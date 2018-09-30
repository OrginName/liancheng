//
//  GuardEduAndCollController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/13.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "GuardEduController.h"
#import "EditAllController.h"
#import "LCDatePicker.h"
#import "AbilityNet.h"
#import "SortCollProController.h"
#import <PGDatePicker/PGDatePickManager.h>
#import "AllDicMo.h"
//LCDatePickerDelegate
@interface GuardEduController ()<UITextViewDelegate,PGDatePickerDelegate>
{
    NSInteger currtenTag;
    NSString * _EduID;
    NSString * _collID;
    NSString * _proID;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout;
@property (nonatomic,strong) LCDatePicker * myDatePick;
@property (weak, nonatomic) IBOutlet CustomtextView *textView_Indro;
@property (weak, nonatomic) IBOutlet UITextField *text_Coll;
@property (weak, nonatomic) IBOutlet UITextField *text_Pro;
@property (weak, nonatomic) IBOutlet UIButton *btn_Save;
@property (weak, nonatomic) IBOutlet UITextField *text_XL;
@property (weak, nonatomic) IBOutlet UITextField *end_Time;
@property (weak, nonatomic) IBOutlet UITextField *Start_time;
@end

@implementation GuardEduController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    _EduID = @"";
    _collID = @"";
    _proID = @"";
    [self setMo:self.mo];
}
-(void)setMo:(ResumeMo *)mo{
    _mo = mo;
    if (self.mo!=nil) {
        self.text_Coll.text = mo.collAndcompany;
        self.text_Pro.text = mo.XLAndIntro;
        self.text_XL.text = mo.proAndPro;
        self.Start_time.text = mo.satrtTime;
        self.end_Time.text = mo.endTime;
        self.textView_Indro.text = mo.description1;
        self.layout.constant = (kScreenWidth-20)/2;
        _EduID = mo.eduID;
        _collID = mo.schoolId;
    }
}
//保存按钮点击
- (IBAction)btn_Save:(UIButton *)sender {
    if (sender.tag==30) {
        if (self.text_Coll.text.length==0||self.text_Pro.text.length==0||self.text_XL.text.length==0||self.Start_time.text.length==02||self.end_Time.text.length==0) {
            [YTAlertUtil showTempInfo:@"请查看是否输入完整"];
            return;
        }
        if ([YSTools initTimerCompare:self.Start_time.text withEndTime:self.end_Time.text]!=2) {
            [YTAlertUtil showTempInfo:@"结束日期不能小于开始日期"];
            return;
        }
//        if (self.textView_Indro.text.length==0) {
//            return [YTAlertUtil showTempInfo:@"请输入描述"];
//        }
        NSDictionary * dic =@{
                              @"description": self.textView_Indro.text,
                              @"educationId": @([_EduID integerValue]),
                              @"endDate": self.end_Time.text,
//                              @"professionalId": _proID.length!=0? @([_proID integerValue]):@"",
                              @"resumeId": @([self.resumeID integerValue]),
                              @"schoolId": @([_collID integerValue]),//****
                              @"startDate": self.Start_time.text,
                              @"professionalName":self.text_Pro.text,//专业名称
                              @"schoolName":self.text_Coll.text,//学校名称
                              @"educationId":self.mo!=nil?self.mo.ID:@"",
                              @"educationExperienceId":self.mo!=nil?self.mo.ID:@""
                              };
        if (self.mo!=nil) {
            [YSNetworkTool POST:v1TalentResumeEducationUpdate params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
                [self backReload:2];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
        }else{
            [AbilityNet requstAddEdu:dic withBlock:^(NSDictionary *successDicValue) {
                [self backReload:1];
            }];
        }
    }else{
        [YSNetworkTool POST:v1TalentResumeEducationDelete params:@{@"id":self.mo.ID} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            self.block2();
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    
}
-(void)backReload:(int)a{
    ResumeMo * mo = [[ResumeMo alloc] init];
    mo.collAndcompany = self.text_Coll.text;
    mo.proAndPro = self.text_XL.text;
    mo.XLAndIntro = self.text_Pro.text;
    mo.satrtTime = self.Start_time.text;
    mo.endTime = self.end_Time.text;
    mo.eduID = _EduID;
    a==1?self.block(mo):self.block1(mo);
    [self.navigationController popViewControllerAnimated:YES];
}
//各个编辑按钮点击
- (IBAction)btn_Click:(UIButton *)sender {
    if (sender.tag==1) {
        SortCollProController * sort = [SortCollProController new];
        sort.title = @"学校";
        sort.url = dictionarySchool;
        sort.block = ^(ShoolOREduMo *mo) {
            self.text_Coll.text = mo.name;
            _collID = mo.ID;
        };
        [self.navigationController pushViewController:sort animated:YES];
    }else if (sender.tag==2) {
//        SortCollProController * sort = [SortCollProController new];
//        sort.title = @"专业";
//        sort.url = dictionaryProfessional;
//        sort.block = ^(ShoolOREduMo *mo) {
//            self.text_Pro.text = mo.name;
//            _proID = mo.ID;
//        };
//        [self.navigationController pushViewController:sort animated:YES];
        EditAllController * edit = [EditAllController new];
        edit.receiveTxt  = sender.tag==2?self.text_Pro.text :self.text_Coll.text;
        edit.block = ^(NSString * str){
            sender.tag==2?(self.text_Pro.text = str):(self.text_Coll.text=str);
        };
        [self.navigationController pushViewController:edit animated:YES];
    }
    else if (sender.tag==3) {
        NSMutableArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:KAllDic]];
        NSArray *contentArr = [arr[0] contentArr];
        NSMutableArray *title = [NSMutableArray array];
        for (int i=0; i < contentArr.count; i++) {
            AllContentMo * mo = contentArr[i];
            [title addObject:mo.description1];
            YTLog(@"%@",mo.description1);
            YTLog(@"%@",mo.value);
        }
        WeakSelf
        [YTAlertUtil alertMultiWithTitle:nil message:nil style:UIAlertControllerStyleActionSheet multiTitles:title multiHandler:^(UIAlertAction *action, NSArray *titles, NSUInteger idx) {
            AllContentMo * mo = contentArr[idx];
            weakSelf.text_XL.text = mo.description1;
            _EduID = mo.value;
        } cancelTitle:@"取消" cancelHandler:nil completion:nil];
    }
    else{
        currtenTag = sender.tag;
//        [self.myDatePick animateShow];
        [self tanDatePick];
    }
}
-(void)setUI{
    self.textView_Indro.placeholder = @"请输入工作描述";
    self.textView_Indro.placeholderColor = [UIColor hexColorWithString:@"#bbbbbb"];
    
//    [self initDate];
}
//#pragma mark ---LCDatePickerDelegate-----
//- (void)lcDatePickerViewWithPickerView:(LCDatePicker *)picker str:(NSString *)str {
//    UITextField * text = (UITextField *)[self.view viewWithTag:currtenTag+6];
//    text.text = str;
//}
#pragma mark ---- PGDatePickerDelegate-----
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %ld", (long)dateComponents.year);
    NSString * str = [NSString stringWithFormat:@"%ld-%@%ld-%@%ld",(long)dateComponents.year,dateComponents.month<10?@"0":@"",(long)dateComponents.month,dateComponents.day<10?@"0":@"",(long)dateComponents.day];
    UITextField * text = (UITextField *)[self.view viewWithTag:currtenTag+6];
    text.text = str;
}
//创建日期插件
-(void)initDate{
//    self.myDatePick = [[LCDatePicker alloc] initWithFrame:kScreen];
//    self.myDatePick.delegate  = self;
//    [self.view addSubview:self.myDatePick];
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
    datePicker.maximumDate = [NSDate date];
    datePicker.delegate = self;
    [self presentViewController:datePickManager animated:false completion:nil];
}
@end

