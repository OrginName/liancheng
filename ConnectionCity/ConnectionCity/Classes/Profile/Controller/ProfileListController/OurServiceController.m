//  OurServiceController.m
//  ConnectionCity
//  Created by umbrella on 2018/6/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
#import "OurServiceController.h"
#import "SegmentPageHead.h"
#import "CustomButton.h"
#import "OurServiceCell.h"
#import "ProfileNet.h"
#import "FirstTanView.h"
#import "RefineView.h"
#import "StarEvaluator.h"
#import "CircleNet.h"
@interface OurServiceController ()<MLMSegmentPageDelegate,UITableViewDelegate,UITableViewDataSource,CellClickDelegate,FirstTanViewDelegate,StarEvaluatorDelegate>
{
    NSArray *list,*list1;
    UIButton *_tmpBtn;
    NSMutableArray *arr;
    NSInteger currentTag;
    NSInteger _currentIndex;
    int _page;
}
@property (nonatomic,strong) RefineView * refine;
@property (nonatomic,strong) FirstTanView * first;
@property (nonatomic,strong)NSMutableArray * tab_Arr;
@property (weak, nonatomic) IBOutlet CustomButton *btn_All;
@property (strong, nonatomic) UIScrollView *scrollHead;
@property (nonatomic, strong) MLMSegmentPage *pageView;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * data_Arr;
@property (nonatomic,assign) float scroe;
@end
@implementation OurServiceController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayNotice:) name:NOTI_ALI_PAY_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTab) name:NOTI_WEI_XIN_PAY_SUCCESS object:nil];
    self.scroe = 0;
}
#pragma mark - alipayNotice
- (void)alipayNotice:(NSNotification *)notification {
    if ([[[notification object] objectForKey:@"userInfo"] integerValue] == 9000) {
        //支付成功
        [self reloadData];
    }else{
        //支付失败
        
    };
}
//微信
-(void)reloadTab{
    [self reloadData];
}
//刷新数据
-(void)reloadData{
    UITableView * tab = self.tab_Arr[_currentIndex];
    [tab.mj_header beginRefreshing];
}
-(void)setUI{
    self.title = @"我的服务";
    self.btn_All.selected = YES;
    _tmpBtn = self.btn_All;
    list = @[@"待付款", @"待接单",@"待赴约",@"已赴约", @"待评价", @"已完成"];
    list1 = @[@"待付款", @"待接单",@"待履约", @"待评价", @"已完成"];
    self.tab_Arr = [NSMutableArray array];
    self.data_Arr = [NSMutableArray array];
    _currentIndex = 0;
    _page = 1;
    [self setupSlider:list];
    currentTag = 1;
}
- (void)cellBtnClick:(UITableViewCell *)cell{
    UITableView * tab = (UITableView *)self.tab_Arr[_currentIndex];
    OurServiceCell * cell1 = (OurServiceCell *)cell;
    NSIndexPath * index = [tab indexPathForCell:cell1];
    myServiceMo * mo = self.data_Arr[index.row];
    if ([cell1.btn_status.titleLabel.text isEqualToString:@"缴费"]) {
        [YTAlertUtil alertMultiWithTitle:nil message:nil style:UIAlertControllerStyleActionSheet multiTitles:@[@"支付宝",@"微信"] multiHandler:^(UIAlertAction *action, NSArray *titles, NSUInteger idx) {
            if (idx==0) {
                [YTThirdPartyPay v1Pay:@{@"orderNo": mo.orderNo,@"payType":kAlipay}];
            }else{
                [YTThirdPartyPay v1Pay:@{@"orderNo": mo.orderNo,@"payType":kWechat}];
            }
        } cancelTitle:@"取消" cancelHandler:^(UIAlertAction *action) {
        } completion:nil];
    }else if([cell1.btn_status.titleLabel.text isEqualToString:@"取消"]||[cell1.btn_status.titleLabel.text isEqualToString:@"终止服务"]){//我提供的服务取消
        self.first = [[NSBundle mainBundle] loadNibNamed:@"FirstTanView" owner:nil options:nil][1];
        self.first.delegate = self;
        self.first.frame = CGRectMake(10, 0, kScreenWidth-20, 235); 
        self.refine = [[RefineView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) type:self.first];
        WeakSelf
        self.first.block = ^(NSString *txt) {
            [weakSelf requstUpdateStates:@{
                                           @"remark": txt,
                                           @"orderNo": mo.orderNo,
                                       @"status":@40}];
        };
        [self.refine alertSelectViewshow];
    }else if([cell1.btn_status.titleLabel.text isEqualToString:@"接单"]){
        [self requstUpdateStates:@{@"orderNo": mo.orderNo,
                                   @"status":@15,
                                   @"remark":@""
                                   }];
    }else if([cell1.btn_status.titleLabel.text isEqualToString:@"赴约"]){
        [self requstUpdateStates:@{@"orderNo": mo.orderNo,
                                   @"status":@20,
                                   @"remark":@""
                                   }];
    }else if([cell1.btn_status.titleLabel.text isEqualToString:@"履约"]){
        [self requstUpdateStates:@{@"orderNo": mo.orderNo,
                                   @"status":@30,
                                   @"remark":@""
                                   }];
    }else if([cell1.btn_status.titleLabel.text isEqualToString:@"评价"]){
        self.first = [[NSBundle mainBundle] loadNibNamed:@"FirstTanView" owner:nil options:nil][2];
        self.first.delegate = self;
        self.first.frame = CGRectMake(10, 0, kScreenWidth-20, 235);
        StarEvaluator * ev = [[StarEvaluator alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        ev.delegate = self;
        [self.first.view_PJ addSubview:ev];
        self.refine = [[RefineView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) type:self.first];
        WeakSelf
        self.first.block = ^(NSString *txt) {
            [weakSelf requstUpdatePJ:@{
                                       @"content": txt,
                                       @"typeId": @([mo.ID integerValue]),
                                       @"orderNo":mo.orderNo
                                       }];
            
        };
        [self.refine alertSelectViewshow];
    }
}
- (void)starEvaluator:(StarEvaluator *)evaluator currentValue:(float)value{
    NSLog(@"%f",value);
    if (value>5) {
        self.scroe = 10;
    }else
    self.scroe = [self roundFloat:(value*2)];
}
-(float)roundFloat:(float)price{
    return (floorf(price*100 + 0.5))/100;
}
/**
 评价

 @param dic1 param
 */
-(void)requstUpdatePJ:(NSDictionary *)dic1{
    NSDictionary * dic = @{
                           @"content": dic1[@"content"],
                           @"score": @(self.scroe),
                           @"type": @40,
                           @"typeId": @([dic1[@"typeId"] integerValue])
                           };
    [CircleNet requstSendPL:dic withSuc:^(NSDictionary *successDicValue) {
        [self requstUpdateStates:@{@"orderNo": dic1[@"orderNo"],
                               @"status":@50,
                               @"remark":@""}];
    }];
}
/**
 更新状态
 */
-(void)requstUpdateStates:(NSDictionary *)dic1{
    NSDictionary * dic = @{
                           @"remark": dic1[@"remark"],
                           @"orderNo": dic1[@"orderNo"],
                           @"status": @([dic1[@"status"] intValue])
                           };
    [ProfileNet requstUpdateService:dic block:^(NSDictionary *successDicValue) {
         [self.data_Arr removeAllObjects];
         [self reloadTab];
    } withFailBlock:^(NSError *error) {
        
    }];
}
//加载数据
-(void)loadData:(NSDictionary *)dic1 tab:(UITableView *)tab{
    NSDictionary * dic = @{
                           @"orderCommentStatus": @([dic1[@"1"] intValue]),//订单评论状态
                           @"orderPayStatus": @([dic1[@"2"] intValue]),//订单支付状态
                           @"orderStatus": @([dic1[@"3"] intValue]),//订单状态
                           @"pageNumber": @(_page),
                           @"pageSize": @15,
                           };
    [ProfileNet requstMyService:dic flag:_tmpBtn.tag block:^(NSMutableArray *successArrValue) {
        if (successArrValue.count==0) {
            [self endRefrsh:tab];
            [tab reloadData];
            return [YTAlertUtil showTempInfo:@"暂无数据"];
        }
        if (_page==1) {
            [self.data_Arr removeAllObjects];
        }
        _page++;
        self.data_Arr = successArrValue;
        [tab reloadData];
        [self endRefrsh:tab];
    }withFailBlock:^(NSError *failValue) {
        [self endRefrsh:tab];
    }];;
}
-(void)endRefrsh:(UITableView *)tab{
    [tab.mj_header endRefreshing];
    [tab.mj_footer endRefreshing];
}
-(void)setupSlider:(NSArray *)arr{
    NSArray * arr1 = [self viewArr];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _pageView = [[MLMSegmentPage alloc] initSegmentWithFrame:CGRectMake(10, 70, kScreenWidth-20, kScreenHeight-80) titlesArray:arr vcOrviews:arr1];
    _pageView.headStyle = SegmentHeadStyleLine;
    _pageView.delegate = self;
    _pageView.loadAll = YES;
    _pageView.countLimit = arr.count;
    _pageView.fontScale = 1;
    _pageView.fontSize = 15;
    _pageView.lineHeight = 1;
    _pageView.bottomLineHeight = 0;
    _pageView.deselectColor = [UIColor hexColorWithString:@"#656565"];
    _pageView.selectColor = YSColor(243, 152, 48);
    _pageView.lineColor = YSColor(243, 152, 48);
    [self.view addSubview:_pageView];
    UITableView * tab = arr1[0];
    [tab.mj_header beginRefreshing];
}
#pragma mark ---UITableViewDelegate------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data_Arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OurServiceCell * cell = [OurServiceCell tempTableViewCellWith:tableView indexPath:indexPath currentTag:currentTag];
    cell.mo = self.data_Arr[indexPath.row];
    cell.delegate = self;
    cell.btn_status.tag = indexPath.row;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 185;
}
- (NSArray *)viewArr {
    [self.tab_Arr removeAllObjects];
    arr = [NSMutableArray array];
    for (NSInteger i = 0; i < list.count; i ++) {
        UITableView  *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, kScreenHeight) style:UITableViewStylePlain];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.tag = i+1000;
        NSDictionary * dic = [self dic:i];
        tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page=1;
            [self loadData:dic tab:tableview];
        }];
        tableview.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            [self loadData:dic tab:tableview];
        }];
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableview.backgroundColor = [UIColor whiteColor];
        [arr addObject:tableview];
    }
    self.tab_Arr = arr;
    return arr;
}
//我提供的服务
-(NSDictionary *)dic:(NSInteger)i{
    NSDictionary * dic = @{};
    if (i==0) {//待付款
        dic = @{@"1": @0,//订单评论状态
                @"2": @0,//订单支付状态
                @"3": @0//订单状态};
                };
    }else if(i==1){//待接单
        dic = @{@"1": @0,//订单评论状态
                @"2": @1,//订单支付状态
                @"3": @10//订单状态};
                };
    }else if (i==2){//待赴约
        if (_tmpBtn.tag==1) {
            dic = @{@"1": @0,//订单评论状态
                    @"2": @1,//订单支付状态
                    @"3": @15//订单状态};
                    };
        }else{
            dic = @{@"1": @0,//订单评论状态
                    @"2": @1,//订单支付状态
                    @"3": @20//订单状态};
                    };
        }
        
    }else if (i==3){
        if (_tmpBtn.tag==1) {//已赴约
            dic = @{@"1": @0,//订单评论状态
                    @"2": @1,//订单支付状态
                    @"3": @20//订单状态};
                    };
        }else{
            dic = @{@"1": @0,//订单评论状态
                    @"2": @1,//订单支付状态
                    @"3": @30//订单状态};
                    };
        }
    }else if (i==4){//待评价
        if (_tmpBtn.tag==1) {
            dic = @{@"1": @0,//订单评论状态
                    @"2": @1,//订单支付状态
                    @"3": @30//订单状态};
                    };
        }else{
            dic = @{@"1": @1,//订单评论状态
                    @"2": @1,//订单支付状态
                    @"3": @50//订单状态};
                    };
        }
        
    }else if (i==5){//已完成
        dic = @{@"1": @1,//订单评论状态
                @"2": @1,//订单支付状态
                @"3": @50//订单状态};
                };
    }
    return dic;
}
#pragma mark - delegate
- (void)scrollThroughIndex:(NSInteger)index {
}
- (void)selectedIndex:(NSInteger)index {
    _currentIndex = index;
    _page = 1;
    [self.data_Arr removeAllObjects];
    UITableView * tab = self.tab_Arr[index];
    NSDictionary * dic = [self dic:index];
    [self loadData:dic tab:tab];
}
- (IBAction)btn_Click:(UIButton *)sender {
    [self.pageView removeFromSuperview];
    [self.data_Arr removeAllObjects];
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
