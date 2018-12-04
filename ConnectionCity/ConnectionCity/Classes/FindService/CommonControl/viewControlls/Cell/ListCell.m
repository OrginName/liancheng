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
    self.lab_JL.text = KString(@"%@km", mom.distance);
    self.Arr = [NSMutableArray arrayWithArray:@[self.image1,self.image2,self.iamge3]];
    NSArray * imageArr = [mom.images componentsSeparatedByString:@";"];
    for (int i=0; i<self.Arr.count; i++) {
        if ([imageArr[i] length]!=0) { 
            [self.Arr[i] setHidden:NO];
            [self.Arr[i] sd_setImageWithURL:[NSURL URLWithString:KString(@"%@", imageArr[i])] placeholderImage:[UIImage imageNamed:@"logo2"]];
           
            [self.Arr[i] addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picClick:)]];
        }
    }
    self.lab_des.text = mom.content;
}
-(void)picClick:(UITapGestureRecognizer *)tap{
    NSArray * imageArr = [self.mom.images componentsSeparatedByString:@";"];
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
    [ServiceHomeNet requstServiceListJN:@{@"id":self.mom.userId} withSuc:^(UserMo *user) {
        
     }];
}
@end
