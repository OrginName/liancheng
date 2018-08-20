//
//  KissDetailController.m
//  ConnectionCity
//
//  Created by qt on 2018/8/19.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "KissDetailController.h"
#import "KissUpdateController.h"
@interface KissDetailController ()
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
@end

@implementation KissDetailController
- (void)viewDidLoad {
    self.myList = self.collec_Bottom;
    [super viewDidLoad];
    [self setUI];
    [self initData];
}
-(void)initData{
    WeakSelf
    [YSNetworkTool POST:v1usercloseaccountorderstatistics params:@{} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.lab_todayMoney.text = KString(@"累计%@元", responseObject[kData][@"todayAmount"]);
            weakSelf.lab_yearMoney.text = KString(@"累计%@元", responseObject[kData][@"yearAmount"]);;
            weakSelf.lab_monthMoney.text = KString(@"累计%@元", responseObject[kData][@"monthAmount"]);;
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (IBAction)btn_Update:(UIButton *)sender {
    KissUpdateController * kiss = [KissUpdateController new];
    kiss.title = @"账户修改";
    [self.navigationController pushViewController:kiss animated:YES];
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
}
-(void)setUI{
    self.view.backgroundColor = kCommonBGColor;
    self.view_date.layer.borderColor = YSColor(247, 247, 247).CGColor;
    self.view_date.layer.borderWidth = 1;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@1 forKey:@"lockColumn"];
    NSArray *data = @[@[@"连程号",@"比例",@"收入"]
                      ,@[@"100001",@"12%",@"100"]
                      ,@[@"100002",@"13%",@"1000"]
                      ,@[@"100002",@"14%",@"10000"]
                      
                      ];
    [dic setObject:data forKey:@"data"];
    [self updateMyList:dic withColumnWidths:@[@3,@3,@3]];
}
@end
