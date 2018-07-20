//
//  likeModels.h
//  ConnectionCity
//
//  Created by qt on 2018/7/20.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseModel.h"
@class likeObj;
@interface likeModels : BaseModel
proStr(ID);
proStr(createTime);
proStr(userId);
@property (nonatomic,strong) likeObj * obj;
@end

@interface likeObj : BaseModel
proStr(ID);
proStr(userId);
proStr(content);
proStr(images);
proStr(videos);
proArr(imageArr);//图片数组
proStr(imageCover);//视频第一帧截图
proStr(provinceName);
proStr(containsImage);
proStr(containsVideo);
@end
