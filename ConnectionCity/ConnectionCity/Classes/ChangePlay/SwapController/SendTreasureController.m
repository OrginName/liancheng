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
@interface SendTreasureController ()<PhotoSelectDelegate>
{
    CGFloat itemHeigth;
    UIButton * _tmpBtn;
}
@property (weak, nonatomic) IBOutlet UIButton *btn_YJH;
@property (weak, nonatomic) IBOutlet UIButton *btn_HZW;
@property (nonatomic,strong)PhotoSelect * photo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_photoSelect;
@property (weak, nonatomic) IBOutlet UIView *view_PhotoSelect;
@property (nonatomic,strong) NSMutableArray * Arr_Url;//选择的图片路径
@end

@implementation SendTreasureController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
#pragma mark --- 各种按钮点击------
-(void)Upload{
    [YTAlertUtil showTempInfo:@"发布"];
    
}
-(void)sendData:(NSDictionary *)dic{
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
- (IBAction)changStatusClick:(UIButton *)sender {
    if (sender.tag!=3) {
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
-(void)setUI{
    self.navigationItem.title = @"发布互换信息";
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
