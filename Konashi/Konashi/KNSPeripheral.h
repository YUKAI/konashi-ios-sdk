//
//  KonashiPeripheral.h
//  Konashi
//
//  Created by Akira Matsuda on 9/18/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "KonashiConstant.h"
#import "KNSPeripheralImplProtocol.h"
#import "KNSPeripheralBaseImpl.h"
#import "CBUUID+Konashi.h"
#import "CBService+Konashi.h"
#import "CBPeripheral+Konashi.h"

@interface KNSPeripheral : NSObject <CBPeripheralDelegate>
{
	KNSPeripheralBaseImpl<KNSPeripheralImplProtocol> *impl_;
}

- (instancetype)initWithPeripheral:(CBPeripheral *)p;
- (void)writeData:(NSData *)data serviceUUID:(CBUUID*)uuid characteristicUUID:(CBUUID*)charasteristicUUID;
- (void)readDataWithServiceUUID:(CBUUID*)uuid characteristicUUID:(CBUUID*)charasteristicUUID;
- (void)notificationWithServiceUUID:(CBUUID*)uuid characteristicUUID:(CBUUID*)characteristicUUID on:(BOOL)on;

- (CBPeripheral *)peripheral;

- (CBPeripheralState)state;
- (BOOL)isReady;
- (NSString *)findName;

- (int) pinMode:(int)pin mode:(int)mode;
- (int) pinModeAll:(int)mode;
- (int) pinPullup:(int)pin mode:(int)mode;
- (int) pinPullupAll:(int)mode;
- (int) digitalRead:(int)pin;
- (int) digitalReadAll;
- (int) digitalWrite:(int)pin value:(int)value;
- (int) digitalWriteAll:(int)value;

- (int) pwmMode:(int)pin mode:(int)mode;
- (int) pwmPeriod:(int)pin period:(unsigned int)period;
- (int) pwmDuty:(int)pin duty:(unsigned int)duty;
- (int) pwmLedDrive:(int)pin dutyRatio:(int)ratio;

- (int) readValueAio:(int)pin;

- (int) analogReference;
- (int) analogReadRequest:(int)pin;
- (int) analogRead:(int)pin;
- (int) analogWrite:(int)pin milliVolt:(int)milliVolt;

- (int) i2cMode:(int)mode;
- (int) i2cSendCondition:(int)condition;
- (int) i2cStartCondition;
- (int) i2cRestartCondition;
- (int) i2cStopCondition;
- (int) i2cWrite:(int)length data:(unsigned char*)data address:(unsigned char)address;
- (int) i2cReadRequest:(int)length address:(unsigned char)address;
- (int) i2cRead:(int)length data:(unsigned char*)data;

- (int) uartMode:(int)mode;
- (int) uartBaudrate:(int)baudrate;
- (int) uartWrite:(unsigned char)data;
- (unsigned char) uartRead;

- (int) reset;
- (int) batteryLevelReadRequest;
- (int) batteryLevelRead;
- (int) signalStrengthReadRequest;
- (int) signalStrengthRead;

- (void)enablePIOInputNotification;
- (void)enableUART_RXNotification;

@end
