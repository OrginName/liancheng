//
//  AccountView.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/8.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AccountView.h"
#import "UIView+Geometry.h"
#import <RongIMLib/RongIMLib.h>
#import "PersonalBasicDataController.h"
#import "MessageMo.h"
@interface AccountView()<UITableViewDelegate,UITableViewDataSource>
{
    int _page;
}
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@property (nonatomic,strong) NSMutableArray * arrBlackList;

@end
@implementation AccountView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.tab_Bottom.delegate = self;
    self.tab_Bottom.dataSource = self;
    self.arrBlackList = [NSMutableArray array];
    _page = 1;
    self.tab_Bottom.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self loadBlackList];
    }];
    self.tab_Bottom.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadBlackList];
    }];
    [self.tab_Bottom.mj_header beginRefreshing];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrBlackList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[AccountViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.user = self.arrBlackList[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserMo * user = self.arrBlackList[indexPath.row];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectedItemButton:)]) {
        [self.delegate selectedItemButton:user];
    }
}
#pragma mark ---加载黑名单数据-----
-(void)loadBlackList{
    NSDictionary * dic = @{
                           @"pageNumber": @(_page),
                           @"pageSize": @30
                           };
    WeakSelf
    [YSNetworkTool POST:v1MyBlackPage params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if (_page==1) {
            [weakSelf.arrBlackList removeAllObjects];
        }
        _page++;
        for (NSDictionary * dic1 in responseObject[@"data"][@"content"]) {
            UserMo * user = [UserMo mj_objectWithKeyValues:dic1[@"user"]];
            [weakSelf.arrBlackList addObject:user];
        }
        [weakSelf.tab_Bottom reloadData];
        [weakSelf endRefresh];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf endRefresh];
    }];
}
-(void)endRefresh{
    [self.tab_Bottom.mj_header endRefreshing];
    [self.tab_Bottom.mj_footer endRefreshing];
}
//消息记录清理
- (IBAction)btnClick:(UIButton *)sender {
//    1 清空消息列表  2 清空所有聊天记录  3 清空缓存数据
    if (sender.tag==1) {
        [YTAlertUtil alertDualWithTitle:@"连程" message:@"是否要清空所有的会话列表" style:UIAlertControllerStyleAlert cancelTitle:@"否" cancelHandler:^(UIAlertAction *action) {
            
        } defaultTitle:@"是" defaultHandler:^(UIAlertAction *action) {
             [YTAlertUtil showHUDWithTitle:@"正在清除..."];
            BOOL a = [[RCIMClient sharedRCIMClient] clearConversations:@[@1,@3,@6]];
            if (a) {
                [YTAlertUtil showTempInfo:@"已清理"];
                [YTAlertUtil hideHUD];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateNum" object:nil];
            }else
                [YTAlertUtil hideHUD];
        } completion:nil];
    }else if (sender.tag==2){
        [YTAlertUtil alertDualWithTitle:@"连程" message:@"是否要清空所有的聊天记录" style:UIAlertControllerStyleAlert cancelTitle:@"否" cancelHandler:^(UIAlertAction *action) {
        } defaultTitle:@"是" defaultHandler:^(UIAlertAction *action) {
             [YTAlertUtil showHUDWithTitle:@"正在清除..."];
            NSMutableArray * arr1 = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:@"MESSAGE"]];
            __block int i=0;
            for (MessageMo * mo in arr1) {
                BOOL a = [[RCIMClient sharedRCIMClient] clearMessages:mo.Type targetId:mo.ID];
                if (a) {
                    i++;
                    if (i==arr1.count) {
                        [YTAlertUtil hideHUD];
                        [YTAlertUtil showTempInfo:@"清除成功"];
                        [KUserDefults removeObjectForKey:@"MESSAGE"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateNum" object:nil];
                    }
                }else{
                    [YTAlertUtil hideHUD];
                }
            }
        } completion:nil];
    }else{
        [YTAlertUtil showHUDWithTitle:@"正在清除..."];
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [YTAlertUtil showTempInfo:@"已清除"];
            [YTAlertUtil hideHUD];
        }];
    }
}
@end
@interface AccountViewCell()
@property (nonatomic,strong)UIImageView * image_head;
@property (nonatomic,strong)UILabel * lab_title;
@property (nonatomic,strong)UIView * view_Bottom;
@end
@implementation AccountViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self addSubview:self.image_head];
        [self addSubview:self.lab_title];
        [self addSubview:self.view_Bottom];
    }
    return self;
}
-(void)setUser:(UserMo *)user{
    _user = user;
    [self.image_head sd_setImageWithURL:[NSURL URLWithString:user.headImage] placeholderImage:[UIImage imageNamed:@"our-center-1"]];
    self.lab_title.text = user.nickName?user.nickName:user.ID;
    
}
-(UIImageView *)image_head{
    if (!_image_head) {
        _image_head = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        _image_head.image = [UIImage imageNamed:@"moment_cover"];
    }
    return _image_head;
}
-(UILabel *)lab_title{
    if (!_lab_title) {
        _lab_title = [[UILabel alloc] initWithFrame:CGRectMake(self.image_head.right+10,0,200, 50)];
        _lab_title.font = [UIFont systemFontOfSize:15];
        _lab_title.textColor = YSColor(51, 51, 51);
        _lab_title.text = @"张飞";
    }
    return _lab_title;
}
-(UIView *)view_Bottom{
    if (!_view_Bottom) {
        _view_Bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 49, self.width, 1)];
        _view_Bottom.backgroundColor = YSColor(228, 228, 228);
    }
    return _view_Bottom;
}
@end
