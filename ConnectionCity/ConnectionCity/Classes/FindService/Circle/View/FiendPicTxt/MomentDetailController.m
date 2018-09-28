//
//  MomentDetailController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//
#import "MomentDetailController.h"
#import "MomentKit.h"
#import "UIView+Geometry.h"
#import "MMImageListView.h"
#import "Utility.h"
#import "CircleCell.h"
#import "privateUserInfoModel.h"
#import "CommentView.h"
#import <IQKeyboardManager.h>
#import "ServiceListController.h"
#import "ServiceHomeNet.h"
#import "ShowResumeController.h"
#import "CircleNet.h"
@interface MomentDetailController ()<UITableViewDelegate,UITableViewDataSource,CommentViewDelegate>
{
    NSInteger CurrentIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@property (nonatomic,strong) MomentDetailView * momment;
@property (nonatomic,strong)CommentView * comment;

@end

@implementation MomentDetailController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [self loadCircleDetail];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    if ([[self.receiveMo.userMo.ID description] isEqualToString:[[YSAccountTool userInfo]modelId]]) {
    }
    [self setComment];
    CurrentIndex = 0;
}
-(void)loadCircleDetail{
    WeakSelf
    [CircleNet requstCircleDetail:@{@"id":self.receiveMo.ID} withSuc:^(NSMutableArray *successArrValue) {
        weakSelf.receiveMo.comments = successArrValue;
        [weakSelf.tab_Bottom reloadData];
    }];
}
-(void)saveClick{
    int a = [self.flagStr isEqualToString:@"HomeSend"]?40:20;
    [YSNetworkTool POST:v1CommonCollectCreate params:@{@"type":@(a),@"typeId":self.receiveMo.ID} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [YTAlertUtil showTempInfo:responseObject[@"message"]];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
-(void)ClearAll{
    WeakSelf
    [YTAlertUtil alertDualWithTitle:@"连程" message:@"是否要删除当前动态" style:UIAlertControllerStyleAlert cancelTitle:@"否" cancelHandler:^(UIAlertAction *action) {
        
    } defaultTitle:@"是" defaultHandler:^(UIAlertAction *action) {
        NSString * url = [weakSelf.flagStr isEqualToString:@"HomeSend"]?v1FriendCircleDelete:v1ServiceCircleDelete;
        [YSNetworkTool POST:url params:@{@"id":weakSelf.receiveMo.ID} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            weakSelf.block();
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [YTAlertUtil showTempInfo:@"删除成功"];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    } completion:nil];
    
}
-(void)setUI{
    WeakSelf
    self.navigationItem.title = @"详情";
    if ([self.receiveMo.userId isEqualToString:[[YSAccountTool userInfo]modelId]]) {
         self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(ClearAll) image:@"" title:@"清空" EdgeInsets:UIEdgeInsetsZero];
    }
    self.momment = [[MomentDetailView alloc] initWithFrame:CGRectZero];
    self.momment.receiveMo = self.receiveMo;
    self.tab_Bottom.tableHeaderView = self.momment;
    self.tab_Bottom.tableHeaderView.height = self.receiveMo.cellHeight;
    self.momment.Btnblock = ^{
        [weakSelf ClearAll];
    };//删除
    self.momment.saveBlock = ^{
        [weakSelf saveClick];
    };//收藏 
    self.momment.YDBlock = ^{
//        ServiceListController * serive = [ServiceListController new];
//        serive.user = weakSelf.receiveMo.userMo;
//        [weakSelf.navigationController pushViewController:serive animated:YES];
        [weakSelf loadServiceList];
    };//约单
    [self.tab_Bottom reloadData];
}
//加载服务列表数据
-(void)loadServiceList{
    NSDictionary * dic1 = @{
                            @"cityCode":self.receiveMo.userMo.cityCode?self.self.receiveMo.userMo.cityCode:@"",
                            @"lat": @([self.receiveMo.userMo.lat floatValue]),
                            @"lng": @([self.receiveMo.userMo.lng floatValue]),
                            @"userId":self.receiveMo.userMo.ID
                            };
    //    加载服务列表
    [ServiceHomeNet requstServiceList:dic1 withSuc:^(NSMutableArray *successArrValue) {
        if (successArrValue.count==0) {
            return [YTAlertUtil showTempInfo:@"该用户暂无服务"];
        }
        ShowResumeController * show = [ShowResumeController new];
        show.Receive_Type = ENUM_TypeTrval;
        show.data_Count = successArrValue;
        show.flag = @"1";
        __block NSUInteger index = 0;
        show.zIndex = index;
        [self.navigationController pushViewController:show animated:YES];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.receiveMo.comments.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Comment * comm = self.receiveMo.comments[indexPath.row];
    return comm.cellHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CircleCell0"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CircleCell" owner:nil options:nil][0];
    }
    //添加长按手势
    UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
    longPressGesture.minimumPressDuration=1.0f;//设置长按 时间
    [cell addGestureRecognizer:longPressGesture];
    
    cell.moment =self.receiveMo.comments[indexPath.row];
    return cell;
}
-(void)cellLongPress:(UILongPressGestureRecognizer *)longRecognizer{
    if (longRecognizer.state==UIGestureRecognizerStateBegan) {
        //成为第一响应者，需重写该方法
        if ([[self.receiveMo.userMo.ID description] isEqualToString:[[YSAccountTool userInfo]modelId]]) {
            [self becomeFirstResponder];
            CGPoint location = [longRecognizer locationInView:self.tab_Bottom];
            NSIndexPath * indexPath = [self.tab_Bottom indexPathForRowAtPoint:location];
            Comment * comm = self.receiveMo.comments[indexPath.row];
            CircleCell * cell = (CircleCell *)longRecognizer.view;
            [cell becomeFirstResponder];
            [self setMenItem:comm.replyList cell:cell];
            CurrentIndex = indexPath.row;
        }
    }
}
-(void)setMenItem:(NSArray *)arr cell:(CircleCell *)cell{
    UIMenuItem *itCopy;
    UIMenuItem *itDelete;
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (arr.count!=0) {
        itDelete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(handleDeleteCell:)];
        [menu setMenuItems:@[itDelete]];
    }else{
        itCopy = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(handleCopyCell:)];
        itDelete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(handleDeleteCell:)];
        [menu setMenuItems:@[itCopy,itDelete]];
    }
    [menu setTargetRect:cell.frame inView:self.view];
    [menu setMenuVisible:YES animated:YES];
}
-(void)handleCopyCell:(id)sender{
    self.comment.textField.text = @"";
    [self.comment.textField becomeFirstResponder];
}
-(void)handleDeleteCell:(id)sender{
    //    [YTAlertUtil showTempInfo:@"我是删除"];
    [self deleteOnce];//删除
}
-(void)deleteOnce{
    Comment * comm = self.receiveMo.comments[CurrentIndex];
    [YSNetworkTool POST:v1CommonCommentDelete params:@{@"id":comm.ID} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.receiveMo.comments removeObjectAtIndex:CurrentIndex];
        [self.tab_Bottom reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark -----CommentViewDelegate------
- (void)sendValue{
    Comment * comm = self.receiveMo.comments[CurrentIndex];
    [self reply:comm.ID];
}
-(void)reply:(NSString *)ID{
    NSDictionary * dic1 = @{
                            @"commentId": @([ID integerValue]),
                            @"content": self.comment.textField.text
                            };
    [YSNetworkTool POST:v1CommonCommentReplay params:dic1 showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        Comment * obj = self.receiveMo.comments[CurrentIndex];
        NSMutableArray * arr = [NSMutableArray array];
        [arr addObject:responseObject[@"data"]];
        obj.replyList = [arr copy];
        [self.receiveMo.comments replaceObjectAtIndex:CurrentIndex withObject:obj];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.comment.textField resignFirstResponder];
            [self.tab_Bottom reloadData];
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [self.comment removeFromSuperview];
}
-(void)setComment{
    self.comment = [[CommentView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 40)];
    self.comment.placeHolder = @"请输入回复内容";
    self.comment.btnTitle = @"回复";
    self.comment.delegate = self;
    [KWindowView addSubview:self.comment];
}
@end
#pragma mark------头部view-------
#define TitleColor  [UIColor colorWithRed:179 / 255.0 green:179 / 255.0 blue:179 / 255.0 alpha:1.0]
@interface MomentDetailView()
@property (nonatomic,strong)UIImageView * headImage;
@property (nonatomic,strong)UILabel * headTitleLab;
@property (nonatomic,strong)UILabel * labDes;
@property (nonatomic,strong)UILabel * timelab;
@property (nonatomic,strong)UIButton * delebtn;
@property (nonatomic,strong)UIButton * btnSave;
@property (nonatomic,strong)UIButton * btnYD;
@property (nonatomic,strong)MMImageListView * listView;
@end
@implementation MomentDetailView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self addSubview:self.headImage];
        [self addSubview:self.headTitleLab];
        [self addSubview:self.labDes];
        [self addSubview:self.listView];
        [self addSubview:self.timelab];
        [self addSubview:self.btnYD];
        [self addSubview:self.btnSave];
        [self addSubview:self.delebtn];
    }
    return self;
}
//删除按钮
-(void)shareMoment:(UIButton *)btn{
    self.Btnblock();
}
//收藏button
-(void)SaveMoment:(UIButton *)btn{
    self.saveBlock();
}
//约单button
-(void)YDMoment:(UIButton *)btn{
    if (self.YDBlock) {
        self.YDBlock();
    }
}
-(void)setReceiveMo:(Moment *)receiveMo{
    _receiveMo =receiveMo;
    if ([receiveMo.userId isEqualToString:[[YSAccountTool userInfo]modelId]]) {
        self.delebtn.hidden = NO;
    }
    // 头像
    [_headImage sd_setImageWithURL:[NSURL URLWithString:receiveMo.userMo.headImage] placeholderImage:[UIImage imageNamed:@"no-pic"]];
    // 昵称
    _headTitleLab.text = receiveMo.userMo.nickName;
    CGFloat bottom = _headTitleLab.bottom + kPaddingValue;
    if ([receiveMo.content length]) {
        _labDes.text = receiveMo.content;
         CGFloat labH = [self calculateRowHeight:receiveMo.content fontSize:15];
        _labDes.frame = CGRectMake(_headTitleLab.left, bottom, kScreenWidth-90, labH);
        bottom = _labDes.bottom + kPaddingValue;
    }
    // 图片
    _listView.moment = receiveMo;
    if (receiveMo.fileCount > 0) {
        _listView.origin = CGPointMake(_headTitleLab.left, bottom);
        bottom = _listView.bottom + kPaddingValue;
    }
    long long a = [[YSTools cTimestampFromString:receiveMo.createTime] floatValue];
    _timelab.text = [NSString stringWithFormat:@"%@",[Utility getDateFormatByTimestamp:a]];
    CGFloat textW = [_timelab.text boundingRectWithSize:CGSizeMake(200, kTimeLabelH)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:_timelab.font}
                                                context:nil].size.width;
    _timelab.frame = CGRectMake(_headTitleLab.left, bottom, textW, kTimeLabelH);
    [_btnYD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timelab.mas_top);
        make.left.equalTo(_timelab.mas_right).offset(5);
        make.bottom.equalTo(_timelab.mas_bottom);
    }];
    [_btnSave mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timelab.mas_top);
        make.left.equalTo(_btnYD.mas_right).offset(5);
        make.bottom.equalTo(_btnYD.mas_bottom);
    }];
    [_delebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timelab.mas_top);
        make.left.equalTo(_btnSave.mas_right).offset(5);
        make.bottom.equalTo(_timelab.mas_bottom);
    }];
    receiveMo.cellHeight =_timelab.bottom+20;
}
-(UIImageView *)headImage{
    if (!_headImage) {
        // 头像视图
        _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 40, 40)];
        _headImage.contentMode = UIViewContentModeScaleAspectFill;
        _headImage.userInteractionEnabled = YES;
        _headImage.layer.cornerRadius = 5;
        _headImage.layer.masksToBounds = YES;
    }
    return _headImage;
}
-(UILabel *)headTitleLab{
    if (!_headTitleLab) {
        // 名字视图
        _headTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(_headImage.right+10, _headImage.top, kTextWidth, 20)];
        _headTitleLab.font = [UIFont boldSystemFontOfSize:17.0];
        _headTitleLab.textColor = kHLTextColor;
        _headTitleLab.backgroundColor = [UIColor clearColor];
    }
    return _headTitleLab;
}
-(UILabel *)labDes{
    if (!_labDes) {
        // 正文视图
        _labDes = [[UILabel alloc] init];
        _labDes.font = kTextFont;
        _labDes.numberOfLines = 0;
        _labDes.textColor = YSColor(179, 179, 179);
    }
    return _labDes;
}
-(MMImageListView *)listView{
    if (!_listView) {
        // 图片区
        _listView = [[MMImageListView alloc] initWithFrame:CGRectZero];
    }
    return _listView;
}
-(UILabel *)timelab{
    if (!_timelab) {
        // 时间视图
        _timelab = [[UILabel alloc] init];
        _timelab.textColor = TitleColor;
        _timelab.font = [UIFont systemFontOfSize:14.0f];
    }
    return _timelab;
}
-(UIButton *)btnYD{
    if (!_btnYD) {
        //收藏
        _btnYD = [[UIButton alloc] init];
        _btnYD.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_btnYD setTitleColor:YSColor(242, 151, 40) forState:UIControlStateNormal];
        _btnYD.backgroundColor = [UIColor clearColor];
        [_btnYD setTitle:@"约单" forState:UIControlStateNormal];
        [_btnYD addTarget:self action:@selector(YDMoment:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnYD;
}
-(UIButton *)btnSave{
    if (!_btnSave) {
        //收藏
        _btnSave = [[UIButton alloc] init];
        _btnSave.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_btnSave setTitleColor:YSColor(242, 151, 40) forState:UIControlStateNormal];
         _btnSave.backgroundColor = [UIColor clearColor];
        [_btnSave setTitle:@"收藏" forState:UIControlStateNormal];
        [_btnSave addTarget:self action:@selector(SaveMoment:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSave;
}
-(UIButton *)delebtn{
    if (!_delebtn) {
        //分享
        _delebtn = [[UIButton alloc] init];
        _delebtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_delebtn setTitleColor:YSColor(242, 151, 40) forState:UIControlStateNormal];
        _delebtn.hidden = YES;
        _delebtn.backgroundColor = [UIColor clearColor];
        [_delebtn setTitle:@"删除" forState:UIControlStateNormal];
        [_delebtn addTarget:self action:@selector(shareMoment:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delebtn;
}
- (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};//指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(kScreenWidth - 90, 0)/*计算高度要先指定宽度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
}
@end
