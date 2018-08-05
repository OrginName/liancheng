//
//  TestViewController.m
//  CIO领域demo
//
//  Created by 王冲 on 2017/11/14.
//  Copyright © 2017年 希爱欧科技有限公司. All rights reserved.
//

#import "ClassificationsController1.h"
#import "JKAreaCollectionViewCell.h"
#import "JKAreaTableViewCell.h"
#import "JKReusableView.h"
#import "FootReusableView.h"
#import "JKFlowLayout.h"
#define CIO_SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define CIO_SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define tabWidth 100
@interface ClassificationsController1 ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    JKFlowLayout *layout;
    NSInteger _selectIndex;//记录位置
    BOOL _isScrollDown;//滚动方向
}

@property(nonatomic,strong) NSMutableArray *tableTittleDataArray;
@property(nonatomic,strong) NSMutableArray *headTittleDataArray;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) UICollectionView *collectionView;

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation ClassificationsController1
static NSString *cellID = @"cellID";
static NSString *headerID = @"headerID";
static NSString *footerID = @"footerID";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"JKFlowLayoutDemo";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _selectIndex = 0;
    _isScrollDown = YES;
    
    [self.tableTittleDataArray addObjectsFromArray:@[@"专家",@"CIO",@"教师",@"专家2",@"CIO2",@"教师2",@"专家3",@"CIO3",@"教师3",@"专家4",@"CIO4",@"教师4",@"专家5",@"CIO5",@"教师5",@"专家6",@"CIO6",@"教师6"]];
    
    [self.headTittleDataArray addObjectsFromArray:@[@"专家领域",@"CIO领域",@"教师领域",@"专家领域2",@"CIO领域2",@"教师领域2",@"专家领域3",@"CIO领域3",@"教师领域3",@"专家领域4",@"CIO领域4",@"教师领域4",@"专家领域5",@"CIO领域5",@"教师领域5",@"专家领域6",@"CIO领域6",@"教师领域6"]];
    
    
    [self.dataArray addObjectsFromArray: @[@[@"全部",@"云计算",@"大数据",@"物联网",@"移动应用",@"区块链",@"网络技术",@"互联网技术",@"产品设计",@"产品运营",@"人工智能",@"信息安全",@"数据治理",@"商务智能",@"DevOps",@"EA",@"CIO",@"O2O",@"IT规划",@"IT项目管理",@"IT服务管理",@"流程管理",@"管理系统",@"电子商务",@"数字营销",@"变革转型",@"基础设施",@"智慧医疗",@"智慧城市",@"电子政务",@"智能制造",@"金融科技",@"智慧交通",@"智慧教研",@"智慧能源",@"智慧旅游",@"智慧地产",@"智慧社区",@"软技能",@"创业投资",@"数据中心",@"其他"],@[@"全部",@"金融",@"房地产",@"建筑",@"能源",@"化工",@"政府",@"服装",@"汽车",@"交通",@"医疗",@"医药",@"教育",@"农业",@"物流",@"商贸",@"酒店",@"旅游",@"冶金",@"电器",@"机械",@"IT",@"食品",@"餐饮",@"综合",@"其他"],@[@"全部",@"软件工程",@"数据库",@"电子工程",@"网络工程",@"通信工程",@"云计算",@"人工智能",@"信息安全",@"信息管理",@"大数据",@"自动化",@"电子商务",@"物联网",@"移动互联网",@"电脑设计",@"数字媒体",@"地理信息系统",@"医学信息学",@"计算机应用",@"其他"],@[@"全部",@"云计算",@"大数据",@"物联网",@"移动应用",@"区块链",@"网络技术",@"互联网技术",@"产品设计",@"产品运营",@"人工智能",@"信息安全",@"数据治理",@"商务智能",@"DevOps",@"EA",@"CIO",@"O2O",@"IT规划",@"IT项目管理",@"IT服务管理",@"流程管理",@"管理系统",@"电子商务",@"数字营销",@"变革转型",@"基础设施",@"智慧医疗",@"智慧城市",@"电子政务",@"智能制造",@"金融科技",@"智慧交通",@"智慧教研",@"智慧能源",@"智慧旅游",@"智慧地产",@"智慧社区",@"软技能",@"创业投资",@"数据中心",@"其他"],@[@"全部",@"金融",@"房地产",@"建筑",@"能源",@"化工",@"政府",@"服装",@"汽车",@"交通",@"医疗",@"医药",@"教育",@"农业",@"物流",@"商贸",@"酒店",@"旅游",@"冶金",@"电器",@"机械",@"IT",@"食品",@"餐饮",@"综合",@"其他"],@[@"全部",@"软件工程",@"数据库",@"电子工程",@"网络工程",@"通信工程",@"云计算",@"人工智能",@"信息安全",@"信息管理",@"大数据",@"自动化",@"电子商务",@"物联网",@"移动互联网",@"电脑设计",@"数字媒体",@"地理信息系统",@"医学信息学",@"计算机应用",@"其他"],@[@"全部",@"云计算",@"大数据",@"物联网",@"移动应用",@"区块链",@"网络技术",@"互联网技术",@"产品设计",@"产品运营",@"人工智能",@"信息安全",@"数据治理",@"商务智能",@"DevOps",@"EA",@"CIO",@"O2O",@"IT规划",@"IT项目管理",@"IT服务管理",@"流程管理",@"管理系统",@"电子商务",@"数字营销",@"变革转型",@"基础设施",@"智慧医疗",@"智慧城市",@"电子政务",@"智能制造",@"金融科技",@"智慧交通",@"智慧教研",@"智慧能源",@"智慧旅游",@"智慧地产",@"智慧社区",@"软技能",@"创业投资",@"数据中心",@"其他"],@[@"全部",@"金融",@"房地产",@"建筑",@"能源",@"化工",@"政府",@"服装",@"汽车",@"交通",@"医疗",@"医药",@"教育",@"农业",@"物流",@"商贸",@"酒店",@"旅游",@"冶金",@"电器",@"机械",@"IT",@"食品",@"餐饮",@"综合",@"其他"],@[@"全部",@"软件工程",@"数据库",@"电子工程",@"网络工程",@"通信工程",@"云计算",@"人工智能",@"信息安全",@"信息管理",@"大数据",@"自动化",@"电子商务",@"物联网",@"移动互联网",@"电脑设计",@"数字媒体",@"地理信息系统",@"医学信息学",@"计算机应用",@"其他"],@[@"全部",@"云计算",@"大数据",@"物联网",@"移动应用",@"区块链",@"网络技术",@"互联网技术",@"产品设计",@"产品运营",@"人工智能",@"信息安全",@"数据治理",@"商务智能",@"DevOps",@"EA",@"CIO",@"O2O",@"IT规划",@"IT项目管理",@"IT服务管理",@"流程管理",@"管理系统",@"电子商务",@"数字营销",@"变革转型",@"基础设施",@"智慧医疗",@"智慧城市",@"电子政务",@"智能制造",@"金融科技",@"智慧交通",@"智慧教研",@"智慧能源",@"智慧旅游",@"智慧地产",@"智慧社区",@"软技能",@"创业投资",@"数据中心",@"其他"],@[@"全部",@"金融",@"房地产",@"建筑",@"能源",@"化工",@"政府",@"服装",@"汽车",@"交通",@"医疗",@"医药",@"教育",@"农业",@"物流",@"商贸",@"酒店",@"旅游",@"冶金",@"电器",@"机械",@"IT",@"食品",@"餐饮",@"综合",@"其他"],@[@"全部",@"软件工程",@"数据库",@"电子工程",@"网络工程",@"通信工程",@"云计算",@"人工智能",@"信息安全",@"信息管理",@"大数据",@"自动化",@"电子商务",@"物联网",@"移动互联网",@"电脑设计",@"数字媒体",@"地理信息系统",@"医学信息学",@"计算机应用",@"其他"],@[@"全部",@"云计算",@"大数据",@"物联网",@"移动应用",@"区块链",@"网络技术",@"互联网技术",@"产品设计",@"产品运营",@"人工智能",@"信息安全",@"数据治理",@"商务智能",@"DevOps",@"EA",@"CIO",@"O2O",@"IT规划",@"IT项目管理",@"IT服务管理",@"流程管理",@"管理系统",@"电子商务",@"数字营销",@"变革转型",@"基础设施",@"智慧医疗",@"智慧城市",@"电子政务",@"智能制造",@"金融科技",@"智慧交通",@"智慧教研",@"智慧能源",@"智慧旅游",@"智慧地产",@"智慧社区",@"软技能",@"创业投资",@"数据中心",@"其他"],@[@"全部",@"金融",@"房地产",@"建筑",@"能源",@"化工",@"政府",@"服装",@"汽车",@"交通",@"医疗",@"医药",@"教育",@"农业",@"物流",@"商贸",@"酒店",@"旅游",@"冶金",@"电器",@"机械",@"IT",@"食品",@"餐饮",@"综合",@"其他"],@[@"全部",@"软件工程",@"数据库",@"电子工程",@"网络工程",@"通信工程",@"云计算",@"人工智能",@"信息安全",@"信息管理",@"大数据",@"自动化",@"电子商务",@"物联网",@"移动互联网",@"电脑设计",@"数字媒体",@"地理信息系统",@"医学信息学",@"计算机应用",@"其他"],@[@"全部",@"云计算",@"大数据",@"物联网",@"移动应用",@"区块链",@"网络技术",@"互联网技术",@"产品设计",@"产品运营",@"人工智能",@"信息安全",@"数据治理",@"商务智能",@"DevOps",@"EA",@"CIO",@"O2O",@"IT规划",@"IT项目管理",@"IT服务管理",@"流程管理",@"管理系统",@"电子商务",@"数字营销",@"变革转型",@"基础设施",@"智慧医疗",@"智慧城市",@"电子政务",@"智能制造",@"金融科技",@"智慧交通",@"智慧教研",@"智慧能源",@"智慧旅游",@"智慧地产",@"智慧社区",@"软技能",@"创业投资",@"数据中心",@"其他"],@[@"全部",@"金融",@"房地产",@"建筑",@"能源",@"化工",@"政府",@"服装",@"汽车",@"交通",@"医疗",@"医药",@"教育",@"农业",@"物流",@"商贸",@"酒店",@"旅游",@"冶金",@"电器",@"机械",@"IT",@"食品",@"餐饮",@"综合",@"其他"],@[@"全部",@"软件工程",@"数据库",@"电子工程",@"网络工程",@"通信工程",@"云计算",@"人工智能",@"信息安全",@"信息管理",@"大数据",@"自动化",@"电子商务",@"物联网",@"移动互联网",@"电脑设计",@"数字媒体",@"地理信息系统",@"医学信息学",@"计算机应用",@"其他"]]];
    
    layout = [JKFlowLayout new];
    layout.itemSize = CGSizeMake((CIO_SCREEN_WIDTH-142)/3.0, 30);
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.naviHeight = 0;
    
    /**
     *  设置滑动方向
     *  UICollectionViewScrollDirectionHorizontal 水平方向
     *  UICollectionViewScrollDirectionVertical   垂直方向
     */
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.collectionView registerClass:[JKAreaCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    [self.collectionView registerClass:[JKReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:headerID];
    [self.collectionView registerClass:[FootReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter  withReuseIdentifier:footerID];
    
    // collectionView 的添加
    [self.view addSubview:self.collectionView];
    
    // tableView 的添加
    [self.view addSubview:self.tableView];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.headTittleDataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *array = self.dataArray[section];
    return array.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JKAreaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    NSArray *array = self.dataArray[indexPath.section];
    cell.areaName.text = array[indexPath.row];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind==UICollectionElementKindSectionFooter) {
        
        FootReusableView *footer = [collectionView  dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerID forIndexPath:indexPath];
        footer.backgroundColor = [UIColor whiteColor];
        return footer;
    }
    
    JKReusableView *header = [collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
    header.backgroundColor = [UIColor whiteColor];
    header.headText.text = [NSString stringWithFormat:@"%@",self.headTittleDataArray[indexPath.section]];
    return header;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 35);
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(105,0, CIO_SCREEN_WIDTH-65-41, CIO_SCREEN_HEIGHT-64) collectionViewLayout: layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = NO;
        _collectionView.alwaysBounceHorizontal = NO;
        _collectionView.pagingEnabled = NO;
    }
    
    return _collectionView;
}

-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
}

-(NSMutableArray *)headTittleDataArray{
    
    if (!_headTittleDataArray) {
        _headTittleDataArray = [[NSMutableArray alloc]init];
    }
    return _headTittleDataArray;
}
-(NSMutableArray *)tableTittleDataArray{
    if (!_tableTittleDataArray) {
        _tableTittleDataArray = [[NSMutableArray alloc]init];
    }
    return _tableTittleDataArray;
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, 100, CIO_SCREEN_HEIGHT-64)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor  = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tableTittleDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellID";
    JKAreaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[JKAreaTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_selectIndex == indexPath.row) {
        cell.selected=YES;
    }else{
        cell.selected = NO;
    }
    cell.nameText.text = self.tableTittleDataArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CIO_SCREEN_WIDTH, 0.1)];
    headView.backgroundColor = [UIColor whiteColor];
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CIO_SCREEN_WIDTH, 0.1)];
    footView.backgroundColor = [UIColor whiteColor];
    return footView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1f;
}

// CollectionView分区标题即将展示
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    //         当前CollectionView滚动的方向向上，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (!_isScrollDown && (collectionView.dragging || collectionView.decelerating)) {
        [self selectRowAtIndexPath:indexPath.section];
    }
}
// CollectionView分区标题展示结束
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(nonnull UICollectionReusableView *)view forElementOfKind:(nonnull NSString *)elementKind atIndexPath:(nonnull NSIndexPath *)indexPath {
    //当前CollectionView滚动的方向向下，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (_isScrollDown && (collectionView.dragging || collectionView.decelerating)) {
        [self selectRowAtIndexPath:indexPath.section + 1];
    }
}
// 当拖动CollectionView的时候，处理TableView
- (void)selectRowAtIndexPath:(NSInteger)index {
    
    _selectIndex = index;
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [self.tableView reloadData];
}

#pragma mark - UIScrollView Delegate
// 标记一下CollectionView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    static float lastOffsetY = 0;
    if (self.collectionView == scrollView) {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
}

// 选中 处理collectionView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JKAreaTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = YES;
    _selectIndex = indexPath.row;
    CGRect headerRect = [self frameForHeaderForSection:_selectIndex];
    CGPoint topOfHeader = CGPointMake(0, headerRect.origin.y - _collectionView.contentInset.top);
    [self.collectionView setContentOffset:topOfHeader animated:YES];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.tableView reloadData];
}

- (CGRect)frameForHeaderForSection:(NSInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    UICollectionViewLayoutAttributes *attributes = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    return attributes.frame;
}

-(void)click{
    [self.navigationController popViewControllerAnimated:YES];
}
@end


