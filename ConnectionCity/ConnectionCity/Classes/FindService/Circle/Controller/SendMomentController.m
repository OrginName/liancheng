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
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "AgreementController.h"
@interface SendMomentController ()<PhotoSelectDelegate>
{
    CGFloat itemHeigth;
    NSString * _videoUrl;
    int _isPic;//是否包含图片
    int _isVideo;//是否包含视频
    NSString * _imageURL,*_coverImgaeUrl;
}
@property (weak, nonatomic) IBOutlet UIButton *btn_GZ;
@property (weak, nonatomic) IBOutlet CustomtextView *txt_Moment;
@property (weak, nonatomic) IBOutlet UIView *view_Photo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_photoSlect;
@property (nonatomic,strong)PhotoSelect * photo;
@property (nonatomic,strong) NSMutableArray * Arr_images;
@property (nonatomic,strong) UIImage * coverImage;
@end
@implementation SendMomentController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    _isPic = 0;
    _isVideo = 0;
    self.Arr_images = [NSMutableArray array];
    if ([self.receive_flag isEqualToString:@"EDIT"]) {
        [self initData];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAll) name:@"REMOVEALL" object:nil];
}
-(void)removeAll{
//    [self.photo.selectedPhotos removeAllObjects];
//    [self.photo.selectedAssets removeAllObjects];
    [self.Arr_images removeAllObjects];
}
-(void)initData{
    self.txt_Moment.text = self.receive_Moment.content;
    if ([KString(@"%@", self.receive_Moment.containsImage) isEqualToString:@"1"]) {
        _isPic = 1;
//        _imageURL = self.receive_Moment.images;
        NSArray * arr = [self.receive_Moment.images componentsSeparatedByString:@";"];
        for (int i=0; i<arr.count; i++) {
            if ([arr[i] length]!=0) {
                [self.photo.selectedPhotos addObject:arr[i]];
                [self.Arr_images addObject:arr[i]];
                [self.photo.selectedAssets addObject:@{@"name":arr[i],@"filename":@"image",@"flag":self.receive_flag}];
            }
        }
    }
    if ([KString(@"%@", self.receive_Moment.containsVideo) isEqualToString:@"1"]) {
        _isVideo = 1;
        _videoUrl = self.receive_Moment.videos;
        _coverImgaeUrl = self.receive_Moment.videoCover;
        self.photo.selectedPhotos = [NSMutableArray arrayWithObject:self.receive_Moment.videos];
        [self.photo.selectedAssets addObject:@{@"filename":@"video",@"flag":self.receive_flag}];
    }
}
//完成
-(void)complete{
    if (self.txt_Moment.text.length==0) {
        return [YTAlertUtil showTempInfo:@"对圈子内的朋友说点什么..."];
    }
    if (!self.btn_GZ.selected) {
        return [YTAlertUtil showTempInfo:@"请阅读并同意软件使用规则"];
    }
    BOOL a = [self.receive_flag isEqualToString:@"EDIT"]?YES:NO;
    __block NSString * urlStr = @"";//图片路径拼接
    __block NSString * videoStr = @"";//视频路径
    __block NSInteger index = 0;
    [YTAlertUtil showHUDWithTitle:a?@"正在更新":@"正在发布"];
    if (self.Arr_images.count!=0) {
        for (int i=0; i<self.Arr_images.count; i++) {
            if ([self.Arr_images[i] isKindOfClass:[NSString class]]&&[self.Arr_images[i] containsString:@"http"]) {
                index++;
                urlStr = [NSString stringWithFormat:@"%@%@",self.Arr_images[i],urlStr];
                if (index==self.Arr_images.count) {
                    [self loadData:urlStr urlVideo:@""];
                }
                
            }else{
                [[QiniuUploader defaultUploader] uploadImageToQNFilePath:self.Arr_images[i] withBlock:^(NSDictionary *url) {
                    index++;
                    urlStr = [NSString stringWithFormat:@"%@%@;%@",QINIUURL,url[@"hash"],urlStr];
                    if (index==self.Arr_images.count) {
                        [self loadData:urlStr urlVideo:@""];
                    }
                }];
            }
        }
    }else if (_videoUrl.length!=0) {
        if ([_videoUrl isKindOfClass:[NSString class]]&&[_videoUrl containsString:@"http"]) {
            [self loadData:@"" urlVideo:_videoUrl];
        }else{
            [[QiniuUploader defaultUploader] uploadVideoToQNFilePath:_videoUrl withBlock:^(NSDictionary *url) {
                videoStr = [NSString stringWithFormat:@"%@%@",QINIUURL,url[@"hash"]];
                if (![YSTools dx_isNullOrNilWithObject:_coverImgaeUrl]&&_coverImgaeUrl.length!=0) {
                    [self loadData:@"" urlVideo:videoStr];
                    return;
                }
                [[QiniuUploader defaultUploader] uploadImageToQNFilePath:[UIImage thumbnailOfAVAsset:[NSURL URLWithString:videoStr]] withBlock:^(NSDictionary *url) {
                    _coverImgaeUrl =[NSString stringWithFormat:@"%@%@",QINIUURL,url[@"hash"]];
                    [self loadData:@"" urlVideo:videoStr];
                }];
            }];
        }
    }else{
        [YTAlertUtil showHUDWithTitle:a?@"正在更新":@"正在发布"];
        [self loadData:@"" urlVideo:@""];
    }
    
    
}
//发布朋友圈
-(void)loadData:(NSString *)urlStr urlVideo:(NSString *)videoUrl{
    BOOL a = [self.receive_flag isEqualToString:@"EDIT"]?YES:NO;
    if (videoUrl.length==0&&urlStr.length==0) {
        _isPic = 1;
    }
    NSDictionary * dic = @{
                           @"cityCode": @([[KUserDefults objectForKey:kUserCityID]integerValue]),
                           @"containsImage": @(_isPic),
                           @"containsVideo": @(_isVideo),
                           @"content": self.txt_Moment.text,
                           @"images": urlStr,
                           @"videoCover":_coverImgaeUrl?_coverImgaeUrl:@"",
                           @"videos": videoUrl,
                           @"serviceCircleId":self.receive_Moment.ID?self.receive_Moment.ID:@"",
                           @"friendCircleId":self.receive_Moment.ID?self.receive_Moment.ID:@""
                           };
    NSString * url;
    if (a) {
        url = [self.flagStr isEqualToString:@"HomeMySelf"]?v1FriendCircleUpdate:v1ServiceCircleUpdate;
    }else{
        url = [self.flagStr isEqualToString:@"HomeSend"]?v1FriendCircleCreate:v1ServiceCircleCreate;
    }
    [YSNetworkTool POST:url params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.block) {
            self.block();
        }
        [self.navigationController popViewControllerAnimated:YES];
        [YTAlertUtil showHUDWithTitle:a?@"更新成功":@"发布成功"];
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
    if ([self.flagStr isEqualToString:@"CircleSend"]) {
        self.photo.allowTakeVideo = NO;
        self.photo.allowPickingVideoSwitch = NO;
        self.photo.allowTakePicture = YES;
        self.photo.allowPickingImageSwitch = YES;
    }else{
        self.photo.allowTakeVideo = YES;
        self.photo.allowPickingVideoSwitch = YES;
        self.photo.allowTakePicture = NO;
        self.photo.allowPickingImageSwitch = NO;
    }
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
    [self.Arr_images removeAllObjects];
    [self.Arr_images addObjectsFromArray:imageArr];
    if (imageArr.count<=4) {
        self.photo.height=self.layout_photoSlect.constant = itemHeigth;
    }
//    if (self.photo.maxCountTF!=1) {
//        [self.Arr_images removeObjectAtIndex:tag];
//    }
    if (imageArr.count==0&&![self.flagStr isEqualToString:@"HomeSend"]) {
        self.photo.allowTakeVideo = 1;
        _isPic = 0;
    }
    if (self.photo.maxCountTF==1) {
        _isVideo = 0;
        self.photo.maxCountTF = 8;
        _videoUrl = @"";
    }
}
- (IBAction)btnSelect:(UIButton *)sender {
    sender.selected = !sender.selected;
}
- (IBAction)btnGZ:(UIButton *)sender {
    AgreementController *agreementVC = [[AgreementController alloc]init];
    agreementVC.alias = serviceAgreement;
    [self.navigationController pushViewController:agreementVC animated:YES];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
