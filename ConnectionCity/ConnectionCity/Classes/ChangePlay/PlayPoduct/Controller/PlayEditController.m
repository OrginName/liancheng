//
//  PlayEditController.m
//  ConnectionCity
//
//  Created by qt on 2018/5/27.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "PlayEditController.h"
#import "PlayDouctCell.h"
@interface PlayEditController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray * arr_selectRows;
@property (weak, nonatomic) IBOutlet UITableView *tab_Edit;
@property (nonatomic,strong) NSArray * arr_Data;
@end

@implementation PlayEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self initData];
}
-(void)setUI{
    self.navigationItem.title = @"玩品柜";
}
//上下架btn点击
- (IBAction)UpAndDownBtn:(UIButton *)sender {
    NSString * str =  @"";
    if (sender.tag==1) {
        
    }else{
        
    }
    for (int i=0; i<self.arr_selectRows.count; i++) {
        str = [NSString stringWithFormat:@"%@-%@",str,self.arr_selectRows[i]];
    }
    [YTAlertUtil showTempInfo:str];
}
//初始化加载数据
-(void)initData{
    self.arr_selectRows =[NSMutableArray array];
    self.arr_Data = @[@[@{@"test2":@"1"},@{@"test2":@"2"},@{@"test2":@"2"},@{@"test2":@"2"},@{@"test2":@"2"}],@[@{@"test2":@"1"},@{@"test2":@"2"},@{@"test2":@"2"},@{@"test2":@"2"}]];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arr_Data[section] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 45;
    }else
        return 55;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PlayDouctCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PlayDouctCell2"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"PlayDouctCell" owner:nil options:nil][2];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PlayDouctCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.btn_select.selected = !cell.btn_select.selected;
    NSString * selectStr = [NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row];
    if (![self.arr_selectRows containsObject:selectStr]) {
        [self.arr_selectRows addObject:selectStr];
    }else
        [self.arr_selectRows removeObject:selectStr];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * selectStr = [NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row];
    PlayDouctCell * cell1 = (PlayDouctCell *)cell;
    if ([self.arr_selectRows containsObject:selectStr]) {
        cell1.btn_select.selected = YES;
    }else
        cell1.btn_select.selected = NO;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tab_Edit.width, section==0?55:60)];
    headView.backgroundColor = [UIColor whiteColor];
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(10, section==0?0:5, 55, headView.height)];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:section==0?@"上架":@"下架" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"index"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"index-h"] forState:UIControlStateSelected];
    [btn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:3];
    [headView addSubview:btn];
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headView.width, 10)];
    view1.backgroundColor = YSColor(237, 237, 237);
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, headView.height-2, headView.width, 2)];
    view2.backgroundColor = YSColor(237, 237, 237);
    [headView addSubview:view2];
    if (section!=0) {
        [headView addSubview:view1];
    }
    return headView;
}
@end
