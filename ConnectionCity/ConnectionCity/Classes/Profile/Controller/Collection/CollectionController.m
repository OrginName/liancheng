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
@interface CollectionController ()<UITableViewDelegate,UITableViewDataSource,CollectionCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@property (nonatomic,strong)NSMutableArray * momentList;
@end
@implementation CollectionController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.momentList = [NSMutableArray array];
    [self setUI];
    [self loadData];
    
    self.tab_Bottom.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
    }];
    self.tab_Bottom.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
    }];
}
-(void)loadData{
    NSDictionary * dic = @{
                           @"pageNumber": @1,
                           @"pageSize": @15
                           };
    [YSNetworkTool POST:v1MyCollectPage params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray * Arr = responseObject[@"data"][@"content"];
        for (int i=0; i<Arr.count; i++) {
            Moment * moment = [Moment  mj_objectWithKeyValues:Arr[i]];
            moment.ID = Arr[i][@"typeId"];//收藏ID
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
            [self.tab_Bottom reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
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
    CollectionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CollectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.receive_Mo = self.momentList[indexPath.row];
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)didSelectFullText:(CollectionCell *)cell{
    NSIndexPath * index = [self.tab_Bottom indexPathForCell:cell];
    [self.tab_Bottom reloadRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationTop];
}
@end
