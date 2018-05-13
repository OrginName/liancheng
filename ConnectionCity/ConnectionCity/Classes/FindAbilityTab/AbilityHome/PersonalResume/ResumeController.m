//
//  ResumeController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/12.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ResumeController.h"
#import "ResumeCell.h"
#import "SDCycleScrollView.h"
#import "GuardCollController.h"
#import "GuardEduController.h"
#import "ResumeMo.h"
#define leftCellIdentifier @"leftCellIdentifier"
@interface ResumeController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tab_bottom;
@property (nonatomic,strong) SDCycleScrollView * cycleScrollView;
@property (nonatomic,strong) NSMutableArray * CollArr;
@property (nonatomic,strong) NSMutableArray * EduArr;
@end

@implementation ResumeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"个人简历";
    [self setUI];
    [self initData];
}
//导航栏完成按钮点击
-(void)complete{
    
}
//添加UI
-(void)setUI{
    [self initRightItem];
    [self initScroll];
}
-(void)initData{
    self.CollArr = [[NSMutableArray alloc] init];
    self.EduArr = [[NSMutableArray alloc] init];
}
#pragma mark - tableView 数据源代理方法 -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section!=2&&section!=3) {
        return 1;
    }else if(section==2){
        return self.CollArr.count+2;
    }else{
        return self.EduArr.count+2;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 100;
    }else if (indexPath.section ==1||indexPath.section==4||indexPath.section==5){
        return 50;
    }else if(indexPath.section==2){
        if (indexPath.row==0||indexPath.row==self.CollArr.count+1) {
            return 45;
        }else{
            return 90;
        }
    }else{
        if (indexPath.row==0||indexPath.row==self.EduArr.count+1) {
            return 45;
        }else{
            return 90;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ResumeCell *cell = [ResumeCell tempTableViewCellWith:tableView indexPath:indexPath withCollArr:self.CollArr withEduArr:self.EduArr];
    if (indexPath.section==3&&indexPath.row!=0&&indexPath.row!=self.EduArr.count+1) {
        cell.Mo = self.EduArr[indexPath.row-1];
    }
    if (indexPath.section==2&&indexPath.row!=0&&indexPath.row!=self.CollArr.count+1) {
        cell.Mo = self.CollArr[indexPath.row-1];
    }    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __block ResumeController * weakSelf  = self;
    if ((indexPath.section==2&&indexPath.row==self.CollArr.count+1)) {
        GuardCollController * guard = [GuardCollController new];
        guard.title = @"新增工作经历";
        guard.block = ^(ResumeMo * mo){
            [weakSelf.CollArr addObject:mo];
            [weakSelf.tab_bottom reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:guard animated:YES];
    }else if((indexPath.section==3&&indexPath.row==self.EduArr.count+1)){
        GuardEduController * guard = [GuardEduController new];
        guard.title = @"新增教育经历";
        guard.block = ^(ResumeMo * mo){
            [weakSelf.EduArr addObject:mo];
            [weakSelf.tab_bottom reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:guard animated:YES];
    }
}
#pragma mark ---SDCycleScrollViewDelegate-----
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
//    轮播图点击
}
#pragma mark ---initUI--------
-(void)initRightItem{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(complete) image:@"" title:@"完成" EdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}
-(void)initScroll{
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.tab_bottom.width, 220) imageURLStringsGroup:nil]; // 模拟网络延时情景
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.delegate = self;
    _cycleScrollView.autoScroll = YES;
    _cycleScrollView.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"placeholder"];
    self.tab_bottom.tableHeaderView = _cycleScrollView;
    //                     --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _cycleScrollView.imageURLStringsGroup = @[@"http://down.laifudao.com/tupian/2016117134645.jpg",@"http://img15.3lian.com/2015/f2/136/d/63.jpg",@"http://scimg.jb51.net/allimg/160702/103-160F2132353V9.jpg"];
    });
    
    UIButton * EditBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    EditBtn.frame = CGRectMake(self.tab_bottom.width-40, 20, 25, 25);
    [EditBtn setBackgroundImage:[UIImage imageNamed:@"index-Release"] forState:UIControlStateNormal];
    [self.tab_bottom.tableHeaderView addSubview:EditBtn];
}



@end
