//
//  SendMomentController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "SendMomentController.h"
#import "PhotoSelect.h"
@interface SendMomentController ()<PhotoSelectDelegate>
{
    CGFloat itemHeigth;
}
@property (weak, nonatomic) IBOutlet CustomtextView *txt_Moment;
@property (weak, nonatomic) IBOutlet UIView *view_Photo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_photoSlect;
@property (nonatomic,strong)PhotoSelect * photo;

@end

@implementation SendMomentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
//完成
-(void)complete{
    [YTAlertUtil showTempInfo:@"发布"];
}
-(void)setUI{
    self.txt_Moment.placeholder = @"   对圈子内的朋友说点什么...";
    self.txt_Moment.placeholderColor = YSColor(182, 182, 182);
    self.navigationItem.title = @"服务圈";
    itemHeigth = (self.view_Photo.width - 50) / 4+10;
    self.photo = [[PhotoSelect alloc] initWithFrame:CGRectMake(0, 0, self.view_Photo.width, itemHeigth) withController:self];
    self.photo.backgroundColor = [UIColor whiteColor];
    self.photo.PhotoDelegate = self;
    [self.view_Photo addSubview:self.photo];
    self.layout_photoSlect.constant = itemHeigth;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(complete) image:@"" title:@"完成" EdgeInsets:UIEdgeInsetsZero];
}
#pragma mark ----PhotoSelectDelegate-----
-(void)selectImageArr:(NSArray *)imageArr{
    NSLog(@"%lu",(unsigned long)imageArr.count);
    if (imageArr.count>4) {
        self.photo.height=self.layout_photoSlect.constant = itemHeigth*2;
        
    }
}

@end
