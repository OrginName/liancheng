//
//  MommentPlayerController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "MommentPlayerController.h"
#import "CustomPlayer.h"
@interface MommentPlayerController ()<LPAVPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageBg;
@property (weak, nonatomic) IBOutlet UIImageView *image_head;
@property (weak, nonatomic) IBOutlet UILabel *lab_title;
@property (weak, nonatomic) IBOutlet UILabel *lab_SubTitle;
@property (weak, nonatomic) IBOutlet UILabel *lab_time;
@property (weak, nonatomic) IBOutlet UIButton *btn_Zan;
@property (weak, nonatomic) IBOutlet UIButton *btn_like;
@property (weak, nonatomic) IBOutlet UIButton *btn_moment;

@property (nonatomic,strong) CustomPlayer * playView;
@end

@implementation MommentPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.navigationItem.title = @"服务圈视频";
    NSString * url = @"http://mp4.vjshi.com/2015-01-01/1420097727300_256.mp4";
    [self.view addSubview:self.playView];
    UIImage * image = [self.playView getVideoPreViewImage:url];
    self.imageBg.image = image;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(ShareBtn) image:@"f-share" title:@"" EdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    
}
//分享
-(void)ShareBtn{
    
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
    [self.playView setupPlayerWith:[NSURL URLWithString:@"http://mp4.vjshi.com/2015-01-01/1420097727300_256.mp4"]];
    [self.view bringSubviewToFront:self.image_head];
    [self.view bringSubviewToFront:self.lab_title];
    [self.view bringSubviewToFront:self.lab_SubTitle];
    [self.view bringSubviewToFront:self.btn_Zan];
    [self.view bringSubviewToFront:self.btn_like];
    [self.view bringSubviewToFront:self.btn_moment];
    [self.view bringSubviewToFront:self.lab_time];
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
