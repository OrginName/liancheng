//
//  SendTreasureController.m
//  ConnectionCity
//
//  Created by qt on 2018/5/24.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "SendTreasureController.h"
#import "PhotoSelect.h"
#import "ChangePlayNet.h"
#import "QiniuUploader.h"
#import "ClassificationsController1.h"
@interface SendTreasureController ()<PhotoSelectDelegate>
{
    CGFloat itemHeigth;
    UIButton * _tmpBtn;
}
@property (weak, nonatomic) IBOutlet UITextField *txt_treName;//宝物名称
@property (weak, nonatomic) IBOutlet UITextField *txt_treClass;
@property (weak, nonatomic) IBOutlet UITextField *txt_treDes;
@property (weak, nonatomic) IBOutlet UITextField *txt_changeClass;
@property (weak, nonatomic) IBOutlet UITextField *txt_changeName;
@property (weak, nonatomic) IBOutlet UITextField *txt_changeYQ;
@property (weak, nonatomic) IBOutlet UIButton *btn_YJH;
@property (weak, nonatomic) IBOutlet UIButton *btn_HZW;
@property (weak, nonatomic) IBOutlet UIButton *btn_agree;
@property (nonatomic,strong)PhotoSelect * photo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_photoSelect;
@property (weak, nonatomic) IBOutlet UIView *view_PhotoSelect;
@property (nonatomic,strong) NSMutableArray * arr_receive;
@property (nonatomic,strong) NSMutableArray * Arr_Url;//选择的图片路径
@end
@implementation SendTreasureController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self initData];
}
#pragma mark --- 各种按钮点击------
-(void)Upload{
    [YTAlertUtil showTempInfo:@"发布"];
    __block NSInteger flag = 0;
    __block NSString * str = @"";//网址图片
    [YTAlertUtil showHUDWithTitle:@"正在发布"];
    if (self.Arr_Url.count!=0) {
        for (int i=0; i<self.Arr_Url.count; i++) {
            [[QiniuUploader defaultUploader] uploadImageToQNFilePath:self.Arr_Url[i] withBlock:^(NSDictionary *url) {
                flag++;
                str = [NSString stringWithFormat:@"%@%@;%@",QINIUURL,url[@"hash"],str];
                if (flag==self.Arr_Url.count) {
                    [self sendData:str];
                }
            }];
        }
    }else{
        [self sendData:@""];
    }
}
-(void)sendData:(NSString *)url{
    NSDictionary * dic1 = @{
                           @"areaCode": @0,
                           @"changeCategoryId": @0,
                           @"changeRequire": @"string",
                           @"changeTitle": @"string",
                           @"description": @"string",
                           @"images": @"string",
                           @"lat": @0,
                           @"lng": @0,
                           @"memo": @"string",
                           @"name": @"string",
                           @"treasureCategoryId": @0,
                           @"type": @0
                           };
    [ChangePlayNet requstSendBWClass:dic1 sucBlock:^(NSMutableArray *successArrValue) {
        
    } failBlock:^(NSString *failValue) {
        
    }];
}
//
- (IBAction)BtnClick:(UIButton *)sender {
    if (sender.tag==2) {
        ClassificationsController1 * class = [ClassificationsController1 new];
        class.title = @"宝物分类";
        class.arr_Data = self.arr_receive;
        class.block = ^(NSString *classifiation) {
            
        };
        class.block1 = ^(NSString *classifiation,NSString *classifiation1){
            
        };
        [self.navigationController pushViewController:class animated:YES];
    } 
}
- (IBAction)changStatusClick:(UIButton *)sender {
    if (sender.tag!=13) {
        self.btn_HZW.selected = NO;
        self.btn_YJH.layer.borderColor = YSColor(253, 210, 161).CGColor;
        self.btn_HZW.layer.borderColor =YSColor(247, 247, 247).CGColor;
    }
    if (_tmpBtn !=nil &&_tmpBtn == sender){
        sender.selected = YES;
        sender.layer.borderColor = YSColor(253, 210, 161).CGColor;
    } else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        _tmpBtn.layer.borderColor = YSColor(247, 247, 247).CGColor;
        sender.selected = YES;
        sender.layer.borderColor = YSColor(253, 210, 161).CGColor;
        _tmpBtn = sender;
    }
}
-(void)initData{
    WeakSelf
    [ChangePlayNet requstBWClass:^(NSMutableArray *successArrValue) {
        weakSelf.arr_receive = successArrValue;
    }];
}
-(void)setUI{
    self.navigationItem.title = @"发布宝物信息";
    itemHeigth = (self.view_PhotoSelect.width - 50) / 4+10;
    self.photo = [[PhotoSelect alloc] initWithFrame:CGRectMake(0, 0, self.view_PhotoSelect.width, itemHeigth) withController:self];
    self.photo.backgroundColor = [UIColor clearColor];
    self.layout_photoSelect.constant = itemHeigth+5;
    self.photo.PhotoDelegate = self;
    [self.view_PhotoSelect addSubview:self.photo];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(Upload) image:@"" title:@"发布" EdgeInsets:UIEdgeInsetsZero];
    self.btn_HZW.layer.borderColor = YSColor(253, 210, 161).CGColor;
    self.btn_YJH.layer.borderColor =YSColor(247, 247, 247).CGColor;
    self.btn_YJH.layer.borderWidth = self.btn_HZW.layer.borderWidth=1;
    _tmpBtn = self.btn_HZW;
    self.Arr_Url = [NSMutableArray array];
}
#pragma mark ----PhotoSelectDelegate-----
-(void)selectImageArr:(NSArray *)imageArr{
    NSLog(@"%lu",(unsigned long)imageArr.count);
    if (imageArr.count>4) {
        self.photo.height=self.layout_photoSelect.constant  = itemHeigth*2;
    }
    [self.Arr_Url addObjectsFromArray:imageArr];
}
-(void)selectImage:(UIImage *) image arr:(NSArray *)imageArr{
    if (imageArr.count>=4) {
        self.photo.height=self.layout_photoSelect.constant  = itemHeigth*2;
    }
    [self.Arr_Url addObjectsFromArray:imageArr];
}
-(void)deleteImage:(NSInteger) tag arr:(NSArray *)imageArr{
    if (imageArr.count<=4) {
       self.photo.height=self.layout_photoSelect.constant  = itemHeigth;
    }
    [self.Arr_Url removeObjectAtIndex:tag];
}
@end
