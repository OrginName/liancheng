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
#import "EditAllController.h"
#import "FKGPopOption.h"
#import "TakePhoto.h"
#define leftCellIdentifier @"leftCellIdentifier"
@interface ResumeController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tab_bottom;
@property (nonatomic,strong) SDCycleScrollView * cycleScrollView;
@property (nonatomic,strong) NSMutableArray * CollArr;//工作经历
@property (nonatomic,strong) NSMutableArray * EduArr;//教育经历
@property (nonatomic,strong) NSMutableArray * lunArr;//轮播图数组
@property (nonatomic,strong) UIButton * MaskBtn;
@end

@implementation ResumeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"个人简历";
    [self setUI];
    [self initData];
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
#pragma mark --各种点击事件---
-(void)NOPicClick{
    __block ResumeController * weakSelf = self;
    [[TakePhoto sharedPhoto] sharePicture:^(UIImage *image) {
        [weakSelf.lunArr addObject:image];
        [[weakSelf.tab_bottom.tableHeaderView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [weakSelf initScroll];
    }];
}
//导航栏完成按钮点击
-(void)complete{
    
}
//编辑轮播图
-(void)EditScroll:(UIButton *)sender{
    _cycleScrollView.autoScroll = NO;
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CGRect frame = [sender convertRect:sender.bounds toView:window];
    
    FKGPopOption *s = [[FKGPopOption alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    s.option_mutiple = 0.25;
    s.option_optionContents = @[@"新增", @"编辑", @"删除"];
    // 使用链式语法直接展示 无需再写 [s option_show];
    [[s option_setupPopOption:^(NSInteger index, NSString *content) {
        if (index==0) {
            [[TakePhoto sharedPhoto] sharePicture:^(UIImage *image) {
                if (self.lunArr.count==0) {
                    [self.lunArr addObject:image];
                    [[self.tab_bottom.tableHeaderView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    [self initScroll];
                }else{
                    [self.lunArr addObject:image];
                    self.cycleScrollView.localizationImagesGroup = self.lunArr;
                    [self.cycleScrollView reload];
                }
            }];
        }else{
            self.flagTag = index;
        }
    } whichFrame:frame animate:YES] option_show];
    s.block=^(){
        self.cycleScrollView.autoScroll = YES;
    };
}
#pragma mark - tableView 数据源代理方法 -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section!=3&&section!=4) {
        return 1;
    }else if(section==3){
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
    }else if (indexPath.section ==1||indexPath.section==5||indexPath.section==2){
        return 50;
    }else if(indexPath.section==3){
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
    if (indexPath.section==4&&indexPath.row!=0&&indexPath.row!=self.EduArr.count+1) {
        cell.Mo = self.EduArr[indexPath.row-1];
    }
    if (indexPath.section==3&&indexPath.row!=0&&indexPath.row!=self.CollArr.count+1) {
        cell.Mo = self.CollArr[indexPath.row-1];
    }    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __block ResumeController * weakSelf  = self;
    if ((indexPath.section==3&&indexPath.row==self.CollArr.count+1)) {
        GuardCollController * guard = [GuardCollController new];
        guard.title = @"新增工作经历";
        guard.block = ^(ResumeMo * mo){
            [weakSelf.CollArr addObject:mo];
            [weakSelf.tab_bottom reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:guard animated:YES];
    }else if((indexPath.section==4&&indexPath.row==self.EduArr.count+1)){
        GuardEduController * guard = [GuardEduController new];
        guard.title = @"新增教育经历";
        guard.block = ^(ResumeMo * mo){
            [weakSelf.EduArr addObject:mo];
            [weakSelf.tab_bottom reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:guard animated:YES];
    }if (indexPath.section==5) {
         ResumeCell * cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:5]];
        EditAllController * edit = [EditAllController new];
        edit.block= ^(NSString *EditStr){
            cell.lab_MyselfProW.text = EditStr;
        };
        edit.receiveTxt = cell.lab_MyselfProW.text;
        [self.navigationController pushViewController:edit animated:YES];
    }
}
#pragma mark ---SDCycleScrollViewDelegate-----
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (self.lunArr.count==0) {
        [YTAlertUtil showTempInfo:@"暂无轮播图无法编辑,请点击添加按钮"];
        return;
    }
//    轮播图点击
    switch (self.flagTag) {
        case 1:
            {
                [[TakePhoto sharedPhoto] sharePicture:^(UIImage *image) {
                    [self.lunArr replaceObjectAtIndex:index withObject:image];
                    [self reloadScro];
                }];
            }
            break;
        case 2:
            {
                [self.lunArr removeObjectAtIndex:index];
                [self reloadScro];
            }
            break;
        default:
            break;
    }
    
}
-(void)reloadScro{
    self.cycleScrollView.localizationImagesGroup = self.lunArr;
    [self.cycleScrollView reload];
}
#pragma mark ---initUI--------
-(void)initRightItem{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(complete) image:@"" title:@"完成" EdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}
-(void)initScroll{
    __block ResumeController * weakSelf = self;
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.tab_bottom.width, 220) imageURLStringsGroup:nil]; // 模拟网络延时情景
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.delegate = self;
    _cycleScrollView.autoScroll = YES;
    _cycleScrollView.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"no-pic"];
    if (self.lunArr.count==0) {
        self.tab_bottom.tableHeaderView = self.MaskBtn;
    }else
        self.tab_bottom.tableHeaderView = _cycleScrollView;
    //                     --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _cycleScrollView.localizationImagesGroup = weakSelf.lunArr;
    });
    
    UIButton * EditBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    EditBtn.frame = CGRectMake(self.tab_bottom.width-40, 20, 30, 30);
    [EditBtn setBackgroundImage:[UIImage imageNamed:@"edit-people"] forState:UIControlStateNormal];
    [EditBtn addTarget:self action:@selector(EditScroll:) forControlEvents:UIControlEventTouchUpInside];
    [self.tab_bottom.tableHeaderView addSubview:EditBtn];
}
-(NSMutableArray *)lunArr{
    if (!_lunArr) {
        _lunArr = [[NSMutableArray alloc] init];
    }
    return _lunArr;
}
-(UIButton *)MaskBtn{
    if (!_MaskBtn) {
        _MaskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _MaskBtn.frame =CGRectMake(0, 0, self.tab_bottom.width, 220);
        [_MaskBtn setBackgroundImage:[UIImage imageNamed:@"no-pic"] forState:UIControlStateNormal];
        [_MaskBtn addTarget:self action:@selector(NOPicClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _MaskBtn;
}

@end
