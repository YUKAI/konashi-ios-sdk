//
//  KonashiPeripheral.m
//  Konashi
//
//  Created by Akira Matsuda on 9/18/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "KNSPeripheral.h"
#import "KNSPeripheralImpls.h"
#import "KNSUUIDExtern.h"

@implementation KNSPeripheral

- (instancetype)initWithPeripheral:(CBPeripheral *)p
{
	self = [super init];
	if (self) {
		p.delegate = self;
		[p kns_discoverAllServices];
	}
	
	return self;
}

- (void)writeData:(NSData *)data serviceUUID:(CBUUID*)uuid characteristicUUID:(CBUUID*)charasteristicUUID
{
	[impl_ writeData:data serviceUUID:uuid characteristicUUID:charasteristicUUID];
}

- (void)readDataWithServiceUUID:(CBUUID*)uuid characteristicUUID:(CBUUID*)charasteristicUUID
{
	[impl_ readDataWithServiceUUID:uuid characteristicUUID:charasteristicUUID];
}

- (void)notificationWithServiceUUID:(CBUUID*)uuid characteristicUUID:(CBUUID*)characteristicUUID on:(BOOL)on
{
	[impl_ notificationWithServiceUUID:uuid characteristicUUID:characteristicUUID on:on];
}

#pragma mark -

- (CBPeripheral *)peripheral
{
	return impl_.peripheral;
}

- (CBPeripheralState)state
{
	return impl_.peripheral.state;
}

- (BOOL)isReady
{
	return impl_.isReady;
}

- (NSString *)findName
{
	return impl_.findName;
}

- (int) pinMode:(int)pin mode:(int)mode
{
	return [impl_ pinMode:pin mode:mode];
}

- (int) pinModeAll:(int)mode
{
	return [impl_ pinModeAll:mode];
}

- (int) pinPullup:(int)pin mode:(int)mode
{
	return [impl_ pinPullup:pin mode:mode];
}

- (int) pinPullupAll:(int)mode
{
	return [impl_ pinPullupAll:mode];
}

- (int) digitalRead:(int)pin
{
	return [impl_ digitalRead:pin];
}

- (int) digitalReadAll
{
	return [impl_ digitalReadAll];
}

- (int) digitalWrite:(int)pin value:(int)value
{
	return [impl_ digitalWrite:pin value:value];
}

- (int) digitalWriteAll:(int)value
{
	return [impl_ digitalWriteAll:value];
}

- (int) pwmMode:(int)pin mode:(int)mode
{
	return [impl_ pwmMode:pin mode:mode];
}

- (int) pwmPeriod:(int)pin period:(unsigned int)period
{
	return [impl_ pwmPeriod:pin period:period];
}

- (int) pwmDuty:(int)pin duty:(unsigned int)duty
{
	return [impl_ pwmDuty:pin duty:duty];
}

- (int) pwmLedDrive:(int)pin dutyRatio:(int)ratio
{
	return [impl_ pwmLedDrive:pin dutyRatio:ratio];
}

- (int) readValueAio:(int)pin
{
	return [impl_ readValueAio:pin];
}

- (int) analogReference
{
	return [impl_ analogReference];
}

- (int) analogReadRequest:(int)pin
{
	return [impl_ analogReadRequest:pin];
}

- (int) analogRead:(int)pin
{
	return [impl_ analogRead:pin];
}

- (int) analogWrite:(int)pin milliVolt:(int)milliVolt
{
	return [impl_ analogWrite:pin milliVolt:milliVolt];
}

- (int) i2cMode:(int)mode
{
	return [impl_ i2cMode:mode];
}

- (int) i2cSendCondition:(int)condition
{
	return [impl_ i2cSendCondition:condition];
}

- (int) i2cStartCondition
{
	return [impl_ i2cStartCondition];
}

- (int) i2cRestartCondition
{
	return [impl_ i2cRestartCondition];
}

- (int) i2cStopCondition
{
	return [impl_ i2cStopCondition];
}

- (int) i2cWrite:(int)length data:(unsigned char*)data address:(unsigned char)address
{
	return [impl_ i2cWrite:length data:data address:address];
}

- (int) i2cReadRequest:(int)length address:(unsigned char)address
{
	return [impl_ i2cReadRequest:length address:address];
}

- (int) i2cRead:(int)length data:(unsigned char*)data
{
	return [impl_ i2cRead:length data:data];
}

- (int) uartMode:(int)mode
{
	return [impl_ uartMode:mode];
}

- (int) uartBaudrate:(int)baudrate
{
	return [impl_ uartBaudrate:baudrate];
}

- (int) uartWrite:(unsigned char)data
{
	return [impl_ uartWrite:data];
}

- (unsigned char) uartRead
{
	return [impl_ uartRead];
}

- (int) reset
{
	return [impl_ reset];
}

- (int) batteryLevelReadRequest
{
	return [impl_ batteryLevelReadRequest];
}

- (int) batteryLevelRead
{
	return [impl_ batteryLevelRead];
}

- (int) signalStrengthReadRequest
{
	return [impl_ signalStrengthReadRequest];
}

- (int) signalStrengthRead
{
	return [impl_ signalStrengthRead];
}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
	for (CBService *service in peripheral.services) {
		if ([service.UUID kns_isEqualToUUID:KONASHI_SERVICE_UUID]) {
			impl_ = (KNSKonashiPeripheralImpl<KNSPeripheralImplProtocol>*)[[KNSKonashiPeripheralImpl alloc] initWithPeripheral:peripheral];
			break;
		}
		else if ([service.UUID kns_isEqualToUUID:KOSHIAN_SERVICE_UUID]){
			impl_ = (KNSKoshianPeripheralImpl<KNSPeripheralImplProtocol>*)[[KNSKoshianPeripheralImpl alloc] initWithPeripheral:peripheral];
			break;
		}
	}
	
	if (impl_ != nil) {
		[[NSNotificationCenter defaultCenter] postNotificationName:KONASHI_EVENT_CONNECTED object:nil];
	}
}

- (void)enablePIOInputNotification
{
	[impl_ enablePIOInputNotification];
}

- (void)enableUART_RXNotification
{
	[impl_ enableUART_RXNotification];
}

@end