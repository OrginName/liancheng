//
//  BidManageController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/23.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BidManageController.h"
#import "BidManagerCell.h"
#import "BidManagerFootV.h"
#import "BidManagerHeadV.h"
#import "ConsultativeNegotiationController.h"
#import "FirstControllerMo.h"
#import "ReleaseTenderController.h"
#import "CityMo.h"

@interface BidManageController ()<BidManagerCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;

@end

@implementation BidManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setTableView];
    [self addHeaderRefresh];
    [self addFooterRefresh];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    BidManagerHeadV *tableHeadV = [[[NSBundle mainBundle] loadNibNamed:@"BidManagerHeadV" owner:nil options:nil] firstObject];
    tableHeadV.frame = CGRectMake(0, 0, kScreenWidth, 120);
    self.tableView.tableHeaderView = tableHeadV;
    BidManagerFootV *tableFootV = [[[NSBundle mainBundle] loadNibNamed:@"BidManagerFootV" owner:nil options:nil] firstObject];
    tableFootV.frame = CGRectMake(0, 0, kScreenWidth, 90);
    self.tableView.tableFooterView = tableFootV;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup
- (void)setUI {
    self.navigationItem.title = @"招标管理";
    self.dataArr = [[NSMutableArray alloc]init];
}
- (void)setTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"BidManagerCell" bundle:nil] forCellReuseIdentifier:@"BidManagerCell"];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BidManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BidManagerCell"];
    cell.delegate = self;
    cell.model = _dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - BidManagerCellDelegate
- (void)bidManagerCell:(BidManagerCell *)view changeBtnClick:(UIButton *)btn {
    [YTAlertUtil showTempInfo:@"修改"];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:view];
    FirstControllerMo *mo = _dataArr[indexPath.row];
    NSMutableArray *mutArr = [NSMutableArray arrayWithArray:@[
                                                              mo.title,
                                                              mo.company,
                                                              mo.cityName,
                                                              mo.tenderAddress,
                                                              mo.content,
                                                              mo.tenderImages,
                                                              mo.tenderStartDate,
                                                              mo.tenderEndDate,
                                                              mo.amount,
                                                              mo.contactName,
                                                              mo.contactMobile
                                                              ]];
    ReleaseTenderController *releasevc = [[ReleaseTenderController alloc]init];
    releasevc.cellCntentText = mutArr;
//    releasevc.imageArr = [mo.tenderImages componentsSeparatedByString:@","];
    NSArray *arr = [mo.tenderImages componentsSeparatedByString:@","];
    releasevc.Arr_Url = [NSMutableArray arrayWithArray:arr];
//    for (int i=0; i<arr.count; i++) {
//        if ([arr[i] length]!=0) {
//            [releasevc.photo.selectedPhotos addObject:arr[i]];
//            [releasevc.photo.selectedAssets addObject:@{@"name":arr[i],@"filename":@"image"}];
//        }
//    }
    
//    {
//        _isPic = 1;
//        _imageURL = self.receive_Moment.images;
//        NSArray * arr = [self.receive_Moment.images componentsSeparatedByString:@";"];
//        for (int i=0; i<arr.count; i++) {
//            if ([arr[i] length]!=0) {
//                [self.photo.selectedPhotos addObject:arr[i]];
//                [self.photo.selectedAssets addObject:@{@"name":arr[i],@"filename":@"image"}];
//                //                setProperty:ALAssetTypeVideo forKey:ALAssetPropertyType
//                //                [self.photo.selectedAssets[i] setvalueforpr];
//            }
//        }
//    }
    
    
    CityMo *cityMo = [[CityMo alloc]init];
    cityMo.ID = mo.areaCode;
    cityMo.name = mo.cityName;
    cityMo.lat = mo.lat;
    cityMo.lng = mo.lng;
    releasevc.citymo = cityMo;
    [self.navigationController pushViewController:releasevc animated:YES];
    
//    NSDictionary *dic = @{
//                          @"amount": self.cellCntentText[8],
//                          @"areaCode": self.mo?self.mo.ID:@"",
//                          @"company": self.cellCntentText[1],
//                          @"contactMobile": self.cellCntentText[10],
//                          @"contactName": self.cellCntentText[9],
//                          @"content": self.cellCntentText[4],
//                          @"depositAmount": mo20.data,
//                          @"industryCategoryId": @"0",
//                          @"industryCategoryName": @"string",
//                          @"industryCategoryParentId": @"0",
//                          @"industryCategoryParentName": @"string",
//                          @"lat": self.mo?self.mo.lat:@"",
//                          @"lng": self.mo?self.mo.lng:@"",
//                          @"periodAmount1": mo0.data,
//                          @"periodAmount2": mo1.data,
//                          @"periodAmount3": mo2.data,
//                          @"periodAmount4": mo3.data,
//                          @"periodAmount5": mo4.data,
//                          @"rewardAmount1": mo0.data,
//                          @"rewardAmount2": mo1.data,
//                          @"rewardAmount3": mo2.data,
//                          @"rewardAmount4": mo3.data,
//                          @"rewardAmount5": mo4.data,
//                          @"tenderAddress": self.cellCntentText[3],
//                          @"tenderEndDate": self.cellCntentText[7],
//                          @"tenderImages": self.cellCntentText[5],
//                          @"tenderStartDate": self.cellCntentText[6],
//                          @"title": self.cellCntentText[0],
//                          };
//    _cellPlaceHolds = [NSMutableArray arrayWithArray:@[@"请填写项目标题", @"请填写项目单位", @"请选择所在地", @"请填写开标地点", @"请填写招标内容",@"", @"请选择开始时间",@"请选择截止时间",@"请填写金额万元",@"请填写联系人姓名",@"请填写联系电话"]];

}
- (void)bidManagerCell:(BidManagerCell *)view deleteBtnClick:(UIButton *)btn {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:view];
    FirstControllerMo *mo = _dataArr[indexPath.row];
    [self v1TalentTenderDelete:@{@"id": mo.modelId}];
}
- (void)bidManagerCell:(BidManagerCell *)view negotiationBtnClick:(UIButton *)btn {
    ConsultativeNegotiationController *xsyjVC = [[ConsultativeNegotiationController alloc]init];
    [self.navigationController pushViewController:xsyjVC animated:YES];
}
#pragma mark - 接口请求
- (void)addHeaderRefresh {
    __weak typeof(self) weakSelf = self;
    [YSRefreshTool addRefreshHeaderWithView:self.tableView refreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [strongSelf getHeaderData];
    }];
    [YSRefreshTool beginRefreshingWithView:self.tableView];
}
- (void)addFooterRefresh {
    __weak typeof(self) weakSelf = self;
    [YSRefreshTool addRefreshFooterWithView:self.tableView refreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.page ++;
        [strongSelf getFooterData];
    }];
}
- (void)getHeaderData {
    NSDictionary *dic = @{
                          @"areaCode": @"",
                          @"cityCode": @"",
                          @"industryCategoryId":@"",
                          @"maxDate": @"",
                          @"minDate": @"",
                          @"pageNumber": [NSString stringWithFormat:@"%ld",(long)_page],
                          @"pageSize": @"10",
                          @"provinceCode": @""
                          };
    
    WeakSelf
    [YSNetworkTool POST:v1TalentTenderMyPage params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        [weakSelf.dataArr removeAllObjects];
        weakSelf.dataArr = [FirstControllerMo mj_objectArrayWithKeyValuesArray:responseObject[kData][@"content"]];
        [weakSelf.tableView reloadData];
        [YSRefreshTool endRefreshingWithView:self.tableView];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [YSRefreshTool endRefreshingWithView:self.tableView];
    }];
}
- (void)getFooterData {
    NSDictionary *dic = @{
                          @"areaCode": @"",
                          @"cityCode": @"",
                          @"industryCategoryId":@"",
                          @"maxDate": @"",
                          @"minDate": @"",
                          @"pageNumber": [NSString stringWithFormat:@"%ld",(long)_page],
                          @"pageSize": @"10",
                          @"provinceCode": @""
                          };
    
    WeakSelf
    [YSNetworkTool POST:v1TalentTenderMyPage params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        for (FirstControllerMo *mo in [FirstControllerMo mj_objectArrayWithKeyValuesArray:responseObject[kData][@"content"]]) {
            [weakSelf.dataArr addObject:mo];
        }
        [weakSelf.tableView reloadData];
        [YSRefreshTool endRefreshingWithView:self.tableView];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [YSRefreshTool endRefreshingWithView:self.tableView];
    }];
}

- (void)v1TalentTenderDelete:(NSDictionary *)dic {
    WeakSelf
    [YSNetworkTool POST:v1TalentTenderDelete params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        [YSRefreshTool beginRefreshingWithView:weakSelf.tableView];
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
