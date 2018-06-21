//
//  TrvalInvitController.m
//  ConnectionCity
//
//  Created by qt on 2018/5/30.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "TrvalInvitController.h"
#import "TrvalCell.h"
#import "JFCityViewController.h"
@interface TrvalInvitController ()<UITableViewDataSource,UITableViewDelegate,JFCityViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@property (nonatomic,strong) NSMutableArray * Arr_Dic;
@property (nonatomic,strong) NSMutableDictionary * Dic;
@end

@implementation TrvalInvitController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self initData];
    self.Arr_Dic = [NSMutableArray array];
    self.Dic = [NSMutableDictionary dictionary];
}
-(void)initData{
    [YSNetworkTool POST:dictionaryDictionaryAll params:@{} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        self.Arr_Dic = responseObject[@"data"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
-(void)SearchClick{
    NSArray * arr=  [self.Dic allKeys];
    TrvalCell * cell = [self.tab_Bottom cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    if (![arr containsObject:@"00"]||![arr containsObject:@"01"]||![arr containsObject:@"10"]||![arr containsObject:@"11"]||![arr containsObject:@"12"]||![arr containsObject:@"13"]) {
        [YTAlertUtil showTempInfo:@"请填写完整"];
        return;
    }
    if (cell.txt_View.text.length==0) {
        [YTAlertUtil showTempInfo:@"请输入计划说明"];
        return;
    }
    NSDictionary * dic = @{
                           @"cityCode": @([self.Dic[@"00"][@"ID"] integerValue]),
                           @"departTime": self.Dic[@"10"][@"ID"],
                           @"description": cell.txt_View.text,
                           @"inviteObject": self.Dic[@"01"][@"ID"],
                           @"longTime": self.Dic[@"11"][@"ID"],
//                           @"placeTravel": self.Dic[@"00"][@"ID"],
                           @"travelFee": self.Dic[@"13"][@"ID"],
                           @"travelMode": self.Dic[@"12"][@"ID"]
                           };
    [YSNetworkTool POST:v1ServiceTravelInviteCreate params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [YTAlertUtil showTempInfo:@"发布成功"];
        self.block();
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
-(void)setUI{
    self.navigationItem.title = @"旅行邀约";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(SearchClick) image:@"" title:@"发布" EdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }else if (section==1){
        return 4;
    }else{
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TrvalCell * cell = [TrvalCell tempTableViewCellWith:tableView indexPath:indexPath];
    cell.txt_View.placeholder = @"简单说说您对报名人的要求、旅行计划的安排说明";
    NSString * str = [NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row];
    NSArray * arr = [self.Dic allKeys];
    if ([arr containsObject:str]) {
        cell.txt_Edit.text = self.Dic[str][@"name"];
    }
    cell.txt_View.placeholderColor = YSColor(166, 166, 166);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TrvalCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if ((indexPath.section==0&&indexPath.row==1)||indexPath.section==1) {
        NSArray * arr = [NSArray array];
        NSString * str = @"";
        if (indexPath.section==0&&indexPath.row==1) {
            str = @"18";
        }
        if (indexPath.section==1) {
            if (indexPath.row==0) {
                str = @"19";
            }else if (indexPath.row==1){
                str = @"20";
            }else if (indexPath.row==2){
                str = @"21";
            }else
                str = @"22";
        }
        for (int i=0; i<self.Arr_Dic.count; i++) {
            if ([[self.Arr_Dic[i][@"id"] stringValue] isEqualToString:str]) {
                arr = [YSTools stringToJSON:self.Arr_Dic[i][@"content"]];
            }
        }
        NSMutableArray * title = [NSMutableArray array];
        for (int i=0; i<arr.count; i++) {
            [title addObject:arr[i][@"description"]];
        }
        [YTAlertUtil alertMultiWithTitle:nil message:nil style:UIAlertControllerStyleActionSheet multiTitles:title multiHandler:^(UIAlertAction *action, NSArray *titles, NSUInteger idx) {
            cell.txt_Edit.text = title[idx];
            [self.Dic setObject:@{@"name":title[idx],@"ID":arr[idx][@"value"]} forKey:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
        } cancelTitle:@"取消" cancelHandler:^(UIAlertAction *action) {
            
        } completion:nil];
    }
    if (indexPath.section==0&&indexPath.row==0) {
        JFCityViewController * jf= [JFCityViewController new];
        jf.delegate = self;
        BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:jf];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}
#define mark------JFCityViewControllerDelegate---
-(void)cityMo:(CityMo *)mo{
    TrvalCell * cell = [self.tab_Bottom cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.txt_Edit.text = mo.fullName;
    [self.Dic setObject:@{@"name":mo.fullName,@"ID":mo.ID} forKey:@"00"];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TrvalCell * cell = [[NSBundle mainBundle] loadNibNamed:@"TrvalCell" owner:nil options:nil][1];
    cell.lab_headTitle.text = section==0?@"我要去哪里":section==1?@"计划安排":section==2?@"计划说明":@"";
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section!=2) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tab_Bottom.width, 10)];
        view.backgroundColor = YSColor(239, 239, 239);
        return view;
    }else
        return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section!=2) {
        return 10;
    }else
        return 0.0001f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2) {
        return 96;
    }else
        return 50;
}
@end
