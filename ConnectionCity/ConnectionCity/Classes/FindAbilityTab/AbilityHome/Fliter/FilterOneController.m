//
//  FilterOneController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/11.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FilterOneController.h"
#import "FilterCell.h"
#import "FilterLayout.h"
#import "CustomButton.h"
#import "ServiceHomeNet.h"
#import "UIView+Geometry.h"
#import "AbilityNet.h"
static NSString *ID = @"cityCollectionViewCell";
static NSString * collectionCellIndentider = @"collectionCellIndentider";
@interface FilterOneController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *bollec_bottom;
@property (nonatomic,strong) NSMutableArray * arrData;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic,strong)NSMutableArray * data_Arr;
@property (nonatomic,strong) FilterLayout * flowLyout;
@property (nonatomic,strong) FooterView * foot;
@property (nonatomic,strong) NSMutableDictionary * dic;
@end

@implementation FilterOneController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self initData];
    self.dic = [NSMutableDictionary dictionary];
}
-(void)initData{
    if (self.flag_SX ==1) {
        [ServiceHomeNet requstConditions:^(NSMutableArray *successArrValue) {
            self.data_Arr = successArrValue;
            [self loadData:successArrValue];
            self.dic = [[NSMutableDictionary alloc] initWithDictionary:@{@"0":@"all",@"1":@"0",@"2":@"0",@"3":@"0",@"10":@"0"}];
        } withFailBlock:^(NSString *failValue) {
            
        }];
    }else if (self.flag_SX ==2){
        //    加载筛选条件数据
        [AbilityNet requstAbilityConditions:^(NSMutableArray *successArrValue) {
            self.data_Arr = successArrValue;
            [self loadData:successArrValue];
            self.dic = [[NSMutableDictionary alloc] initWithDictionary:@{@"0":@"1",@"1":@"0",@"2":@"1",@"10":@"1"}];
        }];
    }else{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SX" ofType:@"plist"];
        NSMutableArray * arr = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        [self loadData:arr];
    }
}
-(void)setUI{
    self.bollec_bottom.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.bollec_bottom.contentInset = UIEdgeInsetsMake(0, 0, 81, 0);
    self.flowLyout = [[FilterLayout alloc] init];
    _bollec_bottom.collectionViewLayout = self.flowLyout;
    [_bollec_bottom registerClass:[FilterCell class] forCellWithReuseIdentifier:ID];
    //自定义重用视图 FilterCollecFooterRuesuableView
    [self.bollec_bottom registerClass:[FilterCollecRuesuableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionCellIndentider];
    [self setBotomView];
    
}
-(void)setBotomView{
    self.foot = [[FooterView alloc] initWithFrame:CGRectMake(0, self.bollec_bottom.bottom-(self.flag_SX ==1?31:81), self.bollec_bottom.width, 81)];
    [self.bollec_bottom addSubview:self.foot];
}
//底部重置确定按钮点击
- (IBAction)ResetSureClick:(UIButton *)sender {
    if (sender.tag==1) {
        [self loadData:self.data_Arr];
        self.foot.tmpBtn.selected = NO;
        CustomButton * btn = (CustomButton *)[self.foot viewWithTag:1000];
        btn.selected = YES;
        self.foot.tmpBtn = btn;
    }else{

        [[self.bollec_bottom subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UICollectionViewCell class]]) {
                FilterCell * cell = (FilterCell *)obj;
                NSIndexPath * index = [self.bollec_bottom indexPathForCell:cell];
                NSDictionary * dic = _dataArr[index.section][index.row];
                if (cell.selected) {
                    [self.dic setObject:dic[@"ID"] forKey:KString(@"%ld", index.section)];
                }
            }
        }];
        if (self.foot.tmpBtn.tag==1000) {
            [self.dic setObject:KString(@"%d", 1) forKey:KString(@"%d", 10)];
        }else if (self.foot.tmpBtn.tag==1001){
            [self.dic setObject:KString(@"%d", 0) forKey:KString(@"%d", 10)];
        }
//        NSArray * arr = [self.bollec_bottom indexPathsForSelectedItems];
        NSLog(@"当前的筛选条件是:%@",self.dic);
        self.block(self.dic);
        [self.navigationController popViewControllerAnimated:YES];
       
    }
}

-(void)loadData:(NSMutableArray *)arr{
    self.dataArr = [[NSMutableArray alloc] init];
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SX" ofType:@"plist"];
//    self.arrData = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    self.arrData = arr;
    for (int i=0; i<self.arrData.count; i++) {
        [self.dataArr addObject:self.arrData[i][@"subname"]];
    }
    [_bollec_bottom reloadData];
}
#pragma mark UICollectionViewDataSource 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.arrData[section][@"subname"] count];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.arrData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (indexPath.row < [self.dataArr[indexPath.section] count]) {
        NSDictionary * dic = _dataArr[indexPath.section][indexPath.row];
        [cell configCellWithData:dic];
    }
    cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray * array = [NSMutableArray arrayWithArray:self.dataArr[indexPath.section]];
    for (int i = 0; i < array.count; i++) {
        NSMutableDictionary * dic = [array[i] mutableCopy];
        if (i == indexPath.row) {
            [dic setObject:@"YES" forKey:@"isSelected"];
        } else {
            [dic setObject:@"NO" forKey:@"isSelected"];
        }
        [array replaceObjectAtIndex:i withObject:dic];
    }
    [_dataArr replaceObjectAtIndex:indexPath.section withObject:array];
    [_bollec_bottom reloadData];
    NSLog(@"%@",_dataArr[indexPath.section][indexPath.row]);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        
        FilterCollecRuesuableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionCellIndentider forIndexPath:indexPath];;
        //把想添加的控件放在session区头重用的cell里,并且回来赋值,防止重用(重点!!!!!)
        [headerView getSHCollectionReusableViewHearderTitle:self.arrData[indexPath.section][@"name"]];
        reusableview = headerView;
    }
    return reusableview;
}
@end

#pragma mark -----FilterCollecRuesuableView头部-----
@interface FilterCollecRuesuableView (){
    UILabel *titleLabel;
}

@end

@implementation FilterCollecRuesuableView
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self createBasicView];
    }
    return self;
}
/**
 *  进行基本布局操作,根据需求进行.
 */
-(void)createBasicView{
    titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width, 50)];
    titleLabel.textColor = YSColor(139, 139, 139);
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:titleLabel];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.frame.size.height, self.frame.size.width, 1)];
    view.backgroundColor = YSColor(246, 246, 246);
    [self addSubview:view];
}
/**
 *  设置相应的数据
 *
 *  @param title
 */
-(void)getSHCollectionReusableViewHearderTitle:(NSString *)title{
    titleLabel.text=title;
}
@end
#pragma mark -----FilterCollecRuesuableView尾部-----
@interface FooterView()
@property (nonatomic,strong)CustomButton * btn_All;
@property (nonatomic,strong)CustomButton * btn_onLine;
@end
@implementation FooterView
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self createBasicView];
    }
    return self;
}
/**
 *  进行基本布局操作,根据需求进行.
 */
-(void)createBasicView{
//    1在线 0离线
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, 1)];
    view.backgroundColor = YSColor(246, 246, 246);
    [self addSubview:view];
    CustomButton * btn = [[CustomButton alloc] initWithFrame:CGRectZero];
    [btn setTitle:@"在线" forState:UIControlStateNormal];
    btn.selected = YES;
    _tmpBtn = btn;
    [btn addTarget:self action:@selector(btnClick1:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 1000;
    [self addSubview:btn];
    self.btn_All = btn;
    CustomButton * btn_online = [[CustomButton alloc] initWithFrame:CGRectZero];
    [btn_online setTitle:@"离线" forState:UIControlStateNormal];
    [btn_online addTarget:self action:@selector(btnClick1:) forControlEvents:UIControlEventTouchUpInside];
    btn_online.tag = 1001;
    btn_online.selected = NO;
    [self addSubview:btn_online];
    self.btn_onLine = btn_online;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.btn_All.frame = CGRectMake((kScreenWidth-20)/2-110, 20, 100, 40);
    self.btn_onLine.frame = CGRectMake(self.btn_All.x+120, self.btn_All.y, 100, 40);
}
-(void)btnClick1:(UIButton *)sender{
    CustomButton * btn2 = (CustomButton *)[self viewWithTag:1000];
    if (sender.tag!=1000) {
        btn2.selected = NO;
    }
    if (_tmpBtn == nil){
        sender.selected = YES;
        _tmpBtn = sender;
    }
    else  if (_tmpBtn !=nil &&_tmpBtn == sender){
        sender.selected = YES;
    } else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
    }
}
@end
