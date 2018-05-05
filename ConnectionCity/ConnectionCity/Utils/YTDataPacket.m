//
//  YTDataPacket.m
//  JLTimeRent
//
//  Created by chips on 17/6/23.
//  Copyright © 2017年 YOU-TURN TECHNOLOGY CO.,LTD. All rights reserved.
//

#import "YTDataPacket.h"

static NSUInteger const kStartLen = 2;
static NSUInteger const kCommandLen = 1;
static NSUInteger const kReplyLen = 1;
static NSUInteger const kKeyLen = 17;
static NSUInteger const kEncryptLen = 1;
static NSUInteger const kDataLenLen = 2;
static NSUInteger const kVerifyLen = 1;
static NSUInteger const kDateLen = 6;

@interface YTDataPacket ()

@end

@implementation YTDataPacket

//+ (NSData *)dataWithQuerys:(NSArray<NSNumber *> *)querys
//                       key:(NSString *)key {
//    return [[self class]packetDataWithType:YTDataPacketTypeQuery commands:querys datas:nil key:key pwd:nil];
//}
//
//+ (NSData *)dataWithControl:(YTDataPacketCommand)control
//                       data:(NSInteger)data
//                        key:(NSString *)key
//                        pwd:(NSString *)pwd {
//    return [[self class]packetDataWithType:YTDataPacketTypeControl commands:@[@(control)] datas:@[@(data)] key:key pwd:pwd];
//}
//
//// 根据传来的命令标识返回数据包
//+ (NSData *)packetDataWithType:(YTDataPacketType)type
//                      commands:(NSArray<NSNumber *> *)commands
//                         datas:(NSArray<NSNumber *> *)datas
//                           key:(NSString *)key
//                           pwd:(NSString *)pwd {
//    // 起始符 2byte
//    Byte start[kStartLen] = {0x25, 0x25};
//
//    // 头字符 22byte
//    Byte head[kCommandLen+kReplyLen+kKeyLen+kEncryptLen+kDataLenLen] = {0x00};
//    NSInteger headIdx = 0;
//
//    // 命令标识 1byte
//    head[headIdx++] = (Byte)type;
//
//    // 应答标识 1byte
//    head[headIdx++] = 0xFE;
//
//    // 唯一识别码 17byte
//    if (key.length != kKeyLen) {
//        if (key.length == kKeyLen-1) {
//            key = [NSString stringWithFormat:@"%@0", key];
//        } else {
//            key = @"0123456789ABCDEFG";
//        }
//    }
//    for (int i = 0; i < key.length; i++) {
//        head[headIdx++] = [key characterAtIndex:i];
//    }
//
//    // 数据单元加密方式 1byte
//    head[headIdx++] = 0x01;
//
//    // 数据单元
//    NSMutableData *unitData = [NSMutableData data];
//    [unitData appendData:[[self class]timeDataWithDate:[NSDate date]]];
//    switch (type) {
//            // 组合查询
//        case YTDataPacketTypeQuery: {
//            // 命令字节数
//            Byte commandLenByte = commands.count;
//            // 数据单元追加命令字节数
//            [unitData appendBytes:&commandLenByte length:sizeof(commandLenByte)];
//            // 数据单元追加命令数据
//            for (NSNumber *command in commands) {
//                Byte commandByte = command.integerValue;
//                [unitData appendBytes:&commandByte length:sizeof(commandByte)];
//            }
//            break;
//        }
//        case YTDataPacketTypeControl: {
//            if (commands.count != datas.count) {
//                return nil;
//            }
//            //            // 控制指令的字节数
//            //            NSInteger commandLen = commands.count;
//            //            for (NSNumber *command in commands) {
//            //                // 控制指令+数据的字节数
//            //                commandLen += [[self class]dataLenWithCommand:command.integerValue];
//            //            }
//            Byte cmdDataLenByte = commands.count;
//            // 追加控制指令+数据的字节数
//            [unitData appendBytes:&cmdDataLenByte length:sizeof(cmdDataLenByte)];
//            for (int i = 0; i < commands.count; i++) {
//                YTDataPacketCommand command = commands[i].integerValue;
//                Byte commandByte = command;
//                [unitData appendBytes:&commandByte length:sizeof(commandByte)];
//                NSInteger dataLen = [[self class]dataLenWithCommand:command];
//                Byte dataByte[dataLen];
//                Byte dataHighByte = datas[i].integerValue;
//                switch (command) {
//                    case YTDataPacketCommandControlFire:
//                    case YTDataPacketCommandControlMotorLock:
//                    case YTDataPacketCommandControlAirCondition:
//                        dataByte[0] = dataHighByte;
//                        break;
//                    case YTDataPacketCommandControlLock:
//                        dataByte[0] = dataHighByte;
//                        dataByte[1] = 0x00;
//                        break;
//                    case YTDataPacketCommandControlWindow:
//                        switch (dataHighByte) {
//                            case YTDataPacketControlWindowUp:
//                            case YTDataPacketControlWindowNone:
//                                dataByte[0] = 0x00;
//                                dataByte[1] = 0x00;
//                                break;
//                            case YTDataPacketControlWindowDown:
//                                // 降所有车窗
//                                dataByte[0] = 0xA9;
//                                dataByte[1] = 0xAA;
//                                break;
//                        }
//                        break;
//                    case YTDataPacketCommandControlWhistle:
//                        dataByte[0] = 0x00;
//                        dataByte[1] = 0x00;
//                        dataByte[2] = 0x00;
//                        dataByte[3] = 0x00;
//                        dataByte[4] = 0x00;
//                        break;
//                    case YTDataPacketCommandControlSetFirstKey:
//                    case YTDataPacketCommandControlSetSecondKey:
//                        if (pwd.length < kKeyLen) {
//                            if (pwd.length == kKeyLen-1) {
//                                pwd = [NSString stringWithFormat:@"%@0", pwd];
//                            } else {
//                                pwd = @"0123456789ABCDEFG";
//                            }
//                        }
//                        for (int k = 0; k < dataLen; k++) {
//                            dataByte[k] = [pwd characterAtIndex:k];
//                        }
//                    default:
//                        break;
//                }
//                [unitData appendBytes:dataByte length:sizeof(dataByte)];
//            }
//            break;
//        }
//    }
//    // 数据单元长度 2byte
//    NSUInteger unitDataLen = unitData.length;
//    head[headIdx++] =  (Byte)((unitDataLen>>8) & 0xFF);
//    head[headIdx] =  (Byte)((unitDataLen) & 0xFF);
//
//    // 合并被抑或校验的数据
//    NSMutableData *verifyData = [NSMutableData data];
//    [verifyData appendBytes:head length:sizeof(head)];
//    [verifyData appendData:unitData];
//
//    // 校验码 1byte
//    Byte verifiedByte = [YTDataPacket verifiedDataWithData:verifyData];
//
//    // 拼接数据包(起始符+被校验数据+校验码)
//    NSMutableData *packetData = [NSMutableData data];
//    [packetData appendBytes:start length:sizeof(start)];
//    [packetData appendData:verifyData];
//    [packetData appendBytes:&verifiedByte length:sizeof(verifiedByte)];
//    return packetData;
//}
//
//// 根据传来的命令标识返回命令单元
//+ (NSInteger)dataLenWithCommand:(YTDataPacketCommand)command {
//    // 命令单元长度
//    NSInteger dataLen = 0;
//
//    switch (command) {
//        case YTDataPacketCommandQueryFired:
//        case YTDataPacketCommandQueryMotorLock:
//        case YTDataPacketCommandQueryCharging:
//        case YTDataPacketCommandQueryKey:
//        case YTDataPacketCommandQueryAirCondition:
//        case YTDataPacketCommandQuerySeatBelt:
//        case YTDataPacketCommandQueryAcceleratorPedalTravel:
//        case YTDataPacketCommandQueryBrakePedalTravel:
//        case YTDataPacketCommandQueryGearInfo:
//        case YTDataPacketCommandQueryResidualElectricity:
//        case YTDataPacketCommandQueryChargingPileConnection:
//        case YTDataPacketCommandControlFire:
//        case YTDataPacketCommandControlMotorLock:
//        case YTDataPacketCommandControlAirCondition:
//            dataLen = 1;
//            break;
//        case YTDataPacketCommandQueryDoor:
//        case YTDataPacketCommandQueryLock:
//        case YTDataPacketCommandQueryWindow:
//        case YTDataPacketCommandQueryBrake:
//        case YTDataPacketCommandQueryEnduranceMileage:
//        case YTDataPacketCommandQueryMotorSpeed:
//        case YTDataPacketCommandQuerySpeed:
//        case YTDataPacketCommandQueryTotalBatteryVoltage:
//        case YTDataPacketCommandQueryTotalCurrent:
//        case YTDataPacketCommandQuerySmallBatteryVoltage:
//        case YTDataPacketCommandControlLock:
//        case YTDataPacketCommandControlWindow:
//            dataLen = 2;
//            break;
//        case YTDataPacketCommandQueryLight:
//        case YTDataPacketCommandControlLight:
//            dataLen = 3;
//            break;
//        case YTDataPacketCommandQueryTotalMileage:
//            dataLen = 4;
//            break;
//        case YTDataPacketCommandControlWhistle:
//            dataLen = 5;
//            break;
//        case YTDataPacketCommandQueryLocationInfo:
//            dataLen = 13;
//            break;
//        case YTDataPacketCommandQueryVIN:
//        case YTDataPacketCommandQueryGetFirstKey:
//        case YTDataPacketCommandQueryGetSecondKey:
//        case YTDataPacketCommandControlSetFirstKey:
//        case YTDataPacketCommandControlSetSecondKey:
//            dataLen = kKeyLen;
//            break;
//        default:
//            break;
//    }
//    return dataLen;
//}
//
///** 获取日期字节 */
//+ (NSData *)timeDataWithDate:(NSDate *)date {
//    Byte timeByte[kDateLen];
//    // 日历为阳历
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    // 表示一个日期对象的组件
//    NSDateComponents *component = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
//    // 设定时区
//    [component setTimeZone:[NSTimeZone systemTimeZone]];
//    timeByte[0] = component.year%100;
//    timeByte[1] = component.month;
//    timeByte[2] = component.day;
//    timeByte[3] = component.hour;
//    timeByte[4] = component.minute;
//    timeByte[5] = component.second;
//    NSData *timeData = [NSData dataWithBytes:&timeByte length:sizeof(timeByte)];
//    return timeData;
//}
//
//// 根据数据对象返回抑或校验byte位
//+ (Byte)verifiedDataWithData:(NSData *)data {
//    Byte verifiedByte = 0x00;
//    const char *bytes = data.bytes;
//    for (int i = 0; i < data.length; i++) {
//        verifiedByte ^= (Byte)bytes[i];
//    }
//    return verifiedByte;
//}

@end

@implementation YTDataPacket (Parse)

//+ (NSData *)dataWithReply:(NSData *)data
//                     type:(YTDataPacketReplyType)type {
//    NSInteger typeLoc = 0;
//    NSInteger typeLen = 0;
//    switch (type) {
//        case YTDataPacketReplyTypeStart:
//            typeLoc = 0;
//            typeLen = kStartLen;
//            break;
//        case YTDataPacketReplyTypeCommand:
//            typeLoc = kStartLen;
//            typeLen = kCommandLen;
//            break;
//        case YTDataPacketReplyTypeReply:
//            typeLoc = kStartLen+kCommandLen;
//            typeLen = kReplyLen;
//            break;
//        case YTDataPacketReplyTypeKey:
//            typeLoc = kStartLen+kCommandLen+kReplyLen;
//            typeLen = kKeyLen;
//            break;
//        case YTDataPacketReplyTypeEncrypt:
//            typeLoc = kStartLen+kCommandLen+kReplyLen+kKeyLen;
//            typeLen = kEncryptLen;
//            break;
//        case YTDataPacketReplyTypeDataLen:
//            typeLoc = kStartLen+kCommandLen+kReplyLen+kKeyLen+kEncryptLen;
//            typeLen = kDataLenLen;
//            break;
//        case YTDataPacketReplyTypeDataUnit:
//            // <负数导致崩溃>
//            // (lldb) po typeLen
//            // -12
//            // (lldb) po typeLoc
//            // 24
//            typeLoc = kStartLen+kCommandLen+kReplyLen+kKeyLen+kEncryptLen+kDataLenLen;
//            typeLen = data.length-kVerifyLen-typeLoc;
//            break;
//        case YTDataPacketReplyTypeVerify:
//            typeLoc = data.length-kVerifyLen;
//            typeLen = kVerifyLen;
//            break;
//    }
//    // NSUInteger是无符号的，即没有负数,NSInteger是有符号的，所以NSUInteger类型不能给它赋负值。
//    if (typeLoc < 0 || typeLen < 0) {
//        typeLoc = 0;
//        typeLen = 0;
//    }
//    NSData *subData = [data subdataWithRange:NSMakeRange(typeLoc, typeLen)];
//    return subData;
//}
//
//+ (YTDataPacketType)typeWithReply:(NSData *)data {
//    NSData *replyTypeData = [[self class]dataWithReply:data type:YTDataPacketReplyTypeCommand];
//    NSInteger replyTypeInt = 0;
//    [replyTypeData getBytes:&replyTypeInt length:replyTypeData.length];
//    return replyTypeInt;
//}
//
//+ (YTDataPacketReplyResult)resultWithReply:(NSData *)data {
//    NSData *replyResultData = [[self class]dataWithReply:data type:YTDataPacketReplyTypeReply];
//    NSInteger replyResultInt = 0;
//    [replyResultData getBytes:&replyResultInt length:data.length];
//    return replyResultInt;
//}
//
//+ (NSString *)dateWithReply:(NSData *)data {
//    NSInteger commandType = 0;
//    NSData *commandData = [[self class]dataWithReply:data type:YTDataPacketReplyTypeCommand];
//    [commandData getBytes:&commandType length:commandData.length];
//    switch (commandType) {
//        case YTDataPacketTypeQuery:
//        case YTDataPacketTypeControl: {
//            NSData *dateData = [commandData subdataWithRange:NSMakeRange(0, kDateLen)];
//            NSInteger dateComponentLen = 2;
//            NSInteger year, month, day, hour, minute, second = 0;
//            [dateData getBytes:&year range:NSMakeRange(0, dateComponentLen)];
//            [dateData getBytes:&month range:NSMakeRange(dateComponentLen, dateComponentLen)];
//            [dateData getBytes:&day range:NSMakeRange(dateComponentLen*2, dateComponentLen)];
//            [dateData getBytes:&hour range:NSMakeRange(dateComponentLen*3, dateComponentLen)];
//            [dateData getBytes:&minute range:NSMakeRange(dateComponentLen*4, dateComponentLen)];
//            [dateData getBytes:&second range:NSMakeRange(dateComponentLen*5, dateComponentLen)];
//            return [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld:%ld", (long)year, (long)month, day, hour, minute, second];
//            break;
//        }
//        default:
//            return nil;
//            break;
//    }
//    return nil;
//}
//
//+ (NSInteger)controlCommandWithReply:(NSData *)data {
//    YTDataPacketType type = [[self class]typeWithReply:data];
//    if (type != YTDataPacketTypeControl) {
//        return 0;
//    }
//    NSData *unitData = [[self class]dataWithReply:data type:YTDataPacketReplyTypeDataUnit];
//    NSInteger commandLen = 0;
//    [unitData getBytes:&commandLen range:NSMakeRange(kDateLen, 1)];
//    NSInteger subUnitLoc = kDateLen+1;
//    NSData *subUnitData = [unitData subdataWithRange:NSMakeRange(subUnitLoc, unitData.length-subUnitLoc)];
//    // 获取指令字节
//    NSInteger subCommandByte = 0;
//    [subUnitData getBytes:&subCommandByte range:NSMakeRange(0, kCommandLen)];
//    return subCommandByte;
//}
//
//+ (NSData *)controlDataWithReply:(NSData *)data {
//    YTDataPacketType type = [[self class]typeWithReply:data];
//    if (type != YTDataPacketTypeControl) {
//        return nil;
//    }
//    NSData *unitData = [[self class]dataWithReply:data type:YTDataPacketReplyTypeDataUnit];
//    NSInteger commandLen = 0;
//    [unitData getBytes:&commandLen range:NSMakeRange(kDateLen, 1)];
//    NSInteger subUnitLoc = kDateLen+1;
//    NSData *subUnitData = [unitData subdataWithRange:NSMakeRange(subUnitLoc, unitData.length-subUnitLoc)];
//    // 获取指令字节
//    NSInteger subCommandByte = 0;
//    [subUnitData getBytes:&subCommandByte range:NSMakeRange(0, kCommandLen)];
//    // 获取指令后数据
//    NSInteger unitSubDataLen = [[self class]dataLenWithCommand:subCommandByte];
//    NSData *unitSubData = [subUnitData subdataWithRange:NSMakeRange(kCommandLen, unitSubDataLen)];
//    return unitSubData;
//}
//
//+ (NSArray<NSNumber *> *)statesWithReply:(NSData *)data {
//    NSMutableArray *states = [NSMutableArray array];
//    NSData *unitData = [[self class]dataWithReply:data type:YTDataPacketReplyTypeDataUnit];
//    NSInteger commandLen = 0;
//    
//    //防止获取超出data范围数据崩溃
//    if (unitData.length < (kDateLen + 1)) {
//        return nil;
//    }
//    
//    [unitData getBytes:&commandLen range:NSMakeRange(kDateLen, 1)];
//    NSInteger subUnitLoc = kDateLen+1;
//    NSData *subUnitData = [unitData subdataWithRange:NSMakeRange(subUnitLoc, unitData.length-subUnitLoc)];
//    // 指令所在位置
//    NSInteger subCommandLoc = 0;
//    for (int i = 0; i < commandLen; i++) {
//        if (subCommandLoc >= subUnitData.length) {
//            return nil;
//        }
//        // 获取指令字节
//        NSInteger subCommandByte = 0;
//        [subUnitData getBytes:&subCommandByte range:NSMakeRange(subCommandLoc, 1)];
//        subCommandLoc += 1;
//        // 获取指令后数据
//        NSInteger unitSubDataLen = [[self class]dataLenWithCommand:subCommandByte];
//        NSData *unitSubData = [subUnitData subdataWithRange:NSMakeRange(subCommandLoc, unitSubDataLen)];
//
//        NSData *stateData;
//        switch (subCommandByte) {
//            case YTDataPacketCommandQueryMotorLock:
//            case YTDataPacketCommandQueryCharging:
//            case YTDataPacketCommandQueryChargingPileConnection: {
//                Byte onStateByte = 0x01;
//                stateData = [NSData dataWithBytes:&onStateByte length:sizeof(onStateByte)];
//                break;
//            }
//            case YTDataPacketCommandQueryDoor: {
//                Byte onStateByte[2] = {0xff, 0x00};
//                stateData = [NSData dataWithBytes:onStateByte length:sizeof(onStateByte)];
//                break;
//            }
//            case YTDataPacketCommandQueryLock: {
//                Byte onStateByte[2] = {0x0f, 0xff};
//                stateData = [NSData dataWithBytes:onStateByte length:sizeof(onStateByte)];
//                break;
//            }
//            case YTDataPacketCommandQueryWindow: {
//                Byte onStateByte[2] = {0x00, 0x00};
//                stateData = [NSData dataWithBytes:onStateByte length:sizeof(onStateByte)];
//                break;
//            }
//            case YTDataPacketCommandQueryFired:
//            case YTDataPacketCommandQueryKey:
//            case YTDataPacketCommandQueryBrake:
//            case YTDataPacketCommandQueryLight:
//            case YTDataPacketCommandQueryAirCondition:
//            case YTDataPacketCommandQuerySeatBelt:
//            case YTDataPacketCommandQueryAcceleratorPedalTravel:
//            case YTDataPacketCommandQueryBrakePedalTravel:
//            case YTDataPacketCommandQueryGearInfo:
//            case YTDataPacketCommandQueryTotalMileage:
//            case YTDataPacketCommandQueryResidualElectricity:
//            case YTDataPacketCommandQueryEnduranceMileage:
//            case YTDataPacketCommandQueryMotorSpeed:
//            case YTDataPacketCommandQuerySpeed:
//            case YTDataPacketCommandQueryTotalBatteryVoltage:
//            case YTDataPacketCommandQueryTotalCurrent:
//            case YTDataPacketCommandQuerySmallBatteryVoltage:
//            case YTDataPacketCommandQueryAlarmData:
//            case YTDataPacketCommandQueryVIN:
//            case YTDataPacketCommandQueryLocationInfo:
//            case YTDataPacketCommandQueryGetFirstKey:
//            case YTDataPacketCommandQueryGetSecondKey:
//                break;
//            default:
//                break;
//        }
//        if ([unitSubData isEqualToData:stateData]) {
//            [states addObject:@YES];
//        } else {
//            [states addObject:@NO];
//        }
//        subCommandLoc += unitSubDataLen;
//    }
//    return states;
//}

@end
