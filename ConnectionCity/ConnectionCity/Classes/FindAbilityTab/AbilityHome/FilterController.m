//
//  FilterController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/10.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FilterController.h"
#import "CustomButton.h"

#define leftCellIdentifier @"leftCellIdentifier"
@interface FilterController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@property (nonatomic,copy) NSMutableArray * arrData;
@property (strong,nonatomic)UIButton * tmpBtn;
@property (nonatomic,strong)UIButton * tmpBtn1;
@property (nonatomic,assign) NSInteger selectSection;

@end

@implementation FilterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tab_Bottom registerClass:[UITableViewCell class] forCellReuseIdentifier:leftCellIdentifier];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SX" ofType:@"plist"];
    self.arrData = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
}
#pragma mark - tableView 数据源代理方法 -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section<3) {
        return 150;
    }else
    return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftCellIdentifier];
        [self setCellContent:cell indexPath:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)setCellContent:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    if (section<3) {
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.tab_Bottom.width, 50)];
        lab.textColor = YSColor(139, 139, 139);
        lab.text = self.arrData[section][@"name"];
        lab.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:lab];
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, lab.height, self.tab_Bottom.width, 1)];
        view.backgroundColor = YSColor(246, 246, 246);
        [cell.contentView addSubview:view];
        
        NSArray * arr = self.arrData[section][@"subname"];
        float width = (self.tab_Bottom.width-40)/3;
        __block float y = view.y+10;
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            float x = 10+idx*(width+10);
            if (idx>2) {
                y = 2 * (view.y+5);
                x = 10+(idx%3*(width+10));
            }
            CustomButton * btn = [[CustomButton alloc] initWithFrame:CGRectMake(x,y, width, 40)];
            [btn setTitle:obj forState:UIControlStateNormal];
            btn.selected = NO;
            btn.tag = indexPath.section*100+idx;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];

        }];
    }else{
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.tab_Bottom.width, 1)];
        view.backgroundColor = YSColor(246, 246, 246);
        [cell.contentView addSubview:view];
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(self.tab_Bottom.width/2-110, 40, 100, 40)];
        [btn setTitle:@"全部" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor hexColorWithString:@"#f2f2f2"]];
        [btn setTitleColor:[UIColor hexColorWithString:@"#282828"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.layer.cornerRadius = 5;
        [btn addTarget:self action:@selector(btnClick1:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000;
        btn.layer.masksToBounds = YES;
        [cell.contentView addSubview:btn];
        UIButton * btn1 = [[UIButton alloc] initWithFrame:CGRectMake(btn.x+120, btn.y, 100, 40)];
        [btn1 setTitle:@"在线" forState:UIControlStateNormal];
        [btn1 setBackgroundColor:YSColor(242, 152, 61)];
        btn1.layer.cornerRadius = 5;
        btn1.layer.masksToBounds = YES;
        btn1.selected = YES;
        [btn1 setTitleColor:[UIColor hexColorWithString:@"#282828"] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn1.tag = 1001;
        [btn1 addTarget:self action:@selector(btnClick1:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn1];
        
    }
}
-(void)btnClick:(UIButton *)sender{
    NSLog(@"%ld",(long)sender.tag);
    if (sender.tag!=self.selectSection) {
        _tmpBtn = nil;
    }
    if (_tmpBtn == nil){
        sender.selected = YES;
        _tmpBtn = sender;
    }
    else  if (_tmpBtn !=nil &&_tmpBtn == sender){
        sender.selected = YES;
    } else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
    }
    self.selectSection = sender.tag;
}
-(void)btnClick1:(UIButton *)btn{
     UIButton * btn1 =(UIButton *)[self.view viewWithTag:1001];//在线
    if (btn.tag!=1001) {
        btn1.selected = NO;
        [btn1 setBackgroundColor:[UIColor hexColorWithString:@"#f2f2f2"]];
    }
    if (_tmpBtn1 == nil){
        btn.selected = YES;
        _tmpBtn1 = btn;
        [btn setBackgroundColor:YSColor(242, 152, 61)];
    }
    else  if (_tmpBtn1 !=nil &&_tmpBtn1 == btn){
        btn.selected = YES;
        [btn setBackgroundColor:YSColor(242, 152, 61)];
    } else if (_tmpBtn1!= btn && _tmpBtn1!=nil){
        _tmpBtn1.selected = NO;
        [_tmpBtn1 setBackgroundColor:[UIColor hexColorWithString:@"#f2f2f2"]];
        btn.selected = YES;
        [btn setBackgroundColor:YSColor(242, 152, 61)];
        _tmpBtn1 = btn;
    }
}
@end
 


