//
//  ZBJFViewController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ZBJFViewController.h"
#import "ConsultativeNegotiationCell.h"
#import "InstallmentMo.h"
#import "AllDicMo.h"
#import "PayOrderController.h"

@interface ZBJFViewController ()<ConsultativeNegotiationCellDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation ZBJFViewController

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
    self.navigationItem.title = @"接单缴费";
    self.commitBtn.layer.cornerRadius = 3;
    
    InstallmentMo *mo00 = [[InstallmentMo alloc]init];
    mo00.bbb = YES;
    mo00.title = @"接单金额";
    mo00.data = self.zbjeStr;
    InstallmentMo *mo10 = [[InstallmentMo alloc]init];
    mo10.bbb = NO;
    mo10.title = @"一期";
    mo10.data = self.zbjeStr;
    InstallmentMo *mo11 = [[InstallmentMo alloc]init];
    mo11.bbb = NO;
    mo11.title = @"二期";
    mo11.data = @"0";
    InstallmentMo *mo12 = [[InstallmentMo alloc]init];
    mo12.bbb = NO;
    mo12.title = @"三期";
    mo12.data = @"0";
    InstallmentMo *mo13 = [[InstallmentMo alloc]init];
    mo13.bbb = NO;
    mo13.title = @"四期";
    mo13.data = @"0";
    InstallmentMo *mo14 = [[InstallmentMo alloc]init];
    mo14.bbb = NO;
    mo14.title = @"五期";
    mo14.data = @"0";
    InstallmentMo *mo20 = [[InstallmentMo alloc]init];
    mo20.bbb = NO;
    mo20.title = @"保证金";
    mo20.data = [NSString stringWithFormat:@"%.2f",[self.zbjeStr intValue] * 0.1];
    self.dataArr = [NSMutableArray arrayWithArray:@[@[mo00],@[mo10,mo11,mo12,mo13,mo14],@[mo20]]];
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
    if (section == 1 || section == 2) {
        return 40;
    }else{
        return 10;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==2) {
        return 40;
    }else{
        return 0.1;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    /*
     //重用区头视图
     UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
     if (headerView.subviews.count == 1 && section == 1) {
     UILabel *sectinLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
     sectinLab.textAlignment = NSTextAlignmentCenter;
     sectinLab.textColor = [UIColor orangeColor];
     sectinLab.font = [UIFont systemFontOfSize:15];
     sectinLab.text = @"+分  期";
     [headerView addSubview:sectinLab];
     }else if (headerView.subviews.count == 1 && section == 2) {
     UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 50)];
     lab.text = @"如暂不支付接单金额，必须缴纳保证金。";
     lab.font = [UIFont systemFontOfSize:12];
     lab.textColor = [UIColor darkGrayColor];
     lab.textAlignment = NSTextAlignmentLeft;
     lab.numberOfLines = 0;
     [headerView addSubview:lab];
     }else{
     [headerView.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     }
     //返回区头视图
     return headerView;
     */
    if (section==1) {
        UILabel *sectinLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        sectinLab.textAlignment = NSTextAlignmentCenter;
        sectinLab.textColor = [UIColor orangeColor];
        sectinLab.font = [UIFont systemFontOfSize:15];
        sectinLab.text = @"+分  期";
        return sectinLab;
    }else if (section==2){
        UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 50)];
        lab.text = @"如暂不支付接单金额，必须缴纳保证金。";
        lab.font = [UIFont systemFontOfSize:12];
        lab.textColor = [UIColor darkGrayColor];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.numberOfLines = 0;
        [bgview addSubview:lab];
        return bgview;
    }else{
        return nil;
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    /*
     //重用区头视图
     UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
     if (headerView.subviews.count == 1 && section == 2) {
     UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 50)];
     lab.text = @"接单金额的10%由平台上托管，以保证接单双方权益，交易完成后退还。";
     lab.font = [UIFont systemFontOfSize:12];
     lab.textColor = [UIColor darkGrayColor];
     lab.textAlignment = NSTextAlignmentLeft;
     lab.numberOfLines = 0;
     [headerView addSubview:lab];
     }else{
     [headerView.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     }
     //返回区头视图
     return headerView;
     */
    if (section == 2) {
        UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 50)];
        lab.text = @"接单金额的10%由平台上托管，以保证接单双方权益，交易完成后退还。";
        lab.font = [UIFont systemFontOfSize:12];
        lab.textColor = [UIColor darkGrayColor];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.numberOfLines = 0;
        [bgview addSubview:lab];
        return bgview;
    }else{
        return nil;
    }
}
#pragma mark - ConsultativeNegotiationCellDelegate
- (void)consultativeNegotiationCell:(ConsultativeNegotiationCell *)cell selectedBtn:(UIButton *)btn {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    InstallmentMo *mo = self.dataArr[indexPath.section][indexPath.row];
    mo.bbb = !mo.bbb;
    if (indexPath.section==0) {
        InstallmentMo *oneMo = self.dataArr[1][0];
        InstallmentMo *twoMo = self.dataArr[1][1];
        InstallmentMo *threeMo = self.dataArr[1][2];
        InstallmentMo *fourMo = self.dataArr[1][3];
        InstallmentMo *fiveMo = self.dataArr[1][4];
        InstallmentMo *bzjMo = self.dataArr[2][0];
        oneMo.bbb = NO;
        twoMo.bbb = NO;
        threeMo.bbb = NO;
        fourMo.bbb = NO;
        fiveMo.bbb = NO;
        bzjMo.bbb = NO;
    }else if(indexPath.section==1){
        InstallmentMo *jdjeMo = self.dataArr[0][0];
        InstallmentMo *bzjMo = self.dataArr[2][0];
        jdjeMo.bbb = NO;
        bzjMo.bbb = NO;
    }else if(indexPath.section==2){
        InstallmentMo *oneMo = self.dataArr[1][0];
        InstallmentMo *twoMo = self.dataArr[1][1];
        InstallmentMo *threeMo = self.dataArr[1][2];
        InstallmentMo *fourMo = self.dataArr[1][3];
        InstallmentMo *fiveMo = self.dataArr[1][4];
        InstallmentMo *jdjeMo = self.dataArr[0][0];
        oneMo.bbb = NO;
        twoMo.bbb = NO;
        threeMo.bbb = NO;
        fourMo.bbb = NO;
        fiveMo.bbb = NO;
        jdjeMo.bbb = NO;
    }
    [self.tableView reloadData];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    YTLog(@"%@",textField);
    InstallmentMo *mo = _dataArr[1][textField.tag-1000];
    mo.data = [NSString stringWithFormat:@"%.2f",[textField.text doubleValue]];
    textField.text = [NSString stringWithFormat:@"%.2f",[textField.text doubleValue]];
    double value = 0.0;
    for (int i=0; i<textField.tag-1000 +1; i++) {
        InstallmentMo *model = _dataArr[1][i];
        value = value + [model.data doubleValue];
    }
    if (value > [_zbjeStr doubleValue]) {
        [YTAlertUtil showTempInfo:@"分期金额不能大于总金额"];
        mo.data = @"0";
        textField.text = @"0";
    }else{
        if (textField.tag-1000 < 4) {
            InstallmentMo *mo = _dataArr[1][textField.tag-1000+1];
            mo.data = [NSString stringWithFormat:@"%.2f",[_zbjeStr doubleValue]-value];
            NSIndexPath *indepath = [NSIndexPath indexPathForRow:textField.tag-1000+1 inSection:1];
            ConsultativeNegotiationCell *cell = [_tableView cellForRowAtIndexPath:indepath];
            cell.dataTF.text = [NSString stringWithFormat:@"%.2f",[_zbjeStr doubleValue]-value];
        }
    }
    
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
    InstallmentMo *mo20 = self.dataArr[2][0];
    
    if (!(mo00.bbb || mo0.bbb || mo1.bbb || mo2.bbb || mo3.bbb || mo4.bbb || mo20.bbb)) {
        [YTAlertUtil showTempInfo:@"招标金额、分期、保证金至少选择一项"];
        return;
    }
    AllContentMo *mo;
    NSArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:KAllDic]];
    if (mo00.bbb) {
        mo = [arr[8] contentArr][5];
    }else if(mo20.bbb){
        mo = [arr[8] contentArr][6];
    }else{
        mo = [arr[8] contentArr][7];
    }
    
    NSMutableDictionary *dic =[[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                                          @"amount": self.cellCntentText[9],
                                                                                @"areaCode": self.mo.ID?self.mo.ID:@"",
                                                                                @"company": self.cellCntentText[1],
                                                                                @"contactMobile": self.cellCntentText[11],
                                                                                @"contactName": self.cellCntentText[10],
                                                                                @"content": self.cellCntentText[5],
                                                                                //                          @"depositAmount": mo20.data,
                                                                                @"industryCategoryId": self.industryCategoryId?self.industryCategoryId:@"",
                                                                                @"industryCategoryName": self.industryCategoryName?self.industryCategoryName:@"",
                                                                                @"industryCategoryParentId": @"",
                                                                                @"industryCategoryParentName": @"",
                                                                                @"lat": self.mo?self.mo.lat:@"",
                                                                                @"lng": self.mo?self.mo.lng:@"",
                                                                                //                          @"periodAmount1": mo0.data,
                                                                                //                          @"periodAmount2": mo1.data,
                                                                                //                          @"periodAmount3": mo2.data,
                                                                                //                          @"periodAmount4": mo3.data,
                                                                                //                          @"periodAmount5": mo4.data,
                                                                                //                          @"rewardAmount1": mo0.data,
                                                                                //                          @"rewardAmount2": mo1.data,
                                                                                //                          @"rewardAmount3": mo2.data,
                                                                                //                          @"rewardAmount4": mo3.data,
                                                                                //                          @"rewardAmount5": mo4.data,
                                                                                @"tenderAddress": self.cellCntentText[4],
                                                                                @"tenderEndDate": self.cellCntentText[8],
                                                                                @"tenderImages": self.cellCntentText[6],
                                                                                @"tenderStartDate": self.cellCntentText[7],
                                                                                @"title": self.cellCntentText[0],
                                                                                @"tenderId": self.tenderId?self.tenderId:@"",
                                                                                @"payType":mo.value
                                                                                }] ;
    if (mo00.bbb) {
//        [dic setObject:self.cellCntentText[9] forKey:@"amount"];
    }else if (mo0.bbb || mo1.bbb || mo2.bbb || mo3.bbb || mo4.bbb){
        [dic setObject:mo0.data forKey:@"periodAmount1"];
        [dic setObject:mo1.data forKey:@"periodAmount2"];
        [dic setObject:mo2.data forKey:@"periodAmount3"];
        [dic setObject:mo3.data forKey:@"periodAmount4"];
        [dic setObject:mo4.data forKey:@"periodAmount5"];
    }else if (mo20.bbb){
        [dic setObject:mo20.data forKey:@"depositAmount"];
    }
    BOOL a = [self.receive_flag isEqualToString:@"EDIT"]?YES:NO;
    if (a) {
        [self v1TalentTenderUpdate:dic];
    }else{
        [self v1TalentTenderCreate:dic];
    }
}

#pragma mark - 接口请求
//发布任务
- (void)v1TalentTenderCreate:(NSDictionary *)dic{
    //6、接单全额 7、接单保证金 8、接单赏金托管
    NSArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:KAllDic]];
    InstallmentMo *mo00 = self.dataArr[0][0];
    InstallmentMo *mo0 = self.dataArr[1][0];
//    InstallmentMo *mo1 = self.dataArr[1][1];
//    InstallmentMo *mo2 = self.dataArr[1][2];
//    InstallmentMo *mo3 = self.dataArr[1][3];
//    InstallmentMo *mo4 = self.dataArr[1][4];
    InstallmentMo *mo20 = self.dataArr[2][0];
    AllContentMo *mo;
    NSString *amount;
    if (mo00.bbb) {
        mo = [arr[8] contentArr][5];
        amount = mo00.data;
    }else if(mo20.bbb){
        mo = [arr[8] contentArr][6];
        amount = mo20.data;
    }else{
        mo = [arr[8] contentArr][7];
        amount = mo0.data;
    }
    WeakSelf
    [YSNetworkTool POST:v1TalentTenderCreate params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        PayOrderController *vc = [[PayOrderController alloc]init];
        vc.tenderId = responseObject[kData];
        vc.orderType = mo.value;
        vc.amount = amount;
        vc.dataArr = weakSelf.dataArr;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } failure:nil];
}
//修改接单
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

