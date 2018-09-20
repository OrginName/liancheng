//
//  KissDetailController.m
//  ConnectionCity
//
//  Created by qt on 2018/8/19.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "KissDetailController.h"
#import "KissUpdateController.h"
#import <PGDatePicker/PGDatePickManager.h>
#import "NSDate+Extend.h"
@interface KissDetailController ()<PGDatePickerDelegate>
{
    UIButton * _tmpBtn;
}
@property (weak, nonatomic) IBOutlet UIView *view_date;
@property (weak, nonatomic) IBOutlet UICollectionView *collec_Bottom;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIView *view_line;
@property (weak, nonatomic) IBOutlet UILabel *lab_nickName;//昵称
@property (weak, nonatomic) IBOutlet UILabel *lab_todayMoney;
@property (weak, nonatomic) IBOutlet UILabel *lab_monthMoney;
@property (weak, nonatomic) IBOutlet UILabel *lab_yearMoney;
@property (weak, nonatomic) IBOutlet UITextField *txt_date;
@property (weak, nonatomic) IBOutlet UIButton *btn_Update;
@property (nonatomic,strong) KissModel * modelReceive;
@end

@implementation KissDetailController
- (void)viewDidLoad {
    self.myList = self.collec_Bottom;
    [super viewDidLoad];
    [self setUI];
    _tmpBtn = self.btn1;
    [self initData];
    if (!self.flag) {
        self.btn_Update.hidden = YES;
    }
}
-(void)initData{
    self.txt_date.text = [NSDate stringDate:[NSDate date]];
    WeakSelf
    [YSNetworkTool POST:v1UserCloseAccountGet params:@{@"id": @([self.ID intValue])} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        weakSelf.modelReceive = [KissModel mj_objectWithKeyValues:responseObject[kData]];
        weakSelf.lab_nickName.text = weakSelf.modelReceive.user.nickName?weakSelf.modelReceive.user.nickName:KString(@"用户%@", weakSelf.modelReceive.user.ID);
    } failure:nil];
    [YSNetworkTool POST:v1UserCloseAccountBillStatistics params:@{@"id": @([self.ID intValue])} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.lab_todayMoney.text = KString(@"累计%.3f元", [responseObject[kData][@"todayAmount"] floatValue]);
            weakSelf.lab_yearMoney.text = KString(@"累计%.3f元", [responseObject[kData][@"yearAmount"] floatValue]);
            weakSelf.lab_monthMoney.text = KString(@"累计%.3f元", [responseObject[kData][@"monthAmount"] floatValue]);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

    }];
    [self loadLS];
} 
/**
 加载账户流水数据
 */
-(void)loadLS{
    NSString * url = _tmpBtn.tag==1?v1usercloseaccountbilldate:_tmpBtn.tag==2?v1usercloseaccountbillmonth:v1usercloseaccountbillyear;
    NSString * key = _tmpBtn.tag==1?@"day":_tmpBtn.tag==2?@"month":@"year";
    [YSNetworkTool POST:url params:@{key:self.txt_date.text,@"id": @([self.ID intValue])} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary * dic1 = responseObject[kData];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@1 forKey:@"lockColumn"];
        NSArray *data = @[@[@"连程号",@"比例",@"收入"]
                          ,@[dic1[@"closeUserId"],KString(@"%.1f%%", [dic1[@"rate"] floatValue]*100),KString(@"%.3f", [[dic1[@"incomeAmount"] description] floatValue])]
                          ];
        [dic setObject:data forKey:@"data"];
        [self updateMyList:dic withColumnWidths:@[@3,@3,@3]];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (IBAction)btn_Update:(UIButton *)sender {
    KissUpdateController * kiss = [KissUpdateController new];
    kiss.title = @"账户修改";
    kiss.model = self.modelReceive;
    [self.navigationController pushViewController:kiss animated:YES];
}
//日期选择
- (IBAction)dateSelect:(UIButton *)sender {
    [self tanDatePick:_tmpBtn.tag==1?PGDatePickerModeDate:_tmpBtn.tag==2?PGDatePickerModeYearAndMonth:PGDatePickerModeYear];
}
//首页三个按钮点击选中方法
- (IBAction)btn_selected:(UIButton *)sender {
    if (sender.tag!=1) {
        self.btn1.selected = NO;
    }
    if (_tmpBtn == nil){
        sender.selected = YES;
        _tmpBtn = sender;
    }
    else  if (_tmpBtn !=nil &&_tmpBtn == sender){
        sender.selected = YES;
    } else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.view_line.x = sender.x;
    }];
    NSString * currentTime = [NSDate stringDate:[NSDate date]];
    NSArray * arr = [currentTime componentsSeparatedByString:@"-"];
    self.txt_date.text = _tmpBtn.tag==1?currentTime:_tmpBtn.tag==2?[NSString stringWithFormat:@"%@-%@",arr[0],arr[1]]:KString(@"%@", arr[0]);
    [self loadLS];
}
#pragma mark ---- PGDatePickerDelegate-----
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %ld", (long)dateComponents.year);
    NSString * str = [NSString stringWithFormat:@"%ld-%@%ld-%@%ld",(long)dateComponents.year,dateComponents.month<10?@"0":@"",(long)dateComponents.month,dateComponents.day<10?@"0":@"",(long)dateComponents.day];
    NSString * str1 = [NSString stringWithFormat:@"%ld-%@%ld",(long)dateComponents.year,dateComponents.month<10?@"0":@"",(long)dateComponents.month];
    self.txt_date.text = _tmpBtn.tag==1?str:_tmpBtn.tag==2?str1:KString(@"%ld",(long)dateComponents.year);
    [self loadLS];
}
-(void)setUI{
    self.view.backgroundColor = kCommonBGColor;
    self.view_date.layer.borderColor = YSColor(247, 247, 247).CGColor;
    self.view_date.layer.borderWidth = 1;
}
-(void)tanDatePick:(PGDatePickerMode) mode{
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    //设置半透明的背景颜色
    datePickManager.isShadeBackgroud = true;
    //设置头部的背景颜色
    datePickManager.headerViewBackgroundColor = YSColor(244, 177, 113);
    datePicker.datePickerMode = mode;
    //设置取消按钮的字体颜色
    datePickManager.cancelButtonTextColor = [UIColor whiteColor];
    datePickManager.confirmButtonTextColor = [UIColor whiteColor];
//    datePicker.datePickerType = PGDatePickerType2;
    datePicker.maximumDate = [NSDate date];
    datePicker.delegate = self;
    [self presentViewController:datePickManager animated:false completion:nil];
}
@end
