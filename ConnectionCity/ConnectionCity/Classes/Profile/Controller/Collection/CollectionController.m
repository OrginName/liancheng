//
//  CollectionController.m
//  ConnectionCity
//
//  Created by qt on 2018/6/8.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
// 收藏页面

#import "CollectionController.h"
#import "CollectionCell.h"
#import "Moment.h"
#import "XMPlayer.h"
@interface CollectionController ()<UITableViewDelegate,UITableViewDataSource,CollectionCellDelegate>
{
    int page;
}
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@property (nonatomic,strong)NSMutableArray * momentList;
@end
@implementation CollectionController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.momentList = [NSMutableArray array];
    [self setUI];
    page=1;
    self.tab_Bottom.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page=1;
        [self loadData];
    }];
    self.tab_Bottom.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadData];
    }];
    [self.tab_Bottom.mj_header beginRefreshing];
}
-(void)loadData{
    NSDictionary * dic = @{
                           @"pageNumber": @(page),
                           @"pageSize": @15
                           };
    [YSNetworkTool POST:v1MyCollectPage params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"data"][@"content"] count]==0) {            [self endRefresh];
            return [YTAlertUtil showTempInfo:@"暂无数据"];
        }
        if (page==1) {
            [self.momentList removeAllObjects];
        }
        page++;
        NSArray * Arr = responseObject[@"data"][@"content"];
        for (int i=0; i<Arr.count; i++) {
            Moment * moment = [Moment  mj_objectWithKeyValues:Arr[i]];
            moment.ID = Arr[i][@"typeId"];//收藏ID
            moment.isFullText = NO;
            if ([Arr[i][@"obj"] isKindOfClass:[NSDictionary class]]) {
                moment.text = Arr[i][@"obj"][@"content"];
                moment.videos = [Arr[i][@"obj"][@"videos"] description];
                moment.images = [Arr[i][@"obj"][@"images"] description];
                moment.containsImage =Arr[i][@"obj"][@"containsImage"];
                moment.containsVideo =Arr[i][@"obj"][@"containsVideo"];
            }
            if ([Arr[i][@"user"] isKindOfClass:[NSDictionary class]]) {
                moment.userMo = [UserMo mj_objectWithKeyValues:Arr[i][@"user"]];
                moment.userMo.ID = Arr[i][@"user"][@"id"];
            }
            moment.singleWidth = 500;
            moment.singleHeight = 315;
            if (moment.videos.length!=0&&[moment.videos containsString:@"http"]) {
                moment.coverImage = [UIImage thumbnailOfAVAsset:[NSURL URLWithString:moment.videos]];
            }else{
                moment.coverImage = [UIImage imageNamed:@"no-pic"];
                NSMutableArray * imageArr = [[moment.images componentsSeparatedByString:@";"] mutableCopy];
                [imageArr removeLastObject];
                moment.fileCount = [imageArr count];
            }
            [self.momentList addObject:moment];
            [self endRefresh];
            [self.tab_Bottom reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefresh];
    }];
}
-(void)endRefresh{
    [self.tab_Bottom.mj_header endRefreshing];
    [self.tab_Bottom.mj_footer endRefreshing];
}
-(void)setUI{
    self.navigationItem.title = @"收藏";
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.momentList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.momentList[indexPath.row] cellHeight];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * identify = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    CollectionCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[CollectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.receive_Mo = self.momentList[indexPath.row];
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
- (void)didSelectFullText:(CollectionCell *)cell{
//    NSIndexPath * index = [self.tab_Bottom indexPathForCell:cell];
    [self.tab_Bottom reloadData];
}
-(void)didPlayMyVideo:(CollectionCell *)cell{
    NSIndexPath * index = [self.tab_Bottom indexPathForCell:cell];
    Moment * comm = self.momentList[index.row];
    [self setPlay:comm.videos image:comm.coverImage];
}
-(void)didCancleClick:(CollectionCell *)cell{
    NSIndexPath * index = [self.tab_Bottom indexPathForCell:cell];
    Moment * comm = self.momentList[index.row];
    WeakSelf
    [YSNetworkTool POST:v1CommonCollectCreate params:@{@"typeId":@([comm.ID integerValue]),@"type":@20} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [weakSelf.momentList removeObjectAtIndex:index.row];
        [self.tab_Bottom reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
-(void)setPlay:(NSString *)url image:(UIImage *)image{
    XMPlayerManager *playerManager = [[XMPlayerManager alloc] init];
    playerManager.sourceImagesContainerView = self.view; // 当前的View
    playerManager.currentImage = image;  // 当前的图片
    // playerManager.isAllowDownload = NO; // 不允许下载视频
    //    playerManager.isAllowCyclePlay = NO;  // 不循环播放
    playerManager.videoURL = [NSURL URLWithString:url]; // 当前的视频URL
    [playerManager show];
}

@end
