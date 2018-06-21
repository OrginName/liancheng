//
//  CreatGroupController.m
//  ConnectionCity
//
//  Created by qt on 2018/6/21.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "CreatGroupController.h"
#import "ClassificationsController.h"
#import "EditAllController.h"
#import "TakePhoto.h"
#import "ServiceHomeNet.h"
@interface CreatGroupController ()
{
    NSString * _ID;//服务ID
}
@property (weak, nonatomic) IBOutlet UITextField *txt_name;
@property (weak, nonatomic) IBOutlet UITextField *txt_class;
@property (weak, nonatomic) IBOutlet UITextField *txt_Notice;
@property (nonatomic,strong)NSMutableArray * Arr_Classify;
@end

@implementation CreatGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建服务站";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(Complete) image:nil title:@"完成" EdgeInsets:UIEdgeInsetsZero];
    [self initData];
}
//完成按钮
-(void)Complete{
    if (self.txt_name.text.length==0) {
        [YTAlertUtil showTempInfo:@"请输入服务站名称"];
        return;
    }
    if (self.txt_class.text.length==0) {
        [YTAlertUtil showTempInfo:@"请选择服务类别"];
        return;
    }
    if (self.txt_Notice.text.length==0) {
        [YTAlertUtil showTempInfo:@"请输入服务站公告"];
        return;
    }
    NSDictionary * dic = @{
                           @"areaCode": @([[KUserDefults objectForKey:kUserCityID] integerValue]),
                           @"lat": @([[KUserDefults objectForKey:kLat] floatValue]),
                           @"lng": @([[KUserDefults objectForKey:KLng] floatValue]),
                           @"logo": @"",
                           @"name": self.txt_name.text,
                           @"type": _ID
                           };
    [YSNetworkTool POST:v1ServiceStationCreate params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        self.block();
        [self.navigationController popViewControllerAnimated:YES];
        [YTAlertUtil showTempInfo:responseObject[@"message"]];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
-(void)initData{
    //服务类别列表
    [ServiceHomeNet requstServiceClass:^(NSMutableArray *successArrValue) {
        self.Arr_Classify = successArrValue;
    }];
}
- (IBAction)Btnclick:(UIButton *)sender {
    if (sender.tag==3) {
        ClassificationsController * class = [ClassificationsController new];
        class.arr_Data = self.Arr_Classify;
        class.block1 = ^(NSString *classifiationID, NSString *classifiation) {
            self.txt_class.text = classifiation;
            _ID = classifiationID;
        };
        class.block = ^(NSString *classifiation) {
            
        };
        [self.navigationController pushViewController:class animated:YES];
    }else if (sender.tag==1) {
        [[TakePhoto sharedPhoto] sharePicture:^(UIImage *image) {
            [sender setBackgroundImage:image forState:UIControlStateNormal];
        }];
    }else{
        EditAllController * edit = [EditAllController new];
        edit.block = ^(NSString *EditStr) {
            if (sender.tag==2) {
                self.txt_name.text = EditStr;
            }else
                self.txt_Notice.text = EditStr;
        };
        [self.navigationController pushViewController:edit animated:YES];
    }
}
@end
