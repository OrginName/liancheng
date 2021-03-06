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
#import "QiniuUploader.h"
#import "CustomScro.h"
#import "AllDicMo.h"
#import "AgreementController.h"
@interface SendTripController ()<JFCityViewControllerDelegate,PhotoSelectDelegate,CustomScroDelegate>
{
    CGFloat itemHeigth;
    UIButton * _tmpBtn;
    NSString * _urlStr;
    NSInteger priceTag;
    NSArray * _arr;
}
@property (weak, nonatomic) IBOutlet UIButton *btn_GZ;
@property (nonatomic,strong) CustomScro * customScro;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_select;
@property (nonatomic,strong)NSMutableDictionary * dictionary;
@property (weak, nonatomic) IBOutlet UITextField *txt_Price;
@property (nonatomic,strong)PhotoSelect * photo;
@property (weak, nonatomic) IBOutlet UIView *view_Select;
@property (weak, nonatomic) IBOutlet UITextField *txt_City;
@property (weak, nonatomic) IBOutlet UITextField *txt_Des;
@property (weak, nonatomic) IBOutlet UIView *view_Btn;
@property (nonatomic,strong) NSMutableArray * Arr_Url;
@end

@implementation SendTripController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    self.dictionary = [NSMutableDictionary dictionary];
    self.Arr_Url = [NSMutableArray array];
    _arr = [[NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:KAllDic]][11] contentArr];
    NSMutableArray * arr1 = [NSMutableArray array];
    for (AllContentMo * mo in _arr) {
        [arr1 addObject:mo.description1];
    }
    CustomScro * customScro = [[CustomScro alloc] initWithFrame:CGRectMake(0, 0, self.view_Btn.width, self.view_Btn.height) arr:[arr1 copy] flag:YES];
    customScro.delegate = self;
    [self.view_Btn addSubview:customScro];
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
    if (!_tmpBtn.selected) {
        return [YTAlertUtil showTempInfo:@"请选择单位"];
    }
    if (!self.btn_GZ.selected) {
        return [YTAlertUtil showTempInfo:@"请阅读并同意软件使用规则"];
    }
    NSString * urlStr = @"";
    if (self.Arr_Url.count!=0) {
        for (int i=0; i<self.Arr_Url.count; i++) {
            urlStr = [NSString stringWithFormat:@"%@;%@",self.Arr_Url[i],urlStr];
        }
    }
    NSDictionary * dic = @{
                           @"cityCode": @([self.dictionary[@"cityCode"] floatValue]),
                           @"images": urlStr,
                           @"introduce": self.txt_Des.text,
                           @"lat": @([self.dictionary[@"lat"] floatValue]),
                           @"lng": @([self.dictionary[@"lng"] floatValue]),
                           @"price": @([self.txt_Price.text floatValue]),
                           @"type": @(priceTag)
                           };
    WeakSelf
    [YSNetworkTool POST:v1ServiceTravelCreate params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [YTAlertUtil showTempInfo:responseObject[@"message"]];
        if (weakSelf.block) {
            weakSelf.block();
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark -----CustomScroDelegate--------
- (void)CustomScroBtnClick:(UIButton *)tag{
    if (_tmpBtn == nil){
        tag.selected = YES;
        _tmpBtn = tag;
    }
    if (_tmpBtn !=nil &&_tmpBtn == tag){
        tag.selected = YES;
    } else if (_tmpBtn!= tag && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        tag.selected = YES;
        _tmpBtn = tag;
    }
    AllContentMo * mo = _arr[tag.tag-1];
    priceTag = [[mo.value description] integerValue];
} //声明协议方法
//选择所在城市
- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag==4) {
        JFCityViewController * jf= [JFCityViewController new];
        jf.delegate = self;
        BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:jf];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }else{
        EditAllController * edit = [EditAllController new];
        if (sender.tag==5) {
            edit.receiveTxt = self.txt_Des.text;
        }else
            edit.receiveTxt = self.txt_Price.text;
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
-(void)city:(NSString *)name ID:(NSString *)ID lat:(NSString *)lat lng:(NSString *)lng{
    self.txt_City.text = name;
    [self.dictionary setValue:ID forKey:@"cityCode"];
    [self.dictionary setValue:lat forKey:@"lat"];
    [self.dictionary setValue:lng forKey:@"lng"];
}
//- (IBAction)btn_priceSelect:(UIButton *)sender {
//    if (sender.tag!=1) {
//        UIButton * btn = (UIButton *)[self.view_Btn viewWithTag:1];
//        btn.selected = NO;
//    }
//    priceTag=sender.tag==1?10:sender.tag==2?20:sender.tag==3?30:10;
//    if (_tmpBtn == nil){
//        sender.selected = YES;
//        _tmpBtn = sender;
//    }
//    if (_tmpBtn !=nil &&_tmpBtn == sender){
//        sender.selected = YES;
//    } else if (_tmpBtn!= sender && _tmpBtn!=nil){
//        _tmpBtn.selected = NO;
//        sender.selected = YES;
//        _tmpBtn = sender;
//    }
//}
-(void)setUI{
    self.navigationItem.title = @"发布陪游";
    itemHeigth = (kScreenWidth-70) / 4+10;
    self.photo = [[PhotoSelect alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, itemHeigth) withController:self];
    self.photo.backgroundColor = [UIColor whiteColor];
    self.photo.PhotoDelegate = self;
    self.photo.allowTakeVideo = NO;
    self.layout_select.constant = itemHeigth;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(complete) image:@"" title:@"完成" EdgeInsets:UIEdgeInsetsZero];
    [self.view_Select addSubview:self.photo];
}

#pragma mark ----PhotoSelectDelegate-----
-(void)selectImageArr:(NSArray *)imageArr{
    NSLog(@"%lu",(unsigned long)imageArr.count);
    __block int flag=0;
    if (imageArr.count>=4) {
        self.photo.height=self.layout_select.constant= itemHeigth*2;
    }
    [YTAlertUtil showHUDWithTitle:@"正在上传"];
    for (int i=0; i<imageArr.count; i++) {
        [[QiniuUploader defaultUploader] uploadImageToQNFilePath:imageArr[i] withBlock:^(NSDictionary *url) {
            flag++;
            [self.Arr_Url addObject:[NSString stringWithFormat:@"%@%@",QINIUURL,url[@"hash"]]];
            if (flag == imageArr.count) {
                [YTAlertUtil hideHUD];
            }
        }];
    }
}
-(void)selectImage:(UIImage *) image arr:(NSArray *)imageArr{
    if (imageArr.count>=4) {
        self.photo.height=self.layout_select.constant= itemHeigth*2;
    }
    [YTAlertUtil showHUDWithTitle:@"正在上传"];
    [[QiniuUploader defaultUploader] uploadImageToQNFilePath:image withBlock:^(NSDictionary *url) {
        [YTAlertUtil hideHUD];
        [self.Arr_Url addObject:[NSString stringWithFormat:@"%@%@",QINIUURL,url[@"hash"]]];
    }];
}
-(void)deleteImage:(NSInteger) tag arr:(NSArray *)imageArr{
    if (imageArr.count<=4) {
        self.photo.height=self.layout_select.constant= itemHeigth;
    }
    [self.Arr_Url removeObjectAtIndex:tag];
}
- (IBAction)btn_GZS:(UIButton *)sender {
    if (sender.tag==1000) {
        sender.selected = !sender.selected;
    }else{
        AgreementController *agreementVC = [[AgreementController alloc]init];
        agreementVC.alias = serviceAgreement;
        [self.navigationController pushViewController:agreementVC animated:YES];
    }
}
@end
