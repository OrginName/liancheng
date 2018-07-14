//
//  ConsultativeNegotiationController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/26.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ConsultativeNegotiationController.h"
#import "ConsultativeNegotiationCell.h"

@interface ConsultativeNegotiationController ()<ConsultativeNegotiationCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

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
}
- (void)setTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"ConsultativeNegotiationCell" bundle:nil] forCellReuseIdentifier:@"ConsultativeNegotiationCell"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return 5;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConsultativeNegotiationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConsultativeNegotiationCell"];
    cell.delegate = self;
    if(indexPath.section==0&&indexPath.row==0){
        cell.titleLab.text = @"招标金额";
        cell.dataTF.text = _mo.amount;
    }else if (indexPath.section==1){
        switch (indexPath.row) {
            case 0:
            {
                cell.titleLab.text = @"一期";
                cell.dataTF.text = _mo.periodAmount1;
                break;
            }
            case 1:
            {
                cell.titleLab.text = @"二期";
                cell.dataTF.text = _mo.periodAmount2;
                break;
            }
            case 2:
            {
                cell.titleLab.text = @"三期";
                cell.dataTF.text = _mo.periodAmount3;
                break;
            }
            case 3:
            {
                cell.titleLab.text = @"四期";
                cell.dataTF.text = _mo.periodAmount4;
                break;
            }
            case 4:
            {
                cell.titleLab.text = @"五期";
                cell.dataTF.text = _mo.periodAmount5;
                break;
            }
            default:
                break;
        }    }
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
    if (headerView.subviews.count == 1 && section == 1) {
        UILabel *sectinLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        sectinLab.textAlignment = NSTextAlignmentCenter;
        sectinLab.textColor = [UIColor orangeColor];
        sectinLab.font = [UIFont systemFontOfSize:15];
        sectinLab.text = @"+分  期";
        [headerView addSubview:sectinLab];
    }
    //返回区头视图
    return headerView;
}
#pragma mark - ConsultativeNegotiationCellDelegate
- (void)consultativeNegotiationCell:(ConsultativeNegotiationCell *)cell selectedBtn:(UIButton *)btn {
    btn.selected = !btn.selected;
}
#pragma mark - 点击事件
- (IBAction)commitBtnClick:(id)sender {
    
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
