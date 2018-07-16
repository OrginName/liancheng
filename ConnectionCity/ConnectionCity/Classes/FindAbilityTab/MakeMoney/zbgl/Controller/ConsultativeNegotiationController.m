//
//  ConsultativeNegotiationController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/26.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ConsultativeNegotiationController.h"
#import "ConsultativeNegotiationCell.h"
#import "InstallmentMo.h"

@interface ConsultativeNegotiationController ()<ConsultativeNegotiationCellDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation ConsultativeNegotiationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setTableView];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup
- (void)setUI {
    self.navigationItem.title = @"协商议价";
    self.commitBtn.layer.cornerRadius = 3;
    
    InstallmentMo *mo00 = [[InstallmentMo alloc]init];
    mo00.bbb = YES;
    mo00.title = @"招标金额";
    mo00.data = self.mo.amount;
    InstallmentMo *mo10 = [[InstallmentMo alloc]init];
    mo10.bbb = YES;
    mo10.title = @"一期";
    mo10.data = self.mo.periodAmount1;
    InstallmentMo *mo11 = [[InstallmentMo alloc]init];
    mo11.bbb = YES;
    mo11.title = @"二期";
    mo11.data = self.mo.periodAmount2;
    InstallmentMo *mo12 = [[InstallmentMo alloc]init];
    mo12.bbb = YES;
    mo12.title = @"三期";
    mo12.data = self.mo.periodAmount3;
    InstallmentMo *mo13 = [[InstallmentMo alloc]init];
    mo13.bbb = YES;
    mo13.title = @"四期";
    mo13.data = self.mo.periodAmount4;
    InstallmentMo *mo14 = [[InstallmentMo alloc]init];
    mo14.bbb = YES;
    mo14.title = @"五期";
    mo14.data = self.mo.periodAmount5;
    self.dataArr = [NSMutableArray arrayWithArray:@[@[mo00],@[mo10,mo11,mo12,mo13,mo14]]];
}
- (void)setTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"ConsultativeNegotiationCell" bundle:nil] forCellReuseIdentifier:@"ConsultativeNegotiationCell"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArr[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConsultativeNegotiationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConsultativeNegotiationCell"];
    cell.delegate = self;
    cell.dataTF.delegate = self;
    cell.dataTF.tag = 1000+indexPath.row;
    InstallmentMo *mo = self.dataArr[indexPath.section][indexPath.row];
    cell.model = mo;
    if (indexPath.section!=1) {
        cell.dataTF.userInteractionEnabled = NO;
    }else{
        cell.dataTF.userInteractionEnabled = YES;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 40;
    }else{
        return 10;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //重用区头视图
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (section == 1) {
        for (UIView *view in headerView.subviews) {
            [view removeFromSuperview];
        }
        UILabel *sectinLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        sectinLab.textAlignment = NSTextAlignmentCenter;
        sectinLab.textColor = [UIColor orangeColor];
        sectinLab.font = [UIFont systemFontOfSize:15];
        sectinLab.text = @"+分  期";
        [headerView addSubview:sectinLab];
    }else{
        for (UIView *view in headerView.subviews) {
            [view removeFromSuperview];
        }
    }
    //返回区头视图
    return headerView;
}
#pragma mark - ConsultativeNegotiationCellDelegate
- (void)consultativeNegotiationCell:(ConsultativeNegotiationCell *)cell selectedBtn:(UIButton *)btn {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    InstallmentMo *mo = self.dataArr[indexPath.section][indexPath.row];
    mo.bbb = !mo.bbb;
    [self.tableView reloadData];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    YTLog(@"%@",textField);
    InstallmentMo *mo = _dataArr[1][textField.tag-1000];
    mo.data = textField.text;
    [self.tableView reloadData];
    return YES;
}
#pragma mark - 点击事件
- (IBAction)commitBtnClick:(id)sender {
    InstallmentMo *mo00 = self.dataArr[0][0];
    InstallmentMo *mo0 = self.dataArr[1][0];
    InstallmentMo *mo1 = self.dataArr[1][1];
    InstallmentMo *mo2 = self.dataArr[1][2];
    InstallmentMo *mo3 = self.dataArr[1][3];
    InstallmentMo *mo4 = self.dataArr[1][4];
    
    NSDictionary *dic = @{
                          @"amount": mo00.data,
                          @"areaCode": self.mo.cityCode?self.mo.cityCode:@"",
                          @"company": self.mo.company,
                          @"contactMobile": self.mo.contactMobile,
                          @"contactName": self.mo.contactName,
                          @"content": self.mo.content,
                          @"depositAmount": self.mo.depositAmount,
                          @"industryCategoryId": self.mo.industryCategoryId,
                          @"industryCategoryName": self.mo.industryCategoryName,
                          @"industryCategoryParentId": self.mo.industryCategoryParentId,
                          @"industryCategoryParentName": self.mo.industryCategoryParentName,
                          @"lat": self.mo?self.mo.lat:@"",
                          @"lng": self.mo?self.mo.lng:@"",
                          @"periodAmount1": mo0.data,
                          @"periodAmount2": mo1.data,
                          @"periodAmount3": mo2.data,
                          @"periodAmount4": mo3.data,
                          @"periodAmount5": mo4.data,
                          @"rewardAmount1": mo0.data,
                          @"rewardAmount2": mo1.data,
                          @"rewardAmount3": mo2.data,
                          @"rewardAmount4": mo3.data,
                          @"rewardAmount5": mo4.data,
                          @"tenderAddress": self.mo.tenderAddress,
                          @"tenderEndDate": self.mo.tenderEndDate,
                          @"tenderImages": self.mo.tenderImages,
                          @"tenderStartDate": self.mo.tenderStartDate,
                          @"title": self.mo.title,
                          @"tenderId": self.mo.modelId,
                          };
    [self v1TalentTenderUpdate:dic];
}
#pragma mark - 接口请求
//修改招标
- (void)v1TalentTenderUpdate:(NSDictionary *)dic{
    WeakSelf
    [YSNetworkTool POST:v1TalentTenderUpdate params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [YTAlertUtil alertSingleWithTitle:@"提示" message:responseObject[kMessage] defaultTitle:@"确认" defaultHandler:^(UIAlertAction *action) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        } completion:nil];
    } failure:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end