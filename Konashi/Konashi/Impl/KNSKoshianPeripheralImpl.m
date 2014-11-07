//
//  KoshianPeripheralImpl.m
//  Konashi
//
//  Created by Akira Matsuda on 9/18/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "KNSKoshianPeripheralImpl.h"
#import "KonashiUtils.h"

static NSInteger const i2cDataMaxLength = 16;

@interface KNSKoshianPeripheralImpl ()
{
	// I2C
	unsigned char i2cReadData[i2cDataMaxLength];
}

@end

@implementation KNSKoshianPeripheralImpl

+ (NSInteger)i2cDataMaxLength
{
	return i2cDataMaxLength;
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
			uuid = kns_CreateUUIDFromString(@"229B3009-03FB-40DA-98A7-B0DEF65C2D4B", uuid2);
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

- (instancetype)initWithPeripheral:(CBPeripheral *)p
{
	self = [super initWithPeripheral:p];
	if (self) {
		// I2C
		i2cSetting = KonashiI2CModeDisable;
		for (NSInteger i = 0; i < [[self class] i2cDataMaxLength]; i++) {
			i2cReadData[i] = 0;
		}
		i2cReadDataLength = 0;
		i2cReadAddress = 0;
	}
	
	return self;
}

- (KonashiResult) i2cReadRequest:(int)length address:(unsigned char)address
{
	if(length > 0 && (i2cSetting == KonashiI2CModeEnable || i2cSetting == KonashiI2CModeEnable100K || i2cSetting == KonashiI2CModeEnable400K) &&
	   self.peripheral && self.peripheral.state == CBPeripheralStateConnected){
		
		// set variables
		i2cReadAddress = (address<<1)|0x1;
		i2cReadDataLength = length;
		
		// Set read params
		Byte t[] = {length, i2cReadAddress};
		[self writeData:[NSData dataWithBytes:t length:2] serviceUUID:[[self class] serviceUUID] characteristicUUID:[[self class] i2cReadParamUUID]];
		
		// Request read i2c value
		[self readDataWithServiceUUID:[[self class] serviceUUID] characteristicUUID:[[self class] i2cReadUUID]];
		
		return KonashiResultSuccess;
	}
	else{
		return KonashiResultFailure;
	}
}

- (KonashiResult) i2cRead:(int)length data:(unsigned char*)data
{
	int i;
	
	if(length==i2cReadDataLength){
		for(i=0; i<i2cReadDataLength;i++){
			data[i] = i2cReadData[i];
		}
		return KonashiResultSuccess;
	}
	else{
		return KonashiResultFailure;
	}
}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
	[super peripheral:peripheral didUpdateValueForCharacteristic:characteristic error:error];
	if (!error) {
		if ([characteristic.UUID kns_isEqualToUUID:[[self class] i2cReadUUID]]) {
			[characteristic.value getBytes:i2cReadData length:i2cReadDataLength];
			// [0]: MSB
			
			[[NSNotificationCenter defaultCenter] postNotificationName:KonashiEventI2CReadCompleteNotification object:nil];
		}
	}
}

@end
