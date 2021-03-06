//
//  MMImageListView.m
//  MomentKit
//
//  Created by LEA on 2017/12/14.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MMImageListView.h"
#import "MMImagePreviewView.h"
#import "MomentKit.h"
#import "Utility.h"
#import "UIView+Geometry.h"
#import "YBImageBrowser.h"
#pragma mark - ------------------ 小图List显示视图 ------------------
#define KIMAGEWIDTH  (self.width-kPaddingValue*2)/3
@interface MMImageListView ()

// 图片视图数组
@property (nonatomic, strong) NSMutableArray *imageViewsArray;
// 预览视图
@property (nonatomic, strong) MMImagePreviewView *previewView;

@end

@implementation MMImageListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 小图(九宫格)
        _imageViewsArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 9; i++) {
            MMImageView *imageView = [[MMImageView alloc] initWithFrame:CGRectZero];
            imageView.tag = 1000 + i;
            [imageView setTapSmallView:^(MMImageView *imageView){
                [self singleTapSmallViewCallback:imageView];
            }];
            [_imageViewsArray addObject:imageView];
            [self addSubview:imageView];
        }
        // 预览视图
        _previewView = [[MMImagePreviewView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return self;
}

#pragma mark - 获取整体高度
+ (CGFloat)imageListHeightForMoment:(Moment *)moment
{
    float width = (kScreenWidth-20-2*kImagePadding-90)/3;
    // 图片高度
    CGFloat height = 0;
    NSInteger count = moment.fileCount;
    if (count == 0) {
        height = 0;
    } else if (count == 1) {
        height += [Utility getSingleSize:CGSizeMake(moment.singleWidth, moment.singleHeight)].height;
    } else if (count < 4) {
        height += width;
    } else if (count < 7) {
        height += (width*2 + kImagePadding);
    } else {
        height += (width*3 + kImagePadding*2);
    }
    return height;
}

#pragma mark - Setter
- (void)setMoment:(Moment *)moment
{
    _moment = moment;
    NSArray * imageArr = [moment.images componentsSeparatedByString:@";"];
    for (MMImageView *imageView in _imageViewsArray) {
        imageView.hidden = YES;
    }
    // 图片区
    NSInteger count = moment.fileCount;
    if (count == 0) {
        self.size = CGSizeZero;
        return;
    }
    // 更新视图数据
//    _previewView.pageNum = count;
//    _previewView.scrollView.contentSize = CGSizeMake(_previewView.width*count, _previewView.height);
    // 添加图片
    MMImageView *imageView = nil;
    for (NSInteger i = 0; i < count; i++)
    {
        if (i > 8) {
            break;
        }
        NSInteger rowNum = i/3;
        NSInteger colNum = i%3;
        float width = (kScreenWidth-20-2*kImagePadding-90)/3;
        if(count == 4) {
            rowNum = i/2;
            colNum = i%2;
            width = (kScreenWidth-20-2*kImagePadding-90)/3;
        }
        CGFloat imageX = colNum * (width + kImagePadding);
        CGFloat imageY = rowNum * (width + kImagePadding);
        CGRect frame = CGRectMake(imageX, imageY, width, width);
        
        //单张图片需计算实际显示size
        if (count == 1) {
            CGSize singleSize = [Utility getSingleSize:CGSizeMake(moment.singleWidth, moment.singleHeight)];
            frame = CGRectMake(0, 0, singleSize.width, singleSize.height);
        }
        imageView.imageUrl = imageArr[i];
        imageView = [self viewWithTag:1000+i];
        imageView.hidden = NO;
        imageView.frame = frame;
        NSString * str = @"";
        if (imageArr.count==1) {
            str = KString(@"?imageView2/2/w/%d", 400);
        }else
            str = @"?imageView2/1/w/200/h/200";
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageArr[i],str]] placeholderImage:[UIImage imageNamed:@"logo2"]];
    }
    self.width = kTextWidth;
    self.height = imageView.bottom;
}
#pragma mark - 小图单击
- (void)singleTapSmallViewCallback:(MMImageView *)imageView
{
    NSArray * imageArr = [self.moment.images componentsSeparatedByString:@";"];
    NSMutableArray *browserDataArr = [NSMutableArray array];
    [imageArr enumerateObjectsUsingBlock:^(NSString *_Nonnull urlStr, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![YSTools dx_isNullOrNilWithObject:urlStr]) {
            YBImageBrowseCellData *data = [YBImageBrowseCellData new];
            data.url = [NSURL URLWithString:urlStr];
            data.sourceObject = _imageViewsArray[idx];
            [browserDataArr addObject:data];
        }
    }];
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = browserDataArr;
    browser.currentIndex = imageView.tag-1000;
    [browser show];
    
//    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
//    // 解除隐藏
//    [window addSubview:_previewView];
//    [window bringSubviewToFront:_previewView];
//    // 清空
//    [_previewView.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    // 添加子视图
//    NSInteger index = imageView.tag-1000;
//    NSInteger count = _moment.fileCount;
//    CGRect convertRect;
//    if (count == 1) {
//        [_previewView.pageControl removeFromSuperview];
//    }
//    for (NSInteger i = 0; i < count; i ++)
//    {
//        // 转换Frame
//        MMImageView *pImageView = (MMImageView *)[self viewWithTag:1000+i];
//        convertRect = [[pImageView superview] convertRect:pImageView.frame toView:window];
//        // 添加
//        MMScrollView *scrollView = [[MMScrollView alloc] initWithFrame:CGRectMake(i*_previewView.width, 0, _previewView.width, _previewView.height)];
//        scrollView.tag = 100+i;
//        scrollView.maximumZoomScale = 2.0;
//        [scrollView.imageView sd_setImageWithURL:[NSURL URLWithString:imageArr[i]] placeholderImage:[UIImage imageNamed:@"no-pic"]];
////        scrollView.image = pImageView.image;
//        scrollView.contentRect = convertRect;
//        // 单击
//        [scrollView setTapBigView:^(MMScrollView *scrollView){
//            [self singleTapBigViewCallback:scrollView];
//        }];
//        // 长按
//        [scrollView setLongPressBigView:^(MMScrollView *scrollView){
//            [self longPresssBigViewCallback:scrollView];
//        }];
//        [_previewView.scrollView addSubview:scrollView];
//        if (i == index) {
//            [UIView animateWithDuration:0.3 animations:^{
//                _previewView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
//                _previewView.pageControl.hidden = NO;
//                [scrollView updateOriginRect];
//            }];
//        } else {
//            [scrollView updateOriginRect];
//        }
//    }
//    // 更新offset
//    CGPoint offset = _previewView.scrollView.contentOffset;
//    offset.x = index * kWidth;
//    _previewView.scrollView.contentOffset = offset;
}

#pragma mark - 大图单击||长按
- (void)singleTapBigViewCallback:(MMScrollView *)scrollView
{
    [UIView animateWithDuration:0.3 animations:^{
        _previewView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        _previewView.pageControl.hidden = YES;
        scrollView.contentRect = scrollView.contentRect;
        scrollView.zoomScale = 1.0;
    } completion:^(BOOL finished) {
        [_previewView removeFromSuperview];
    }];
}

- (void)longPresssBigViewCallback:(MMScrollView *)scrollView
{
    
}

@end

#pragma mark - ------------------ 单个小图显示视图 ------------------
@implementation MMImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.clipsToBounds  = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.contentScaleFactor = [[UIScreen mainScreen] scale];
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCallback:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)singleTapGestureCallback:(UIGestureRecognizer *)gesture
{
    if (self.tapSmallView) {
        self.tapSmallView(self);
    }
}

@end
