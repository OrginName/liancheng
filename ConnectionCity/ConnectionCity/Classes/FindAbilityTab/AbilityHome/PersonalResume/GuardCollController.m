//
//  GuardEduAndCollController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/13.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "GuardCollController.h"
#import "LCDatePicker.h"
#import "EditAllController.h"
#import "AbilityNet.h"
#import "ClassificationsController.h"
@interface GuardCollController ()<UITextViewDelegate,LCDatePickerDelegate>
{
    NSInteger  currentTag;
    NSString * _proID;
}
@property (nonatomic,strong) LCDatePicker * myDatePick;
@property (weak, nonatomic) IBOutlet CustomtextView *textView_Indro;
@property (weak, nonatomic) IBOutlet UIButton *bttn_Save;
@property (weak, nonatomic) IBOutlet UITextField *txt_Company;
@property (weak, nonatomic) IBOutlet UITextField *txt_pro;
@property (weak, nonatomic) IBOutlet UITextField *end_Time;
@property (weak, nonatomic) IBOutlet UITextField *start_time;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout;
@property (nonatomic,strong) NSMutableArray * arr_Class;
@end

@implementation GuardCollController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self initData];
    [self setMo:self.mo];
}
-(void)setMo:(ResumeMo *)mo{
    _mo = mo;
    if (self.mo!=nil) {
        self.txt_Company.text = mo.collAndcompany;
        self.txt_pro.text = mo.proAndPro;
        self.start_time.text = mo.satrtTime;
        self.end_Time.text = mo.endTime;
        self.textView_Indro.text = @"暂无";
        self.layout.constant = (kScreenWidth-20)/2;
    }
}
-(void)initData{
    _proID = @"";
    //    加载分类数据
    [AbilityNet requstAbilityClass:^(NSMutableArray *successArrValue) {
        self.arr_Class = successArrValue;
    }];
}
- (IBAction)btn_SelectProfess:(UIButton *)sender {
    ClassificationsController * class = [ClassificationsController new];
    class.title = @"职业分类";
    class.arr_Data = self.arr_Class;
    class.block = ^(NSString *classifiation){
    };
    class.block1 = ^(NSString *classifiationID, NSString *classifiation) {
        self.txt_pro.text = classifiation;
        _proID = classifiationID;
    };
    [self.navigationController pushViewController:class animated:YES];
    
}
- (IBAction)btn_Save:(UIButton *)sender {
    if (sender.tag==30) {
        if (self.txt_Company.text.length==0||self.txt_pro.text.length==0||self.textView_Indro.text.length==0||self.start_time.text.length==02||self.end_Time.text.length==0) {
            [YTAlertUtil showTempInfo:@"请查看是否输入完整"];
            return;
        }
        if ([YSTools initTimerCompare:self.start_time.text withEndTime:self.end_Time.text]!=2) {
            [YTAlertUtil showTempInfo:@"结束日期不能小于开始日期"];
            return;
        }
        NSDictionary * dic = @{
                               @"companyName": self.txt_Company.text,
                               @"description": self.textView_Indro.text,
                               @"endDate": self.start_time.text,
                               @"occupationCategoryId": @([_proID integerValue]),
                               @"resumeId": @([self.resumeID integerValue]),
                               @"startDate": self.end_Time.text
                               };
        if (self.mo!=nil) {
            [YSNetworkTool POST:v1TalentResumeWorkUpdate params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
                [self reloadData:2];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
        }else{
            [AbilityNet requstAddWord:dic withBlock:^(NSDictionary *successArrValue) {
                [self reloadData:1];
            }];
        }
    }else{
        [YSNetworkTool POST:v1TalentResumeWorkDelete params:@{@"id":self.mo.ID} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            self.block2();
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
}
-(void)reloadData:(int)a{
    ResumeMo * mo = [[ResumeMo alloc] init];
    mo.collAndcompany = self.txt_Company.text;
    mo.proAndPro = self.txt_pro.text;
    mo.XLAndIntro = self.textView_Indro.text;
    mo.satrtTime = self.start_time.text;
    mo.endTime = self.end_Time.text;
    a==1?self.block(mo):self.block1(mo);
    [self.navigationController popViewControllerAnimated:YES];
    [YTAlertUtil showTempInfo:@"操作成功"];
}
- (IBAction)btn_Click:(UIButton *)sender {
    if (sender.tag==1) {
        NSArray * arr = @[self.txt_Company,self.txt_pro];
        EditAllController * edit = [EditAllController new];
        edit.block = ^(NSString * str){
            UITextField * text = (UITextField *)arr[sender.tag-1];
            text.text = str;
        };
        [self.navigationController pushViewController:edit animated:YES];
    }else if(sender.tag==3||sender.tag==4){
        currentTag = sender.tag;
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
    UITextField * text = (UITextField *)[self.view viewWithTag:currentTag+5];
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
