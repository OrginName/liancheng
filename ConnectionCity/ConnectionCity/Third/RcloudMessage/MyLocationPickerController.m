//
//  MyLocationPickerController.m
//  ConnectionCity
//
//  Created by qt on 2018/9/2.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "MyLocationPickerController.h"
#import "CustomMap.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
@interface MyLocationPickerController ()<CustomMapDelegate,UITableViewDelegate,UITableViewDataSource,CustomLocationDelegate,AMapSearchDelegate,RCLocationPickerViewControllerDelegate>
{
    NSInteger _index;
}
@property (nonatomic,strong) AMapSearchAPI * search;
@property (nonatomic,strong) AMapPOIAroundSearchRequest *request;
@property (weak, nonatomic) IBOutlet UIView *view_Map;
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@property (nonatomic,strong) CustomMap *cusMap;
@property (nonatomic,strong) NSMutableArray * poiAnnotations;
@end

@implementation MyLocationPickerController

- (void)viewDidLoad {
//    [super viewDidLoad];
    [self setUI];
    self.poiAnnotations = [NSMutableArray array];
//    self.delegate = self;
}
- (void)SendClick{
    AMapPOI * poi = self.poiAnnotations[_index];
    CLLocationCoordinate2D cla = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
    self.cusMap.btn_location.hidden = YES;
    UIImage * image = [self screenShotView:self.cusMap];
    UIImage * image1 = [self thumbnailWithImage:image size:CGSizeMake(200, 100)];
    RCLocationMessage* message = [RCLocationMessage messageWithLocationImage:image1
     
                                       location:cla
     
                                   locationName:poi.name];
    [[RCIM sharedRCIM] sendMessage:self.flag targetId:self.ID content:message pushContent:nil pushData:nil success:^(long messageId) {
    } error:^(RCErrorCode nErrorCode, long messageId) {
    }];
     [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUI{
    self.cusMap = [[CustomMap alloc] initWithFrame:self.view_Map.frame];
    self.cusMap.delegate = self;
    [self.view_Map addSubview:self.cusMap];
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    self.request = [[AMapPOIAroundSearchRequest alloc] init];
    /* 按照距离排序. */
    self.request.sortrule            = 0;
    self.request.requireExtension    = YES;
    [self.search AMapPOIAroundSearch:self.request];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(SendClick) image:@"" title:@"发送" EdgeInsets:UIEdgeInsetsZero];
    self.tab_Bottom.allowsMultipleSelectionDuringEditing = YES;
    _index = 0;
}
- (void)currentMapLocation:(NSDictionary *)locationDictionary location:(CLLocation*)location{
    self.request.location            = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    [self.search AMapPOIAroundSearch:self.request];
}
-(void)dragCenterLocation:(CLLocationCoordinate2D)location{
    self.request.location            = [AMapGeoPoint locationWithLatitude:location.latitude longitude:location.longitude];
    [self.search AMapPOIAroundSearch:self.request];
}
/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    [self.poiAnnotations removeAllObjects];
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        [self.poiAnnotations addObject:obj];
        [self.tab_Bottom reloadData];
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.poiAnnotations.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.row==_index) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }
    AMapPOI * poi = self.poiAnnotations[indexPath.row];
    cell.textLabel.text = poi.name;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 取消前一个选中的，就是单选啦
    //_index设为全局变量出初始化为－1，
    NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:_index inSection:0];
    UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:lastIndex];
    lastCell.accessoryType = UITableViewCellAccessoryNone;
    
    // 选中操作
    UITableViewCell *cell = [tableView  cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    //
    //    // 保存选中的行
    _index = indexPath.row;
    //afterDelay为延迟多少删除上次的选中效果
    [self.tab_Bottom performSelector:@selector(deselectRowAtIndexPath:animated:) withObject:lastIndex afterDelay:.0];
}

-(UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize
{
    
    UIImage *newimage;
    
    if (nil == image) {
        
        newimage = nil;
        
    }
    
    else{
        
        UIGraphicsBeginImageContext(asize);
        
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }
    
    return newimage;
    
}
// 对指定视图进行截图
- (UIImage *)screenShotView:(UIView *)view
{
    UIImage *imageRet = nil;
    
    if (view)
    {
        if(&UIGraphicsBeginImageContextWithOptions)
        {
            UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
        }
        else
        {
            UIGraphicsBeginImageContext(view.frame.size);
        }
        
        //获取图像
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        imageRet = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }else{
    }
    
    return imageRet;
}
@end
