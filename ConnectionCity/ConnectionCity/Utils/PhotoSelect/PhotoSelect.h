//
//  PhotoSelect.h
//  TZImagePickerController
//
//  Created by qt on 2018/5/22.
//  Copyright © 2018年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PhotoSelectDelegate <NSObject>
@optional
-(void)deleteImage:(NSInteger) tag arr:(NSArray *)imageArr;
@optional
-(void)selectImage:(UIImage *) image arr:(NSArray *)imageArr;
@optional
-(void)selectImageArr:(NSArray *)imageArr;
@optional
-(void)selectVideo:(NSString *)VideoUrl;
@end

@interface PhotoSelect : UIView
/// 默认为YES，如果设置为NO, 用户将不能拍摄照片
@property(nonatomic, assign) BOOL allowTakePicture;

/// Default is YES, if set NO, user can't take video.
/// 默认为YES，如果设置为NO, 用户将不能拍摄视频
@property(nonatomic, assign) BOOL allowTakeVideo;
// 设置开关
@property (assign, nonatomic) BOOL showTakePhotoBtnSwitch;  ///< 在内部显示拍照按钮
@property (assign, nonatomic) BOOL showTakeVideoBtnSwitch;  ///< 在内部显示拍视频按钮
@property (assign, nonatomic) BOOL sortAscendingSwitch;     ///< 照片排列按修改时间升序
@property (assign, nonatomic) BOOL allowPickingVideoSwitch; ///< 允许选择视频
@property (assign, nonatomic) BOOL allowPickingImageSwitch; ///< 允许选择图片
@property (assign, nonatomic) BOOL allowPickingGifSwitch;
@property (assign, nonatomic) BOOL allowPickingOriginalPhotoSwitch; ///< 允许选择原图
@property (assign, nonatomic) BOOL showSheetSwitch; ///< 显示一个sheet,把拍照按钮放在外面
@property (assign, nonatomic) NSInteger maxCountTF;  ///< 照片最大可选张数，设置为1即为单选模式
@property (assign, nonatomic) NSInteger maxCountForRow;  ///<界面上一行最多显示几张
@property (assign, nonatomic) NSInteger columnNumberTF;  ///<选择相册里图片时一行显示几张
@property (assign, nonatomic) BOOL allowCropSwitch;
@property (assign, nonatomic) BOOL needCircleCropSwitch;//圆型裁剪
@property (assign, nonatomic) BOOL allowPickingMuitlpleVideoSwitch;
@property (assign, nonatomic) BOOL showSelectedIndexSwitch;
@property (nonatomic,assign) id<PhotoSelectDelegate>PhotoDelegate;
-(instancetype)initWithFrame:(CGRect)frame withController:(UIViewController *)controll;
@end
