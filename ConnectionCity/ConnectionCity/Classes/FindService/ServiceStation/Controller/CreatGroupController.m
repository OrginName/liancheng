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
#import "QiniuUploader.h"
#import "AbilityNet.h"
@interface CreatGroupController ()
{
    NSString * _ID;//服务ID
}
@property (weak, nonatomic) IBOutlet UILabel *lab_name;
@property (weak, nonatomic) IBOutlet UILabel *lab_class;
@property (weak, nonatomic) IBOutlet UILabel *lab_notice;
@property (weak, nonatomic) IBOutlet UITextField *txt_name;
@property (weak, nonatomic) IBOutlet UITextField *txt_class;
@property (weak, nonatomic) IBOutlet UITextField *txt_Notice;
@property (nonatomic,copy) NSString * qun_Url;
@property (nonatomic,strong)NSMutableArray * Arr_Classify;
@end

@implementation CreatGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建服务站";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(Complete) image:nil title:@"完成" EdgeInsets:UIEdgeInsetsZero];
    [self initData];
    self.qun_Url = @"";
    [self setUI];
}
//完成按钮
-(void)Complete{
    if (self.txt_name.text.length==0) {
        [YTAlertUtil showTempInfo:self.flag_str==1?@"请输入团队名称":@"请输入服务站名称"];
        return;
    }
    if (self.txt_class.text.length==0) {
        [YTAlertUtil showTempInfo:self.flag_str==1?@"请选择职业分类":@"请选择服务类别"];
        return;
    }
    if (self.txt_Notice.text.length==0) {
        [YTAlertUtil showTempInfo:self.flag_str==1?@"请输入团队公告":@"请输入服务站公告"];
        return;
    }
    if (self.qun_Url.length==0) {
        [YTAlertUtil showHUDWithTitle:@"请上传群头像"];
    }
    NSDictionary * dic = @{
                           @"areaCode": @([[KUserDefults objectForKey:kUserCityID] integerValue]),
                           @"lat": @([[KUserDefults objectForKey:kLat] floatValue]),
                           @"lng": @([[KUserDefults objectForKey:KLng] floatValue]),
                           @"logo": self.qun_Url,
                           @"name": self.txt_name.text,
                           @"notice": self.txt_Notice.text,
                           @"type": _ID
                           };
    [YSNetworkTool POST:self.flag_str==1?v1TalentTeamCreate: v1ServiceStationCreate params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        self.block();
        [self.navigationController popViewControllerAnimated:YES];
        [YTAlertUtil showTempInfo:responseObject[@"message"]];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
-(void)initData{
    //服务类别列表
    if (self.flag_str==1) {
        [AbilityNet requstAbilityClass:^(NSMutableArray *successArrValue) {
            self.Arr_Classify = successArrValue;
        }];
    }else{
        [ServiceHomeNet requstServiceClass:^(NSMutableArray *successArrValue) {
            self.Arr_Classify = successArrValue;
        }];
    }
}
- (IBAction)Btnclick:(UIButton *)sender {
    if (sender.tag==3) {
        ClassificationsController * class = [ClassificationsController new];
        class.arr_Data = self.Arr_Classify;
        class.title = self.flag_str==1?@"职业分类":@"服务分类";
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
            [YTAlertUtil showHUDWithTitle:@"正在上传..."];
            [[QiniuUploader defaultUploader] uploadImageToQNFilePath:image withBlock:^(NSDictionary *url) {
                self.qun_Url = [NSString stringWithFormat:@"%@%@",QINIUURL,url[@"hash"]];
                [YTAlertUtil hideHUD];
            }];
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
-(void)setUI{
    if (self.flag_str==1) {
        self.lab_name.text = @"团队名称";
        self.lab_class.text = @"团队分类";
        self.lab_notice.text = @"团队公告";
        self.title = @"创建团队";
    }
}
@end
