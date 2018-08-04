//
//  ReleaseTenderController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/22.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ReleaseTenderController.h"
#import "ReleaseTenderCell.h"
#import "ReleaseTenderAdditionalCell.h"
#import "EditAllController.h"
#import "LCDatePicker.h"
#import "JFCityViewController.h"
#import "QiniuUploader.h"
#import "ZBJFViewController.h"
#import "PhotoSelect.h"
#import "CityMo.h"
#import "ClassificationsController.h"
#import "AbilityNet.h"

@interface ReleaseTenderController ()<LCDatePickerDelegate,JFCityViewControllerDelegate,PhotoSelectDelegate>
{
    NSInteger currtenTag;
    CGFloat itemHeigth;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray<NSString *> *cellTitles;
@property (nonatomic, strong) NSMutableArray<NSString *> *cellPlaceHolds;
@property (nonatomic, strong) LCDatePicker * myDatePick;
@property (nonatomic, strong) NSMutableArray *cellCntentText;
@property (nonatomic, strong) CityMo *citymo;
@property (nonatomic, strong) PhotoSelect * photo;
@property (nonatomic, strong) NSMutableArray *Arr_Url;
@property (nonatomic, strong) NSMutableArray * arr_Class;
@property (nonatomic, strong) NSString *industryCategoryId;
@property (nonatomic, strong) NSString *industryCategoryName;

@end

@implementation ReleaseTenderController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self initData];
    [self setTableView];
    if ([self.receive_flag isEqualToString:@"EDIT"]) {
        [self initEDITData];
    }else{
        if ([kDefaults objectForKey:@"cellCntentText"]) {
            _cellCntentText = [NSMutableArray arrayWithArray:[kDefaults objectForKey:@"cellCntentText"]];

            NSDictionary *dic = [kDefaults objectForKey:@"citymooo"];
            if (dic) {
                CityMo *mo = [[CityMo alloc]init];
                mo.name = dic[@"cityName"];
                mo.ID = dic[@"cityCode"];
                mo.lat = dic[@"lat"];
                mo.lng = dic[@"lng"];
                self.citymo = mo;
            }
            NSArray * arr = [_cellCntentText[6] componentsSeparatedByString:@";"];
            for (int i=0; i<arr.count; i++) {
                if ([arr[i] length]!=0) {
                    [self.photo.selectedPhotos addObject:arr[i]];
                    [self.Arr_Url addObject:arr[i]];
                    [self.photo.selectedAssets addObject:@{@"name":arr[i],@"filename":@"image",@"flag":@"EDIT"}];
                }
            }
            [self.tableView reloadData];

            
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAll) name:@"REMOVEALL" object:nil];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [kDefaults setObject:_cellCntentText forKey:@"cellCntentText"];
    if (_citymo) {
        if (_citymo.name && _citymo.ID && _citymo.lat && _citymo.lng) {
            [kDefaults setObject:@{@"cityName": _citymo.name,@"cityCode": _citymo.ID,@"lat": _citymo.lat,@"lng": _citymo.lng} forKey:@"citymooo"];
        }
    }
    [kDefaults synchronize];
}
-(void)removeAll{
    [self.Arr_Url removeAllObjects];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - setup
-(void)setUI {
    self.navigationItem.title = @"发布任务";
    _cellTitles = @[@"项目标题", @"项目单位", @"行业分类", @"接单所在地", @"开标地点", @"接单内容", @"",@"报名/抢单时间",@"抢单截止时间",@"接单金额",@"联系人",@"联系电话"];
    _cellPlaceHolds = [NSMutableArray arrayWithArray:@[@"请填写项目标题", @"请填写项目单位", @"请选择行业", @"请选择所在地", @"请填写开标地点", @"请填写接单内容",@"", @"请选择开始时间",@"请选择截止时间",@"请填写金额元",@"请填写联系人姓名",@"请填写联系电话"]];
    _cellCntentText = [NSMutableArray arrayWithArray:@[@"", @"", @"", @"", @"", @"",@"", @"",@"",@"",@"",@""]];
    [self initDate];
}
-(void)initData{
    //self.areaCode = [KUserDefults objectForKey:kUserCityID];
    //加载分类数据
    WeakSelf
    [AbilityNet requstMakeMoneyClass:^(NSMutableArray *successArrValue) {
        weakSelf.arr_Class = successArrValue;
    }];
}
- (void)setTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"ReleaseTenderCell" bundle:nil] forCellReuseIdentifier:@"ReleaseTenderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReleaseTenderAdditionalCell" bundle:nil] forCellReuseIdentifier:@"ReleaseTenderAdditionalCell"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [footView addSubview:bgView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(38, 9, kScreenWidth - 38*2, 50 - 9*2);
    btn.layer.cornerRadius = 3;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:YSColor(236,95,90)];
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    self.tableView.tableFooterView = footView;
}
//创建日期插件
-(void)initDate{
    self.myDatePick = [[LCDatePicker alloc] initWithFrame:kScreen];
    self.myDatePick.delegate  = self;
    self.myDatePick.minDate = [NSDate date];
    [self.view addSubview:self.myDatePick];
    self.Arr_Url = [NSMutableArray array];
}
-(void)initEDITData{
    _cellCntentText = [NSMutableArray arrayWithArray:@[
                                                       self.firstMo.title,
                                                       self.firstMo.company,
                                                       self.firstMo.industryCategoryName,
                                                       self.firstMo.cityName,
                                                       self.firstMo.tenderAddress,
                                                       self.firstMo.content,
                                                       self.firstMo.tenderImages,
                                                       self.firstMo.tenderStartDate,
                                                       self.firstMo.tenderEndDate,
                                                       self.firstMo.amount,
                                                       self.firstMo.contactName,
                                                       self.firstMo.contactMobile
                                                       ]];
    
    CityMo *mo = [[CityMo alloc]init];
    mo.name = self.firstMo.cityName;
    mo.ID = self.firstMo.cityCode;
    mo.lat = self.firstMo.lat;
    mo.lng = self.firstMo.lng;
    self.citymo = mo;
    
    NSArray * arr = [self.firstMo.tenderImages componentsSeparatedByString:@";"];
    for (int i=0; i<arr.count; i++) {
        if ([arr[i] length]!=0) {
            [self.photo.selectedPhotos addObject:arr[i]];
            [self.Arr_Url addObject:arr[i]];
            [self.photo.selectedAssets addObject:@{@"name":arr[i],@"filename":@"image",@"flag":self.receive_flag}];
        }
    }
    [self.tableView reloadData];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellCntentText.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReleaseTenderCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"ReleaseTenderCell"];
    ReleaseTenderAdditionalCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"ReleaseTenderAdditionalCell"];
    if (indexPath.row == 6) {
        itemHeigth = (kScreenWidth-70) / 3+10;
        self.photo = [[PhotoSelect alloc] initWithFrame:CGRectMake(0, 0, cell2.photoBgView.width, cell2.photoBgView.height) withController:self];
        self.photo.backgroundColor = [UIColor whiteColor];
        self.photo.PhotoDelegate = self;
        self.photo.allowTakeVideo = NO;
        self.photo.maxCountTF = 3;
        self.photo.maxCountForRow = 3;
        [cell2.photoBgView addSubview: self.photo];
        
        
        for (int i=0; i<self.Arr_Url.count; i++) {
            if ([self.Arr_Url[i] length]!=0) {
                [self.photo.selectedPhotos addObject:self.Arr_Url[i]];
                [self.photo.selectedAssets addObject:@{@"name":self.Arr_Url[i],@"filename":@"image",@"flag":@"EDIT"}];
            }
        }
        
        return cell2;
    }else{
        cell1.titleLab.text = _cellTitles[indexPath.row];
        cell1.detailLab.placeholder = _cellPlaceHolds[indexPath.row];
        cell1.detailLab.text = _cellCntentText[indexPath.row];
        return cell1;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row==2){
        ClassificationsController * class = [ClassificationsController new];
        class.title = @"行业类型";
        class.arr_Data = self.arr_Class;
        WeakSelf
        class.block = ^(NSString *classifiation){
            
        };
        class.block1 = ^(NSString *classifiationID, NSString *classifiation) {
            weakSelf.industryCategoryId = classifiationID;
            weakSelf.industryCategoryName = classifiation;
            weakSelf.cellCntentText[2] = classifiation;
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:class animated:YES];
        return;
    }else if(indexPath.row==3){
        JFCityViewController * jf= [JFCityViewController new];
        jf.delegate = self;
        BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:jf];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        return;
    }else if (indexPath.row==7){
        currtenTag = indexPath.row;
        [self.myDatePick animateShow];
        return;
    }else if (indexPath.row==8){
        currtenTag = indexPath.row;
        [self.myDatePick animateShow];
        return;
    }
    
    if(indexPath.row!=6){
        EditAllController * edit = [EditAllController new];
        WeakSelf
        edit.block = ^(NSString * str){
            if (indexPath.row==9) {
                str = [NSString stringWithFormat:@"%.2f",[str floatValue]];
            }
            weakSelf.cellCntentText[indexPath.row] = str;
            [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:edit animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 60;
    }else{
        return 10;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row == 6) {
        return 185;
    }else{
        return 50;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //重用区头视图
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (section == 1) {
        if (headerView.subviews.count == 1) {
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
            lab.text = @"最多上传3个,每个不超过10M,支持jpg,png,gif格式";
            lab.font = [UIFont systemFontOfSize:12];
            lab.textColor = [UIColor darkGrayColor];
            lab.textAlignment = NSTextAlignmentCenter;
            [headerView addSubview:lab];
        }
    }
    return headerView;
}
#pragma mark ---LCDatePickerDelegate-----
- (void)lcDatePickerViewWithPickerView:(LCDatePicker *)picker str:(NSString *)str {
    self.cellCntentText[currtenTag] = str;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:currtenTag inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - JFCityViewControllerDelegate
- (void)cityName:(NSString *)name {
    self.cellCntentText[3] = name;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}
-(void)cityMo:(CityMo *)mo{
    self.citymo = mo;
}
-(void)city:(NSString *)name ID:(NSString *)ID lat:(NSString *)lat lng:(NSString *)lng {
    self.cellCntentText[3] = name;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    CityMo *mo = [[CityMo alloc]init];
    mo.name = name;
    mo.ID = ID;
    mo.lat = lat;
    mo.lng = lng;
    self.citymo = mo;
}

#pragma mark ----PhotoSelectDelegate-----
-(void)selectImageArr:(NSArray *)imageArr{
    [self.Arr_Url addObjectsFromArray:imageArr];
}
-(void)selectImage:(UIImage *)image arr:(NSArray *)imageArr{
    [self.Arr_Url addObjectsFromArray:imageArr];
}
-(void)deleteImage:(NSInteger) tag arr:(NSArray *)imageArr{
    [self.Arr_Url removeAllObjects];
    [self.Arr_Url addObjectsFromArray:imageArr];
}
#pragma mark - 点击事件
- (void)nextBtnClick:(UIButton *)btn {
    for (int i=0; i<self.cellCntentText.count; i++) {
        NSString *str = self.cellCntentText[i];
        if ([YSTools dx_isNullOrNilWithObject:str] && i!=6) {
            [YTAlertUtil showTempInfo:@"请将信息填写完整"];
            return;
        }
    }
    
    if ([YSTools initTimerCompare:self.cellCntentText[7] withEndTime:self.cellCntentText[8]]!=2) {
        [YTAlertUtil showTempInfo:@"结束日期不能小于开始日期"];
        return;
    }
    
    BOOL a = [self.receive_flag isEqualToString:@"EDIT"]?YES:NO;
    __block NSString * urlStr = @"";//图片路径拼接
    __block NSInteger index = 0;
    if (self.Arr_Url.count!=0) {
        [YTAlertUtil showHUDWithTitle:a?@"正在更新":@"正在上传图片"];
        for (int i=0; i<self.Arr_Url.count; i++) {
            if ([self.Arr_Url[i] isKindOfClass:[NSString class]]&&[self.Arr_Url[i] containsString:@"http"]) {
                index++;
                urlStr = [NSString stringWithFormat:@"%@;%@",self.Arr_Url[i],urlStr];
                if (index==self.Arr_Url.count) {
                    [YTAlertUtil hideHUD];
                    [self pushVCWhithUrlStr:urlStr];
                }
            }else{
                WeakSelf
                [[QiniuUploader defaultUploader] uploadImageToQNFilePath:self.Arr_Url[i] withBlock:^(NSDictionary *url) {
                    index++;
                    urlStr = [NSString stringWithFormat:@"%@%@;%@",QINIUURL,url[@"hash"],urlStr];
                    if (index==weakSelf.Arr_Url.count) {
                        [YTAlertUtil hideHUD];
                        [weakSelf pushVCWhithUrlStr:urlStr];
                    }
                }];
            }
        }
    }else{
        [YTAlertUtil showTempInfo:@"请上传接单附件"];
    }
}
- (void)pushVCWhithUrlStr:(NSString *)urlStr {
    self.cellCntentText[6] = urlStr;
    ZBJFViewController *zbjfVC = [[ZBJFViewController alloc]init];
    zbjfVC.receive_flag = self.receive_flag;
    zbjfVC.tenderId = self.tenderId;
    zbjfVC.cellCntentText = self.cellCntentText;
    zbjfVC.zbjeStr = self.cellCntentText[9];
    zbjfVC.mo = self.citymo;
    zbjfVC.industryCategoryId = self.industryCategoryId;
    zbjfVC.industryCategoryName = self.industryCategoryName;
    [self.navigationController pushViewController:zbjfVC animated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
