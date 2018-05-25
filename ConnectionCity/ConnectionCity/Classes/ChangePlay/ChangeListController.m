//
//  ChangeListController.m
//  ConnectionCity
//
//  Created by qt on 2018/5/21.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ChangeListController.h"
#import "ChangeCell.h"
#import "JFCityViewController.h"
#import "ClassificationsController.h"
#import "FilterOneController.h"
#import "ShowResumeController.h"
#define ID @"ChangeCell"
@interface ChangeListController ()<JFCityViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *view_X;
@property (weak, nonatomic) IBOutlet UILabel *lab_City;
@property (weak, nonatomic) IBOutlet UICollectionView *collec_Bottom;
@property (nonatomic,strong) ChangeListLayout * flowLyout;

@end

@implementation ChangeListController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.collec_Bottom.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.flowLyout = [[ChangeListLayout alloc] init];
    _collec_Bottom.collectionViewLayout = self.flowLyout;
    [_collec_Bottom registerNib:[UINib nibWithNibName:@"ChangeCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:ID];
     self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(SearchClick) image:@"search" title:@"" EdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
    [self initNavi];
}
- (IBAction)btn_Click:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1:
        {
            JFCityViewController * jf= [JFCityViewController new];
            jf.delegate = self;
            BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:jf];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 2:
        {
            ClassificationsController * class = [ClassificationsController new];
            class.title = @"职业分类";
            class.block = ^(NSString *classifiation){
                UILabel * btn = (UILabel *)[self.view_X viewWithTag:2];
                btn.text = classifiation;
            };
            [self.navigationController pushViewController:class animated:YES];
        }
            break;
        case 3:
        {
            FilterOneController * filter = [FilterOneController new];
            filter.title = @"筛选条件";
            [self.navigationController pushViewController:filter animated:YES];
        }
            break;
        default:
            break;
    }
}
//标题栏点击
-(void)AddressClick:(UIButton *)btn{
    [YTAlertUtil showTempInfo:@"标题栏点击"];
}
//搜索按钮点击
-(void)SearchClick{
    [YTAlertUtil showTempInfo:@"搜搜"];
}
#pragma mark - JFCityViewControllerDelegate
- (void)cityName:(NSString *)name {
    UILabel * btn = (UILabel *)[self.view_X viewWithTag:1];
    btn.text = name;
}
#pragma mark UICollectionViewDataSource 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChangeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ShowResumeController * show = [ShowResumeController new];
    show.Receive_Type = ENUM_TypeTreasure;
    [self.navigationController pushViewController:show animated:YES];
}
-(void)initNavi{
    //自定义标题视图
    UIView * nav_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    btn.tag = 99999;
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:@"换着玩" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"Arrow-xia"] forState:UIControlStateNormal];
    [btn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:5];
    [btn addTarget:self action:@selector(AddressClick:) forControlEvents:UIControlEventTouchUpInside];
    [nav_view addSubview:btn];
    self.navigationItem.titleView = nav_view;
}
@end


//FilterLayout
@implementation ChangeListLayout
/// 准备布局
- (void)prepareLayout {
    [super prepareLayout];
    //设置item尺寸
    CGFloat itemW = (self.collectionView.frame.size.width - 10)/ 2;
    self.itemSize = CGSizeMake(itemW, itemW+50);
    //设置最小间距
    self.minimumLineSpacing = 10;
    self.minimumInteritemSpacing = 10;
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    [self setHeaderReferenceSize:CGSizeMake(self.collectionView.frame.size.width,50)];
}
@end
