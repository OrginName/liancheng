//
//  OurSendController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "OurSendController.h"
#import "YTSideMenuModel.h"
#import "ProfileCell.h"
#import "OurResumeController.h"
@interface OurSendController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) NSArray <YTSideMenuModel *> *menuModels;
@property (weak, nonatomic) IBOutlet UITableView *tab_bottom;

@end

@implementation OurSendController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
//添加UI
-(void)setUI{
    self.navigationItem.title = @"我的发布";
}
#pragma mark ---UITableviewDelegate--------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menuModels.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfileCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell" owner:nil options:nil][0];
    }
    YTSideMenuModel *model = self.menuModels[indexPath.row];
    cell.iconImgV.image = [UIImage imageNamed:model.mIcon];
    cell.titleLab.text = model.mTitle;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *className = self.menuModels[indexPath.row].mClass;
    OurResumeController *vc = (OurResumeController *)[[NSClassFromString(className) alloc]init];
    if (vc == nil)return;
    vc.receive_Mo = self.menuModels[indexPath.row];
    vc.index = indexPath.row+2;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - setter and getter
- (NSArray<YTSideMenuModel *> *)menuModels {
    if (_menuModels == nil) {
        NSMutableArray <YTSideMenuModel *> *menuArr = [NSMutableArray array];
        NSArray * menuArray = @[@{@"icon":@"our-jl",
                                  @"title":@"简历",@"class":@"OurResumeController"},
                                @{@"icon":@"服务",@"title":@"服务",@"class":@"OurResumeController"},
                                @{@"icon":@"our-t-1",@"title":@"陪旅行",@"class":@"OurResumeController"},
                                @{@"icon":@"our-t-line",@"title":@"旅行邀约",@"class":@"OurResumeController"},
                                @{@"icon":@"our-wup",@"title":@"宝物",@"class":@"OurResumeController"},
                                @{@"icon":@"our-ch",@"title":@"身份互换",@"class":@"OurResumeController"}];
        [menuArray enumerateObjectsUsingBlock:^(NSDictionary *_Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
            YTSideMenuModel *model = [YTSideMenuModel modelWithDictionary:dic];
            [menuArr addObject:model];
        }];
        _menuModels = menuArr;
    }
    return _menuModels;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //关闭自适应
    if (@available(iOS 11.0, *)) {
        self.tab_bottom.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
@end
