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
#import "PhotoSelect.h"
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
@property (nonatomic, strong) PhotoSelect * photo;
@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic, strong) NSMutableArray *Arr_Url;

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
    _cellPlaceHolds = [NSMutableArray arrayWithArray:@[@"简单描述招标需求", @"海通物业管理有限公司", @"点选择所在地", @"线上", @"填写招标内容",@"", @"选择开始时间",@"选择截止间",@"填写金额 万元",@"填写联系人姓名",@"填写联系电话"]];
    [self initDate];
}
- (void)setTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"ReleaseTenderCell" bundle:nil] forCellReuseIdentifier:@"ReleaseTenderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReleaseTenderAdditionalCell" bundle:nil] forCellReuseIdentifier:@"ReleaseTenderAdditionalCell"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(38, 9, kScreenWidth - 38*2, 50 - 9*2);
    btn.layer.cornerRadius = 3;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:YSColor(236,95,90)];
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];
    self.tableView.tableFooterView = footView;
}
//创建日期插件
-(void)initDate{
    self.myDatePick = [[LCDatePicker alloc] initWithFrame:kScreen];
    self.myDatePick.delegate  = self;
    [self.view addSubview:self.myDatePick];
    self.Arr_Url = [NSMutableArray array];
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
//        self.photo.backgroundColor = [UIColor redColor];
        [cell2.photoBgView addSubview: self.photo];
        return cell2;
    }else{
        cell1.titleLab.text = _cellTitles[indexPath.row];
        cell1.detailLab.text = _cellPlaceHolds[indexPath.row];
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
            weakSelf.cellPlaceHolds[indexPath.row] = str;
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
    self.cellPlaceHolds[currtenTag] = str;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:currtenTag inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - JFCityViewControllerDelegate
- (void)cityName:(NSString *)name {
    self.cellPlaceHolds[2] = name;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}
-(void)cityMo:(CityMo *)mo{
//    [self requestPrivateUserUpdateWithDic:@{@"areaCode": mo.ID}];
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
    ZBJFViewController *zbjfVC = [[ZBJFViewController alloc]init];
    [self.navigationController pushViewController:zbjfVC animated:YES];
    
    if (self.imageArr.count!=0) {
        [YTAlertUtil showHUDWithTitle:@"正在上传"];
    }
    __block int flag = 0;
    WeakSelf
    for (int i=0; i<self.imageArr.count; i++) {
        [[QiniuUploader defaultUploader] uploadImageToQNFilePath:self.imageArr[i] withBlock:^(NSDictionary *url) {
            flag++;
            [weakSelf.Arr_Url addObject:[NSString stringWithFormat:@"%@%@",QINIUURL,url[@"hash"]]];
            if (flag == weakSelf.imageArr.count) {
                [YTAlertUtil hideHUD];
                /*
                NSDictionary *dic = @{
                                      @"areaCode": [KUserDefults objectForKey:kUserCityID],
                                      @"company": weakSelf.cellPlaceHolds[1],
                                      @"contactMobile": weakSelf.cellPlaceHolds[10],
                                      @"contactName": weakSelf.cellPlaceHolds[9],
                                      @"content": weakSelf.cellPlaceHolds[4],
                                      @"depositAmount": weakSelf.cellPlaceHolds[8],
                                      @"lat": [KUserDefults objectForKey:kLat],
                                      @"lng": [KUserDefults objectForKey:KLng],
                                      @"tenderAddress": weakSelf.cellPlaceHolds[3],
                                      @"tenderEndDate": weakSelf.cellPlaceHolds[7],
                                      @"tenderImages": [weakSelf.Arr_Url componentsJoinedByString:@","],
                                      @"tenderStartDate": weakSelf.cellPlaceHolds[6],
                                      @"title": weakSelf.cellPlaceHolds[0]
                                      };
                [weakSelf v1TalentTenderCreate:dic];
                 */
            }
        }];
    }
}
#pragma mark - 接口请求
- (void)v1TalentTenderCreate:(NSDictionary *)dic{
    WeakSelf
    [YSNetworkTool POST:v1TalentTenderCreate params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [YTAlertUtil alertSingleWithTitle:@"提示" message:responseObject[kMessage] defaultTitle:@"确认" defaultHandler:^(UIAlertAction *action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } completion:nil];
    } failure:nil];
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
