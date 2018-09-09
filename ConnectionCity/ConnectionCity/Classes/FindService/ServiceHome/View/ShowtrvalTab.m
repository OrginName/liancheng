//  ShowtrvalTab.m
//  ConnectionCity
//  Created by umbrella on 2018/5/31.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
#import "ShowtrvalTab.h"
#import "SDCycleScrollView.h"
#import "ShowTrvalCell.h"
#import "AppointmentController.h"
#import "AllDicMo.h"
#import "StarEvaluator.h"
#import "CustomImageScro.h"
#import "CustomScro.h"
#import "FriendCircleController.h"
@interface ShowtrvalTab()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,ShowTrvalCellDelegate,CustomScroDelegate>
{
    CustomScro * _scr;
}
@property (nonatomic,strong) SDCycleScrollView * cycleScrollView;
@property (nonatomic,strong) NSMutableArray * lunArr;//轮播图数组
@property (nonatomic,strong) UITableView * tab_Bottom;
@property (nonatomic,strong) UIViewController * control;
@property (nonatomic,strong) UIButton * Save_Like;
@property (nonatomic,strong) UIButton * btn_Like;
@property (nonatomic,assign) NSInteger flag;
@end
@implementation ShowtrvalTab
-(instancetype)initWithFrame:(CGRect)frame withControl:(UIViewController *)control{
    if (self = [super initWithFrame:frame]) {
        self.control = control;
        [self initScroll];
        [self addSubview:self.tab_Bottom];
        self.JNIndex = 0;
    }
    return self;
}
-(void)setMo:(UserMo *)Mo{
    _Mo  = Mo;
    [self.lunArr removeAllObjects];
    ServiceListMo * list = Mo.serviceList[self.JNIndex];
    for (NSString * url in [list.images componentsSeparatedByString:@";"]) {
        if (url.length!=0) {
            [self.lunArr addObject:url];
        }
    }
    if ([list.likeCount intValue]>0) {
        self.btn_Like.selected = YES;
    }
    [self.btn_Like setTitle:[list.likeCount description] forState:UIControlStateNormal];
    _flag = 0;
}

-(void)setMoTrval:(trvalMo *)MoTrval{
    _MoTrval  = MoTrval;
    for (NSString * url in [MoTrval.images componentsSeparatedByString:@";"]) {
        if (url.length!=0) {
            [self.lunArr addObject:url];
        }
    }
    if ([MoTrval.likeCount intValue]>0) {
        self.btn_Like.selected = YES;
    }
    [self.btn_Like setTitle:[MoTrval.likeCount description] forState:UIControlStateNormal];
    _flag = 1;
}
#pragma mark ---SDCycleScrollViewDelegate-----
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}
#pragma mark --UITableviewDelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 4;
    }else if (section==2){
        return 1;
    }else if(section==3){
        if (self.Mo!=nil) {
            return [self.Mo.serviceList[_JNIndex] commentList].count;
        }else{
            return self.MoTrval.comments.count;
        }
    }else{
        if (self.Mo!=nil) {
            ServiceListMo * list = self.Mo.serviceList[_JNIndex];
            return list.property.length!=0?[[YSTools stringToJSON:list.property] count]:0;
        }else{
            return 0;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row == 0 ) {
            return 65;
        }else if(indexPath.row==3){
            if ((self.Mo!=nil&&[self.Mo.serviceList[self.JNIndex] serviceCircleList].count==0)||(self.MoTrval!=nil&&self.MoTrval.serviceCircleList.count==0)) {
                return 40;
            }else{
                return (kScreenWidth-68)/4+45;
            }
        }else{
            if (indexPath.row==2&&self.Mo==nil) {
                return 0;
            }
            return 40;
        }
    }else if (indexPath.section==2){
        if (self.Mo!=nil) {
            float hidth = [YSTools cauculateHeightOfText:[self.Mo.serviceList[self.JNIndex] introduce] width:kScreenWidth-40 font:13];
            return 200+hidth;
        }else{
            float hidth = [YSTools cauculateHeightOfText:self.MoTrval.introduce width:kScreenWidth-40 font:13];
             return 170+hidth;
        }
    }else if(indexPath.section==3){
        if (self.Mo!=nil) {
            commentList * com =[self.Mo.serviceList[self.JNIndex] commentList][indexPath.row];
            return com.cellHeight;
        }else{
            comments * com = self.MoTrval.comments[indexPath.row];
           return com.cellHeight;
        }
    }else{
        if (self.Mo!=nil) {
            ServiceListMo * list = self.Mo.serviceList[_JNIndex];
            return [YSTools cauculateHeightOfText:list.propertyNameArr[indexPath.row] width:kScreenWidth-40 font:14]+40;
        }else{
            return 0;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==3) {
        return 50;
    }else if(section==2){
        return 0;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==3) {
        ShowTrvalCell * cell = [[NSBundle mainBundle] loadNibNamed:@"ShowTrvalCell" owner:nil options:nil][4];
        StarEvaluator * ev = [[StarEvaluator alloc] initWithFrame:CGRectMake(0, 9, 140, 40)];
        ev.animate = NO;
        if (self.Mo!=nil) {
            ev.currentValue = [[self.Mo.serviceList[self.JNIndex]score] floatValue]/2;
        }else{
            ev.currentValue = [self.MoTrval.score floatValue]/2;
        }
        [cell.viewStar addSubview:ev];
        return cell;
    } else {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tab_Bottom.width, 10)];
        view.backgroundColor = YSColor(238, 238, 238);
        return view;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] init];
    return footView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowTrvalCell *cell = [ShowTrvalCell tempTableViewCellWith:tableView indexPath:indexPath];
    cell.delegate = self;
    if (indexPath.section==0&&indexPath.row==1) {
        NSMutableArray * arr = [NSMutableArray array];
        if (self.Mo!=nil) {
            arr = [self loadA:self.Mo.isSkillAuth b:self.Mo.isMobileAuth c:self.Mo.isIdentityAuth d:self.Mo.isCompanyAuth];
        }else{
            arr = [self loadA:self.MoTrval.user.isSkillAuth b:self.MoTrval.user.isMobileAuth c:self.MoTrval.user.isIdentityAuth d:self.MoTrval.user.isCompanyAuth];
        }
        
        CustomImageScro * img = [[CustomImageScro alloc] initWithFrame:CGRectMake(0, 0, cell.view_RZ.width, cell.view_RZ.height) arr:[arr copy]];
        [cell.view_RZ addSubview:img];
    }
    if (indexPath.section==0&&indexPath.row==2) {
        if (!_scr) {
            _scr = [[CustomScro alloc] initWithFrame:CGRectMake(0, 0, cell.view_JNB.width, cell.view_JNB.height) arr:self.Mo.JNArr flag:NO];
            _scr.delegate = self;
            _scr.isShowLine = YES;
            [cell.view_JNB addSubview:_scr];
        }
    }
    if (indexPath.section==0||indexPath.section==2) {
        cell.JNIndexReceive = self.JNIndex;
        cell.list = self.Mo;
        cell.trval = self.MoTrval;
        
    }else if(indexPath.section==3){
        if (self.Mo!=nil) {
            cell.commen = [self.Mo.serviceList[self.JNIndex]commentList][indexPath.row];
        }else{
            cell.commentrval = self.MoTrval.comments[indexPath.row];
        }
    }else{
        if (self.Mo!=nil) {
            cell.propertyName = [self.Mo.serviceList[self.JNIndex] propertyNameArr][indexPath.row];
            cell.typeName = [self.Mo.serviceList[self.JNIndex] typeNameArr][indexPath.row];
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==3) {
            FriendCircleController * friend = [FriendCircleController new];
        friend.user = self.Mo!=nil?self.Mo:self.MoTrval.user;
            [self.control.navigationController pushViewController:friend animated:YES];
    }
}
-(NSMutableArray *)loadA:(NSString *)a b:(NSString *)b c:(NSString *)c d:(NSString *)d{
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
    if ([d isEqualToString:@"1"]) {
        [arr addObject:@"our-rz-p"];
    }
    return arr;
}
//ShowTrvalCellDelegate
-(void)btnClick:(NSInteger)tag{
    AppointmentController * appoint = [AppointmentController new];
    appoint.str =_flag==0?@"YD":@"trval";
    appoint.user = self.Mo;
    appoint.list = self.Mo.serviceList[self.JNIndex];
    appoint.trval = self.MoTrval;
    [self.control.navigationController pushViewController:appoint animated:YES];
}
- (void)CustomScroBtnClick:(UIButton *)tag{
    self.JNIndex = tag.tag-1;
    [self setMo:self.Mo];
    self.cycleScrollView.imageURLStringsGroup = self.lunArr;
    [self.tab_Bottom reloadData];
    [self.cycleScrollView reload];
} //声明协议方法
#pragma mark ---initUI--------
-(void)initScroll{
    __block ShowtrvalTab * weakSelf = self;
    SDCycleScrollView * cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imageURLStringsGroup:nil]; // 模拟网络延时情景
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.delegate = self;
    cycleScrollView.autoScroll = YES;
    cycleScrollView.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    cycleScrollView.placeholderImage = [UIImage imageNamed:@"no-pic"];
    self.cycleScrollView = cycleScrollView;
    self.tab_Bottom.tableHeaderView = cycleScrollView;
    //--- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView.imageURLStringsGroup = weakSelf.lunArr;
    });
    [cycleScrollView addSubview:self.btn_Like];
    [cycleScrollView addSubview:self.Save_Like];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.tab_Bottom.frame = CGRectMake(0, 0, kScreenWidth-20, self.frame.size.height);
    self.cycleScrollView.frame = CGRectMake(0, 0, self.tab_Bottom.width, self.tab_Bottom.width*0.8);
}
-(UITableView *)tab_Bottom{
    if (!_tab_Bottom) {
        _tab_Bottom = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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
//#warning 收藏按钮选中和未选中图片记得更换
//-(UIButton *)Save_Like{
//    if (!_Save_Like) {
//        _Save_Like = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-60, 60, 30, 40)];
//        _Save_Like.backgroundColor = [UIColor whiteColor];
//        _Save_Like.layer.cornerRadius = 5;
//        [_Save_Like setImage:[UIImage imageNamed:@"s-praise"] forState:UIControlStateNormal];
//        [_Save_Like setImage:[UIImage imageNamed:@"s-praise1"] forState:UIControlStateSelected];
//        _Save_Like.titleLabel.font = [UIFont systemFontOfSize:13];
//        [_Save_Like setTitle:@"12" forState:UIControlStateNormal];
//        [_Save_Like setTitleColor:YSColor(181, 181, 181) forState:UIControlStateNormal];
//        [_Save_Like setTitleColor:YSColor(251, 159, 14) forState:UIControlStateSelected];
//        [_Save_Like addTarget:self action:@selector(SaveClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_Save_Like layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:2];
//    }
//    return _Save_Like;
//}
//点赞按钮点击
-(void)likeClick:(UIButton *)sender{
    NSMutableArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:KAllDic]];
    AllContentMo * mo = [arr[5] contentArr][1];
    NSString * str = @"";
    if (self.Mo!=nil) {
        str = [self.Mo.serviceList[self.JNIndex] ID];
    }else
        str = self.MoTrval.ID;
    [YSNetworkTool POST:v1CommonCommentAddlike  params:@{@"typeId":@([str integerValue]),@"type":@([mo.value integerValue])} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        sender.selected = !sender.selected;
        [sender setTitle:[NSString stringWithFormat:@"%@",responseObject[@"data"]] forState:UIControlStateNormal];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
//收藏按钮点击
//-(void)SaveClick:(UIButton *)sender{
//    sender.selected = !sender.selected;
//}
-(UIButton *)btn_Like{
    if (!_btn_Like) {
        _btn_Like = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-60, 10, 30, 40)];
        _btn_Like.backgroundColor = [UIColor whiteColor];
        _btn_Like.layer.cornerRadius = 5;
        [_btn_Like setImage:[UIImage imageNamed:@"s-praise"] forState:UIControlStateNormal];
        [_btn_Like setImage:[UIImage imageNamed:@"s-praise1"] forState:UIControlStateSelected];
        _btn_Like.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btn_Like setTitle:@"1" forState:UIControlStateNormal];
        [_btn_Like setTitleColor:YSColor(181, 181, 181) forState:UIControlStateNormal];
        [_btn_Like setTitleColor:YSColor(251, 159, 14) forState:UIControlStateSelected];
        [_btn_Like addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btn_Like layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:2];
    }
    return _btn_Like;
}
@end
