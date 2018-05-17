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
static NSString *ID = @"cityCollectionViewCell";
static NSString * collectionCellIndentider = @"collectionCellIndentider";
@interface FilterOneController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *bollec_bottom;
@property (nonatomic,strong) NSMutableArray * arrData;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic,strong) FilterLayout * flowLyout;
@property (nonatomic,strong) FooterView * foot;
@end

@implementation FilterOneController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self loadData];
}
-(void)setUI{
    self.bollec_bottom.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.flowLyout = [[FilterLayout alloc] init];
    _bollec_bottom.collectionViewLayout = self.flowLyout;
    [_bollec_bottom registerClass:[FilterCell class] forCellWithReuseIdentifier:ID];
    //自定义重用视图 FilterCollecFooterRuesuableView
    [self.bollec_bottom registerClass:[FilterCollecRuesuableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionCellIndentider];
    [self setBotomView];
    
}
-(void)setBotomView{
    self.bollec_bottom.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
    self.foot = [[FooterView alloc] initWithFrame:CGRectMake(0, self.bollec_bottom.height-85, self.bollec_bottom.width, 100)];
    [self.bollec_bottom addSubview:self.foot];
}
//底部重置确定按钮点击
- (IBAction)ResetSureClick:(UIButton *)sender {
//    NSLog(@"123123");
    if (sender.tag==1) {
        [self loadData];
        self.foot.tmpBtn.selected = NO;
        CustomButton * btn = (CustomButton *)[self.foot viewWithTag:1001];
        btn.selected = YES;
        self.foot.tmpBtn = btn;
    }else{
       __block NSString * str = @"";
        [[self.bollec_bottom subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UICollectionViewCell class]]) {
                FilterCell * cell = (FilterCell *)obj;
                if (cell.selected) {
                    str = [str stringByAppendingString:cell.lab_title.text];
                }
            }
        }];
//        NSArray * arr = [self.bollec_bottom indexPathsForSelectedItems];
        
        NSLog(@"当前的筛选条件是:%@",[str stringByAppendingString:self.foot.tmpBtn.titleLabel.text]);
    }
}
-(void)loadData{
    self.dataArr = [[NSMutableArray alloc] init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SX" ofType:@"plist"];
    self.arrData = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
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
    return 3;
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
        NSMutableDictionary * dic = array[i];
        if (i == indexPath.row) {
            [dic setObject:@YES forKey:@"isSelected"];
        } else {
            [dic setObject:@NO forKey:@"isSelected"];
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
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 1)];
    view.backgroundColor = YSColor(246, 246, 246);
    [self addSubview:view];
    CustomButton * btn = [[CustomButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-110, 40, 100, 40)];
    [btn setTitle:@"全部" forState:UIControlStateNormal];
    btn.selected = NO;
    [btn addTarget:self action:@selector(btnClick1:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 1000;
    [self addSubview:btn];
    CustomButton * btn_online = [[CustomButton alloc] initWithFrame:CGRectMake(btn.x+120, btn.y, 100, 40)];
    [btn_online setTitle:@"在线" forState:UIControlStateNormal];
    [btn_online addTarget:self action:@selector(btnClick1:) forControlEvents:UIControlEventTouchUpInside];
    btn_online.tag = 1001;
    btn_online.selected = YES;
    _tmpBtn = btn_online;
    [self addSubview:btn_online];
}
-(void)btnClick1:(UIButton *)sender{
    CustomButton * btn2 = (CustomButton *)[self viewWithTag:1001];
    if (sender.tag!=1001) {
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
