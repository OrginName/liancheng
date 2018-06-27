//
//  Moment.h
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//
//  动态Model
//

#import <Foundation/Foundation.h>
#import "UserMo.h"
@interface Moment : BaseModel

// 正文
@property (nonatomic,copy) NSString *text;
// 发布位置
@property (nonatomic,copy) NSString *location;
// 发布者名字
@property (nonatomic,copy) NSString *userName;
// 发布者头像路径[本地路径]
@property (nonatomic,copy) NSString *userThumbPath;
// 赞的人[逗号隔开的字符串]
@property (nonatomic,copy) NSString *praiseNameList;
// 单张图片的宽度
@property (nonatomic,assign) CGFloat singleWidth;
// 单张图片的高度
@property (nonatomic,assign) CGFloat singleHeight;
// 图片数量
@property (nonatomic,assign) NSInteger fileCount;
// 发布时间戳
@property (nonatomic,assign) long long time;
// 显示'全文'/'收起'
@property (nonatomic,assign) BOOL isFullText;
// 评论集合
@property (nonatomic,strong) NSArray *commentList;

@property (nonatomic,assign) CGFloat cellHeight;

proStr(userId);
proStr(ID);
proStr(content);
proStr(cityName);
proStr(cityCode);
proStr(createTime);
proStr(videos);
proStr(likeCount);//点赞数
proStr(images);//图片
proArr(comments);//不知道是不是评价先放着
@property (nonatomic,strong)UIImage * coverImage;
@property (nonatomic,strong) UserMo * userMo;
@end
