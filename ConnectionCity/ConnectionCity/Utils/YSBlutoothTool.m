//
//  AppDelegate.m
//  BlueTooth
//
//  Created by JYS on 17/7/3.
//  Copyright © 2017年 insaiapp. All rights reserved.
//

#import "YSBlutoothTool.h"

@interface YSBlutoothTool()<CBCentralManagerDelegate,CBPeripheralDelegate>

@end

@implementation YSBlutoothTool
/** 中心管理者 */
+ (instancetype)shareBlueTooth {
    static dispatch_once_t once;
    static YSBlutoothTool *blueTooth = nil;
    dispatch_once(&once, ^{
        blueTooth = [[self alloc] init];
    });
    return blueTooth;
}
/** 初始化中心管理者 */
- (instancetype)init {
    self = [super init];
    if (self) {
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], CBCentralManagerOptionShowPowerAlertKey, nil];
        self.centralMgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:options];
        self.array_peripheral = [[NSMutableArray alloc]init];
    }
    return self;
}
/** 开始扫描 */
- (void)startScan {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self stopScan];
        [self.centralMgr scanForPeripheralsWithServices:nil options:nil];
    });
}
/** 停止扫描 */
- (void)stopScan {
    [self.centralMgr stopScan];
}
/** 连接蓝牙 */
- (void)connectBlueToothWithPeripheral:(CBPeripheral *)peripheral{
    [self cancelBlueTooth];
    NSLog(@"要连接的外设名称:%@",peripheral.name);
    _discoveredPeripheral = peripheral;
    [_centralMgr connectPeripheral:peripheral options:nil];
    [self stopScan];
}
/** 断开蓝牙 */
- (void)cancelBlueTooth {
    if (_discoveredPeripheral != nil) {
        [self.centralMgr cancelPeripheralConnection:_discoveredPeripheral];
    }
}
/** 写入数据 */
- (void)writeChar:(NSData *)data {
    NSLog(@"蓝牙要写入的数据: %@",data);
    // 回调didWriteValueForCharacteristic
    if (_writeCharacteristic == nil) {
        return;
    }
    if (_discoveredPeripheral.state == CBPeripheralStateConnected) {
        [_discoveredPeripheral writeValue:data forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
    }
}
#pragma mark - CBCentralManagerDelegate
/** 只要中心管理者状态发生变化触发此代理方法 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    /*
     CBCentralManagerStateUnknown = 0,
     CBCentralManagerStateResetting,
     CBCentralManagerStateUnsupported,
     CBCentralManagerStateUnauthorized,
     CBCentralManagerStatePoweredOff,
     CBCentralManagerStatePoweredOn,
     */
    self.blueToothPoweredOn = central.state == CBCentralManagerStatePoweredOn;
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_CENTRAL_MANAGER_DID_UPDATE_STATE object:@{@"central":central}];
}
/** 发现外设后触发此代理方法 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"%@",advertisementData);
    
    NSData *data = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
    NSString *mac = [self p_convertToNSStringWithNSData:data];
    if (mac.length == 20) {
        mac = [[mac stringByReplacingOccurrencesOfString:@" " withString:@""] substringFromIndex:8];
        if ([mac isEqualToString:_macStr]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_DISCOVER_PERIPHERAL object:@{@"central":central,@"peripheral":peripheral,@"advertisementData":advertisementData,@"RSSI":RSSI}];
        }
    }
}
/** 中心管理者连接外设成功 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    //设置外设的代理
    [_discoveredPeripheral setDelegate:self];
    //搜索服务,回调didDiscoverServices
    [_discoveredPeripheral discoverServices:nil];
    //停止扫描
    [self stopScan];
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_CONNECT_PERIPHERAL object:@{@"central":central,@"peripheral":peripheral}];
}
/** 中心管理者连接外设失败 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    //停止扫描
    [self stopScan];
    //此时连接发生错误
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_CONNECT_FAIL_OR_DISCONNECT_PERIPHERAL object:@{@"central":central,@"peripheral":peripheral}];
}
/** 中心管理者丢失连接 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_CONNECT_FAIL_OR_DISCONNECT_PERIPHERAL object:@{@"central":central,@"peripheral":peripheral}];
}
#pragma mark - CBPeripheralDelegate
/** 发现外设的服务后调用的方法 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        NSLog(@"发现外设的服务发生错误 : %@", [error localizedDescription]);
        return;
    }
    for (CBService *s in peripheral.services) {
        NSLog(@"服务的UUID : %@", s.UUID);
        if ([s.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID]]) {
            //发现服务后,让设备再发现服务内部的特征们 didDiscoverCharacteristicsForService
            [s.peripheral discoverCharacteristics:nil forService:s];
        }
    }
}
/** 发现外设服务里的特征的时候调用的代理方法 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) {
        NSLog(@"发现外设服务里的特征发生错误: %@", [error localizedDescription]);
        return;
    }
    for (CBCharacteristic *c in service.characteristics) {
        //NSLog(@"发现外设服务里的特征的属性:%lu",(unsigned long)c.properties) ;
        //订阅通知 回调didUpdateValueForCharacteristic:error
        if ([c.UUID isEqual:[CBUUID UUIDWithString:kNotifyCharacteristicUUID]]) {
            [peripheral setNotifyValue:YES forCharacteristic:c];
        }
        if ([c.UUID isEqual:[CBUUID UUIDWithString:kWriteCharacteristicUUID]]) {
            _writeCharacteristic = c;
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_DISCOVER_PERIPHERAL_SERVICE_CHARACTERISTIC object:@{@"peripheral":peripheral,@"service":service,@"characteristic":c}];
        }
    }
}
/** 向特征值写数据时的回调方法 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    NSLog(@"%@",error);
}
/** 订阅的特征值有新的数据时回调 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"订阅的特征值发生错误: %@",[error localizedDescription]);
        return;
    }
    /*
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kNotifyCharacteristicUUID]]) {
        [peripheral readValueForCharacteristic:characteristic];
    }
     */
}
/** 获取到数据时回调更新特征的value的时候会调用 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kNotifyCharacteristicUUID]]) {
        if(![YSTools dx_isNullOrNilWithObject:characteristic.value]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_UPDATE_VALUE_FOR_CHARACTERISTIC object:@{@"peripheral":peripheral,@"characteristic":characteristic}];
        }else{
            NSLog(@"无数据返回");
        }
    }
}
#pragma mark - 私有方法
// 将data转换为不带<>的字符串
- (NSString *)p_convertToNSStringWithNSData:(NSData *)data {
    NSMutableString *strTemp = [NSMutableString stringWithCapacity:[data length]*2];
    const unsigned char *szBuffer = [data bytes];
    
    for (NSInteger i=0; i < [data length]; ++i) {
        
        [strTemp appendFormat:@"%02lx",(unsigned long)szBuffer[i]];
        
    }
    
    return strTemp;
}
@end
