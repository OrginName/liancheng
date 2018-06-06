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
#import "MyPickerView.h"
#import "SendSelectCell.h"
#import "EditAllController.h"
@interface SendServiceController ()<PhotoSelectDelegate,UITableViewDelegate,UITableViewDataSource,MyPickerViewDelegate>
{
    CGFloat itemHeigth,layout_Height;
    UIButton * _tmpBtn;
}
@property (nonatomic,strong)SendSelectCell * selectView;
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@property (nonatomic,strong)PhotoSelect * photo;
@property (nonatomic,strong) MyPickerView * myPicker;
@property (nonatomic,assign) NSInteger section2Num;
@property (nonatomic,strong) NSArray * arr1;
@property (nonatomic,strong) NSArray * arr2;
@end

@implementation SendServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布服务";
    [self setUI];
    self.arr1 = @[@{@"isMulitable":@"1",@"name":@"擅长位置",@"subname":@[@{@"isSelected":@YES,@"title":@"坦克"},@{@"isSelected":@NO,@"title":@"射手"},@{@"isSelected":@NO,@"title":@"法师"},@{@"isSelected":@NO,@"title":@"刺客"}]},@{@"isMulitable":@"0",@"name":@"最高段位",@"subname":@[@{@"isSelected":@YES,@"title":@"黄金"},@{@"isSelected":@NO,@"title":@"白银及一下"},@{@"isSelected":@NO,@"title":@"铂金"},@{@"isSelected":@NO,@"title":@"王者"}]}];
    self.arr2 = @[@{@"isMulitable":@"0",@"name":@"擅长位置",@"subname":@[@{@"isSelected":@YES,@"title":@"坦克"},@{@"isSelected":@NO,@"title":@"射手"},@{@"isSelected":@NO,@"title":@"法师"},@{@"isSelected":@NO,@"title":@"刺客"}]}];
}
-(void)setUI{
    itemHeigth = (kScreenWidth-70) / 4+10;
    self.photo = [[PhotoSelect alloc] initWithFrame:CGRectMake(0, 0, self.tab_Bottom.width, itemHeigth) withController:self];
    self.photo.backgroundColor = [UIColor whiteColor];
    self.photo.PhotoDelegate = self;
    self.tab_Bottom.tableHeaderView = self.photo;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(complete) image:@"" title:@"完成" EdgeInsets:UIEdgeInsetsZero];
    [self.view addSubview:self.myPicker];
    _section2Num = 1;
    [self.view addSubview:self.selectView];
}
#pragma mark ---- 各种按钮点击i-----
-(void)complete{
    [YTAlertUtil showTempInfo:@"完成"];
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
        _myPicker.mutableArr = [NSMutableArray arrayWithObjects:@"游戏服务",@"王者服务", nil];
        [_myPicker animateShow];
    }else if(indexPath.section!=4&&indexPath.section!=5){
        SendServiceCell * cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
        EditAllController * edit = [EditAllController new];
        edit.block = ^(NSString * str){
            cell.txt_Placeholder.text = str;
        };
        [self.navigationController pushViewController:edit animated:YES];
    }
} 
#pragma mark ---- MyPickerViewDelegate ---
- (void)myPickerViewWithPickerView:(MyPickerView *)pickerV Str:(NSString *)Str{
    SendServiceCell * cell = [self.tab_Bottom cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [_selectView.arrData removeAllObjects];
    if ([Str isEqualToString:@"游戏服务"]) {
        _selectView.arrData = [self.arr1 mutableCopy];
    }else{
        _selectView.arrData = [self.arr2 mutableCopy];
    }
    [self.tab_Bottom reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    cell.txt_Placeholder.text = Str;
}
#pragma mark ----PhotoSelectDelegate-----
-(void)selectImageArr:(NSArray *)imageArr{
    NSLog(@"%lu",(unsigned long)imageArr.count);
    if (imageArr.count>4) {
        self.photo.height = itemHeigth*2;
        UIView *headerView = self.tab_Bottom.tableHeaderView;
        headerView.height = self.photo.height;
        [self.tab_Bottom beginUpdates];
        [self.tab_Bottom setTableHeaderView:headerView];// 关键是这句话
        [self.tab_Bottom endUpdates];
    }
}
#pragma mark --- 懒加载UI-----
-(MyPickerView *)myPicker{
    if (!_myPicker) {
        _myPicker = [[MyPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 200)];
        _myPicker.delegate = self;
    }
    return _myPicker;
}
-(SendSelectCell *)selectView{
    if (!_selectView) {
        _selectView = [[SendSelectCell alloc] initWithFrame:CGRectMake(0, 0, self.tab_Bottom.width, 300)];
    }
    return _selectView;
}
@end
