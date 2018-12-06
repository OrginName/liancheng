//
//  ListCell.m
//  ConnectionCity
//
//  Created by qt on 2018/11/24.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ListCell.h"
#import "YBImageBrowser.h"
#import "ServiceHomeNet.h"
@implementation ListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setMom:(Moment *)mom{
    _mom = mom;
    [self.img_head sd_setImageWithURL:[NSURL URLWithString:KString(@"%@?imageView2/1/w/100/h/100", mom.headImage)] placeholderImage:[UIImage imageNamed:@"logo2"]];
    self.lab_nickName.text = mom.nickName;
    self.lab_age.text = mom.age?mom.age:@"-";
    self.image_sex.image = [UIImage imageNamed:[mom.gender isEqualToString:@"1"]?@"men":@"women"];
    self.lab_JL.text = KString(@"%.2fkm", [mom.distance floatValue]);
    self.Arr = [NSMutableArray arrayWithArray:@[self.image1,self.image2,self.iamge3]];
    self.lab_time.hidden = YES;
    NSArray * imageArr = [mom.images componentsSeparatedByString:@";"];
    NSMutableArray * arr;
    if (imageArr.count<=3) {
        arr = [imageArr mutableCopy];
    }else
        arr = self.Arr;
    for (int i=0; i<arr.count; i++) {
        if ([imageArr[i] length]!=0) { 
            [self.Arr[i] setHidden:NO];
            [self.Arr[i] sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageArr[i],BIGTU]] placeholderImage:[UIImage imageNamed:@"logo2"]];
           
            [self.Arr[i] addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picClick:)]];
        }
    }
    self.lab_des.text = mom.content;
}
-(void)setMo:(CircleListMo *)mo{
    _mo = mo;
    [self.img_head sd_setImageWithURL:[NSURL URLWithString:KString(@"%@?imageView2/1/w/100/h/100", mo.headImage)] placeholderImage:[UIImage imageNamed:@"logo2"]];
    self.lab_nickName.text = mo.nickName;
    self.lab_JL.text = KString(@"%.2fkm", [mo.distance floatValue]);
    self.view_ageSex.hidden = YES;
    self.lab_time.text = [YSTools compareCurrentTime:mo.createTime];;
    self.Arr = [NSMutableArray arrayWithArray:@[self.image1,self.image2,self.iamge3]];
    NSArray * imageArr = [mo.images componentsSeparatedByString:@";"];
    NSMutableArray * arr;
    if (imageArr.count<=3) {
        arr = [imageArr mutableCopy];
    }else
        arr = self.Arr;
    for (int i=0; i<arr.count; i++) {
        if ([imageArr[i] length]!=0) {
            [self.Arr[i] setHidden:NO];
            [self.Arr[i] sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageArr[i],BIGTU]] placeholderImage:[UIImage imageNamed:@"logo2"]];
            
            [self.Arr[i] addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picClick:)]];
        }
    }
    self.lab_des.text = mo.content;
}
-(void)picClick:(UITapGestureRecognizer *)tap{
    NSArray * imageArr = [self.mom!=nil?self.mom.images:self.mo.images componentsSeparatedByString:@";"];
    NSMutableArray *browserDataArr = [NSMutableArray array];
    [imageArr enumerateObjectsUsingBlock:^(NSString *_Nonnull urlStr, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![YSTools dx_isNullOrNilWithObject:urlStr]&&idx<3) {
            YBImageBrowseCellData *data = [YBImageBrowseCellData new];
            data.url = [NSURL URLWithString:urlStr];
            data.sourceObject = self.Arr[idx];
            [browserDataArr addObject:data];
        }
    }];
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = browserDataArr;
    browser.currentIndex = tap.view.tag-1;
    [browser show];
}
- (IBAction)YY:(UIButton *)sender {
    WeakSelf
    [ServiceHomeNet requstServiceListJN:@{@"id":self.mom!=nil?self.mom.userId:self.mo.userId} withSuc:^(UserMo *user) {
        if (!user) {
            [YTAlertUtil showTempInfo:@"暂无服务"];
        }else{
            if (weakSelf.block) {
                weakSelf.block(self);
            } 
        }
     }];
}
- (IBAction)btn_ClikHead:(UIButton *)sender {
    if (self.headBlcok) {
        self.headBlcok(self);
    }
}
@end
