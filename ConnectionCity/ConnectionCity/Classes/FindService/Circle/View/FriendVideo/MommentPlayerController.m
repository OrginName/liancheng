//
//  MommentPlayerController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "MommentPlayerController.h"
#import "CustomPlayer.h"
#import "Utility.h"
@interface MommentPlayerController ()<LPAVPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageBg;
@property (weak, nonatomic) IBOutlet UIImageView *image_head;
@property (weak, nonatomic) IBOutlet UILabel *lab_title;
@property (weak, nonatomic) IBOutlet UILabel *lab_SubTitle;
@property (weak, nonatomic) IBOutlet UILabel *lab_time;
@property (weak, nonatomic) IBOutlet UIButton *btn_Zan;
@property (weak, nonatomic) IBOutlet UIButton *btn_like;
@property (weak, nonatomic) IBOutlet UIButton *btn_moment;
@property (weak, nonatomic) IBOutlet UIView *view_Zan;
@property (weak, nonatomic) IBOutlet UIView *view_Like;
@property (weak, nonatomic) IBOutlet UIView *view_moment;
@property (nonatomic,strong) CustomPlayer * playView;
@end

@implementation MommentPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setMoment:self.moment];
}
-(void)setUI{
    self.navigationItem.title = @"服务圈视频";
    [self.view addSubview:self.playView];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(ShareBtn) image:@"share-1" title:@"" EdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
}
-(void)setMoment:(Moment *)moment{
    _moment = moment;
    self.imageBg.image = moment.coverImage;
    [self.image_head sd_setImageWithURL:[NSURL URLWithString:moment.userMo.headImage] placeholderImage:[UIImage imageNamed:@"no-pic"]];
    self.lab_title.text = moment.userMo.nickName;
    self.lab_SubTitle.text = moment.content;
    long long a = [[YSTools cTimestampFromString:moment.createTime] floatValue];
    self.lab_time.text = [NSString stringWithFormat:@"%@",[Utility getDateFormatByTimestamp:a]];
    [self.btn_Zan setTitle:KString(@"%@", moment.likeCount) forState:UIControlStateNormal];
}
//分享
-(void)ShareBtn{
    [YTAlertUtil showTempInfo:@"分享"];
}
- (IBAction)BtnClcik:(UIButton *)sender {
    NSArray * arr = @[@"ServiceListController",@"EvaluationController",@"ServiceListController"];
    if (sender.tag>=3) {
        [self.navigationController pushViewController:[super rotateClass:arr[sender.tag-3]] animated:YES];
    }
}
- (IBAction)palyBtnClcik:(UIButton *)sender {
    self.imageBg.hidden = YES;
    self.playView.hidden = NO;
    [self.playView setupPlayerWith:[NSURL URLWithString:self.moment.videos]];
    [self.view bringSubviewToFront:self.image_head];
    [self.view bringSubviewToFront:self.lab_title];
    [self.view bringSubviewToFront:self.lab_SubTitle];
//    [self.view bringSubviewToFront:self.btn_Zan];
//    [self.view bringSubviewToFront:self.btn_like];
//    [self.view bringSubviewToFront:self.btn_moment];
    [self.view bringSubviewToFront:self.lab_time];
    [self.view bringSubviewToFront:self.view_Zan];
    [self.view bringSubviewToFront:self.view_moment];
    [self.view bringSubviewToFront:self.view_Like];
}
// 数据刷新
- (void)refreshDataWith:(NSTimeInterval)totalTime Progress:(NSTimeInterval)currentTime LoadRange:(NSTimeInterval)loadTime{
    
}
// 状态/错误 提示
- (void)promptPlayerStatusOrErrorWith:(LPAVPlayerStatus)status{
    
}
-(CustomPlayer *)playView{
    if (!_playView) {
        _playView = [[CustomPlayer alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, kScreenHeight-145)];
        _playView.hidden = YES;
    }
    return _playView;
}
@end
