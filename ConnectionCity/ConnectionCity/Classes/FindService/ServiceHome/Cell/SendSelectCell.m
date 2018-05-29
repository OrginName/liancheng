//
//  SendSelectCell.m
//  ConnectionCity
//
//  Created by qt on 2018/5/29.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "SendSelectCell.h"
#import "FilterCell.h"
#import "CustomButton.h"
#import "SelectLayout.h"
static NSString *ID = @"cityCollectionViewCell";
static NSString * collectionCellIndentider = @"collectionCellIndentider";
@interface SendSelectCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic)  UICollectionView *bollec_bottom;

@property (nonatomic,strong) SelectLayout * flowLyout;
@end
@implementation SendSelectCell
-(void)layoutSubviews{
    [super layoutSubviews];
    self.bollec_bottom.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bollec_bottom];
        [self setUI];
        [self loadData];
    }
    return self;
}
-(void)setUI{
    self.bollec_bottom.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.dataArr = [NSMutableArray array];
    [_bollec_bottom registerClass:[FilterCell class] forCellWithReuseIdentifier:ID];
    //自定义重用视图 FilterCollecFooterRuesuableView
    [self.bollec_bottom registerClass:[SendCollecRuesuableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionCellIndentider];
}
-(void)setArrData:(NSMutableArray *)arrData{
    _arrData = arrData;
    for (int i=0; i<arrData.count; i++) {
        [self.dataArr addObject:arrData[i][@"subname"]];
    }
    [_bollec_bottom reloadData];
}
-(void)loadData{
//    self.dataArr = [[NSMutableArray alloc] init];
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SX" ofType:@"plist"];
//    self.arrData = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
//    for (int i=0; i<self.arrData.count; i++) {
//        [self.dataArr addObject:self.arrData[i][@"subname"]];
//    }
//    [_bollec_bottom reloadData];
}
#pragma mark UICollectionViewDataSource 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArr count];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [self.arrData count];
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
        SendCollecRuesuableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionCellIndentider forIndexPath:indexPath];;
        //把想添加的控件放在session区头重用的cell里,并且回来赋值,防止重用(重点!!!!!)
        [headerView getSHCollectionReusableViewHearderTitle:self.arrData[indexPath.section][@"name"]];
        reusableview = headerView;
    }
    return reusableview;
}
-(UICollectionView *)bollec_bottom{
    if (!_bollec_bottom) {
        _flowLyout = [[SelectLayout alloc] init];
        _bollec_bottom = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLyout];
        _bollec_bottom.backgroundColor = [UIColor whiteColor];
        _bollec_bottom.delegate = self;
        _bollec_bottom.dataSource = self;
    }
    return _bollec_bottom;
}
@end
#pragma mark -----FilterCollecRuesuableView头部-----
@interface SendCollecRuesuableView (){
    UILabel *titleLabel;
}

@end

@implementation SendCollecRuesuableView
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
