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
@interface MomentDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@property (nonatomic,strong) MomentDetailView * momment;
@end

@implementation MomentDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)ClearAll{
    [YTAlertUtil showTempInfo:@"清空"];
}
-(void)setUI{
    self.navigationItem.title = @"详情";
    if ([self.receiveMo.userId isEqualToString:[[YSAccountTool userInfo]ID]]) {
         self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(ClearAll) image:@"" title:@"清空" EdgeInsets:UIEdgeInsetsZero];
    } 
    self.momment = [[MomentDetailView alloc] initWithFrame:CGRectZero];
    self.momment.receiveMo = self.receiveMo;
    self.tab_Bottom.tableHeaderView = self.momment;
    self.tab_Bottom.tableHeaderView.height = self.receiveMo.cellHeight;
    self.momment.Btnblock = ^{
        [YTAlertUtil showTempInfo:@"我是删除"];
    };
    [self.tab_Bottom reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.receiveMo.comments.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CircleCell1"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CircleCell" owner:nil options:nil][0];
    }
    cell.moment =self.receiveMo.comments[indexPath.row];
    return cell;
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
        [self addSubview:self.delebtn];
    }
    return self;
}
//删除按钮
-(void)shareMoment:(UIButton *)btn{
    self.Btnblock();
}
-(void)setReceiveMo:(Moment *)receiveMo{
    _receiveMo =receiveMo;
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
    _delebtn.frame = CGRectMake(_timelab.right+5, _timelab.top, 60, kTimeLabelH);
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
        _timelab.font = [UIFont systemFontOfSize:13.0f];
    }
    return _timelab;
}
-(UIButton *)delebtn{
    if (!_delebtn) {
        //分享
        _delebtn = [[UIButton alloc] init];
        _delebtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_delebtn setTitleColor:YSColor(242, 151, 40) forState:UIControlStateNormal];
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
