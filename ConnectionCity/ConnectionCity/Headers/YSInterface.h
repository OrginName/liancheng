//
//  YSInterface.h
//  dumbbell
//
//  Created by JYS on 16/3/10.
//  Copyright © 2016年 insaiapp. All rights reserved.
//

#ifndef YSInterface_h
#define YSInterface_h


//主机地址
#define HOSTURL @"http://120.79.69.110:8080/PT/APP/"
//加密秘钥
static NSString * const MIMISECRET = @"a33f2f4h6sf469daa9d1g8953d8js5ss";
//1、注册
static NSString * const registerURL = @"register";
//2、登录
static NSString * const loginURL = @"login";
//3、下载原始数据
static NSString * const downloadOriginalFile = @"downloadOriginalFile";
//4、按用户id查找最新检测信息
static NSString * const getUserNewRecord = @"getUserNewRecord";
//5、按用户id修改密码
static NSString * const updatepassword = @"updatepassword";
//6、下载分析报告
static NSString * const getRecordByTime = @"getRecordByTime";
//7、查看历史记录
static NSString * const findAllDetection = @"findAllDetection";
//8、按用户id查找用户详细信息
static NSString * const findUserById = @"findUserById";
//9、修改用户信息（昵称，姓名，出生日期，身高，体重，性别)
static NSString * const changeUserinfo = @"changeUserinfo";
//10、修改用户头像
static NSString * const changeUserimage = @"changeUserimage";
//11、App二维码下载地址
static NSString * const qrurl = @"http://120.79.69.110:8080/daycanhealth.png";
//12、头像地址
static NSString * const headerurl = @"http://120.79.69.110:8080/PT/image/";
//13、原始数据txt文件下载地址
static NSString * const uploadurl = @"http://120.79.69.110:8080/PT/upload/";



#endif /* YSInterface_h */




