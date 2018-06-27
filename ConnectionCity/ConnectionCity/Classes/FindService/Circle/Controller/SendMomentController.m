//
//  SendMomentController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "SendMomentController.h"
#import "PhotoSelect.h"
#import "QiniuUploader.h"
@interface SendMomentController ()<PhotoSelectDelegate>
{
    CGFloat itemHeigth;
    NSString * _videoUrl;
    int _isPic;//是否包含图片
    int _isVideo;//是否包含视频
}
@property (weak, nonatomic) IBOutlet CustomtextView *txt_Moment;
@property (weak, nonatomic) IBOutlet UIView *view_Photo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_photoSlect;
@property (nonatomic,strong)PhotoSelect * photo;
@property (nonatomic,strong) NSMutableArray * Arr_images;
@end
@implementation SendMomentController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    _isPic = 0;
    _isVideo = 0;
    self.Arr_images = [NSMutableArray array];
}
//完成
-(void)complete{
    if (self.txt_Moment.text.length==0) {
        return [YTAlertUtil showHUDWithTitle:@"对圈子内的朋友说点什么..."];
    }
    __block NSString * urlStr = @"";//图片路径拼接
    __block NSString * videoStr = @"";//视频路径
    __block NSInteger index = 0;
    [YTAlertUtil showHUDWithTitle:@"正在发布"];
    if (self.Arr_images.count!=0) {
        for (int i=0; i<self.Arr_images.count; i++) {
            [[QiniuUploader defaultUploader] uploadImageToQNFilePath:self.Arr_images[i] withBlock:^(NSDictionary *url) {
                index++;
                urlStr = [NSString stringWithFormat:@"%@%@;%@",QINIUURL,url[@"hash"],urlStr];
                if (index==self.Arr_images.count) {
                    [self loadData:urlStr urlVideo:@""];
                }
            }];
        }
    }else if (_videoUrl.length!=0) {
        [[QiniuUploader defaultUploader] uploadVideoToQNFilePath:_videoUrl withBlock:^(NSDictionary *url) {
            videoStr = [NSString stringWithFormat:@"%@%@",QINIUURL,url[@"hash"]];
            [self loadData:@"" urlVideo:videoStr];
        }];
    }else{
        [YTAlertUtil showHUDWithTitle:@"正在发布"];
        [self loadData:@"" urlVideo:@""];
    }
    
    
}
//发布朋友圈
-(void)loadData:(NSString *)urlStr urlVideo:(NSString *)videoUrl{
    NSDictionary * dic = @{
//                           @"areaCode":@,
                           @"cityCode": @([[KUserDefults objectForKey:kUserCityID]integerValue]),
                           @"containsImage": @(_isPic),
                           @"containsVideo": @(_isVideo),
                           @"content": self.txt_Moment.text,
                           @"images": urlStr,
                           @"videos": videoUrl
                           };
    [YSNetworkTool POST:v1ServiceCircleCreate params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        self.block();
        [self.navigationController popViewControllerAnimated:YES];
        [YTAlertUtil showHUDWithTitle:@"发布成功"];
        [YTAlertUtil hideHUD];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
-(void)setUI{
    self.txt_Moment.placeholder = @"   对圈子内的朋友说点什么...";
    self.txt_Moment.placeholderColor = YSColor(182, 182, 182);
    self.navigationItem.title = @"服务圈";
    itemHeigth = (self.view_Photo.width - 50) / 4+10;
    self.photo = [[PhotoSelect alloc] initWithFrame:CGRectMake(0, 0, self.view_Photo.width, itemHeigth) withController:self];
    self.photo.showTakePhotoBtnSwitch = NO;
    self.photo.showTakeVideoBtnSwitch=NO;
    self.photo.allowPickingImageSwitch = YES;//是否允许选取照片
    self.photo.allowPickingVideoSwitch = YES;
    self.photo.showSelectedIndexSwitch = NO;
    self.photo.backgroundColor = [UIColor whiteColor];
    self.photo.PhotoDelegate = self;
    [self.view_Photo addSubview:self.photo];
    self.layout_photoSlect.constant = itemHeigth;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(complete) image:@"" title:@"完成" EdgeInsets:UIEdgeInsetsZero];
}
#pragma mark ----PhotoSelectDelegate-----
-(void)selectImageArr:(NSArray *)imageArr{//图片
    NSLog(@"%lu",(unsigned long)imageArr.count);
    if (imageArr.count>=4) {
        self.photo.height=self.layout_photoSlect.constant = itemHeigth*2;
    }
    _isPic = 1;
    self.photo.allowTakeVideo = NO;
    [self.Arr_images addObjectsFromArray:imageArr];
}
-(void)selectVideo:(NSString *)VideoUrl{//视频
    _videoUrl = VideoUrl;
    self.photo.maxCountTF = 1;
    _isVideo = 1;
}
-(void)selectImage:(UIImage *)image arr:(NSArray *)imageArr{
    [self.Arr_images addObjectsFromArray:imageArr];
}
-(void)deleteImage:(NSInteger) tag arr:(NSArray *)imageArr{
    if (imageArr.count<=4) {
        self.photo.height=self.layout_photoSlect.constant = itemHeigth;
    }
    if (self.photo.maxCountTF!=1) {
        [self.Arr_images removeObjectAtIndex:tag];
    }
    if (imageArr.count==0) {
        self.photo.allowTakeVideo = 1;
        _isPic = 0;
    }
    if (self.photo.maxCountTF==1) {
        _isVideo = 0;
        self.photo.maxCountTF = 8;
        _videoUrl = @"";
    }
}
@end
