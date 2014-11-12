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
#import "CBUUID+Konashi.h"
#import "CBService+Konashi.h"
#import "CBPeripheral+Konashi.h"
#import "KNSPeripheralImplProtocol.h"
#import "KNSHandlerManager.h"

@interface KNSPeripheralBaseImpl : NSObject <CBPeripheralDelegate, KNSPeripheralImplProtocol>
{
	// status
	BOOL isCallFind;
	
	// Digital PIO
	unsigned char pioSetting;
	unsigned char pioPullup;
	unsigned char pioOutput;
	unsigned char pioInput;
	unsigned char pioByte[32];
	
	// PWM
	unsigned char pwmSetting;
	unsigned int pwmDuty[8];
	unsigned int pwmPeriod[8];
	
	// Analog IO
	unsigned int analogValue[3];
	
	// UART
	unsigned char uartSetting;
	unsigned char uartBaudrate;
	NSData *uartRxData;
	
	// I2C
	NSData *i2cReadData;
	unsigned char i2cSetting;
	unsigned char i2cReadDataLength;
	unsigned char i2cReadAddress;
	
	// Hardware
	int batteryLevel;
	int rssi;
}

@property (nonatomic, weak) KNSHandlerManager *handlerManager;
@property (nonatomic, readonly, getter=isReady) BOOL ready;
@property (nonatomic, readonly) CBPeripheral *peripheral;
@property (nonatomic, readonly) NSString *softwareRevisionString;

- (instancetype)initWithPeripheral:(CBPeripheral *)p;
- (void)writeData:(NSData *)data serviceUUID:(CBUUID*)uuid characteristicUUID:(CBUUID*)charasteristicUUID;
- (void)readDataWithServiceUUID:(CBUUID*)uuid characteristicUUID:(CBUUID*)charasteristicUUID;
- (void)notificationWithServiceUUID:(CBUUID*)uuid characteristicUUID:(CBUUID*)characteristicUUID on:(BOOL)on;

@end
