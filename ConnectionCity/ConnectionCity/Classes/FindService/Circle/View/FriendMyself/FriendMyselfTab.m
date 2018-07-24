//
//  FriendMyselfTab.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FriendMyselfTab.h"
#import "FindMySelfCell.h"
#import "privateUserInfoModel.h"
#import "SendMomentController.h"
#import "CircleNet.h"
#import "Moment.h"
@interface FriendMyselfTab()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _page;
}
@property (nonatomic,strong)UIImageView * headImage;
@property (nonatomic,strong) UIViewController * controller;
@property (nonatomic,strong) NSMutableArray * data_Arr;
@property (nonatomic,strong)  NSMutableArray * data;
@end
@implementation FriendMyselfTab
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withControll:(UIViewController *)control{
    if (self = [super initWithFrame:frame style:style]) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.data_Arr = [NSMutableArray array];
        self.delegate = self;
        self.dataSource = self;
        self.tableHeaderView = self.headImage;
        self.rowHeight = 86;
        self.controller = control;
        [self initData];
         _page = 1;
        self.data = [NSMutableArray array];
    }
    return self;
}
//初始化数据
-(void)initData{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page=1;
        [self loadDataFriendList];
    }];
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataFriendList];
    }];
    [self.mj_header beginRefreshing];
}
//加载朋友圈列表
-(void)loadDataFriendList{
    if ([self.flagStr isEqualToString:@"HomeMySelf"]) {
        
        NSDictionary * dic = @{
                               @"pageNumber": @(_page),
                               @"pageSize": @15
                               };
        [CircleNet requstHomeCirclelDic:dic withSuc:^(NSMutableArray *successArrValue) {
            if (_page==1) {
                [self.data removeAllObjects];
                [self.data_Arr removeAllObjects];
            }
            _page++;
            [self.mj_header endRefreshing];
            [self.mj_footer endRefreshing];
            [self jsonDataArr:successArrValue];
        } FailErrBlock:^(NSError *failValue) {
            [self.mj_header endRefreshing];
            [self.mj_footer endRefreshing];
        }];
    }else{
        NSDictionary * dic = @{
                               @"containsImage": @0,
                               @"containsVideo": @0,
                               @"pageNumber": @(_page),
                               @"pageSize": @15
                               };
        [CircleNet requstCirclelDic:dic flag:@"Friend" withSuc:^(NSMutableArray *successArrValue) {
            if (_page==1) {
                [self.data removeAllObjects];
                [self.data_Arr removeAllObjects];
            }
            _page++;
            [self.mj_header endRefreshing];
            [self.mj_footer endRefreshing];
            //        [self.data_Arr addObjectsFromArray:successArrValue];
            [self jsonDataArr:successArrValue];
            //        [KUserDefults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.data_Arr] forKey:@"VIDEO"];
            //        [self reloadData];
        }FailErrBlock:^(NSError *failValue) {
            [self.mj_header endRefreshing];
            [self.mj_footer endRefreshing];
        }];
    }
  
}
-(void)jsonDataArr:(NSMutableArray *)arr{
    [self.data_Arr removeAllObjects];
    // 获取代表公历的NSCalendar对象
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags
                                          fromDate:dt];
    // 获取各时间字段的数值
    NSLog(@"现在是%ld年" , comp.year);
    for (int i=0; i<arr.count; i++) {
        Moment * moment = arr[i];
        NSString * year = [moment.createTime componentsSeparatedByString:@"-"][0];
        if (self.data&&self.data.count!=0) {
            for (int j=0; j<self.data.count; j++) {
                if ([self.data[j] isKindOfClass:[NSDictionary class]]&&[[self.data[j] allKeys][0] isEqualToString:year]) {
                    [self.data[j][year] addObject:moment];
                }else{
                    NSMutableArray * arr3 = [NSMutableArray array];
                    [arr3 addObject:moment];
                    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObject:arr3 forKey:year];
                    [self.data addObject:dic];
                }
            }
        }else{
            NSMutableArray * arr3 = [NSMutableArray array];
            [arr3 addObject:moment];
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObject:arr3 forKey:year];
            [self.data addObject:dic];
        }
    }
    [self.data_Arr addObjectsFromArray:[self.data copy]];
    [self reloadData];
    NSLog(@"%lu",(unsigned long)self.data.count);
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data_Arr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary * dic = self.data_Arr[section]; 
    return [dic[[dic allKeys][0]] count];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    FindMySelfCell * cell1 = (FindMySelfCell *)cell;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FindMySelfCell * cell = [FindMySelfCell tempTableViewCellWith:tableView indexPath:indexPath];
    [self bringSubviewToFront:[self.tableHeaderView viewWithTag:11111111]];
    NSDictionary * dic = self.data_Arr[indexPath.section];
    cell.moment = dic[[dic allKeys][0]][indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 78;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    FindMySelfCell * cell = [[NSBundle mainBundle] loadNibNamed:@"FindMySelfCell" owner:nil options:nil][0];
    UIButton * btn = [[UIButton alloc] initWithFrame:cell.frame];
    btn.tag = section;
    [btn addTarget:self action:@selector(SectionClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btn];
    if (section!=0) {
         NSDictionary * dic = self.data_Arr[section];
        cell.image_photo.hidden = YES;
        cell.lab_Time.text = [dic allKeys][0];
        cell.lab_Time.font = [UIFont systemFontOfSize:20];
        cell.lab_Time.textColor = [UIColor blackColor];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SendMomentController * send = [SendMomentController new];
    send.title = @"编辑";
    WeakSelf
    send.block = ^{
        _page = 1;
        [weakSelf.mj_header beginRefreshing];
    };
    send.receive_flag = @"EDIT";
    send.flagStr = self.flagStr;
    NSDictionary * dic = self.data_Arr[indexPath.section];
    Moment * moment = dic[[dic allKeys][0]][indexPath.row];
    if ([self.flagStr isEqualToString:@"HomeMySelf"]){
        moment.containsImage = @"1";
    }
    send.receive_Moment = moment;
    [self.controller.navigationController pushViewController:send animated:YES];
}
#pragma mark ----SectionClick-----
-(void)SectionClick:(UIButton *)btn{
    if (btn.tag==0) {
        SendMomentController * send = [SendMomentController new];
        send.title = @"服务圈";
        send.flagStr = @"HomeSend";
        send.block = ^{
            [self.mj_header beginRefreshing];
        };
        [self.controller.navigationController pushViewController:send animated:YES];
    }
}
-(UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, 250)];
        privateUserInfoModel * userInfo = [YSAccountTool userInfo];
        [_headImage sd_setImageWithURL:[NSURL URLWithString:userInfo.backgroundImage] placeholderImage:[UIImage imageNamed:@"2"]];
        UIImageView * image1 = [[UIImageView alloc] initWithFrame:CGRectMake(_headImage.width-70, _headImage.height-25, 50, 50)];
        [image1 sd_setImageWithURL:[NSURL URLWithString:userInfo.headImage] placeholderImage:[UIImage imageNamed:@"no-pic"]];
        image1.layer.cornerRadius = 25;
        image1.layer.masksToBounds = YES;
        [_headImage addSubview:image1];
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(image1.x-40, image1.y, 100, 25)];
        lab.text = userInfo.nickName;
        lab.textColor = YSColor(55, 21, 17);
        lab.font = [UIFont systemFontOfSize:14];
        [_headImage addSubview:lab];
    }
    return _headImage;
}
@end
