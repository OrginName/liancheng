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
#import "AgreementController.h"
#define leftCellIdentifier @"leftCellIdentifier"
@interface ResumeController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
{
    NSString * resumeID;//简历ID
    NSInteger _currtIndexRow;
}
@property (weak, nonatomic) IBOutlet UITableView *tab_bottom;
@property (nonatomic,strong) SDCycleScrollView * cycleScrollView;
@property (nonatomic,strong) NSMutableArray * CollArr;//工作经历
@property (nonatomic,strong) NSMutableArray * EduArr;//教育经历
@property (nonatomic,strong) NSMutableArray * lunArr;//轮播图数组
@property (nonatomic,strong) UIButton * MaskBtn;
@property (nonatomic,strong) NSMutableArray * Arr_Dic;//选择项数组
@property (nonatomic,strong) NSMutableDictionary * Data_Dic;//填写过的字典
@property (nonatomic,strong) NSMutableDictionary * isOpen;//判断显示一行还是多行
@property (nonatomic,strong) NSMutableArray * data_ArrWork;//工作经历数值
@property (nonatomic,strong) NSMutableArray * data_ArrWdu;//教育经历数值
@end
@implementation ResumeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"合作信息";
    [self setUI];
    [self initData];
}
//添加UI
-(void)setUI{
    [self initRightItem];
    [self initScroll];
    resumeID = @"";
    _currtIndexRow = 0;
}
-(void)initData{
    self.Data_Dic = [NSMutableDictionary dictionary];
    self.CollArr = [[NSMutableArray alloc] init];
    self.EduArr = [[NSMutableArray alloc] init];
    self.data_ArrWork = [[NSMutableArray alloc] init];
    self.data_ArrWdu = [NSMutableArray array];
    [YSNetworkTool POST:dictionaryDictionaryAll params:@{} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        self.Arr_Dic = responseObject[@"data"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    self.isOpen = [[NSMutableDictionary alloc] initWithDictionary:@{@"40":@"NO",@"50":@"NO"}];
    if (self.resume!=nil) {
        resumeID = self.resume.modelId;
        for (educationExperienceListModel * model in self.resume.educationExperienceList) {
            ResumeMo * mo = [ResumeMo new];
            mo.collAndcompany = model.schoolName;
            mo.proAndPro = model.educationName;
            mo.XLAndIntro = model.professionalName;
            mo.satrtTime = model.startDate;
            mo.endTime = model.endDate;
            mo.description1 = model.description1;
            mo.ID = model.ID;
            mo.eduID = model.educationId;
            mo.schoolId = model.schoolId;
            [self.data_ArrWdu addObject:mo];
        }
        for (WorkExperienceListModel * model in self.resume.workExperienceList) {
            ResumeMo * mo = [ResumeMo new];
            mo.collAndcompany = model.companyName;
            mo.XLAndIntro = model.descriptions;
            mo.proAndPro = model.occupationCategoryName.parentName;
            mo.ID = KString(@"%ld", model.modelId);
            mo.satrtTime = model.startDate;
            mo.endTime = model.endDate;
            mo.occupationCategoryId = KString(@"%ld", model.occupationCategoryId);
            [self.data_ArrWork addObject:mo];
        }
        if (self.data_ArrWdu.count!=0) {
            [self.EduArr addObject:self.data_ArrWdu[0]];
        }
        if (self.data_ArrWork.count!=0) {
            [self.CollArr addObject:self.data_ArrWork[0]];
        }
        NSArray * imgArr = [self.resume.avatar componentsSeparatedByString:@";"];
        __block int i=0;
        WeakSelf
        [imgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * urlStr = (NSString *)obj;
            urlStr = [NSString stringWithFormat:@"%@%@",urlStr,BIGTU];
            if (urlStr.length!=0) {
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:urlStr] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    
                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    i++;
                    if (![YSTools dx_isNullOrNilWithObject:image]) {
                        [weakSelf.lunArr addObject:image];
                    }
                    if (i==imgArr.count) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (weakSelf.lunArr.count!=0) {
                                [[weakSelf.tab_bottom.tableHeaderView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                                [weakSelf initScroll];
                            }
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                weakSelf.cycleScrollView.localizationImageNamesGroup = weakSelf.lunArr;
                                [weakSelf.cycleScrollView reload];
                            });
                        });
                    }
                }];
            }
        }];
        [self.Data_Dic setObject:@{@"name":self.resume.salaryName,@"ID":KString(@"%ld", self.resume.salaryId)} forKey:@"10"];
        [self.Data_Dic setObject:@{@"name":self.resume.educationName,@"ID":KString(@"%ld", self.resume.educationId)} forKey:@"20"];
        [self.Data_Dic setObject:@{@"name":self.resume.workingName,@"ID":KString(@"%ld", (long)self.resume.workingId)} forKey:@"30"];
        [self.Data_Dic setObject:self.resume.introduce forKey:@"60"];
        [self.tab_bottom reloadData];
    }
    [self.Data_Dic setObject:@"1" forKey:@"70"];
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
    if (![arr containsObject:@"70"]||([arr containsObject:@"70"]&&![self.Data_Dic[@"70"] isEqualToString:@"1"])) {
        return [YTAlertUtil showTempInfo:@"请阅读并同意发布规则"];
    }
    if (![arr containsObject:@"60"]) {
        return [YTAlertUtil showTempInfo:@"请输入自我介绍"];
    }
    __block NSString * str = @"";
    __block NSInteger flag=0;
    [YTAlertUtil showHUDWithTitle:self.resume!=nil?@"正在更新简历": @"正在创建简历"];
    if (self.lunArr.count!=0) {
        for (int i=0; i<self.lunArr.count; i++) {
            if (([self.lunArr[i] isKindOfClass:[NSString class]])&& [self.lunArr[i] containsString:@"http"]) {
                flag++;
                str = [NSString stringWithFormat:@"%@%@",self.lunArr[i],str];
                if (flag==self.lunArr.count) {
                    [self loadData:str];
                }
            }else{
                [[QiniuUploader defaultUploader] uploadImageToQNFilePath:self.lunArr[i] withBlock:^(NSDictionary *url) {
                    flag++;
                    str = [NSString stringWithFormat:@"%@%@;%@",QINIUURL,url[@"hash"],str];
                    if (flag==self.lunArr.count) {
                        [self loadData:str];
                    }
                }];
            }
        }
    }else{
        [self loadData:@""];
    }
    
}
-(void)loadData:(NSString *)str{
    NSDictionary * dic = @{
                           @"avatar": str,
                           @"cityCode": @([[KUserDefults objectForKey:kUserCityID]integerValue]),
                           @"educationId": @([self.Data_Dic[@"20"][@"ID"] integerValue]),
                           @"introduce": self.Data_Dic[@"60"],
                           @"lat": @([[KUserDefults objectForKey:kLat]floatValue]),
                           @"lng": @([[KUserDefults objectForKey:KLng]floatValue]),
                           @"salaryId": @([self.Data_Dic[@"10"][@"ID"] integerValue]),
                           @"workingId": @([self.Data_Dic[@"30"][@"ID"] integerValue]),
                           @"resumeId":resumeID
                           };
    if (self.resume!=nil) {
        [YSNetworkTool POST:v1TalentResumeUpdate params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
            [YTAlertUtil hideHUD];
            [YTAlertUtil showTempInfo:@"简历更新成功"];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else{
        [AbilityNet requstAddResume:dic  withBlock:^(NSDictionary *successDicValue) {
            [YTAlertUtil hideHUD];
            [YTAlertUtil showTempInfo:@"简历创建成功"];
            resumeID = KString(@"%@", successDicValue[@"data"]);
        }];
    }
    
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
                    self.cycleScrollView.localizationImageNamesGroup = self.lunArr;
                }else{
                    [self.lunArr addObject:image];
                    self.cycleScrollView.localizationImageNamesGroup = self.lunArr;
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
        if ([self.isOpen[@"40"] isEqualToString:@"NO"]) {
            return self.CollArr.count>0?3:2;
        }else
            return self.CollArr.count+2;
        
    }else if(section==5){
        if ([self.isOpen[@"50"] isEqualToString:@"NO"]) {
            return self.EduArr.count>0?3:2;
        }else
            return self.EduArr.count+2;
    }else{
        return 0;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 8;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 100;
    }else if (indexPath.section ==1||indexPath.section==6||indexPath.section==2||indexPath.section==3||indexPath.section==7){
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
        if ([self.isOpen[@"50"] isEqualToString:@"NO"]&&self.EduArr.count!=0) {
            if (self.EduArr.count>0) {
                cell.Mo = self.EduArr[0];
            }
            cell.imageISNo.transform = CGAffineTransformIdentity;
        }else
        {
            cell.Mo = self.EduArr[indexPath.row-1];
            cell.imageISNo.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
    }
    else if (indexPath.section==4&&indexPath.row!=0&&indexPath.row!=self.CollArr.count+1) {
        if ([self.isOpen[@"40"] isEqualToString:@"NO"]&&self.CollArr.count!=0) {
            if (self.CollArr.count>0) {
                cell.Mo = self.CollArr[0];
            }
            cell.imageISNo.transform = CGAffineTransformIdentity;
        }else{
            cell.Mo = self.CollArr[indexPath.row-1];
            cell.imageISNo.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
    }
    if (_resume!=nil) {
        cell.image_edit.hidden = NO;
    }
    NSArray * arr = [self.Data_Dic allKeys];
    NSString * idnex = [NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row];
    if ([arr containsObject:[NSString stringWithFormat:@"%ld0",(long)indexPath.section]]) {
        if ([idnex isEqualToString:@"70"]) {
            cell.btnAgree.selected = [self.Data_Dic[@"70"] integerValue];
        }
        else if ([idnex isEqualToString:@"60"]) {
            cell.lab_MyselfProW.text = self.Data_Dic[@"60"];
        }else{
            cell.txt_salWay.text = self.Data_Dic[idnex][@"name"];
        }
    }
    WeakSelf
    cell.block = ^(NSInteger flag) {
        [weakSelf.Data_Dic setValue:[NSString stringWithFormat:@"%ld",(long)flag] forKey:@"70"];
    };
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ResumeCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    WeakSelf
    if (indexPath.section==4&&indexPath.row==0) {
        if ([self.isOpen[@"40"] isEqualToString:@"NO"]) {
            self.isOpen[@"40"] = @"YES";
            cell.imageISNo.transform = CGAffineTransformMakeRotation(M_PI_2);
            [self.CollArr removeAllObjects];
            [self.CollArr addObjectsFromArray:[self.data_ArrWork copy]];
        }else{
            self.isOpen[@"40"] = @"NO";
            if (self.data_ArrWork.count!=0) {
                [self.CollArr removeAllObjects];
                [self.CollArr addObject:self.data_ArrWork[0]];
            }
            cell.imageISNo.transform = CGAffineTransformIdentity;
        }
        [self.tab_bottom reloadData];
    }
    if (indexPath.section==5&&indexPath.row==0) {
        if ([self.isOpen[@"50"] isEqualToString:@"NO"]) {
            self.isOpen[@"50"] = @"YES";
            cell.imageISNo.transform = CGAffineTransformMakeRotation(M_PI_2);
            [self.EduArr removeAllObjects];
            [self.EduArr addObjectsFromArray:[self.data_ArrWdu copy]];
        }else{
            self.isOpen[@"50"] = @"NO";
            cell.imageISNo.transform = CGAffineTransformIdentity;
            if (self.data_ArrWdu.count!=0) {
                [self.EduArr removeAllObjects];
                [self.EduArr addObject:self.data_ArrWdu[0]];
            }
        }
        [self.tab_bottom reloadData];
    }
    if ((indexPath.section==4&&indexPath.row==self.CollArr.count+1)) {
        if (resumeID.length==0) {
            return [YTAlertUtil showTempInfo:@"请先点击完成新增简历在添加工作经历"];
        }
        GuardCollController * guard = [GuardCollController new];
        guard.title = @"新增工作经历";
        guard.block = ^(ResumeMo * mo){
            [weakSelf.data_ArrWork addObject:mo];
            [weakSelf.CollArr removeAllObjects];
            [weakSelf.CollArr  addObjectsFromArray:[weakSelf.data_ArrWork copy]];
            weakSelf.isOpen[@"40"] = @"YES";
            [weakSelf.tab_bottom reloadData];
        };
        guard.resumeID = resumeID;
        [self.navigationController pushViewController:guard animated:YES];
    }else if((indexPath.section==5&&indexPath.row==self.EduArr.count+1)){
        //        resumeID = @"18";
        if (resumeID.length==0) {
            return [YTAlertUtil showTempInfo:@"请先点击完成新增简历在添加教育经历"];
        }
        GuardEduController * guard = [GuardEduController new];
        guard.eduArr = [YSTools stringToJSON:self.Arr_Dic[0][@"content"]];
        guard.title = @"新增教育经历";
        guard.block = ^(ResumeMo * mo){
            [weakSelf.data_ArrWdu addObject:mo];
            [self loadArr];
        };
        guard.resumeID = resumeID;
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
    }else if (indexPath.section==7){
//        cell.btnAgree.selected = !cell.btnAgree.selected;
//        [self.Data_Dic setValue:[NSString stringWithFormat:@"%d",cell.btnAgree.selected] forKey:@"70"];
        AgreementController *agreementVC = [[AgreementController alloc]init];
        agreementVC.alias = serviceAgreement;
        [self.navigationController pushViewController:agreementVC animated:YES];
    }else if (indexPath.section==6){
        EditAllController * edit  = [EditAllController new];
        edit.receiveTxt = cell.lab_MyselfProW.text;
        edit.block = ^(NSString *EditStr) {
            cell.lab_MyselfProW.text = EditStr;
            [self.Data_Dic setObject:EditStr forKey:@"60"];
        };
        [self.navigationController pushViewController:edit animated:YES];
    }else if (indexPath.section==4&&indexPath.row!=0&&indexPath.row!=self.CollArr.count+1){
        GuardCollController * guard = [GuardCollController new];
        guard.mo = self.CollArr[indexPath.row-1];
        guard.resumeID=resumeID;
        guard.block2 = ^{
            [weakSelf.data_ArrWork removeObjectAtIndex:(_currtIndexRow-1)];
            [self loadArr1];
        };
        guard.block1 = ^(ResumeMo *Mo) {
            [weakSelf.data_ArrWork replaceObjectAtIndex:(_currtIndexRow-1) withObject:Mo];
            [self loadArr1];
        };
        guard.title = @"编辑合作介绍";
        _currtIndexRow = indexPath.row;
        [self.navigationController pushViewController:guard animated:YES];
        
    }else if (indexPath.section==5&&indexPath.row!=0&&indexPath.row!=self.EduArr.count+1){
        GuardEduController * guard = [GuardEduController new];
        guard.mo = self.EduArr[indexPath.row-1];
        guard.title = @"编辑教育经历";
        guard.resumeID =resumeID;
        guard.block2 = ^{
            [weakSelf.data_ArrWdu removeObjectAtIndex:(_currtIndexRow-1)];
            [self loadArr];
        };
        guard.block1 = ^(ResumeMo *Mo) {
            [weakSelf.data_ArrWdu replaceObjectAtIndex:(_currtIndexRow-1) withObject:Mo];
            [self loadArr];
        };
        _currtIndexRow = indexPath.row;
        [self.navigationController pushViewController:guard animated:YES];
    }
}
-(void)loadArr1{
    WeakSelf
    [weakSelf.CollArr removeAllObjects];
    [weakSelf.CollArr  addObjectsFromArray:[weakSelf.data_ArrWork copy]];
    weakSelf.isOpen[@"40"] = @"YES";
    [weakSelf.tab_bottom reloadData];
}
-(void)loadArr{
    WeakSelf
    [weakSelf.EduArr removeAllObjects];
    [weakSelf.EduArr  addObjectsFromArray:[weakSelf.data_ArrWdu copy]];
    weakSelf.isOpen[@"50"] = @"YES";
    [weakSelf.tab_bottom reloadData];
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
    self.cycleScrollView.localizationImageNamesGroup = self.lunArr;
    [self.cycleScrollView reload];
}
#pragma mark ---initUI--------
-(void)initRightItem{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(complete) image:@"" title:@"完成" EdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}
-(void)initScroll{
    //    __block ResumeController * weakSelf = self;
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.tab_bottom.width, self.tab_bottom.width*0.8) imageURLStringsGroup:nil]; // 模拟网络延时情景
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.delegate = self;
    _cycleScrollView.autoScroll = YES;
//    _cycleScrollView.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"no-pic"];
    if (self.lunArr.count==0) {
        self.tab_bottom.tableHeaderView = self.MaskBtn;
    }else
        self.tab_bottom.tableHeaderView = _cycleScrollView;
    //                     --- 模拟加载延迟
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        _cycleScrollView.localizationImagesGroup = weakSelf.lunArr;
    //    });
    
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

