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
#import "AbilityNet.h"
#import "QiniuUploader.h"
#define leftCellIdentifier @"leftCellIdentifier"
@interface ResumeController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
{
    NSString * resumeID;//简历ID
}
@property (weak, nonatomic) IBOutlet UITableView *tab_bottom;
@property (nonatomic,strong) SDCycleScrollView * cycleScrollView;
@property (nonatomic,strong) NSMutableArray * CollArr;//工作经历
@property (nonatomic,strong) NSMutableArray * EduArr;//教育经历
@property (nonatomic,strong) NSMutableArray * lunArr;//轮播图数组
@property (nonatomic,strong) UIButton * MaskBtn;
@property (nonatomic,strong) NSMutableArray * Arr_Dic;//选择项数组
@property (nonatomic,strong) NSMutableDictionary * Data_Dic;//填写过的字典
@property (nonatomic,strong) NSDictionary * isOpen;//判断显示一行还是多行
@property (nonatomic,strong) NSMutableArray * data_ArrWork;
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
    resumeID = @"26";
}

-(void)initData{
    self.Data_Dic = [NSMutableDictionary dictionary];
    self.CollArr = [[NSMutableArray alloc] init];
    self.EduArr = [[NSMutableArray alloc] init];
    self.data_ArrWork = [[NSMutableArray alloc] init];
    [YSNetworkTool POST:dictionaryDictionaryAll params:@{} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        self.Arr_Dic = responseObject[@"data"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    self.isOpen = @{@"40":@"NO",@"50":@"NO"};
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
    NSArray * arr = [self.Data_Dic allKeys];
    if (![arr containsObject:@"10"]) {
        return [YTAlertUtil showTempInfo:@"请选择薪资"];
    }
    if (![arr containsObject:@"20"]) {
        return [YTAlertUtil showTempInfo:@"请选择学历"];
    }
    if (![arr containsObject:@"30"]) {
        return [YTAlertUtil showTempInfo:@"请选择工作经验"];
    }
    if (![arr containsObject:@"60"]||([arr containsObject:@"60"]&&![self.Data_Dic[@"60"] isEqualToString:@"1"])) {
        return [YTAlertUtil showTempInfo:@"请同意发布规则"];
    }
    __block NSString * str = @"";
     __block NSInteger flag=0;
    if (self.lunArr.count!=0) {
        [YTAlertUtil showHUDWithTitle:@"正在上传照片"];
        for (int i=0; i<self.lunArr.count; i++) {
            [[QiniuUploader defaultUploader] uploadImageToQNFilePath:self.lunArr[i] withBlock:^(NSDictionary *url) {
                flag++;
                str = [NSString stringWithFormat:@"%@;%@",url[@"hash"],str];
                if (flag==self.lunArr.count) {
                    [YTAlertUtil hideHUD];
                   
                    [self loadData:str];
                }
            }];
        }
    }else{
        [self loadData:@""];
    }
   
}
-(void)loadData:(NSString *)str{
    NSDictionary * dic = @{
                           //                           @"areaCode": @0,
                           @"avatar": str,
                           @"cityCode": @([[KUserDefults objectForKey:kUserCityID]integerValue]),
                           @"educationId": @([self.Data_Dic[@"20"][@"ID"] integerValue]),
                           @"introduce": @"string",
                           @"lat": @([[KUserDefults objectForKey:kLat]floatValue]),
                           @"lng": @([[KUserDefults objectForKey:KLng]floatValue]),
                           //                           @"provinceCode": @0,
                           @"salaryId": @([self.Data_Dic[@"10"][@"ID"] integerValue]),
                           @"workingId": @([self.Data_Dic[@"30"][@"ID"] integerValue])
                           };
    [AbilityNet requstAddResume:dic withBlock:^(NSDictionary *successDicValue) {
        resumeID = KString(@"%@", successDicValue[@"data"]);
    }];
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
    if (section!=4&&section!=5) {
        return 1;
    }else if(section==4){
        return self.CollArr.count+2;
    }else {
        return self.EduArr.count+2;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 100;
    }else if (indexPath.section ==1||indexPath.section==6||indexPath.section==2||indexPath.section==3){
        return 50;
    }else if(indexPath.section==4){
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
    if (indexPath.section==5&&indexPath.row!=0&&indexPath.row!=self.EduArr.count+1) {
            cell.Mo = self.EduArr[indexPath.row-1];
    }
   else if (indexPath.section==4&&indexPath.row!=0&&indexPath.row!=self.CollArr.count+1) {
 
       cell.Mo = self.CollArr[indexPath.row-1];
 
    }
    NSArray * arr = [self.Data_Dic allKeys];
    if ([arr containsObject:[NSString stringWithFormat:@"%ld0",(long)indexPath.section]]) {
        if ([arr containsObject:@"60"]) {
            cell.btnAgree.selected = [self.Data_Dic[@"60"] integerValue];
        }
        cell.txt_salWay.text = self.Data_Dic[KString(@"%ld", indexPath.section)][@"name"];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ResumeCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    __block ResumeController * weakSelf  = self;
    if ((indexPath.section==4&&indexPath.row==self.CollArr.count+1)) {
        if (resumeID.length==0) {
            return [YTAlertUtil showTempInfo:@"请先点击完成新增简历在添加工作经历"];
        }
        GuardCollController * guard = [GuardCollController new];
        guard.title = @"新增工作经历";
        guard.block = ^(ResumeMo * mo){
            [weakSelf.CollArr addObject:mo];
            [weakSelf.tab_bottom reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:UITableViewRowAnimationNone];
        };
        guard.resumeID = resumeID;
        [self.navigationController pushViewController:guard animated:YES];
    }else if((indexPath.section==5&&indexPath.row==self.EduArr.count+1)){
        if (resumeID.length==0) {
            return [YTAlertUtil showTempInfo:@"请先点击完成新增简历在添加教育经历"];
        }
        GuardEduController * guard = [GuardEduController new];
        guard.eduArr = [YSTools stringToJSON:self.Arr_Dic[0][@"content"]];
        guard.title = @"新增教育经历";
        guard.block = ^(ResumeMo * mo){
            [weakSelf.EduArr addObject:mo];
            [weakSelf.tab_bottom reloadSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:guard animated:YES];
    }else if(indexPath.section==2||indexPath.section==1||indexPath.section==3){
        NSString * str = indexPath.section==1?@"17":indexPath.section==2?@"1":@"16";
        NSArray * arr = [NSArray array];
        for (int i=0; i<self.Arr_Dic.count; i++) {
            if ([[self.Arr_Dic[i][@"id"] stringValue] isEqualToString:str]) {
                arr = [YSTools stringToJSON:self.Arr_Dic[i][@"content"]];
            }
        }
        NSMutableArray * title = [NSMutableArray array];
        for (int i=0; i<arr.count; i++) {
            [title addObject:arr[i][@"description"]];
        }
        [YTAlertUtil alertMultiWithTitle:nil message:nil style:UIAlertControllerStyleActionSheet multiTitles:title multiHandler:^(UIAlertAction *action, NSArray *titles, NSUInteger idx) {
            cell.txt_salWay.text = title[idx];
            [self.Data_Dic setObject:@{@"name":title[idx],@"ID":arr[idx][@"value"]} forKey:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
        } cancelTitle:@"取消" cancelHandler:^(UIAlertAction *action) {
            
        } completion:nil];
    }else if (indexPath.section==6){
        cell.btnAgree.selected = !cell.btnAgree.selected;
        [self.Data_Dic setValue:[NSString stringWithFormat:@"%d",cell.btnAgree.selected] forKey:[NSString stringWithFormat:@"%d0",6]];
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
    EditBtn.frame = CGRectMake(kScreenWidth-60, 10, 30, 30);
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
