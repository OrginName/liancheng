//
//  Comment.h
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//
//  评论Model
//

#import <Foundation/Foundation.h>
#import "UserMo.h"
@interface Comment : BaseModel<NSCoding>

// 正文
@property (nonatomic,copy) NSString *text;
// 发布者名字
@property (nonatomic,copy) NSString *userName;
// 发布时间戳
@property (nonatomic,assign) long long time;
// 关联动态的PK
@property (nonatomic,assign) int pk;
@property (nonatomic,strong) UserMo * user;
proStr(content);
proStr(ID);
proStr(typeName);
proArr(replyList);
proStr(createTime);
@property (nonatomic,assign)CGFloat cellHeight;
@end
