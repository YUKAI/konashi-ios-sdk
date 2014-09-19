//
//  KNSPeripheralBaseImpl.m
//  Konashi
//
//  Created by Akira Matsuda on 9/20/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "KNSPeripheralBaseImpl.h"
#import "KonashiUtils.h"

@implementation KNSPeripheralBaseImpl

- (instancetype)initWithPeripheral:(CBPeripheral *)p
{
	self = [super init];
	if (self) {
		_peripheral = p;
		_peripheral.delegate = self;
		[_peripheral kns_discoverAllCharacteristics];
		// Digital PIO
		pioSetting = 0;
		pioPullup = 0;
		pioInput = 0;
		pioOutput = 0;
		
		// PWM
		pwmSetting = 0;
		for (NSInteger i = 0; i < 8; i++) {
			pwmPeriod[i] = 0;
			pwmDuty[i] = 0;
		}
		
		// Analog IO
		for (NSInteger i = 0; i < 3; i++) {
			analogValue[i] = 0;
		}
		
		// I2C
		i2cSetting = KONASHI_I2C_DISABLE;
		for (NSInteger i = 0; i < KONASHI_I2C_DATA_MAX_LENGTH; i++) {
			i2cReadData[i] = 0;
		}
		i2cReadDataLength = 0;
		i2cReadAddress = 0;
		
		// UART
		uartSetting = KONASHI_UART_DISABLE;
		uartBaudrate = KONASHI_UART_RATE_9K6;
		
		// RSSI
		rssi = 0;
		
		// others
		_ready = NO;
		isCallFind = NO;
	}
	
	return self;
}

#pragma mark -

- (void)writeData:(NSData *)data serviceUUID:(KNSUUID)uuid characteristicUUID:(KNSUUID)characteristicUUID
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (void)readDataWithServiceUUID:(KNSUUID)uuid characteristicUUID:(KNSUUID)characteristicUUID
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (void)notificationWithServiceUUID:(KNSUUID)uuid characteristicUUID:(KNSUUID)characteristicUUID on:(BOOL)on
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
	//KNS_LOG(@"peripheralDidUpdateRSSI");
	
	rssi = [peripheral.RSSI intValue];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:KONASHI_EVENT_UPDATE_SIGNAL_STRENGTH object:nil];
}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
	if (!error) {
		KNS_LOG(@"Characteristics of service with UUID : %@ found", [service.UUID kns_stringValue]);
		
#ifdef KONASHI_DEBUG
		for(int i=0; i < service.characteristics.count; i++) {
			CBCharacteristic *c = [service.characteristics objectAtIndex:i];
			KNS_LOG(@"Found characteristic %@\nvalue: %@\ndescriptors: %@\nproperties: %@\nisNotifying: %d\nisBroadcasted: %d",
					[c.UUID kns_stringValue], c.value, c.descriptors, NSStringFromCBCharacteristicProperty(c.properties), c.isNotifying, c.isBroadcasted);
		}
#endif
		
		CBService *s = [peripheral.services objectAtIndex:(peripheral.services.count - 1)];
		if([service.UUID kns_isEqualToUUID:s.UUID]) {
			KNS_LOG(@"Finished discovering all services' characteristics");
//			[self readyModule];
		}
	}
	else {
		KNS_LOG(@"ERROR: Characteristic discorvery unsuccessfull!");
	}
}

@end