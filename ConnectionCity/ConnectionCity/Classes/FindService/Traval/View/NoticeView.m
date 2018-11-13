//
//  NoticeView.m
//  ConnectionCity
//
//  Created by umbrella on 2018/11/13.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "NoticeView.h"
#import "TXScrollLabelView.h"
#import "CircleNet.h"
#import "noticeMo.h"
#import "AgreementController.h"
@interface NoticeView()<TXScrollLabelViewDelegate>
@property (nonatomic,strong)UIViewController * control;
@property (nonatomic,strong)NSMutableArray * arr_notice;
@property (nonatomic,strong)TXScrollLabelView * scrollLable;
@end
@implementation NoticeView
-(instancetype)initWithFrame:(CGRect)frame controller:(UIViewController *)contro{
    if (self = [super initWithFrame:frame]) {
        self.arr_notice = [NSMutableArray array];
        self.control = contro;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
        [self addSubview:view];
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
        image.image = [UIImage imageNamed:@"news"];
        image.backgroundColor = [UIColor whiteColor];
        [view addSubview:image];
        NSString *scrollTitle = @"";
        TXScrollLabelView *scrollLabelView = [TXScrollLabelView scrollWithTitle:scrollTitle type:TXScrollLabelViewTypeLeftRight velocity:2 options:UIViewAnimationOptionCurveEaseInOut];
        scrollLabelView.scrollLabelViewDelegate = self;
//        scrollLabelView.click = ^{
//            NSLog(@"14123123123213");
//        };
        scrollLabelView.scrollInset = UIEdgeInsetsMake(0, -100, 0, 0);
        scrollLabelView.scrollTitleColor = YSColor(40, 40, 40);
        scrollLabelView.font = [UIFont systemFontOfSize:15];
        scrollLabelView.backgroundColor = [UIColor whiteColor];
        scrollLabelView.frame = CGRectMake(40, 0, kScreenWidth-70, 50);
        [view addSubview:scrollLabelView];
        self.scrollLable = scrollLabelView;
        [self loadNotice];
    }
    return self;
}
-(void)loadNotice{
    NSDictionary * dic = @{
                           @"pageNumber":@1,
                           @"pageSize":@20,
                           @"cityCode":[KUserDefults objectForKey:kUserCityID]?@([[KUserDefults objectForKey:kUserCityID] intValue]):@"",
                           };
    WeakSelf
    [CircleNet requstNotice:dic withSuc:^(NSMutableArray *successDicValue) {
        if([successDicValue count]==0){
            
        }else{
            NSArray * arr = [NoticeMo mj_objectArrayWithKeyValuesArray:successDicValue];
            weakSelf.arr_notice = [arr mutableCopy];
            weakSelf.scrollLable.scrollTitle = [arr[arr.count-1] title];
            [weakSelf.scrollLable beginScrolling];
        }
    }];
}
#pragma mark - LMJScrollTextView2 Delegate
- (void)scrollLabelView:(TXScrollLabelView *)scrollLabelView didClickWithText:(NSString *)text atIndex:(NSInteger)index{
    NoticeMo * mo  = self.arr_notice[self.arr_notice.count-1];
    AgreementController *agreementVC = [[AgreementController alloc]init];
    agreementVC.title = @"详情";
    agreementVC.url = mo.url;
    [self.control.navigationController pushViewController:agreementVC animated:YES];
}
@end
