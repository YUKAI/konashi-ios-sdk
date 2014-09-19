//
//  KNSPeripheralBaseImpl.h
//  Konashi
//
//  Created by Akira Matsuda on 9/20/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "KonashiConstant.h"
#import "KNSUUID.h"
#import "CBUUID+Konashi.h"
#import "CBService+Konashi.h"
#import "CBPeripheral+Konashi.h"

@interface KNSPeripheralBaseImpl : NSObject <CBPeripheralDelegate>
{
	// status
	BOOL isCallFind;
	
	// Digital PIO
	unsigned char pioSetting;
	unsigned char pioPullup;
	unsigned char pioOutput;
	unsigned char pioInput;
	
	// PWM
	unsigned char pwmSetting;
	unsigned int pwmDuty[8];
	unsigned int pwmPeriod[8];
	
	// Analog IO
	unsigned int analogValue[3];
	
	// I2C
	unsigned char i2cSetting;
	unsigned char i2cReadData[KONASHI_I2C_DATA_MAX_LENGTH];
	unsigned char i2cReadDataLength;
	unsigned char i2cReadAddress;
	
	// UART
	unsigned char uartSetting;
	unsigned char uartBaudrate;
	unsigned char uartRxData;
	
	// Hardware
	int batteryLevel;
	int rssi;
}

@property (nonatomic, readonly, getter=isReady) BOOL ready;
@property (nonatomic, readonly) CBPeripheral *peripheral;

- (instancetype)initWithPeripheral:(CBPeripheral *)p;
- (void)writeData:(NSData *)data serviceUUID:(KNSUUID)uuid characteristicUUID:(KNSUUID)charasteristicUUID;
- (void)readDataWithServiceUUID:(KNSUUID)uuid characteristicUUID:(KNSUUID)charasteristicUUID;
- (void)notificationWithServiceUUID:(KNSUUID)uuid characteristicUUID:(KNSUUID)characteristicUUID on:(BOOL)on;

@end
