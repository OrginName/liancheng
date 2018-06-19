//
//  SendTripController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/31.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "SendTripController.h"
#import "PhotoSelect.h"
#import "JFCityViewController.h"
#import "EditAllController.h"
@interface SendTripController ()<JFCityViewControllerDelegate,PhotoSelectDelegate>
{
    CGFloat itemHeigth;
    UIButton * _tmpBtn;
    NSString * _urlStr;
    NSInteger priceTag;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_select;
@property (nonatomic,strong)NSMutableDictionary * dictionary;
@property (weak, nonatomic) IBOutlet UITextField *txt_Price;
@property (nonatomic,strong)PhotoSelect * photo;
@property (weak, nonatomic) IBOutlet UIView *view_Select;
@property (weak, nonatomic) IBOutlet UITextField *txt_City;
@property (weak, nonatomic) IBOutlet UITextField *txt_Des;
@property (weak, nonatomic) IBOutlet UIView *view_Btn;
@end

@implementation SendTripController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    self.dictionary = [NSMutableDictionary dictionary];
    priceTag = 10;
}
//完成
-(void)complete{
    if (self.txt_City.text.length==0) {
        [YTAlertUtil showTempInfo:@"请选择所在地区"];
        return;
    }
    if (self.txt_Des.text.length==0) {
        [YTAlertUtil showTempInfo:@"请输入陪游介绍"];
        return;
    }
    if (self.txt_Price.text.length==0) {
        [YTAlertUtil showTempInfo:@"请输入陪游价格"];
        return;
    }
    NSDictionary * dic = @{
                           @"cityCode": @([self.dictionary[@"cityCode"] floatValue]),
                           @"images": _urlStr,
                           @"introduce": self.txt_Des.text,
                           @"lat": @([self.dictionary[@"lat"] floatValue]),
                           @"lng": @([self.dictionary[@"lng"] floatValue]),
                           @"price": @([self.txt_Price.text floatValue]),
                           @"type": @(priceTag)
                           };
    [YSNetworkTool POST:v1ServiceTravelCreate params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
        [YTAlertUtil showTempInfo:responseObject[@"message"]];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
//选择所在城市
- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag==4) {
        JFCityViewController * jf= [JFCityViewController new];
        jf.delegate = self;
        BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:jf];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }else{
        EditAllController * edit = [EditAllController new];
        edit.block = ^(NSString *EditStr) {
            if (sender.tag==5) {
                self.txt_Des.text = EditStr;
            }else{
                self.txt_Price.text = EditStr;
            }
        };
        [self.navigationController pushViewController:edit animated:YES];
    }
}
#pragma mark -----JFCityViewControllerDelegate----
-(void)cityMo:(CityMo *)mo{
    self.txt_City.text = mo.fullName;
    [self.dictionary setValue:mo.ID forKey:@"cityCode"];
    [self.dictionary setValue:mo.lat forKey:@"lat"];
    [self.dictionary setValue:mo.lng forKey:@"lng"];
}
- (IBAction)btn_priceSelect:(UIButton *)sender {
    if (sender.tag!=1) {
        UIButton * btn = (UIButton *)[self.view_Btn viewWithTag:1];
        btn.selected = NO;
    }
    priceTag=sender.tag==1?10:sender.tag==2?20:sender.tag==3?30:10;
    if (_tmpBtn == nil){
        sender.selected = YES;
        _tmpBtn = sender;
    }
    if (_tmpBtn !=nil &&_tmpBtn == sender){
        sender.selected = YES;
    } else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
    }
}
-(void)setUI{
    self.navigationItem.title = @"发布陪游";
    itemHeigth = (kScreenWidth-70) / 4+10;
    self.photo = [[PhotoSelect alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, itemHeigth) withController:self];
    self.photo.backgroundColor = [UIColor whiteColor];
    self.photo.PhotoDelegate = self;
    self.layout_select.constant = itemHeigth;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(complete) image:@"" title:@"完成" EdgeInsets:UIEdgeInsetsZero];
    [self.view_Select addSubview:self.photo];
}
#pragma mark ----PhotoSelectDelegate-----
-(void)selectImageArr:(NSArray *)imageArr{
    NSLog(@"%lu",(unsigned long)imageArr.count);
    if (imageArr.count>4) {
        self.photo.height=self.layout_select.constant= itemHeigth*2; 
    }
    _urlStr =@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1977804817,1381775671&fm=200&gp=0.jpg;https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528544357416&di=e79bd79f86eea467f4fca6a5bfe35d7d&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimage%2Fc0%253Dshijue1%252C0%252C0%252C294%252C40%2Fsign%3D0392a2bf17950a7b6138468762b808ac%2F03087bf40ad162d9bd499b951bdfa9ec8b13cd90.jpg";
}
@end
