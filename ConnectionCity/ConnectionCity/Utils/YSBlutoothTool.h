//
//  AppDelegate.m
//  BlueTooth
//
//  Created by JYS on 17/7/3.
//  Copyright © 2017年 insaiapp. All rights reserved.

//外设只提供 RPM1(每分钟转数) & PULSE(脉跳)数值給APP & 轮径固定280mm
//0、时速(km/h)    <(28.0*3.14159*RPM*60)/100000>
//1、时间(min)     <使用定时器计时>
//2、里程数(km)    <时间*速度-->累加>
//3、配速(min)  <1/时速*60>
//4、平均速度(km/h) <时速累加除以个数>
//5、心率(bpm)     <读取><算出平均心率>
//6、热量消耗(cal)  <时速*0.38*TIME(分) -->累加>

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@class YSBlutoothPeripheral;

@interface YSBlutoothTool : NSObject
/** 中心管理者 */
@property(nonatomic,strong)CBCentralManager* centralMgr;
/** 蓝牙名称 */
@property (nonatomic,strong)NSString *deviceName;
/** 用户的蓝牙是否开启 */
@property (nonatomic, assign) BOOL blueToothPoweredOn;
/** 要连接外设的Mac地址 */
@property (nonatomic,strong)NSString *macStr;
/** 连接到的外设 */
@property (nonatomic, strong) CBPeripheral *discoveredPeripheral;
/** 连接到的外设数组 */
@property (nonatomic, strong) NSMutableArray *array_peripheral;
/** 外设服务特征 */
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;
/** 中心管理者 */
+ (instancetype)shareBlueTooth;
/** 开始扫描 */
- (void)startScan;
/** 停止扫描 */
- (void)stopScan;
/** 连接蓝牙 */
- (void)connectBlueToothWithPeripheral:(YSBlutoothPeripheral *)peripheral;
/** 断开蓝牙 */
- (void)cancelBlueTooth;
/** 写入数据 */
- (void)writeChar:(NSData *)data;

@end
