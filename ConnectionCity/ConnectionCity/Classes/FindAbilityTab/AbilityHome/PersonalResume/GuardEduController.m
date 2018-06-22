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
@interface GuardEduController ()<UITextViewDelegate,LCDatePickerDelegate>
{
    NSInteger currtenTag;
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
}
//保存按钮点击
- (IBAction)btn_Save:(UIButton *)sender {
    if (self.text_Coll.text.length==0||self.text_Pro.text.length==0||self.text_XL.text.length==0||self.Start_time.text.length==02||self.end_Time.text.length==0) {
        [YTAlertUtil showTempInfo:@"请查看是否输入完整"];
        return;
    }
    ResumeMo * mo = [[ResumeMo alloc] init];
    mo.collAndcompany = self.text_Coll.text;
    mo.proAndPro = self.text_Pro.text;
    mo.XLAndIntro = self.text_XL.text;
    mo.satrtTime = self.Start_time.text;
    mo.endTime = self.end_Time.text;
    self.block(mo);
    [self.navigationController popViewControllerAnimated:YES];
}
//各个编辑按钮点击
- (IBAction)btn_Click:(UIButton *)sender {
    NSArray * arr = @[self.text_Coll,self.text_Pro,self.text_XL];
    if (sender.tag<4) {
        EditAllController * edit = [EditAllController new];
        edit.block = ^(NSString * str){
            UITextField * text = (UITextField *)arr[sender.tag-1];
            text.text = str;
        };
        [self.navigationController pushViewController:edit animated:YES];
    }else{
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

