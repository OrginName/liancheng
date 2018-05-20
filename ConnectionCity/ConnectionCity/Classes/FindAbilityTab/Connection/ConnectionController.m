//
//  ConnectionController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/9.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ConnectionController.h"
#import "SegmentPageHead.h"
#import "ConnectionCell.h"
@interface ConnectionController ()<MLMSegmentPageDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSArray *list;
    UIButton *_tmpBtn;
}
@property (strong, nonatomic) UIScrollView *scrollHead;
@property (weak, nonatomic) IBOutlet UIButton *btn_All;//所有的人

@property (nonatomic, strong) MLMSegmentPage *pageView;
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation ConnectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSlider];
    [self setUI];
}
-(void)setUI{
    _tmpBtn = self.btn_All;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"return-f" title:@"" EdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
     self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(SearchClick) image:@"search" title:@"" EdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
}
#pragma mark --- 按钮点击方法-----
-(void)back{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"BACKMAINWINDOW" object:nil];
}
//搜索按钮
-(void)SearchClick{
    [YTAlertUtil showTempInfo:@"我是搜搜"];
}
- (IBAction)btn_Click:(UIButton *)sender {
    if (_tmpBtn !=nil &&_tmpBtn == sender){
        sender.selected = YES;
    } else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
    }
}
-(void)setupSlider{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    list = @[@"推荐", @"同乡",@"同行", @"校友", @"同事"];
    _pageView = [[MLMSegmentPage alloc] initSegmentWithFrame:CGRectMake(10, 70, kScreenWidth-20, kScreenHeight-200) titlesArray:list vcOrviews:[self viewArr]];
    _pageView.headStyle = SegmentHeadStyleLine;
    _pageView.delegate = self;
    _pageView.loadAll = YES;
    _pageView.countLimit = 5;
    _pageView.fontScale = 1;
    _pageView.fontSize = 15;
    _pageView.lineHeight = 0;
    _pageView.bottomLineHeight = 0;
    _pageView.deselectColor = [UIColor hexColorWithString:@"#656565"];
    _pageView.selectColor = [UIColor hexColorWithString:@"f49930"];
     [self.view addSubview:_pageView];
}
#pragma mark ---UITableViewDelegate------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConnectionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ConnectionCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ConnectionCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 82;
}
- (NSArray *)viewArr {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < list.count; i ++) {
        UITableView  *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, kScreenHeight-2000) style:UITableViewStylePlain];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableview.backgroundColor = [UIColor whiteColor];
        [arr addObject:tableview];
    }
    return arr;
}
#pragma mark - delegate
- (void)scrollThroughIndex:(NSInteger)index {
    //    NSLog(@"scroll through %@",@(index));
}

- (void)selectedIndex:(NSInteger)index {
    //    NSLog(@"select %@",@(index));
}
@end
