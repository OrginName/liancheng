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
#import "RCDHttpTool.h"
#import "UserMo.h"
#import "PersonalBasicDataController.h"
@interface ConnectionController ()<MLMSegmentPageDelegate,UITableViewDelegate,UITableViewDataSource,ConnectionCellDelegate>
{
    NSArray *list;
    UIButton *_tmpBtn;
    int _page;
    NSInteger _currentIndex;
}
@property (nonatomic,strong)NSMutableArray * data_Arr;
@property (nonatomic,strong)NSMutableArray * tabArr;
@property (strong, nonatomic) UIScrollView *scrollHead;
@property (weak, nonatomic) IBOutlet UIButton *btn_All;//所有的人
@property (nonatomic, strong) MLMSegmentPage *pageView;
@property (strong, nonatomic) MyTab *tableView;
@end

@implementation ConnectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabArr = [NSMutableArray array];
    [self setupSlider];
    [self setUI];
    _page = 0;
    _currentIndex = 0;
    MyTab * tab = self.tabArr[_currentIndex];
    [tab.mj_header beginRefreshing];
}
-(void)setUI{
    _tmpBtn = self.btn_All;
    [super setFlag_back:YES];
    self.data_Arr = [NSMutableArray array];
//     self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(SearchClick) image:@"search" title:@"" EdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
}
-(void)loadData:(NSInteger)a tab:(MyTab *)tab{
   NSString * str = a==0?v1TalentConnectionCityPage:a==1?v1TalentConnectionEducationPage:v1TalentConnectionOccupationPage;
    NSDictionary * dic = @{};
    if (_tmpBtn.tag==2) {
        dic = @{@"lat":[KUserDefults objectForKey:kLat],@"lng":[KUserDefults objectForKey:KLng],@"pageNumber":@(_page),@"pageSize":@15};
    }else
        dic = @{@"pageNumber": @(_page),
                @"pageSize": @(15) 
                };
    [YSNetworkTool POST:str params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray * arr = responseObject[@"data"][@"content"];
        if (arr.count==0) {
            [YTAlertUtil showTempInfo:@"暂无数据"];
            [tab reloadData];
            [self endReload:tab];
            return;
        }
        if (_page==1) {
            [self.data_Arr removeAllObjects];
        }
        _page++;
        for (int i=0; i<[arr count]; i++) {
            UserMo * mo = [UserMo mj_objectWithKeyValues:arr[i]];
            [self.data_Arr addObject:mo];
        }
        [tab reloadData];
        [self endReload:tab];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endReload:tab];
    }];
}
-(void)endReload:(UITableView *)tab{
    [tab.mj_header endRefreshing];
    [tab.mj_footer endRefreshing];
}
//搜索按钮
//-(void)SearchClick{
//    [YTAlertUtil showTempInfo:@"我是搜搜"];
//}
- (IBAction)btn_Click:(UIButton *)sender {
    if (_tmpBtn !=nil &&_tmpBtn == sender){
        sender.selected = YES;
    } else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
    }
    [self.data_Arr removeAllObjects];
    _page=1;
    MyTab * tab = self.tabArr[_currentIndex];
    [tab.mj_header beginRefreshing];
}
#pragma mark -------ConnectionCellDelegate-------------
- (void)btnClick:(UIButton *)btn{
    UITableView * tab = self.tabArr[_currentIndex];
    UserMo * mo = self.data_Arr[btn.tag-1];
    [RCDHTTPTOOL requestFriend:mo.ID complete:^(BOOL result) {
        if (result) {
            [YTAlertUtil showTempInfo:@"好友申请已发送"];
            mo.isFriend = @"1";
            [self.data_Arr replaceObjectAtIndex:btn.tag-1 withObject:mo];
            [tab reloadData];
        }
    }];
}
-(void)DetailClick:(UIButton *)btn{
    UserMo * mo = self.data_Arr[btn.tag-1];
    PersonalBasicDataController * person = [PersonalBasicDataController new];
    person.connectionMo = mo;
    person.title = mo.nickName?mo.nickName:mo.ID;
    [self.navigationController pushViewController:person animated:YES];
}
-(void)setupSlider{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    list = @[@"同乡",@"校友", @"同行"];
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
    return self.data_Arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConnectionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ConnectionCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ConnectionCell" owner:nil options:nil] lastObject];
    }
    cell.btn_detail.tag=cell.btn_Add.tag = indexPath.row+1;
    cell.mo = self.data_Arr[indexPath.row];
    cell.cellDelegate = self;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 82;
}
- (NSArray *)viewArr {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < list.count; i ++) {
        MyTab  *tableview = [[MyTab alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, kScreenHeight-2000) style:UITableViewStylePlain];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.tag = i;
        tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page=1;
            [self loadData:i tab:tableview];
        }];
        tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _page++;
            [self loadData:i tab:tableview];
        }];
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableview.backgroundColor = [UIColor whiteColor];
        [arr addObject:tableview];
    }
    [self.tabArr addObjectsFromArray:[arr copy]];
    return arr;
}
#pragma mark - delegate
- (void)scrollThroughIndex:(NSInteger)index {
    
}
- (void)selectedIndex:(NSInteger)index {
    NSLog(@"select %@",@(index));
    _currentIndex = index;
    _page = 1;
    MyTab * tab = self.tabArr[index];
//    [tab.mj_header beginRefreshing];
    [self loadData:index tab:tab];
}
@end
