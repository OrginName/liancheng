//
//  YTDataPacket.h
//  JLTimeRent
//
//  Created by chips on 17/6/23.
//  Copyright © 2017年 YOU-TURN TECHNOLOGY CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 查询指令 */
typedef NS_OPTIONS(NSInteger, YTDataPacketCommand) {
    SOF = 0xFFEF,
    EMPTY = 0x00,
    CMD_PID_BINDING = 0x01,
    CMD_PID_UNBIND = 0x02,
    CMD_START_SENSOR_COLLECT = 0x11,
    CMD_STOP_SENSOR_COLLECT = 0x12,
    CMD_SENSOR_INFO_REPORT = 0x13,
    CMD_START_FLASH_STORE = 0x21,
    CMD_RESTORE_FLASH_STORE = 0x22,
    CMD_STOP_FLASH_STORE = 0x23,
    CMD_UPLOAD_FLASH_STORE = 0x24,
    CMD_RECEIVE_FLASH = 0x25,
    QUERY_DEV_STATUS = 0x7F,
    CMD_UPLOAD_SENSOR_INFO = 0x81,
    CMD_DNLOAD_SENSOR_INFO = 0x82,
    NEED_RES = 0x80,
    INNEED_RES = 0x00,
    
};

/** 蓝牙向Tbox发送数据包类 */
@interface YTDataPacket : NSObject


//public static byte[] getStartSensorCollect() {
//    return DataUtils.add(SOF, EMPTY, EMPTY, CMD_START_SENSOR_COLLECT, NEED_RES, EMPTY);
//}
//
//public static byte[] getStopSensorCollect() {
//    return DataUtils.add(SOF, EMPTY, EMPTY, CMD_STOP_SENSOR_COLLECT, NEED_RES, EMPTY);
//}

//public static byte[] getPidBinding(String pid, String name) {
//    byte[] PIDLen = new byte[]{(byte) (pid.length() & 0xFF)};
//    byte[] NAMELen = new byte[]{(byte) (name.length() & 0xFF)};
//    byte[] dataLen = DataUtils.intToInt16Byte(2 + pid.length() + name.length());
//    return DataUtils.add(SOF, EMPTY, EMPTY, CMD_PID_BINDING, NEED_RES, dataLen, PIDLen, pid
//                         .getBytes(), NAMELen, name.getBytes());
//}

//public static byte[] getUserInfoBinding(String userid, String phone , String pillowid, String testtime) {
//    byte[] useridLen = new byte[]{(byte) (userid.length() & 0xFF)};
//    byte[] phoneLen = new byte[]{(byte) (phone.length() & 0xFF)};
//    byte[] pillowidLen = new byte[]{(byte) (pillowid.length() & 0xFF)};
//    byte[] testtimeLen = new byte[]{(byte) (testtime.length() & 0xFF)};
//    byte[] dataLen = DataUtils.intToInt16Byte(4 + userid.length() + phone.length()+ pillowid.length() + testtime.length());
//    return DataUtils.add(SOF, EMPTY, EMPTY, CMD_PID_BINDING, NEED_RES, dataLen, useridLen, userid
//                         .getBytes(), phoneLen, phone.getBytes(), pillowidLen, pillowid.getBytes(), testtimeLen, testtime.getBytes());
//}

//public static byte[] getPidUnBind() {
//    return DataUtils.add(SOF, EMPTY, EMPTY, CMD_PID_UNBIND, NEED_RES, EMPTY, EMPTY);
//}
//
//public static byte[] getStartFlashStore() {
//    return DataUtils.add(SOF, EMPTY, EMPTY, CMD_START_FLASH_STORE, NEED_RES, EMPTY);
//}
//
//public static byte[] getRestoreFlashStore() {
//    return DataUtils.add(SOF, EMPTY, EMPTY, CMD_RESTORE_FLASH_STORE, NEED_RES, EMPTY);
//}
//
//public static byte[] getStopFlashStore() {
//    return DataUtils.add(SOF, EMPTY, EMPTY, CMD_STOP_FLASH_STORE, NEED_RES, EMPTY);
//}
//
//public static byte[] getUploadFlashStore() {
//    return DataUtils.add(SOF, EMPTY, EMPTY, CMD_UPLOAD_FLASH_STORE, NEED_RES, EMPTY);
//}
//
//public static byte[] getQueryDevStatus() {
//    return DataUtils.add(SOF, EMPTY, EMPTY, QUERY_DEV_STATUS, NEED_RES, EMPTY);
//}
//
//public static byte[] getReceiveFlash() {
//    return DataUtils.add(SOF, EMPTY, EMPTY, CMD_RECEIVE_FLASH, NEED_RES, EMPTY, EMPTY);
//}

///** 根据传来的命令标识返回数据包 */
//+ (NSData *)packetDataWithType:(YTDataPacketType)type
//                      commands:(NSArray<NSNumber *> *)commands
//                         datas:(NSArray<NSNumber *> *)datas
//                           key:(NSString *)key
//                           pwd:(NSString *)pwd;
//
///** 根据传来的命令标识返回数据包 */
//+ (NSData *)dataWithQuerys:(NSArray<NSNumber *> *)querys
//                       key:(NSString *)key;
//
///** 根据传来的命令标识返回数据包 */
//+ (NSData *)dataWithControl:(YTDataPacketCommand)control
//                       data:(NSInteger)data
//                        key:(NSString *)key
//                        pwd:(NSString *)pwd;

@end

@interface YTDataPacket (Parse)

//typedef NS_ENUM(NSInteger, YTDataPacketReplyResult) {
//    YTDataPacketReplyResultCommand = 0xFE,  // 命令
//    YTDataPacketReplyResultPush = 0xFF,  // 主动推送
//    YTDataPacketReplyResultSuccess = 0x01,  // 应答成功
//    YTDataPacketReplyResultFailure = 0x02,  //应答失败
//};
//
//typedef NS_ENUM(NSInteger, YTDataPacketReplyType) {
//    YTDataPacketReplyTypeStart = 0,  // 起始符
//    YTDataPacketReplyTypeCommand,  // 命令标识
//    YTDataPacketReplyTypeReply,  // 应答标识
//    YTDataPacketReplyTypeKey,  // 唯一识别码
//    YTDataPacketReplyTypeEncrypt,  // 数据单元加密方式
//    YTDataPacketReplyTypeDataLen,  // 数据单元长度
//    YTDataPacketReplyTypeDataUnit,  // 数据单元
//    YTDataPacketReplyTypeVerify,  //校验码
//};
//
///** 分段解析数据 */
//+ (NSData *)dataWithReply:(NSData *)data
//                     type:(YTDataPacketReplyType)type;
//
///** 解析数据返回指令类型 */
//+ (YTDataPacketType)typeWithReply:(NSData *)data;
//
///** 解析数据返回结果 */
//+ (YTDataPacketReplyResult)resultWithReply:(NSData *)data;
//
///** 解析数据返回日期 */
//+ (NSString *)dateWithReply:(NSData *)data;
//
///** 解析数据状态数组(BOOL Number类型) */
//+ (NSArray<NSNumber *> *)statesWithReply:(NSData *)data;
//
///** 解析数据控制指令 */
//+ (NSInteger)controlCommandWithReply:(NSData *)data;
//
///** 解析数据控制指令子数据 */
//+ (NSData *)controlDataWithReply:(NSData *)data;

@end
