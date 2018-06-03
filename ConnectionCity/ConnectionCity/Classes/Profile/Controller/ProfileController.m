//
//  ProfileController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ProfileController.h"
#import "YTSideMenuModel.h"
#import "ProfileCell.h"

@interface ProfileController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray <YTSideMenuModel *> *menuModels;

@end

@implementation ProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Setup
- (void)setupTableView {
    [self registerCell];
}

- (void)registerCell {
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileCell" bundle:nil] forCellReuseIdentifier:@"ProfileCell"];
}
#pragma mark - setter and getter
- (NSArray<YTSideMenuModel *> *)menuModels {
    if (_menuModels == nil) {
        NSMutableArray <YTSideMenuModel *> *menuArr = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle]pathForResource:@"MenuIcons" ofType:@"plist"];
        NSArray *menuArray = [NSArray arrayWithContentsOfFile:path];
        [menuArray enumerateObjectsUsingBlock:^(NSDictionary *_Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
            YTSideMenuModel *model = [YTSideMenuModel modelWithDictionary:dic];
            [menuArr addObject:model];
        }];
        _menuModels = menuArr;
    }
    return _menuModels;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuModels.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileCell *profileCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
    YTSideMenuModel *model = self.menuModels[indexPath.row];
    profileCell.iconImgV.image = [UIImage imageNamed:model.mIcon];
    profileCell.titleLab.text = model.mTitle;
    return profileCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 根据类名跳转控制器
//    NSString *className = [YTAccountInfo loginState] ? self.menuModels[indexPath.row].mClass : @"YTLoginViewController";
//    UIViewController *vc = (UIViewController *)[[NSClassFromString(className) alloc]init];
//    if (vc == nil)return;
//    UINavigationController *rootNC = [NSObject yt_getRootNC];
//    [rootNC pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
