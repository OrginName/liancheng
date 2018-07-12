//
//  OurServiceController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "OurServiceController.h"
#import "SegmentPageHead.h"
#import "CustomButton.h"
#import "OurServiceCell.h"
#import "ProfileNet.h"
@interface OurServiceController ()<MLMSegmentPageDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSArray *list,*list1;
    UIButton *_tmpBtn;
    NSMutableArray *arr;
    NSInteger currentTag;
    NSInteger _currentIndex;
    int _page;
}
@property (nonatomic,strong)NSMutableArray * tab_Arr;
@property (weak, nonatomic) IBOutlet CustomButton *btn_All;
@property (strong, nonatomic) UIScrollView *scrollHead;
@property (nonatomic, strong) MLMSegmentPage *pageView;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * data_Arr;
@end

@implementation OurServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.title = @"我的服务";
    self.btn_All.selected = YES;
    _tmpBtn = self.btn_All;
    list = @[@"待付款", @"待接单",@"待赴约", @"待评价", @"已完成"];
    list1 = @[@"待付款", @"待接单",@"待履约", @"待评价", @"已完成"];
    self.tab_Arr = [NSMutableArray array];
    self.data_Arr = [NSMutableArray array];
    _currentIndex = 0;
    _page = 1;
    [self setupSlider:list];
    currentTag = 1;
}
//加载数据
-(void)loadData:(NSInteger)a tab:(UITableView *)tab{
    NSDictionary * dic = @{
                           @"pageNumber": @(_page),
                           @"pageSize": @15,
                           @"status": @(a)
                           };
    [ProfileNet requstMyService:dic flag:_tmpBtn.tag block:^(NSMutableArray *successArrValue) {
        if (_page==1) {
            [self.data_Arr removeAllObjects];
        }
        _page++;
        [self endRefrsh:tab];
    }withFailBlock:^(NSString *failValue) {
        [self endRefrsh:tab];
    }];;
}
-(void)endRefrsh:(UITableView *)tab{
    [tab.mj_header endRefreshing];
    [tab.mj_footer endRefreshing];
}
-(void)setupSlider:(NSArray *)arr{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _pageView = [[MLMSegmentPage alloc] initSegmentWithFrame:CGRectMake(10, 70, kScreenWidth-20, kScreenHeight-80) titlesArray:arr vcOrviews:[self viewArr]];
    _pageView.headStyle = SegmentHeadStyleLine;
    _pageView.delegate = self;
    _pageView.loadAll = YES;
    _pageView.countLimit = 5;
    _pageView.fontScale = 1;
    _pageView.fontSize = 15;
    _pageView.lineHeight = 1;
    _pageView.bottomLineHeight = 0;
    _pageView.deselectColor = [UIColor hexColorWithString:@"#656565"];
    _pageView.selectColor = YSColor(243, 152, 48);
    _pageView.lineColor = YSColor(243, 152, 48);
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
    
    OurServiceCell * cell = [OurServiceCell tempTableViewCellWith:tableView indexPath:indexPath currentTag:currentTag];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 185;
}
- (NSArray *)viewArr {
    arr = [NSMutableArray array];
    for (NSInteger i = 0; i < list.count; i ++) {
        UITableView  *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, kScreenHeight) style:UITableViewStylePlain];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.tag = i+1000;
        if (i==0) {
            [tableview.mj_header beginRefreshing];
        }
        tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page=1;
            [self loadData:i tab:tableview];
        }];
        tableview.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            [self loadData:i tab:tableview];
        }];
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableview.backgroundColor = [UIColor whiteColor];
        [arr addObject:tableview];
    }
    self.tab_Arr = arr;
    return arr;
}
#pragma mark - delegate
- (void)scrollThroughIndex:(NSInteger)index {
        NSLog(@"scroll through %@",@(index));
}
- (void)selectedIndex:(NSInteger)index {
        NSLog(@"select %@",@(index));
    NSInteger a = 10+index*10;
    _currentIndex = index;
    UITableView * tab = self.tab_Arr[index];
    [self loadData:a tab:tab];
}
- (IBAction)btn_Click:(UIButton *)sender {
    [self.pageView removeFromSuperview];
    if (sender.tag==1) {
        [self setupSlider:list];
    }else
        [self setupSlider:list1];
    if (_tmpBtn !=nil &&_tmpBtn == sender){
        sender.selected = YES;
        
    } else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
    }
    currentTag = sender.tag;
}
@end

@implementation leftView
@end
@implementation rightView
@end
