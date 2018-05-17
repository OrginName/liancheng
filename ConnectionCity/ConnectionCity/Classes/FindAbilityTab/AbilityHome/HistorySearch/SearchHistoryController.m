//
//  SearchHistoryController.m
//  ConnectionCity
//
//  Created by qt on 2018/5/16.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "SearchHistoryController.h"
#import "JFCityHeaderView.h"
#import "SearchCell.h"
@interface SearchHistoryController() <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)UITableView * tab_Bottom;
@property (nonatomic, strong) JFCityHeaderView *headerView;
@property (nonatomic,strong) UIView * view_Search;
@property (nonatomic,strong) UITextField * search_text;
@property (nonatomic,strong) SearchCell * cell;

@end
@implementation SearchHistoryController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
//搜索按钮
-(void)search{
    [YTAlertUtil showTempInfo:@"我是搜索按钮"];
}
//搜索框删除按钮
-(void)deleteSearch{
    self.search_text.text = @"";
}
-(void)clearSearchAll:(UIButton *)btn{
    [YTAlertUtil showTempInfo:@"清空历史按钮"];
}
-(void)setUI{
    [self.view addSubview:self.tab_Bottom];
    self.navigationItem.titleView = self.view_Search;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(search) image:@"search" title:@"" EdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
}
#pragma mark --- UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
    _cell.cityNameArray = @[@"PHP",@"银行专员",@"IOS",@"安卓",@"JAVA",@"Python"];
    
    return _cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    view.backgroundColor =  [UIColor whiteColor];
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 70, 40)];
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor = [UIColor hexColorWithString:@"#989898"];
    [view addSubview:lab];
    if(section==0){
       lab.text = @"推荐搜索";
    }else{
        lab.text = @"历史搜索";
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(view.width-120, 0, 100, 40)];
        [btn setTitle:@"清空历史" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor hexColorWithString:@"#cccccc"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn addTarget:self action:@selector(clearSearchAll:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, lab.height, self.view.width, 1)];
    view1.backgroundColor = YSColor(246, 246, 246);
    [view addSubview:view1];
    return view;
}
-(UITableView *)tab_Bottom{
    if (!_tab_Bottom) {
        _tab_Bottom = [[UITableView alloc] init];
        _tab_Bottom.frame = CGRectMake(10, 10, kScreenWidth-20, kScreenHeight-20);
        _tab_Bottom.delegate = self;
        _tab_Bottom.dataSource = self;
        _tab_Bottom.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tab_Bottom registerClass:[SearchCell class] forCellReuseIdentifier:@"SearchCell"];
    }
    return _tab_Bottom;
}
-(UIView *)view_Search{
    if (!_view_Search) {
        _view_Search = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-100, 30)];
        _view_Search.backgroundColor = [UIColor whiteColor];
        _search_text = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-150, 30)];
        _search_text.backgroundColor = [UIColor whiteColor];
        _search_text.placeholder = @"   请输入搜索内容";
        _search_text.font = [UIFont systemFontOfSize:14];
        _search_text.delegate = self;
        [_view_Search addSubview:_search_text];
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(_search_text.width+20, 10,10, 10)];
        [btn addTarget:self action:@selector(deleteSearch) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_view_Search addSubview:btn];
    }
    return _view_Search;
}

@end
