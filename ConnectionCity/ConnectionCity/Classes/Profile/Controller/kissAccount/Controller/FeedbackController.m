//
//  FeedbackController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/8/18.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FeedbackController.h"
#import "YTAdviceInputView.h"
#import "YTPlaceholderTextView.h"
#import "PhotoSelect.h"
#import "AllDicMo.h"
#import "QiniuUploader.h"

@interface FeedbackController ()<PhotoSelectDelegate>
@property (weak, nonatomic) IBOutlet UIView *adviceBgV;
@property (weak, nonatomic) IBOutlet UIView *photoBgV;
@property (weak, nonatomic) IBOutlet UILabel *categoryLab;
@property (nonatomic, strong) YTAdviceInputView *adviceView;
@property (nonatomic, strong) PhotoSelect * photo;
@property (nonatomic, strong) NSMutableArray *Arr_Url;
@property (nonatomic, strong) AllContentMo * mo;

@end

@implementation FeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setUI];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setUI {
    NSMutableArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:KAllDic]];
    NSArray *contentArr = [arr[32] contentArr];
    if (contentArr.count>0) {
        _mo = contentArr[0];
        _categoryLab.text = _mo.description1;
    }
    [_adviceBgV addSubview:self.adviceView];
    self.photo = [[PhotoSelect alloc] initWithFrame:CGRectMake(0, 0, _photoBgV.width, _photoBgV.height) withController:self];
    self.photo.backgroundColor = [UIColor whiteColor];
    self.photo.PhotoDelegate = self;
    self.photo.allowTakeVideo = NO;
    self.photo.maxCountTF = 3;
    self.photo.maxCountForRow = 3;
    [_photoBgV addSubview: self.photo];
    self.Arr_Url = [NSMutableArray array];
}
- (YTAdviceInputView *)adviceView {
    if (_adviceView == nil) {
        _adviceView = [[YTAdviceInputView alloc]initWithFrame:CGRectMake(0, 0, _adviceBgV.width, _adviceBgV.height)];
        _adviceView.textView.placeholder = @"请输入您的建议和意见，我们将不断改进";
    }
    return _adviceView;
}
- (IBAction)selectCategoryBtnClick:(id)sender {
    NSMutableArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:KAllDic]];
    NSArray *contentArr = [arr[32] contentArr];
    NSMutableArray *title = [NSMutableArray array];
    for (int i=0; i < contentArr.count; i++) {
        AllContentMo * mo = contentArr[i];
        [title addObject:mo.description1];
        YTLog(@"%@",mo.description1);
        YTLog(@"%@",mo.value);
    }
    WeakSelf
    [YTAlertUtil alertMultiWithTitle:nil message:nil style:UIAlertControllerStyleActionSheet multiTitles:title multiHandler:^(UIAlertAction *action, NSArray *titles, NSUInteger idx) {
        weakSelf.mo = contentArr[idx];
        weakSelf.categoryLab.text = weakSelf.mo.description1;
    } cancelTitle:@"取消" cancelHandler:nil completion:nil];
}
- (IBAction)commitBtnClick:(id)sender {
    if ([YSTools dx_isNullOrNilWithObject:self.mo]) {
        [YTAlertUtil showTempInfo:@"请选择问题类别"];
        return;
    }
    if (self.adviceView.text.length == 0) {
        [YTAlertUtil showTempInfo:@"请输入您的宝贵意见哦"];
        return;
    }
    if (self.Arr_Url.count > 0) {
        __block NSString * urlStr = @"";
        __block NSInteger index = 0;
        [YTAlertUtil showHUDWithTitle:@"正在上传图片"];
        for (int i=0; i<self.Arr_Url.count; i++) {
            WeakSelf
            [[QiniuUploader defaultUploader] uploadImageToQNFilePath:self.Arr_Url[i] withBlock:^(NSDictionary *url) {
                index++;
                urlStr = [NSString stringWithFormat:@"%@%@;%@",QINIUURL,url[@"hash"],urlStr];
                if (index==weakSelf.Arr_Url.count) {
                    [YTAlertUtil hideHUD];
                    [weakSelf requestSubmitFeedback:urlStr];
                }
            }];
        }
    }else{
        [self requestSubmitFeedback:nil];
    }
}
#pragma mark ----PhotoSelectDelegate-----
-(void)selectImageArr:(NSArray *)imageArr{
    [self.Arr_Url removeAllObjects];
    [self.Arr_Url addObjectsFromArray:imageArr];
}
-(void)selectImage:(UIImage *)image arr:(NSArray *)imageArr{
    [self.Arr_Url removeAllObjects];
    [self.Arr_Url addObjectsFromArray:imageArr];
}
-(void)deleteImage:(NSInteger) tag arr:(NSArray *)imageArr{
    [self.Arr_Url removeAllObjects];
    [self.Arr_Url addObjectsFromArray:imageArr];
}
#pragma mark - 请求方法
- (void)requestSubmitFeedback:(NSString *)urlStr {
    WeakSelf
    [YSNetworkTool POST:v1FeedbackCreate params:@{@"category": _mo.value,@"content":self.adviceView.text,@"image":urlStr?urlStr:@""} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [YTAlertUtil alertSingleWithTitle:@"提示" message:@"反馈提交成功，感谢您的宝贵意见" defaultTitle:@"确定" defaultHandler:^(UIAlertAction *action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } completion:nil];
    } failure:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
