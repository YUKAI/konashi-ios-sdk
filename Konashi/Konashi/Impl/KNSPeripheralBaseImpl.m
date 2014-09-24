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

- (void)writeData:(NSData *)data serviceUUID:(CBUUID*)serviceUUID characteristicUUID:(CBUUID*)characteristicUUID
{
    CBService *service = [self.peripheral kns_findServiceFromUUID:serviceUUID];
    if (!service) {
        KNS_LOG(@"Could not find service with UUID %@ on peripheral with UUID %@", [serviceUUID kns_dataDescription], self.peripheral.identifier.UUIDString);
        return;
    }
    CBCharacteristic *characteristic = [service kns_findCharacteristicFromUUID:characteristicUUID];
    if (!characteristic) {
        KNS_LOG(@"Could not find characteristic with UUID %@ on service with UUID %@ on peripheral with UUID %@", [characteristicUUID kns_dataDescription], [serviceUUID kns_dataDescription], self.peripheral.identifier.UUIDString);
        return;
    }
    [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
}

- (void)readDataWithServiceUUID:(CBUUID*)serviceUUID characteristicUUID:(CBUUID*)characteristicUUID
{
    CBService *service = [self.peripheral kns_findServiceFromUUID:serviceUUID];
    if (!service) {
        KNS_LOG(@"Could not find service with UUID %@ on peripheral with UUID %@\r\n", [serviceUUID kns_dataDescription], self.peripheral.identifier.UUIDString);
        return;
    }
    CBCharacteristic *characteristic = [service kns_findCharacteristicFromUUID:characteristicUUID];
    if (!characteristic) {
        KNS_LOG(@"Could not find characteristic with UUID %@ on service with UUID %@ on peripheral with UUID %@", [characteristicUUID kns_dataDescription], [serviceUUID kns_dataDescription], self.peripheral.identifier.UUIDString);
        return;
    }
    [self.peripheral readValueForCharacteristic:characteristic];
}

- (void)notificationWithServiceUUID:(CBUUID*)serviceUUID characteristicUUID:(CBUUID*)characteristicUUID on:(BOOL)on
{
    CBService *service = [self.peripheral kns_findServiceFromUUID:serviceUUID];

    if (!service) {
        KNS_LOG(@"Could not find service with UUID %@ on peripheral with UUID %@", [serviceUUID kns_dataDescription], self.peripheral.identifier.UUIDString);
        return;
    }
    CBCharacteristic *characteristic = [service kns_findCharacteristicFromUUID:characteristicUUID];
    if (!characteristic) {
        KNS_LOG(@"Could not find characteristic with UUID %@ on service with UUID %@ on peripheral with UUID %@", [characteristicUUID kns_dataDescription], [serviceUUID kns_dataDescription], self.peripheral.identifier.UUIDString);
        return;
    }
    [self.peripheral setNotifyValue:on forCharacteristic:characteristic];
}

- (void)enablePIOInputNotification
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (void)enableUART_RXNotification
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

#pragma mark - CBPeripheralDelegate

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
	//KNS_LOG(@"peripheralDidUpdateRSSI");
	
	rssi = [peripheral.RSSI intValue];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:KONASHI_EVENT_UPDATE_SIGNAL_STRENGTH object:nil];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
	if (!error) {
		KNS_LOG(@"Characteristics of service with UUID : %@ found", [service.UUID kns_dataDescription]);
		
#ifdef KONASHI_DEBUG
		for(int i=0; i < service.characteristics.count; i++) {
			CBCharacteristic *c = [service.characteristics objectAtIndex:i];
			KNS_LOG(@"Found characteristic %@\nvalue: %@\ndescriptors: %@\nproperties: %@\nisNotifying: %d\n",
					[c.UUID kns_dataDescription], c.value, c.descriptors, NSStringFromCBCharacteristicProperty(c.properties), c.isNotifying);
		}
#endif
		
		CBService *s = [peripheral.services objectAtIndex:(peripheral.services.count - 1)];
		if([service.UUID kns_isEqualToUUID:s.UUID]) {
			KNS_LOG(@"Finished discovering all services' characteristics");
			// set konashi property
			_ready = YES;
			
			[[NSNotificationCenter defaultCenter] postNotificationName:KONASHI_EVENT_READY object:nil];
			
			// Enable PIO input notification
			[self enablePIOInputNotification];
			
			// Enable UART RX notification
			[self enableUART_RXNotification];
		}
	}
	else {
		KNS_LOG(@"ERROR: Characteristic discorvery unsuccessfull!");
	}
}

@end
