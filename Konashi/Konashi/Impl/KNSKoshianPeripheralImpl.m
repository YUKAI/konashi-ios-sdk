//
//  KoshianPeripheralImpl.m
//  Konashi
//
//  Created by Akira Matsuda on 9/18/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "KNSKoshianPeripheralImpl.h"
#import "KonashiUtils.h"

static NSString *const kLatestFirmwareVersion = @"2.0.0";

@interface KNSKoshianPeripheralImpl ()

@end

@implementation KNSKoshianPeripheralImpl

- (NSInteger)uartDataMaxLength
{
	return [self uartDataMaxLengthByRevisionString:self.softwareRevisionString];
}

+ (NSInteger)i2cDataMaxLength
{
	return 16;
}

// UUID
+ (CBUUID *)batteryServiceUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"180F", uuid);
}

+ (CBUUID *)levelServiceUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"2A19", uuid);
}

+ (CBUUID *)powerStateUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"2A1B", uuid);
}

+ (CBUUID *)serviceUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"229BFF00-03FB-40DA-98A7-B0DEF65C2D4B", uuid);
}

// PIO
+ (CBUUID *)pioSettingUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"229B3000-03FB-40DA-98A7-B0DEF65C2D4B", uuid);
}

+ (CBUUID *)pioPullupUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"229B3001-03FB-40DA-98A7-B0DEF65C2D4B", uuid);
}

+ (CBUUID *)pioOutputUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"229B3002-03FB-40DA-98A7-B0DEF65C2D4B", uuid);
}

+ (CBUUID *)pioInputNotificationUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"229B3003-03FB-40DA-98A7-B0DEF65C2D4B", uuid);
}

// PWM
+ (CBUUID *)pwmConfigUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"229B3004-03FB-40DA-98A7-B0DEF65C2D4B", uuid);
}

+ (CBUUID *)pwmParamUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"229B3005-03FB-40DA-98A7-B0DEF65C2D4B", uuid);
}

+ (CBUUID *)pwmDutyUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"229B3006-03FB-40DA-98A7-B0DEF65C2D4B", uuid);
}

// Analog
+ (CBUUID *)analogDriveUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"229B3007-03FB-40DA-98A7-B0DEF65C2D4B", uuid);
}

+ (CBUUID *)analogReadUUIDWithPinNumber:(NSInteger)pin
{
	CBUUID *uuid = nil;
	switch (pin) {
		case 0: {
			static CBUUID *uuid0;
			uuid = kns_CreateUUIDFromString(@"229B3008-03FB-40DA-98A7-B0DEF65C2D4B", uuid0);
		}
			break;
		case 1: {
			static CBUUID *uuid1;
			uuid = kns_CreateUUIDFromString(@"229B3009-03FB-40DA-98A7-B0DEF65C2D4B", uuid1);
		}
			break;
		case 2: {
			static CBUUID *uuid2;
			uuid = kns_CreateUUIDFromString(@"229B300A-03FB-40DA-98A7-B0DEF65C2D4B", uuid2);
		}
			break;
		default:
			break;
	}

	return uuid;
}

// I2C
+ (CBUUID *)i2cConfigUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"229B300B-03FB-40DA-98A7-B0DEF65C2D4B", uuid);
}

+ (CBUUID *)i2cStartStopUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"229B300C-03FB-40DA-98A7-B0DEF65C2D4B", uuid);
}

+ (CBUUID *)i2cWriteUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(	@"229B300D-03FB-40DA-98A7-B0DEF65C2D4B", uuid);
}

+ (CBUUID *)i2cReadParamUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(	@"229B300E-03FB-40DA-98A7-B0DEF65C2D4B", uuid);
}

+ (CBUUID *)i2cReadUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(	@"229B300F-03FB-40DA-98A7-B0DEF65C2D4B", uuid);
}

// UART
+ (CBUUID *)uartConfigUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(	@"229B3010-03FB-40DA-98A7-B0DEF65C2D4B", uuid);
}

+ (CBUUID *)uartBaudrateUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(	@"229B3011-03FB-40DA-98A7-B0DEF65C2D4B", uuid);
}

+ (CBUUID *)uartTX_UUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(	@"229B3012-03FB-40DA-98A7-B0DEF65C2D4B", uuid);
}

+ (CBUUID *)uartRX_NotificationUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(	@"229B3013-03FB-40DA-98A7-B0DEF65C2D4B", uuid);
}

// Hardware
+ (CBUUID *)hardwareResetUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(	@"229B3014-03FB-40DA-98A7-B0DEF65C2D4B", uuid);
}

+ (CBUUID *)lowBatteryNotificationUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(	@"229B3015-03FB-40DA-98A7-B0DEF65C2D4B", uuid);
}

+ (CBUUID *)upgradeServiceUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(	@"3908d54f-0c55-4ea1-8fd1-8394a172257d", uuid);
}

+ (CBUUID *)upgradeCharacteristicControlPointUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(	@"0f7a29bb-a965-4279-8546-b56e981c008b", uuid);
}

+ (CBUUID *)upgradeCharacteristicDataUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(	@"8e922cce-eec6-47b0-b46d-09563a8da638", uuid);
}

- (KonashiResult) uartWriteData:(NSData *)data
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected && uartSetting==KonashiUartModeEnable){
		if ([self.softwareRevisionString isEqualToString:@"2.0.0"]) {
			// revision stringが2.0.0の時はマルチバイトで送信できる
			// 先頭1バイトはデータ長
			NSMutableData *d = [NSMutableData new];
			NSUInteger length = data.length;
			[d appendBytes:&length length:1];
			[d appendData:data];
			[self writeData:d serviceUUID:[[self class] serviceUUID] characteristicUUID:[[self class] uartTX_UUID]];
		}
		else {
			unsigned char *d = (unsigned char *)[data bytes];
			for (NSInteger i = 0; i < data.length; i++) {
				[self writeData:[NSData dataWithBytes:&d[i] length:1] serviceUUID:[[self class] serviceUUID] characteristicUUID:[[self class] uartTX_UUID]];
			}
		}
		
		return KonashiResultSuccess;
	}
	else{
		return KonashiResultFailure;
	}
}

- (KonashiResult) uartBaudrate:(KonashiUartBaudrate)baudrate
{
	KonashiResult result = KonashiResultFailure;
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected && uartSetting==KonashiUartModeDisable){
		if ([self.softwareRevisionString isEqualToString:@"1.0.0"]) {
			if(KonashiUartBaudrateRate9K6 == baudrate){
				result = KonashiResultSuccess;
			}
		}
		else {
			if(KonashiUartBaudrateRate9K6 <= baudrate && baudrate <= KonashiUartBaudrateRate115K2){
				result = KonashiResultSuccess;
			}
		}
	}
	
	if (result == KonashiResultSuccess) {
		Byte t[] = {(baudrate>>8)&0xff, baudrate&0xff};
		NSData *baudrateData = [NSData dataWithBytes:t length:2];
		[self writeData:baudrateData serviceUUID:[[self class] serviceUUID] characteristicUUID:[[self class] uartBaudrateUUID]];
		uartBaudrate = baudrate;
	}
	
	return result;
}

- (void)uartDataDidUpdate:(NSData *)data
{
	if ([self.softwareRevisionString isEqualToString:@"2.0.0"]) {
		unsigned char byte[32];
		[data getBytes:byte length:1];
		char length = byte[0];
		[data getBytes:byte range:NSMakeRange(1, length)];
		uartRxData = [[NSData alloc] initWithBytes:byte length:data.length - 1];
	}
	else {
		uartRxData = [data copy];
	}
	// [0]: MSB
	if (self.handlerManager.uartRxCompleteHandler) {
		self.handlerManager.uartRxCompleteHandler(uartRxData);
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:KonashiEventUartRxCompleteNotification object:nil];
}

#pragma mark -

- (NSInteger)uartDataMaxLengthByRevisionString:(NSString *)revisionString
{
	NSInteger dataLength = 1;
	// revision stringが2.0.0の時だけマルチバイトで送信できる
	if ([revisionString isEqualToString:@"2.0.0"]) {
		dataLength = 18;
	}
	
	return dataLength;
}

@end
