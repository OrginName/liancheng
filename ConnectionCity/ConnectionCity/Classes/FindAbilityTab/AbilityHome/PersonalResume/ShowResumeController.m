//
//  ShowResumeController.m
//  ConnectionCity
//
//  Created by qt on 2018/5/15.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ShowResumeController.h"
#import "ShowResumeTab.h"
#import "ShowCardTab.h"
#import "ShowTreaueTab.h"
#import "ShowtrvalTab.h"
#import "trvalMo.h"
#import "AllDicMo.h"
#import "ServiceHomeNet.h"
#import "RCDChatViewController.h"
#define identifier @"ScrollCell"
#define TabHeight kScreenHeight-185
@interface ShowResumeController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIButton *btn_sayAndChange;
@property (nonatomic, strong)NSMutableArray *imageArray;
@property (nonatomic, assign)Boolean isFullScreen;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, assign)NSInteger currentIndex;
@property (nonatomic, strong)ShowResumeTab * showTab;
@property (nonatomic, strong)ShowCardTab * showCardTab;
@property (nonatomic, strong)ShowTreaueTab * showTreaueTab;
@property (nonatomic, strong)ShowtrvalTab * trvaltab;

@end

@implementation ShowResumeController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
#pragma mark --- 分享按钮点击-----
-(void)Share{
    [YSShareTool share];
}
-(void)setUI{
     self.imageArray = [NSMutableArray arrayWithArray:@[@"001.jpg",@"002.jpg",@"003.jpg"]];
    [self.view addSubview:self.collectionView];
    if(self.Receive_Type == ENUM_TypeCard){
        self.title = @"互换身份";
    }else if (self.Receive_Type == ENUM_TypeResume){
       [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.zIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }else if (self.Receive_Type == ENUM_TypeTreasure){
        self.title = @"互换宝物";
        [self.btn_sayAndChange setTitle:@"我想换" forState:UIControlStateNormal];
    }else if (self.Receive_Type == ENUM_TypeTrval){
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.zIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(Share) image:@"share" title:@"" EdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    _currentIndex = 0;
}
//加载列表数据
-(void)loadData:(NSString *)ID{
//    加载服务数据
    if (self.Receive_Type == ENUM_TypeTrval){
        [YSNetworkTool POST:v1ServiceDetail params:@{@"id":ID} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
}
#pragma mark --各种点击事件---
//导航栏完成按钮点击
-(void)complete{
    
}
//对话 关注  交换点击
- (IBAction)callAndChangeClick:(UIButton *)sender {
    if (sender.tag==4&&self.Receive_Type == ENUM_TypeTreasure) {
        [self.navigationController pushViewController:[super rotateClass:@"DouctChangeController"] animated:YES];
    }if (sender.tag==4&&self.Receive_Type == ENUM_TypeTrval&&[self.str isEqualToString:@"TrvalTrip"]) {
        trvalMo * mo = self.data_Count[self.zIndex];
        [self GZLoadData:mo.ID];
    }
    if (sender.tag==4) {
        if ([self.data_Count[self.zIndex] isKindOfClass:[trvalMo class]]) {
            trvalMo * mo = self.data_Count[self.zIndex];
            [self GZLoadData:mo.ID];
        }else if ([self.data_Count[self.zIndex] isKindOfClass:[ServiceListMo class]]){
            ServiceListMo * mo = self.data_Count[self.zIndex];
            [self GZLoadData:mo.ID];
        }
    }
    if (sender.tag==3) {
        if ([self.str isEqualToString:@"TrvalTrip"]){
            trvalMo * mo = self.data_Count[self.zIndex];
            if ([[mo.user.isBlack description] isEqualToString:@"1"]) {
                return [YTAlertUtil showTempInfo:@"您已在对方的黑名单中,暂不能对话"];
            }
        }else{
            ServiceListMo * mo = self.data_Count[self.zIndex];
            if ([[mo.user1.isBlack description] isEqualToString:@"1"]) {
                return [YTAlertUtil showTempInfo:@"您已在对方的黑名单中,暂不能对话"];
            }
        }
        RCDChatViewController *chatViewController = [[RCDChatViewController alloc] init];
        chatViewController.conversationType = ConversationType_PRIVATE;
        NSString *title,*ID,*name;
        if (self.Receive_Type == ENUM_TypeTrval){
            if ([self.str isEqualToString:@"TrvalTrip"]){
                trvalMo * mo = self.data_Count[self.zIndex];                
                ID = [mo.user.ID description];
                name = mo.user.nickName;
            }else{
                ServiceListMo * mo = self.data_Count[self.zIndex];
                ID = [mo.user1.ID description];
                name = mo.user1.nickName;
            }
        }else if (self.Receive_Type == ENUM_TypeResume){
            AbilttyMo * resume = self.data_Count[self.zIndex];
            ID = [resume.userMo.ID description];
            name = resume.userMo.nickName;
        }
        chatViewController.targetId = ID;
        if ([ID isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
            title = [RCIM sharedRCIM].currentUserInfo.name;
        } else {
            title = name;
        }
        chatViewController.title = title;
//        chatViewController.needPopToRootView = YES;
        chatViewController.displayUserNameInCell = NO;
        [self.navigationController pushViewController:chatViewController animated:YES];
    }
}
-(void)GZLoadData:(NSString *)type{
    NSMutableArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:KAllDic]];
//    if (self.Receive_Type == ENUM_TypeTrval){
//        if ([self.str isEqualToString:@"TrvalTrip"]){
//
//        }
//    }
    AllContentMo * mo = [arr[5] contentArr][1];
    [YSNetworkTool POST:v1CommonFollowCreate params:@{@"typeId":@([type integerValue]),@"type":@([mo.value integerValue])} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        [YTAlertUtil showTempInfo:@"关注成功"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.data_Count.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    if (self.Receive_Type == ENUM_TypeResume) {
        self.showTab = [[ShowResumeTab alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, TabHeight)];
        AbilttyMo * resume = self.data_Count[indexPath.row];
        self.showTab.abilttyMo = resume;
        self.title = resume.userMo.nickName;
        [cell.contentView addSubview:self.showTab];
    }else if(self.Receive_Type == ENUM_TypeCard){
        self.showCardTab = [[ShowCardTab alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, TabHeight)];
        [cell.contentView addSubview:self.showCardTab];
    }else if (self.Receive_Type == ENUM_TypeTrval){
        self.trvaltab = [[ShowtrvalTab alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, TabHeight) withControl:self];
        if ([self.str isEqualToString:@"TrvalTrip"]) {
            trvalMo * mo = self.data_Count[indexPath.row];
            self.title = mo.user.nickName;
            self.trvaltab.MoTrval = mo;
        }else{
            ServiceListMo * mo = self.data_Count[indexPath.row];
            self.title = mo.title;
            self.trvaltab.Mo = mo; 
        }
        [cell.contentView addSubview:self.trvaltab];

    }else {
        self.showTreaueTab = [[ShowTreaueTab alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, TabHeight)];
        [cell.contentView addSubview:self.showTreaueTab];
    }
    return cell;
}
 
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth-20, TabHeight);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //得到每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    self.zIndex = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1;
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight);
        layout.minimumInteritemSpacing = 0.0f;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, TabHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
        _collectionView.contentSize = CGSizeMake(kScreenWidth*self.imageArray.count, kScreenHeight);
        _collectionView.contentOffset = CGPointMake(0, 0);
    }
    return _collectionView;
} 
- (IBAction)UPDownClick:(UIButton *)sender {
//    [self layoutIfNeeded];
    if (sender.tag==1) {
        self.zIndex--;
        if (self.zIndex<0) {
            self.zIndex = 0;
            [YTAlertUtil showTempInfo:@"在往前没有了"];
            return;
        }
       
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.zIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }else{
        self.zIndex++;
        if (self.zIndex>self.data_Count.count-1) {
            self.zIndex = self.data_Count.count-1;
            [YTAlertUtil showTempInfo:@"在往后没有了"];
            return;
        }
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.zIndex inSection:0]  atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    if (self.Receive_Type == ENUM_TypeTrval&&self.zIndex<=self.data_Count.count-1&&self.zIndex>0){
        if ([self.str isEqualToString:@"TrvalTrip"]){
            trvalMo * mo = self.data_Count[self.zIndex];
            [ServiceHomeNet requstLiulanNum:@{@"id":mo.ID} flag:2 withSuc:^(NSMutableArray *successArrValue) {
                
            }];
        }else{
            ServiceListMo * mo = self.data_Count[self.zIndex];
            [ServiceHomeNet requstLiulanNum:@{@"id":mo.ID} flag:1 withSuc:^(NSMutableArray *successArrValue) {
                
            }];
        }
    }
}
@end
