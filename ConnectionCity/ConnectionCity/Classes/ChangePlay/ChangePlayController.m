//
//  ChangePlayController.m
//  ConnectionCity
//
//  Created by qt on 2018/5/20.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ChangePlayController.h"
#import "ChangeCell.h"
#import "ChangeHeadView.h"
#import "ChangeListController.h"
#import "ShowResumeController.h"
#import "RefineView.h"
#import "PopThree.h"
#import "SendTreasureController.h"
#define ID @"ChangeCell"
static NSString * collectionCellIndentider = @"collectionCellIndentider";
@interface ChangePlayController ()<UICollectionViewDelegate,UICollectionViewDataSource,PopThreeDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *coll_Botom;
@property (nonatomic,strong) ChangeLayout * flowLyout;
@property (nonatomic,strong) ChangeHeadView *changeHead;
@property (nonatomic,strong) RefineView * refine;
@property (nonatomic,strong) PopThree * pop;
@property (nonatomic,assign) NSInteger  flag;
@end

@implementation ChangePlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setFlag_back:YES];//设置返回按钮
    [self setUI];
     _flag = NO;
}
//导航栏标题点击
-(void)AddressClick:(UIButton *)btn{
    self.pop = [[[NSBundle mainBundle] loadNibNamed:@"PopThree" owner:nil options:nil] lastObject];
    self.pop.frame = CGRectMake(0, 0, kScreenWidth, 165);
    self.pop.delegate = self;
    self.refine = [[RefineView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) type:self.pop];
    [self.refine alertSelectViewshow];
}
//PopThreeDelegate声明协议方法
- (void)sendValue:(NSInteger )tag{
    _flag = YES;
    if (tag==1||tag==2) {
        NSString * str = tag==1?@"BaseOneTabController":@"BaseFindServiceTabController";
        [self.navigationController pushViewController:[super rotateClass:str] animated:YES];
    }
}
-(void)setUI{
    [self initNavi];
    self.coll_Botom.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.flowLyout = [[ChangeLayout alloc] init];
    _coll_Botom.collectionViewLayout = self.flowLyout;
    [_coll_Botom registerNib:[UINib nibWithNibName:@"ChangeCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:ID];
    self.coll_Botom.contentInset = UIEdgeInsetsMake(289, 0, 0, 0);
    _changeHead = [[[NSBundle mainBundle] loadNibNamed:@"ChangeHeadView" owner:nil options:nil] lastObject];
    [self.coll_Botom addSubview:self.changeHead];
//    //自定义重用视图 FilterCollecFooterRuesuableView
    [self.coll_Botom registerClass:[ChangeCollecRuesuableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionCellIndentider];
    WeakSelf
    _changeHead.block = ^(NSInteger flag){
        NSLog(@"%ld",flag);
         _flag = NO;
        if (flag==4||flag==5) {
            ChangeListController * change = [ChangeListController new];
            [weakSelf.navigationController pushViewController:change animated:YES];
        }else if(flag==1){
            SendTreasureController * send = [SendTreasureController new];
            [weakSelf.navigationController pushViewController:send animated:YES];
        }else if(flag==3){
            [YTAlertUtil showTempInfo:@"使用说明"];
        }else{
            [YTAlertUtil showTempInfo:@"我换什么"];
        }
    };
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
     _flag = NO;
    ShowResumeController * show = [ShowResumeController new];
    show.Receive_Type = ENUM_TypeTreasure;
    [self.navigationController pushViewController:show animated:YES];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        
        ChangeCollecRuesuableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionCellIndentider forIndexPath:indexPath];;
        reusableview = headerView;
    }
    return reusableview;
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden= NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_flag) {
        self.navigationController.navigationBar.hidden= YES;
    }
}
@end



//FilterLayout
@implementation ChangeLayout
/// 准备布局
- (void)prepareLayout {
    [super prepareLayout];
    //设置item尺寸
    CGFloat itemW = (self.collectionView.frame.size.width - 10)/ 2;
    self.itemSize = CGSizeMake(itemW, itemW+50);
    //设置最小间距
    self.minimumLineSpacing = 10;
    self.minimumInteritemSpacing = 10;
    self.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    [self setHeaderReferenceSize:CGSizeMake(self.collectionView.frame.size.width,50)];
}
@end

@implementation ChangeCollecRuesuableView
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createBasicView];
    }
    return self;
}
/**
 *  进行基本布局操作,根据需求进行.
 */
-(void)createBasicView{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 10, 10)];
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    view.backgroundColor = YSColor(0, 185, 161);
    [self addSubview:view];
    
    UILabel * titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.frame.size.width-40, self.frame.size.height)];
    titleLabel.text = @"附近的宝物";
    titleLabel.textColor = YSColor(34, 34, 34);
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:titleLabel];
}
@end
