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

@end
