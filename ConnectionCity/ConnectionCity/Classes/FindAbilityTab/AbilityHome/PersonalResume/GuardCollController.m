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
@interface GuardCollController ()<UITextViewDelegate,LCDatePickerDelegate>
{
    NSInteger  currentTag;
}
@property (nonatomic,strong) LCDatePicker * myDatePick;
@property (weak, nonatomic) IBOutlet CustomtextView *textView_Indro;
@property (weak, nonatomic) IBOutlet UIButton *bttn_Save;
@property (weak, nonatomic) IBOutlet UITextField *txt_Company;
@property (weak, nonatomic) IBOutlet UITextField *txt_pro;
@property (weak, nonatomic) IBOutlet UITextField *end_Time;
@property (weak, nonatomic) IBOutlet UITextField *start_time;
@end

@implementation GuardCollController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
- (IBAction)btn_Save:(UIButton *)sender {
    if (self.txt_Company.text.length==0||self.txt_pro.text.length==0||self.textView_Indro.text.length==0||self.start_time.text.length==02||self.end_Time.text.length==0) {
        [YTAlertUtil showTempInfo:@"请查看是否输入完整"];
        return;
    }
    NSDictionary * dic = @{
                           @"companyName": @"string",
                           @"description": @"string",
                           @"endDate": @"2018-06-22T07:00:16.968Z",
                           @"occupationCategoryId": @0,
                           @"resumeId": @0,
                           @"startDate": @"2018-06-22T07:00:16.968Z"
                           };
    [AbilityNet requstAddWord:dic withBlock:^(NSMutableArray *successArrValue) {
        
    }];
    ResumeMo * mo = [[ResumeMo alloc] init];
    mo.collAndcompany = self.txt_Company.text;
    mo.proAndPro = self.txt_pro.text;
    mo.XLAndIntro = self.textView_Indro.text;
    mo.satrtTime = self.start_time.text;
    mo.endTime = self.end_Time.text;
    self.block(mo);
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btn_Click:(UIButton *)sender {
    if (sender.tag<3) {
        NSArray * arr = @[self.txt_Company,self.txt_pro];
        EditAllController * edit = [EditAllController new];
        edit.block = ^(NSString * str){
            UITextField * text = (UITextField *)arr[sender.tag-1];
            text.text = str;
        };
        [self.navigationController pushViewController:edit animated:YES];
    }else{
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
