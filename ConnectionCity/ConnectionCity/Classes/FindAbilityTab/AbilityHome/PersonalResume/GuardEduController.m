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
@interface GuardEduController ()<UITextViewDelegate,LCDatePickerDelegate>
{
    NSInteger currtenTag;
    NSString * _EduID;
    NSString * _collID;
    NSString * _proID;
}
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
        NSDictionary * dic =@{
                              @"description": self.textView_Indro.text,
                              @"educationId": @([_EduID integerValue]),
                              @"endDate": self.end_Time.text,
                              @"professionalId": @([_proID integerValue]),
                              @"resumeId": @([self.resumeID integerValue]),
                              @"schoolId": @([_collID integerValue]),//****
                              @"startDate": self.Start_time.text,
                              @"professinalName":self.text_Pro.text,//专业名称
                              @"schoolName":self.text_Coll.text//学校名称
                              };
        [AbilityNet requstAddEdu:dic withBlock:^(NSDictionary *successDicValue) {
            ResumeMo * mo = [[ResumeMo alloc] init];
            mo.collAndcompany = self.text_Coll.text;
            mo.proAndPro = self.text_Pro.text;
            mo.XLAndIntro = self.text_XL.text;
            mo.satrtTime = self.Start_time.text;
            mo.endTime = self.end_Time.text;
            self.block(mo);
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    }else{
        [YTAlertUtil showTempInfo:@"删除按钮"];
    }
    
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
        SortCollProController * sort = [SortCollProController new];
        sort.title = @"专业";
        sort.url = dictionaryProfessional;
        sort.block = ^(ShoolOREduMo *mo) {
            self.text_Pro.text = mo.name;
            _proID = mo.ID;
        };
        [self.navigationController pushViewController:sort animated:YES];
//        EditAllController * edit = [EditAllController new];
//        edit.block = ^(NSString * str){
//            sender.tag==2?(self.text_Pro.text = str):(self.text_Coll.text=str);
//        };
//        [self.navigationController pushViewController:edit animated:YES];
    }
    else if (sender.tag==3) {
        NSMutableArray * title = [NSMutableArray array];
        for (int i=0; i<self.eduArr.count; i++) {
            [title addObject:self.eduArr[i][@"description"]];
        }
        [YTAlertUtil alertMultiWithTitle:nil message:nil style:UIAlertControllerStyleActionSheet multiTitles:title multiHandler:^(UIAlertAction *action, NSArray *titles, NSUInteger idx) {
            self.text_XL.text = title[idx];
            _EduID = self.eduArr[idx][@"value"];
        } cancelTitle:@"取消" cancelHandler:^(UIAlertAction *action) {
            
        } completion:nil];
    }
    else{
        currtenTag = sender.tag;
        [self.myDatePick animateShow];
    }
}
-(void)setUI{
    self.textView_Indro.placeholder = @"请输入工作描述";
    self.textView_Indro.placeholderColor = [UIColor hexColorWithString:@"#bbbbbb"];
    
    [self initDate];
}
#pragma mark ---LCDatePickerDelegate-----
- (void)lcDatePickerViewWithPickerView:(LCDatePicker *)picker str:(NSString *)str {
    UITextField * text = (UITextField *)[self.view viewWithTag:currtenTag+6];
    text.text = str;
}
//创建日期插件
-(void)initDate{
    self.myDatePick = [[LCDatePicker alloc] initWithFrame:kScreen];
    self.myDatePick.delegate  = self;
    [self.view addSubview:self.myDatePick];
}
-(void)textViewDidChange:(UITextView *)textView{
    //首行缩进
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3;    //行间距
    //    paragraphStyle.maximumLineHeight = 60;   /**最大行高*/
    paragraphStyle.firstLineHeadIndent = 20.f;    /**首行缩进宽度*/
    paragraphStyle.alignment = NSTextAlignmentJustified;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 ,NSForegroundColorAttributeName:[UIColor hexColorWithString:@"#bbbbbb"]};
    self.textView_Indro.attributedText = [[NSAttributedString alloc] initWithString:self.textView_Indro.text attributes:attributes];
}
@end

