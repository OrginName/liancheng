//
//  SendServiceController.m
//  ConnectionCity
//
//  Created by qt on 2018/5/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "SendServiceController.h"
#import "PhotoSelect.h"
#import "SendServiceCell.h"
#import "LCPicker.h"
#import "SendSelectCell.h"
#import "EditAllController.h"
#import "ClassificationsController.h"
#import "ServiceHomeNet.h"
#import "QiniuUploader.h"
@interface SendServiceController ()<PhotoSelectDelegate,UITableViewDelegate,UITableViewDataSource,SendSelectCellDelegate,SendServiceCellDelegate>
{
    CGFloat itemHeigth,layout_Height;
    UIButton * _tmpBtn;
    NSString * _secrviceType;
}
@property (nonatomic,strong)SendSelectCell * selectView;
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@property (nonatomic,strong)PhotoSelect * photo;
@property (nonatomic,strong) LCPicker * myPicker;
@property (nonatomic,assign) NSInteger section2Num;
@property (nonatomic,strong) NSArray * arr1;
@property (nonatomic,strong) NSMutableDictionary * Dic2;
@property (nonatomic,strong) NSString * serviceCategoryId;
@property (nonatomic,strong) NSMutableArray * Attr_Arr;
@property (nonatomic,strong) NSMutableArray * Arr_Url;//选择的图片路径
@end

@implementation SendServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布服务";
    self.Attr_Arr = [NSMutableArray array];
    self.Dic2 = [NSMutableDictionary dictionary];
    self.Arr_Url = [NSMutableArray array];
    [self setUI];
}
-(void)setUI{
    itemHeigth = (kScreenWidth-70) / 4+10;
    self.photo = [[PhotoSelect alloc] initWithFrame:CGRectMake(0, 0, self.tab_Bottom.width, itemHeigth) withController:self];
    self.photo.backgroundColor = [UIColor whiteColor];
    self.photo.PhotoDelegate = self;
    self.photo.allowTakeVideo = NO;
    self.tab_Bottom.tableHeaderView = self.photo;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(complete) image:@"" title:@"完成" EdgeInsets:UIEdgeInsetsZero];
    [self.view addSubview:self.myPicker];
    _section2Num = 1;
    [self.view addSubview:self.selectView];
    [self.Dic2 setValue:@"10" forKey:KString(@"%d", 4)];
    [self.Dic2 setValue:@"1" forKey:KString(@"%d", 5)];
    if (!self.arr_receive) {
        self.arr_receive = [NSMutableArray array];
        //    服务类别列表
        WeakSelf
        [ServiceHomeNet requstServiceClass:^(NSMutableArray *successArrValue) {
            weakSelf.arr_receive = successArrValue;
        }];
    }
}
#pragma mark ---- 各种按钮点击i-----
-(void)complete{
    NSArray * arr = [self.Dic2 allKeys];
    if (![arr containsObject:KString(@"%d",0)]||![arr containsObject:KString(@"%d",1)]||![arr containsObject:KString(@"%d",2)]||![arr containsObject:KString(@"%d",3)]) {
        [YTAlertUtil showTempInfo:@"请填写完整"];
        return;
    }
    if (![arr containsObject:KString(@"%d", 5)]) {
        [YTAlertUtil showTempInfo:@"请阅读并同意找服务发布规则"];
        return;
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
                    [self loadData:str];
                }
            }];
        }
    }else{
        [self loadData:@""];
    }
}
-(void)loadData:(NSString *)urlStr{
    NSInteger areaCode = [[KUserDefults objectForKey:kUserCityID] integerValue];
    float lat = [[KUserDefults objectForKey:kLat] floatValue];
    float lng = [[KUserDefults objectForKey:KLng] floatValue];
    NSDictionary * dic = @{
                           @"cityCode": @(areaCode),
                           //                           @"areaCode": @(areaCode),
                           @"content": @"",
                           @"images": urlStr,
                           @"introduce": self.Dic2[KString(@"%d", 2)],
                           @"lat": @(lat),
                           @"lng": @(lng),
                           @"price": @([self.Dic2[KString(@"%d", 3)] floatValue]),
                           @"properties": self.Attr_Arr,
                           @"serviceCategoryId":@([_secrviceType integerValue]),
                           @"title": self.Dic2[KString(@"%d", 0)],
                           @"type": self.Dic2[KString(@"%d", 4)]
                           };
    [YSNetworkTool POST:v1ServiceCreate params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        [YTAlertUtil hideHUD];
        [YTAlertUtil showTempInfo:responseObject[@"message"]];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0||section==5) {
        return 10;
    }else
        return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1) {
        unsigned long a =0;
        for (int i=0; i<_selectView.arrData.count; i++) {
            NSArray * arr= _selectView.arrData[i][@"subname"];
            unsigned long b=(arr.count%3==0)?(arr.count/3):((arr.count/3)+1);
            a +=b;
            NSLog(@"%lu",a);
        }
        return (a*40)+(_selectView.arrData.count*50)+((a+1)*10);
    }else{
        return 0.001f;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SendServiceCell * cell = [SendServiceCell tempTableViewCellWith:tableView indexPath:indexPath];
    // 取出存储所有textFileld改变对应的行
    NSArray *indexArr  = [self.Dic2 allKeys];
    if ([indexArr containsObject:[NSString stringWithFormat:@"%ld",indexPath.section]]) {
        // 如果字典中保存当前的值，那么直接从字典里取出值然后赋给UITextField的text
        cell.txt_Placeholder.text = [self.Dic2 objectForKey:[NSString stringWithFormat:@"%ld",indexPath.section]];
    } else {
        cell.txt_Placeholder.text =nil;
    }
    cell.delegate = self;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section!=4||indexPath.section!=5) {
        return 44;
    }else
        return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0||section==5) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tab_Bottom.width, 10)];
        view.backgroundColor = YSColor(239, 239, 239);
        return view;
    }else
        return [UIView new];
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==1) {
        return self.selectView;
    }else
        return [[UIView alloc] init];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{ 
    if (indexPath.section == 1) {
        ClassificationsController * class = [ClassificationsController new];
        class.title = @"服务分类";
        class.arr_Data = self.arr_receive;
        class.block = ^(NSString *classifiation) {
            
        };
        class.block1 = ^(NSString *classifiation,NSString *classifiation1){
            _serviceCategoryId = classifiation;
            [self loadClassAttr:classifiation str:classifiation1];
            //将发生改变的textField的内容对应cell的行
            [self.Dic2 setValue:classifiation1 forKey:[NSString stringWithFormat:@"%ld",indexPath.section]];
        };
        [self.navigationController pushViewController:class animated:YES];
    }else if(indexPath.section!=4&&indexPath.section!=5){
        SendServiceCell * cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
        EditAllController * edit = [EditAllController new];
        edit.receiveTxt = cell.txt_Placeholder.text;
        edit.block = ^(NSString * str){
            cell.txt_Placeholder.text = str;
            [self.Dic2 setValue:str forKey:[NSString stringWithFormat:@"%ld",indexPath.section]];
        };
        [self.navigationController pushViewController:edit animated:YES];
    }
} 
#pragma mark ----PhotoSelectDelegate-----
-(void)selectImageArr:(NSArray *)imageArr{
    NSLog(@"%lu",(unsigned long)imageArr.count);
//    __block int flag=0;
    if (imageArr.count>=4) {
        self.photo.height = itemHeigth*2;
        UIView *headerView = self.tab_Bottom.tableHeaderView;
        headerView.height = self.photo.height;
        [self.tab_Bottom beginUpdates];
        [self.tab_Bottom setTableHeaderView:headerView];// 关键是这句话
        [self.tab_Bottom endUpdates];
    }
    [self.Arr_Url addObjectsFromArray:imageArr];
//    [YTAlertUtil showHUDWithTitle:@"正在上传"];
//    for (int i=0; i<imageArr.count; i++) {
//        [[QiniuUploader defaultUploader] uploadImageToQNFilePath:imageArr[i] withBlock:^(NSDictionary *url) {
//            flag++;
//            [self.Arr_Url addObject:[NSString stringWithFormat:@"%@%@",QINIUURL,url[@"hash"]]];
//            if (flag == imageArr.count) {
//                [YTAlertUtil hideHUD];
//            }
//        }];
//    }
}
-(void)selectImage:(UIImage *) image arr:(NSArray *)imageArr{
    if (imageArr.count>=4) {
        self.photo.height = itemHeigth*2;
        UIView *headerView = self.tab_Bottom.tableHeaderView;
        headerView.height = self.photo.height;
        [self.tab_Bottom beginUpdates];
        [self.tab_Bottom setTableHeaderView:headerView];// 关键是这句话
        [self.tab_Bottom endUpdates];
    }
    [self.Arr_Url addObjectsFromArray:imageArr];
//    [YTAlertUtil showHUDWithTitle:@"正在上传"];
//    [[QiniuUploader defaultUploader] uploadImageToQNFilePath:image withBlock:^(NSDictionary *url) {
//        [YTAlertUtil hideHUD];
//        [self.Arr_Url addObject:[NSString stringWithFormat:@"%@%@",QINIUURL,url[@"hash"]]];
//    }];
}
-(void)deleteImage:(NSInteger) tag arr:(NSArray *)imageArr{
    if (imageArr.count<=4) {
        self.photo.height = itemHeigth;
        UIView *headerView = self.tab_Bottom.tableHeaderView;
        headerView.height = self.photo.height;
        [self.tab_Bottom beginUpdates];
        [self.tab_Bottom setTableHeaderView:headerView];// 关键是这句话
        [self.tab_Bottom endUpdates];
    }
    [self.Arr_Url removeObjectAtIndex:tag];
}
#pragma mark ----SendSelectCellDelegate----
- (void)selectedItemButton:(NSString *)arr{
    [self.Attr_Arr addObject:arr];
}
#pragma mark ----SendServiceCellDelegate----
- (void)selectedItem:(NSInteger)tag{
    NSString * a = tag==1?@"10":tag==2?@"20":tag==3?@"30":@"";
    [self.Dic2 setValue:a forKey:[NSString stringWithFormat:@"%d",4]];
}
- (void)selectedAgree:(UIButton *)btn{
     [self.Dic2 setValue:[NSString stringWithFormat:@"%d",btn.selected] forKey:[NSString stringWithFormat:@"%d",5]];
}
#pragma mark --- 懒加载UI-----
-(SendSelectCell *)selectView{
    if (!_selectView) {
        _selectView = [[SendSelectCell alloc] initWithFrame:CGRectMake(0, 0, self.tab_Bottom.width, 300)];
        _selectView.delegate = self;
    }
    return _selectView;
}
//加载各种数据
-(void)loadClassAttr:(NSString *)ID str:(NSString *)name{
    NSDictionary * dic = @{@"id":ID};
    _secrviceType = ID;
    SendServiceCell * cell = [self.tab_Bottom cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.txt_Placeholder.text = name;
    [KUserDefults setObject:name forKey:@"ClassName"];
    [ServiceHomeNet requstServiceClassAttrParam:dic succblick:^(NSMutableArray *successArrValue) {
        
        [_selectView.arrData removeAllObjects];
        _selectView.arrData = successArrValue;
        [self.tab_Bottom reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [KUserDefults removeObjectForKey:@"ClassName"];
} 
@end
