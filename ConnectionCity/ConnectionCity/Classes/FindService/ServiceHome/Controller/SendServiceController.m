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
    self.arr1 = @[@{@"name":@"擅长位置",@"subname":@[@{@"isSelected":@"YES",@"title":@"坦克"},@{@"isSelected":@"NO",@"title":@"射手"},@{@"isSelected":@"NO",@"title":@"法师"},@{@"isSelected":@"NO",@"title":@"刺客"}]},@{@"name":@"最高段位",@"subname":@[@{@"isSelected":@"YES",@"title":@"黄金"},@{@"isSelected":@"NO",@"title":@"白银及一下"},@{@"isSelected":@"NO",@"title":@"铂金"},@{@"isSelected":@"NO",@"title":@"王者"}]}];
}
-(void)setUI{
    itemHeigth = (self.tab_Bottom.width - 50) / 4+10;
    self.photo = [[PhotoSelect alloc] initWithFrame:CGRectMake(0, 0, self.tab_Bottom.width, itemHeigth) withController:self];
    self.photo.backgroundColor = [UIColor whiteColor];
    self.photo.PhotoDelegate = self;
    self.tab_Bottom.tableHeaderView = self.photo;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(complete) image:@"" title:@"完成" EdgeInsets:UIEdgeInsetsZero];
    [self.view addSubview:self.myPicker];
    _section2Num = 1;
}
#pragma mark ---- 各种按钮点击i-----
-(void)complete{
    [YTAlertUtil showTempInfo:@"完成"];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section!=2) {
        return 1;
    }else{
        return _section2Num;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0||section==5) {
        return 10;
    }else
        return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1) {
        int a = _selectView.arrData.count%3;
        a = a==0?a:(a+1);
        return a*40+(a+1)*10+50;
    }else
        return 0;
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
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tab_Bottom.width, 10)];
    view.backgroundColor = YSColor(239, 239, 239);
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        _myPicker.mutableArr = [NSMutableArray arrayWithObjects:@"游戏服务",@"王者服务", nil];
        [_myPicker animateShow];
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==1) {
         return self.selectView;
    }else
        return [UIView new];
}
#pragma mark ---- MyPickerViewDelegate ---
- (void)myPickerViewWithPickerView:(MyPickerView *)pickerV Str:(NSString *)Str{
    SendServiceCell * cell = [self.tab_Bottom cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.txt_Placeholder.text = Str;
    _selectView.arrData = [NSMutableArray arrayWithArray:@[self.arr1]];
    [self.tab_Bottom reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
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
        _selectView.arrData= [NSMutableArray arrayWithArray:self.arr1];
    }
    return _selectView;
}
@end
