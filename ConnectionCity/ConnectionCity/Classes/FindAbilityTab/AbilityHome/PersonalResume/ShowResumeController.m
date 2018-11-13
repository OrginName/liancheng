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
#import "serviceListNewMo.h"
#import "AbilityNet.h"
#import "privateUserInfoModel.h"
#define identifier @"ScrollCell"
#define TabHeight kScreenHeight-184
#define TabHeight1 kScreenHeight-134
@interface ShowResumeController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *next_layout;
@property (weak, nonatomic) IBOutlet UIView *view_Nex;
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
@property (nonatomic, strong)UserMo * User;
@property (nonatomic, strong)AbilttyMo * abilityMoNew;
@property (nonatomic, strong)trvalMo * trvalNew;
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
        [self loadResumedetail];
    }else if (self.Receive_Type == ENUM_TypeTreasure){
        self.title = @"互换宝物";
        [self.btn_sayAndChange setTitle:@"我想换" forState:UIControlStateNormal];
    }else if ([self.flag isEqualToString:@"1"]){
        if ([self.flagNext isEqualToString:@"NONext"]) {
            self.view_Nex.hidden = YES;
            self.next_layout.constant = 0;
        }
        [self loadDataJNB];
    }else if([self.flag isEqualToString:@"3"]){
        [self loadDataPYDetail];
    }
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(Share) image:@"share" title:@"" EdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    _currentIndex = 0;
}
//加载简历详情
-(void)loadResumedetail{
    WeakSelf
    serviceListNewMo * mo = self.data_Count[self.zIndex];
    [AbilityNet requstResumeDetail:@{@"id":mo.resumeId} withBlock:^(AbilttyMo *user) {
        weakSelf.abilityMoNew = user;
        [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:weakSelf.zIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        NSIndexPath * index = [NSIndexPath indexPathForRow:self.zIndex inSection:0];
        [weakSelf.collectionView reloadItemsAtIndexPaths:@[index]];
    }];
}
//加载列表数据
-(void)loadDataJNB{
    WeakSelf
    serviceListNewMo * mo = self.data_Count[self.zIndex];
    [ServiceHomeNet requstServiceListJN:@{@"id":mo.ID} withSuc:^(UserMo *user) {
        weakSelf.User = user;
        [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:weakSelf.zIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        NSIndexPath * index = [NSIndexPath indexPathForRow:self.zIndex inSection:0];
        [weakSelf.collectionView reloadItemsAtIndexPaths:@[index]];
    }];
}
//加载陪游详情
-(void)loadDataPYDetail{
    WeakSelf
    trvalMo * mo = self.data_Count[self.zIndex];
    [ServiceHomeNet requstPYDetail:@{@"id": mo.ID} withSuc:^(trvalMo *user) {
        weakSelf.trvalNew = user;
        [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:weakSelf.zIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        NSIndexPath * index = [NSIndexPath indexPathForRow:self.zIndex inSection:0];
        [weakSelf.collectionView reloadItemsAtIndexPaths:@[index]];
    }];
}
#pragma mark --各种点击事件---
//导航栏完成按钮点击
-(void)complete{
    
}
//对话 关注  交换点击
- (IBAction)callAndChangeClick:(UIButton *)sender {
    if (sender.tag==4&&self.Receive_Type == ENUM_TypeTreasure) {
        [self.navigationController pushViewController:[super rotateClass:@"DouctChangeController"] animated:YES];
    }
    if (sender.tag==4) {
        if ([self.data_Count[self.zIndex] isKindOfClass:[trvalMo class]]) {
            trvalMo * mo = self.data_Count[self.zIndex];
            [self GZLoadData:mo.ID typeID:@"40"];
        }else if ([self.data_Count[self.zIndex] isKindOfClass:[serviceListNewMo class]]&&self.Receive_Type == ENUM_TypeTrval){
            [self GZLoadData:[self.User.serviceList[self.trvaltab.JNIndex] ID] typeID:@"20"];
        }else if (self.Receive_Type == ENUM_TypeResume){
            [self GZLoadData:self.abilityMoNew.ID typeID:@"50"];
        }
    }
    if (sender.tag==3) {
        if ([self.str isEqualToString:@"TrvalTrip"]){
//            trvalMo * mo = self.data_Count[self.zIndex];
            if ([[self.trvalNew.user.isBlack description] isEqualToString:@"1"]) {
                return [YTAlertUtil showTempInfo:@"您已在对方的黑名单中,暂不能对话"];
            }
        }else{
            NSString * str = @"";
            if (self.Receive_Type == ENUM_TypeResume){
                str = self.abilityMoNew.user.isBlack;
            }else{ 
                str = self.User.isBlack;
            }
            if ([[str description] isEqualToString:@"1"]) {
                return [YTAlertUtil showTempInfo:@"您已在对方的黑名单中,暂不能对话"];
            }
        }
        RCDChatViewController *chatViewController = [[RCDChatViewController alloc] init];
        chatViewController.conversationType = ConversationType_PRIVATE;
        NSString *title,*ID,*name;
        if (self.Receive_Type == ENUM_TypeTrval){
            if ([self.str isEqualToString:@"TrvalTrip"]){
//                trvalMo * mo = self.data_Count[self.zIndex];
                ID = [self.trvalNew.user.ID description];
                name = self.trvalNew.user.nickName?self.trvalNew.user.nickName:KString(@"用户%@", self.trvalNew.user.ID);
            }else{
                ID = [self.User.ID description];
                name = self.User.nickName;
            }
        }else if (self.Receive_Type == ENUM_TypeResume){
            ID = [self.abilityMoNew.user.ID description];
            name = self.abilityMoNew.user.nickName?self.abilityMoNew.user.nickName:self.abilityMoNew.user.ID;
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
-(void)GZLoadData:(NSString *)type typeID:(NSString *)typeID{
    NSDictionary * dic = @{
                           @"typeId":@([type integerValue]),
                           @"type":@([typeID integerValue]),
                           @"followedUserId":[[YSAccountTool userInfo] modelId]
                           };
    [YSNetworkTool POST:v1CommonFollowCreate params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
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
        self.title = self.abilityMoNew.user.nickName?self.abilityMoNew.user.nickName:KString(@"用户%@", [self.abilityMoNew.user.ID description]);
        self.showTab.Mo = self.abilityMoNew;
        [cell.contentView addSubview:self.showTab];
    }else if(self.Receive_Type == ENUM_TypeCard){
        self.showCardTab = [[ShowCardTab alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, TabHeight)];
        [cell.contentView addSubview:self.showCardTab];
    }else if (self.Receive_Type == ENUM_TypeTrval){
        self.trvaltab = [[ShowtrvalTab alloc] initWithFrame:CGRectMake(0, [self.flagNext isEqualToString:@"NONext"]?-25:0, kScreenWidth-20,self.collectionView.height) withControl:self];
        if ([self.flag isEqualToString:@"3"]) {
            self.title = self.trvalNew.user.nickName?self.trvalNew.user.nickName:KString(@"用户%@", [self.trvalNew.userId description]);
            self.trvaltab.MoTrval = self.trvalNew;
        }else if([self.flag isEqualToString:@"1"]){
            self.title = self.User.nickName?self.User.nickName:KString(@"用户%@", [self.User.ID description]);
            self.trvaltab.Mo = self.User;
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
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, [self.flagNext isEqualToString:@"NONext"]? TabHeight1: TabHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor redColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
        _collectionView.contentSize = CGSizeMake(kScreenWidth*self.imageArray.count, kScreenHeight);
        _collectionView.contentOffset = CGPointMake(0, 0);
    }
    return _collectionView;
}
- (IBAction)UPDownClick:(UIButton *)sender {
    if (sender.tag==1) {
        self.zIndex--;
        if (self.zIndex<0) {
            self.zIndex = 0;
            [YTAlertUtil showTempInfo:@"在往前没有了"];
            return;
        }
    }else{
        self.zIndex++;
        if (self.zIndex>self.data_Count.count-1) {
            self.zIndex = self.data_Count.count-1;
            [YTAlertUtil showTempInfo:@"在往后没有了"];
            return;
        }
    }
    if ([self.flag isEqualToString:@"1"]) {
        [self loadDataJNB];//加载服务技能包详情
    }else if ([self.flag isEqualToString:@"2"]){
        [self loadResumedetail];//加载简历详情
    }else if ([self.flag isEqualToString:@"3"]){
        [self loadDataPYDetail];//加载陪游详情
    }
    if (self.Receive_Type == ENUM_TypeTrval&&self.zIndex<=self.data_Count.count-1&&self.zIndex>0){
        if ([self.str isEqualToString:@"TrvalTrip"]){
            trvalMo * mo = self.data_Count[self.zIndex];
            [ServiceHomeNet requstLiulanNum:@{@"id":mo.ID} flag:2 withSuc:^(NSMutableArray *successArrValue) {
                
            }];
        }else{
            [ServiceHomeNet requstLiulanNum:@{@"id":[self.User.serviceList[self.trvaltab.JNIndex] ID]} flag:1 withSuc:^(NSMutableArray *successArrValue) {
                
            }];
        }
    }
}
@end

