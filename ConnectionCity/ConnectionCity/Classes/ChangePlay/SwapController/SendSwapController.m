//
//  SendSwapController.m
//  ConnectionCity
//
//  Created by qt on 2018/5/22.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "SendSwapController.h"
#import "PhotoSelect.h"
#import "EditAllController.h"
#import "JFCityViewController.h"
#import "AllDicMo.h"
#import "ChangePlayNet.h"
#import "QiniuUploader.h"
@interface SendSwapController ()<PhotoSelectDelegate,JFCityViewControllerDelegate>
{
    CGFloat itemHeigth;
     NSString * cityID,* HHID;//城市ID 互换板块ID
}
@property (weak, nonatomic) IBOutlet UIView *view_Bottom;
@property (weak, nonatomic) IBOutlet UIView *view_PhotoSelect;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layou_Photo;
@property (weak, nonatomic) IBOutlet CustomtextView *textview_MS;
@property (weak, nonatomic) IBOutlet UITextField *txt_headTitle;
@property (weak, nonatomic) IBOutlet UITextField *txt_City;
@property (weak, nonatomic) IBOutlet UITextField *txt_HHBK;
@property (weak, nonatomic) IBOutlet UITextField *txt_Title;
@property (nonatomic,strong) NSMutableArray * Arr_Url;//选择的图片路径
@property (nonatomic,strong)PhotoSelect * photo;
@end

@implementation SendSwapController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    self.Arr_Url = [NSMutableArray array];
}
#pragma mark --- 发布提交Upload---
-(void)Upload{
    if ([YSTools dx_isNullOrNilWithObject:self.txt_HHBK.text]) {
        return [YTAlertUtil showTempInfo:@"请选择互换板块"];
    }
    if ([YSTools dx_isNullOrNilWithObject:self.txt_City.text]) {
        return [YTAlertUtil showTempInfo:@"请选择城市"];
    }
    if ([YSTools dx_isNullOrNilWithObject:self.txt_headTitle.text]) {
        return [YTAlertUtil showTempInfo:@"请输入互换标题"];
    }
    if ([YSTools dx_isNullOrNilWithObject:self.textview_MS.text]) {
        return [YTAlertUtil showTempInfo:@"请输入互换描述"];
    }
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
    NSDictionary * dic = @{
                           @"areaCode": @([cityID intValue]),
                           @"description": self.textview_MS.text,
                           @"images": url,
                           @"title": self.txt_Title.text,
                           @"type": @([HHID intValue])
                           };
    [ChangePlayNet requstSendHH:dic sucBlock:^(NSDictionary *successDicValue){
        [YTAlertUtil hideHUD];
        [self.navigationController popViewControllerAnimated:YES];
    } failBlock:^(NSError *failValue) {
        [YTAlertUtil hideHUD];
    }];
}
//所在地区 互换标题  互换板块 点击方法
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==1) {
        JFCityViewController * jf= [JFCityViewController new];
        jf.delegate = self;
        BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:jf];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }else if (textField.tag==2){
        NSArray * arr = [[NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:KAllDic]][2] contentArr];
        NSMutableArray * arr1 = [NSMutableArray array];
        for (AllContentMo * mo in arr) {
            [arr1 addObject:mo.description1];
        }
        WeakSelf
        [YTAlertUtil alertMultiWithTitle:nil message:nil style:UIAlertControllerStyleActionSheet multiTitles:arr1 multiHandler:^(UIAlertAction *action, NSArray *titles, NSUInteger idx) {
            AllContentMo * mo = arr[idx];
            weakSelf.txt_HHBK.text = mo.description1;
            HHID = mo.value;
        } cancelTitle:@"取消" cancelHandler:^(UIAlertAction *action) {
            
        } completion:nil];
    }else{
        EditAllController * edit = [EditAllController new];
        edit.receiveTxt = self.txt_headTitle.text;
        WeakSelf
        edit.block = ^(NSString * str){
            weakSelf.txt_headTitle.text = str;
        };
        [self.navigationController pushViewController:edit animated:YES];
    }
    return NO;
}

#pragma mark -----------JFCityViewControllerDelegate----------------
-(void)city:(NSString *)name ID:(NSString *)ID lat:(NSString *)lat lng:(NSString *)lng{
    self.txt_City.text = name;
    cityID = ID;
}
-(void)cityMo:(CityMo *)mo{
    self.txt_City.text = mo.name;
    cityID = mo.ID;
}
-(void)setUI{
    self.navigationItem.title = @"发布互换信息";
    itemHeigth = (self.view_PhotoSelect.width - 50) / 4+10;
    self.photo = [[PhotoSelect alloc] initWithFrame:CGRectMake(0, 0, self.view_PhotoSelect.width, itemHeigth) withController:self];
    self.photo.backgroundColor = [UIColor clearColor];
    self.layou_Photo.constant = itemHeigth+10;
    self.photo.PhotoDelegate = self;
    [self.view_PhotoSelect addSubview:self.photo];
    self.textview_MS.placeholder = @"请输入描述";
    self.textview_MS.placeholderColor = YSColor(213, 213, 213);
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(Upload) image:@"" title:@"提交" EdgeInsets:UIEdgeInsetsZero];
}
#pragma mark ----PhotoSelectDelegate-----
-(void)selectImageArr:(NSArray *)imageArr{
    NSLog(@"%lu",(unsigned long)imageArr.count);
    if (imageArr.count>4) {
        self.photo.height=self.layou_Photo.constant  = itemHeigth*2;
    }
    [self.Arr_Url addObjectsFromArray:imageArr];
}
-(void)selectImage:(UIImage *) image arr:(NSArray *)imageArr{
    if (imageArr.count>=4) {
        self.photo.height=self.layou_Photo.constant  = itemHeigth*2;
    }
    [self.Arr_Url addObjectsFromArray:imageArr];
}
-(void)deleteImage:(NSInteger) tag arr:(NSArray *)imageArr{
    if (imageArr.count<=4) {
        self.photo.height=self.layou_Photo.constant  = itemHeigth;
    }
    [self.Arr_Url removeObjectAtIndex:tag];
} 
@end
