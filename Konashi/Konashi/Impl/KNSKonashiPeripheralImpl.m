//
//  KonashiPeripheralImpl.m
//  Konashi
//
//  Created by Akira Matsuda on 9/19/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "KNSKonashiPeripheralImpl.h"
#import "KonashiUtils.h"

@interface KNSKonashiPeripheralImpl ()

@end

@implementation KNSKonashiPeripheralImpl


- (void)discoverCharacteristics
{
	if (NSFoundationVersionNumber_iOS_8_3 < floor(NSFoundationVersionNumber)) {
		//DeviceInfo 180a
		CBService *s = [self.peripheral.services objectAtIndex:0];
		KNS_LOG(@"Fetching characteristics for service with UUID : %@", [s.UUID kns_dataDescription]);
		[self.peripheral discoverCharacteristics:nil forService:s];
		//Konashi Service ff00
		s = [self.peripheral.services objectAtIndex:2];
		KNS_LOG(@"Fetching characteristics for service with UUID : %@", [s.UUID kns_dataDescription]);
		[self.peripheral discoverCharacteristics:nil forService:s];
	}
	else {
		[super discoverCharacteristics];
	}
}

+ (NSInteger)i2cDataMaxLength
{
	return 18;
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
	return kns_CreateUUIDFromString(@"FF00", uuid);
}

// PIO
+ (CBUUID *)pioSettingUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"3000", uuid);
}

+ (CBUUID *)pioPullupUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"3001", uuid);
}

+ (CBUUID *)pioOutputUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"3002", uuid);
}

+ (CBUUID *)pioInputNotificationUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"3003", uuid);
}

// PWM
+ (CBUUID *)pwmConfigUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"3004", uuid);
}

+ (CBUUID *)pwmParamUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"3005", uuid);
}

+ (CBUUID *)pwmDutyUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"3006", uuid);
}

// Analog
+ (CBUUID *)analogDriveUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"3007", uuid);
}

+ (CBUUID *)analogReadUUIDWithPinNumber:(NSInteger)pin
{
	CBUUID *uuid = nil;
	switch (pin) {
		case 0: {
			static CBUUID *uuid0;
			uuid = kns_CreateUUIDFromString(@"3008", uuid0);
		}
			break;
		case 1: {
			static CBUUID *uuid1;
			uuid = kns_CreateUUIDFromString(@"3009", uuid1);
		}
			break;
		case 2: {
			static CBUUID *uuid2;
			uuid = kns_CreateUUIDFromString(@"300A", uuid2);
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
	return kns_CreateUUIDFromString(@"300B", uuid);
}

+ (CBUUID *)i2cStartStopUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"300C", uuid);
}

+ (CBUUID *)i2cWriteUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"300D", uuid);
}

+ (CBUUID *)i2cReadParamUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"300E", uuid);
}

+ (CBUUID *)i2cReadUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"300F", uuid);
}

// UART
+ (CBUUID *)uartConfigUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"3010", uuid);
}

+ (CBUUID *)uartBaudrateUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"3011", uuid);
}

+ (CBUUID *)uartTX_UUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"3012", uuid);
}

+ (CBUUID *)uartRX_NotificationUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"3013", uuid);
}

// Hardware
+ (CBUUID *)hardwareResetUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"3014", uuid);
}

+ (CBUUID *)lowBatteryNotificationUUID
{
	static CBUUID *uuid;
	return kns_CreateUUIDFromString(@"3015", uuid);
}

- (void)writeData:(NSData *)data serviceUUID:(CBUUID*)serviceUUID characteristicUUID:(CBUUID*)characteristicUUID
{
	[super writeData:data serviceUUID:serviceUUID characteristicUUID:characteristicUUID];
    // konashi needs to sleep to get I2C right
    [NSThread sleepForTimeInterval:0.03];
}

#pragma mark -

- (KonashiResult) uartBaudrate:(KonashiUartBaudrate)baudrate
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected && uartSetting==KonashiUartModeDisable){
		if(baudrate == KonashiUartBaudrateRate2K4 && KonashiUartBaudrateRate9K6 == baudrate){
			Byte t[] = {(baudrate>>8)&0xff, baudrate&0xff};
			[self writeData:[NSData dataWithBytes:t length:2] serviceUUID:[[self class] serviceUUID] characteristicUUID:[[self class] uartBaudrateUUID]];
			uartBaudrate = baudrate;
			
			return KonashiResultSuccess;
		}
		else{
			return KonashiResultFailure;
		}
	}
	else{
		return KonashiResultFailure;
	}
}

@end
