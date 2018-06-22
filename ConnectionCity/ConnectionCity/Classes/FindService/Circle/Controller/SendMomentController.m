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
    NSDictionary * dic = @{
                           @"areaCode":@([[KUserDefults objectForKey:kUserCityID]integerValue]),
                           @"cityCode": @([[KUserDefults objectForKey:kUserCityID]integerValue]),
                           @"containsImage": @1,
                           @"containsVideo": @1,
                           @"content": self.txt_Moment.text,
                           @"images": @"http://img5.imgtn.bdimg.com/it/u=974328080,785294559&fm=27&gp=0.jpg;http://img4.imgtn.bdimg.com/it/u=3947090186,1008283992&fm=27&gp=0.jpg",
                           @"videos": @"http://mp4.vjshi.com/2018-02-23/5e982007de347d14152cc722cdc7fb2d.mp4;http://mp4.vjshi.com/2014-10-03/1412345605895_747.mp4"
                           };
    [YSNetworkTool POST:v1ServiceCircleCreate params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        self.block();
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
-(void)setUI{
    self.txt_Moment.placeholder = @"   对圈子内的朋友说点什么...";
    self.txt_Moment.placeholderColor = YSColor(182, 182, 182);
    self.navigationItem.title = @"服务圈";
    itemHeigth = (self.view_Photo.width - 50) / 4+10;
    self.photo = [[PhotoSelect alloc] initWithFrame:CGRectMake(0, 0, self.view_Photo.width, itemHeigth) withController:self];
    self.photo.allowPickingVideoSwitch = YES;
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
