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

@interface ReleaseTenderController ()<LCDatePickerDelegate,JFCityViewControllerDelegate,PhotoSelectDelegate>
{
    NSInteger currtenTag;
    CGFloat itemHeigth;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 发票cell title数据源数组 */
@property (nonatomic, copy) NSArray<NSString *> *cellTitles;
/** 发票cell TextField placeHold数据源数组 */
@property (nonatomic, strong) NSMutableArray<NSString *> *cellPlaceHolds;
@property (nonatomic, strong) LCDatePicker * myDatePick;

@end

@implementation ReleaseTenderController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setTableView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup
-(void)setUI {
    self.navigationItem.title = @"发布招标";
    _cellTitles = @[@"项目标题", @"项目单位", @"招标所在地", @"开标地点", @"招标内容", @"",@"报名/投标时间",@"投标截止时间",@"招标金额",@"联系人",@"联系电话"];
    _cellPlaceHolds = [NSMutableArray arrayWithArray:@[@"请填写项目标题", @"请填写项目单位", @"请选择所在地", @"请填写开标地点", @"请填写招标内容",@"", @"请选择开始时间",@"请选择截止时间",@"请填写金额万元",@"请填写联系人姓名",@"请填写联系电话"]];
    if (!_cellCntentText) {
        _cellCntentText = [NSMutableArray arrayWithArray:@[@"", @"", @"", @"", @"",@"", @"",@"",@"",@"",@""]];
    }
    [self initDate];
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
    [self.view addSubview:self.myDatePick];
    if (!_Arr_Url) {
        self.Arr_Url = [NSMutableArray array];
    }
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 11;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReleaseTenderCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"ReleaseTenderCell"];
    ReleaseTenderAdditionalCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"ReleaseTenderAdditionalCell"];
    if (indexPath.row == 5) {
        itemHeigth = (kScreenWidth-70) / 3+10;
        self.photo = [[PhotoSelect alloc] initWithFrame:CGRectMake(0, 0, cell2.photoBgView.width, cell2.photoBgView.height) withController:self];
        self.photo.backgroundColor = [UIColor whiteColor];
        self.photo.PhotoDelegate = self;
        self.photo.allowTakeVideo = YES;
        self.photo.maxCountTF = 3;
        self.photo.maxCountForRow = 3;
        [cell2.photoBgView addSubview: self.photo];
        
        
        for (int i=0; i<self.Arr_Url.count; i++) {
            if ([self.Arr_Url[i] length]!=0) {
                [self.photo.selectedPhotos addObject:self.Arr_Url[i]];
                [self.photo.selectedAssets addObject:@{@"name":self.Arr_Url[i],@"filename":@"image"}];
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
        JFCityViewController * jf= [JFCityViewController new];
        jf.delegate = self;
        BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:jf];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        return;
    }else if (indexPath.row==6){
        currtenTag = indexPath.row;
        [self.myDatePick animateShow];
        return;
    }else if (indexPath.row==7){
        currtenTag = indexPath.row;
        [self.myDatePick animateShow];
        return;
    }
    
    if(indexPath.row!=5){
        EditAllController * edit = [EditAllController new];
        WeakSelf
        edit.block = ^(NSString * str){
            if (indexPath.row==8) {
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
    if (indexPath.row == 5) {
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
    self.cellCntentText[2] = name;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}
-(void)cityMo:(CityMo *)mo{
    self.citymo = mo;
}
-(void)city:(NSString *)name ID:(NSString *)ID lat:(NSString *)lat lng:(NSString *)lng {
    CityMo *mo = [[CityMo alloc]init];
    mo.name = name;
    mo.ID = ID;
    mo.lat = lat;
    mo.lng = lng;
    self.citymo = mo;
}

#pragma mark ----PhotoSelectDelegate-----
-(void)selectImageArr:(NSArray *)imageArr{
    NSLog(@"%lu",(unsigned long)imageArr.count);
    self.imageArr = imageArr;

}
-(void)selectImage:(UIImage *) image arr:(NSArray *)imageArr{
    NSLog(@"%lu",(unsigned long)imageArr.count);
    self.imageArr = imageArr;
    
}
-(void)deleteImage:(NSInteger) tag arr:(NSArray *)imageArr{
    NSLog(@"%lu",(unsigned long)imageArr.count);
    self.imageArr = imageArr;
}
#pragma mark - 点击事件
- (void)nextBtnClick:(UIButton *)btn {
    for (int i=0; i<self.cellCntentText.count; i++) {
        NSString *str = self.cellCntentText[i];
        if ([YSTools dx_isNullOrNilWithObject:str] && i!=5) {
            [YTAlertUtil showTempInfo:@"请将信息填写完整"];
            return;
        }
    }
    if (self.imageArr.count!=0) {
        [YTAlertUtil showHUDWithTitle:@"正在上传"];
    }else{
        [YTAlertUtil showTempInfo:@"请上传招标附件"];
        return;
    }
    __block int flag = 0;
    WeakSelf
    for (int i=0; i<self.imageArr.count; i++) {
        [[QiniuUploader defaultUploader] uploadImageToQNFilePath:self.imageArr[i] withBlock:^(NSDictionary *url) {
            flag++;
            [weakSelf.Arr_Url addObject:[NSString stringWithFormat:@"%@%@",QINIUURL,url[@"hash"]]];
            if (flag == weakSelf.imageArr.count) {
                [YTAlertUtil hideHUD];
                weakSelf.cellCntentText[5] = [weakSelf.Arr_Url componentsJoinedByString:@","];
                ZBJFViewController *zbjfVC = [[ZBJFViewController alloc]init];
                zbjfVC.cellCntentText = weakSelf.cellCntentText;
                zbjfVC.zbjeStr = weakSelf.cellCntentText[8];
                zbjfVC.mo = weakSelf.citymo;
                [weakSelf.navigationController pushViewController:zbjfVC animated:YES];
            }
        }];
    }
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
