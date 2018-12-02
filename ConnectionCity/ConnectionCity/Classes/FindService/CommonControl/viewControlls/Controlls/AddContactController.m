//
//  AddContactController.m
//  ConnectionCity
//
//  Created by qt on 2018/11/27.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AddContactController.h"
#import "AddNewContactController.h"
#import "AddNewContact1Controller.h"
#import "PersonNet.h"
@class AddContactCell;
@interface AddContactController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *lab_tip;
@property (weak, nonatomic) IBOutlet UITableView *tab_bottom;
@property (nonatomic,strong) NSMutableArray * arr_Data;
@end
@implementation AddContactController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
    [self initData];
}
-(void)setUI{
    NSMutableAttributedString * mutableAttriStr = [[NSMutableAttributedString alloc] initWithString:@"· 设置后仅在使用一键报警或紧急情况下，会主动通知紧急联系人"];
    NSDictionary * attris = @{NSForegroundColorAttributeName:YSColor(248, 119, 145)};
    [mutableAttriStr setAttributes:attris range:NSMakeRange(9,4)];
    self.lab_tip.attributedText = mutableAttriStr;
}
-(void)initData{
    self.arr_Data = [NSMutableArray array];
    WeakSelf
    [PersonNet requstContactList:@{} withDic:^(NSMutableArray *successArrValue) {
        weakSelf.arr_Data = successArrValue;
        [self.tab_bottom reloadData];
    } FailDicBlock:^(NSError *failValue) {
        
    }];
}
//新增联系人
-(void)AddContact{
    WeakSelf
    AddNewContact1Controller * add = [AddNewContact1Controller new];
    add.title = @"添加紧急联系人";
    add.blcok = ^{
        [weakSelf initData];
    };
    [self.navigationController pushViewController:add animated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr_Data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddContactCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[AddContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.dic = self.arr_Data[indexPath.row];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    
    UIView * viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 2)];
    viewLine.backgroundColor =YSColor(239, 240, 241);
    [view addSubview:viewLine];
    
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(15,15, 20, 20)];
    image.image = [UIImage imageNamed:@"addPho"];
    [view addSubview:image];
    
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 200, 50)];
    lab.text = @"新增紧急联系人";
    lab.textColor = YSColor(171, 172, 173);
    lab.font = [UIFont systemFontOfSize:14];
    [view addSubview:lab];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AddContact)];
    [view addGestureRecognizer:tap];
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf
    AddNewContactController * add = [AddNewContactController new];
    add.title = @"紧急联系人";
    add.dicReceive = self.arr_Data[indexPath.row];
    add.blcok = ^{
        [weakSelf initData];
    };
    [self.navigationController pushViewController:add animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}
@end

@implementation AddContactCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.imgaRen];
        [self addSubview:self.lab_Phone];
        [self addSubview:self.btn_GL];
        [self addSubview:self.view_line];
    }
    return self;
}
-(void)setDic:(NSDictionary *)dic{
    _dic = dic;
    self.lab_Phone.text = [NSString stringWithFormat:@"%@   %@", [dic[@"mobile"] description],[dic[@"name"] description]];    
}
-(UIImageView *)imgaRen{
    if (!_imgaRen) {
        _imgaRen = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 15, 15)];
        _imgaRen.image = [UIImage imageNamed:@"anquan_icon4"];
    }
    return _imgaRen;
}
-(UILabel *)lab_Phone{
    if (!_lab_Phone) {
        _lab_Phone = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, kScreenWidth-150, 50)];
        _lab_Phone.textColor = YSColor(34, 38, 40);
        _lab_Phone.font = [UIFont systemFontOfSize:14];
        _lab_Phone.text = @"13233919756  测试";
    }
    return _lab_Phone;
}
-(UIButton *)btn_GL{
    if (!_btn_GL) {
        _btn_GL = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-50, 0, 40, 50)];
        [_btn_GL setTitle:@"管理" forState:UIControlStateNormal];
        _btn_GL.userInteractionEnabled = NO;
        [_btn_GL setTitleColor:YSColor(241, 136, 68) forState:UIControlStateNormal];
        _btn_GL.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btn_GL addTarget:self action:@selector(GLClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_GL;
}
-(UIView *)view_line{
    if (!_view_line) {
        _view_line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 2)];
        _view_line.backgroundColor = YSColor(239, 240, 241);
        }
    return _view_line;
}
-(void)GLClick{
    
}
@end
