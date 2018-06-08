//
//  AccountView.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/8.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AccountView.h"
#import "UIView+Geometry.h"
@interface AccountView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;

@end
@implementation AccountView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.tab_Bottom.delegate = self;
    self.tab_Bottom.dataSource = self;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[AccountViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}
//消息记录清理
- (IBAction)btnClick:(UIButton *)sender {
//    1 清空消息列表  2 清空所有聊天记录  3 清空缓存数据
    if (sender.tag==1) {
        [YTAlertUtil showTempInfo:@"清空消息列表"];
    }else if (sender.tag==2){
        [YTAlertUtil showTempInfo:@"清空所有聊天记录"];
    }else{
        [YTAlertUtil showTempInfo:@"清空缓存数据"];
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
