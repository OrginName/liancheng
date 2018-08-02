//
//  ShowResumeTab.m
//  ConnectionCity
//
//  Created by qt on 2018/5/16.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
#import "ShowResumeTab.h"
#import "SDCycleScrollView.h"
#import "ShowResumeCell.h"
#import "ShowResume1.h"
#import "CustomImageScro.h"
#define SHOWCELL @"SHOWCELL"
@interface ShowResumeTab()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) SDCycleScrollView * cycleScrollView;
@property (nonatomic,strong) NSMutableArray * lunArr;//轮播图数组
@property (nonatomic,strong) UITableView * tab_Bottom;
@property (nonatomic,strong) NSMutableDictionary * dict;
@property (nonatomic,strong) NSMutableArray * data_Arr;
@property (nonatomic,strong) ShowResume1 * resume;
@end
@implementation ShowResumeTab
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.tab_Bottom];
        [self initScroll];
        [self initData];
    }
    return self;
}
-(void)initData{
    self.data_Arr = [NSMutableArray array];
    self.dict =[[NSMutableDictionary alloc] initWithDictionary:@{@"1":@"NO",@"2":@"NO"}];
}
-(void)setAbilttyMo:(AbilttyMo *)abilttyMo{
    _abilttyMo = abilttyMo;
    for (NSString * url in [abilttyMo.userMo.headImage componentsSeparatedByString:@";"]) {
        if (url.length!=0) {
            [self.lunArr addObject:url];
        }
    }
//    self.lunArr = [[abilttyMo.userMo.headImage componentsSeparatedByString:@";"] mutableCopy];
}
#pragma mark ---SDCycleScrollViewDelegate-----
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}
#pragma mark --UITableviewDelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 3;
    }else if (section==1){
        if ([self.dict[@"1"] isEqualToString:@"NO"]) {
            return self.abilttyMo.workExperienceList.count>0?1:0;
        }
        return self.abilttyMo.workExperienceList.count;
    }else if (section==2){
        if ([self.dict[@"2"] isEqualToString:@"NO"]) {
            return self.abilttyMo.educationExperienceList.count>0?1:0;
        }
        return self.abilttyMo.educationExperienceList.count;
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 110;
        }else if(indexPath.row==2){
           return 80;
        }else{
            return 53;
        }
    }else if(indexPath.section==1||indexPath.section==2){
        return 90;
    }else
        return 112;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1||section==2) {
        return 50;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowResumeCell *cell = [ShowResumeCell tempTableViewCellWith:tableView indexPath:indexPath];
    cell.ability = self.abilttyMo;
    if (indexPath.section==1) {
        if ([self.dict[@"1"] isEqualToString:@"YES"]) {
            cell.work = self.abilttyMo.WorArr[indexPath.row];
            NSLog(@"%@",self.resume.lab_nametitle.text);
            self.resume.imageTurn.transform = CGAffineTransformMakeRotation(M_PI_2);
        }else{
            cell.work = self.abilttyMo.WorArr[0];
            self.resume.imageTurn.transform = CGAffineTransformIdentity;
        }
    }
    if (indexPath.section==0&&indexPath.row==1) {
         NSMutableArray * arr = [self loadA:self.abilttyMo.userMo.isSkillAuth b:self.abilttyMo.userMo.isMobileAuth c:self.abilttyMo.userMo.isIdentityAuth];
        CustomImageScro * img = [[CustomImageScro alloc] initWithFrame:CGRectMake(0, 0, cell.view_RZ.width, cell.view_RZ.height) arr:[arr copy]];
        [cell.view_RZ addSubview:img];
    }
    if (indexPath.section==2) {
        if ([self.dict[@"2"] isEqualToString:@"YES"]) {
            cell.edu = self.abilttyMo.EduArr[indexPath.row];
             self.resume.imageTurn.transform = CGAffineTransformMakeRotation(M_PI_2);
        }else{
            cell.edu = self.abilttyMo.EduArr[0];
             self.resume.imageTurn.transform = CGAffineTransformIdentity;
        }
    }
    return cell;
}
-(NSMutableArray *)loadA:(NSString *)a b:(NSString *)b c:(NSString *)c{
    NSMutableArray * arr = [NSMutableArray array];
    if ([a isEqualToString:@"1"]) {
        [arr addObject:@"our-rz-tec"];
    }
    if ([b isEqualToString:@"1"]) {
        [arr addObject:@"our-rz-phone"];
    }
    if ([c isEqualToString:@"1"]) {
        [arr addObject:@"our-rz-p"];
    }
    return arr;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ShowResume1 * view = [[[NSBundle mainBundle] loadNibNamed:@"ShowResume1" owner:nil options:nil] firstObject];
    view.lab_nametitle.text = section==2?@"教育经历":@"工作经历";
    if (section==1) {
        if ([self.dict[@"1"] isEqualToString:@"NO"]) {
            view.imageTurn.transform = CGAffineTransformIdentity;
        }else{
             view.imageTurn.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
    }else if (section==2){
        if ([self.dict[@"2"] isEqualToString:@"NO"]) {
            view.imageTurn.transform = CGAffineTransformIdentity;
        }else
             view.imageTurn.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    WeakSelf
    view.block = ^{
        if (section==1) {
            if ([weakSelf.dict[@"1"] isEqualToString:@"NO"]) {
                weakSelf.dict[@"1"] = @"YES";
            }else{
                weakSelf.dict[@"1"] = @"NO";
            }
        }else if (section==2){
            if ([weakSelf.dict[@"2"] isEqualToString:@"NO"]) {
                weakSelf.dict[@"2"] = @"YES";
            }else
                weakSelf.dict[@"2"] = @"NO";
        }
        [weakSelf.tab_Bottom reloadData]; 
    };
    return view;
}
#pragma mark ---initUI--------
-(void)initScroll{
    __block ShowResumeTab * weakSelf = self;
    SDCycleScrollView * cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imageURLStringsGroup:nil]; // 模拟网络延时情景
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.delegate = self;
    cycleScrollView.autoScroll = YES;
    cycleScrollView.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    cycleScrollView.placeholderImage = [UIImage imageNamed:@"no-pic"];
    self.cycleScrollView = cycleScrollView;
    self.tab_Bottom.tableHeaderView = cycleScrollView;
    //                --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView.imageURLStringsGroup = weakSelf.lunArr;
    });
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.tab_Bottom.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.cycleScrollView.frame = CGRectMake(0, 0, self.tab_Bottom.width, 220);
}
-(UITableView *)tab_Bottom{
    if (!_tab_Bottom) {
        _tab_Bottom = [[UITableView alloc] init];
        _tab_Bottom.delegate = self;
        _tab_Bottom.dataSource = self;
        _tab_Bottom.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tab_Bottom;
}
-(NSMutableArray *)lunArr{
    if (!_lunArr) {
        _lunArr = [[NSMutableArray alloc] init];
    }
    return _lunArr;
}
@end
