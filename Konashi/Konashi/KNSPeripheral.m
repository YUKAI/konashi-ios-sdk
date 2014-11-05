//
//  KonashiPeripheral.m
//  Konashi
//
//  Created by Akira Matsuda on 9/18/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "KNSPeripheral.h"
#import "KNSPeripheralImpls.h"

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

- (KonashiResult) pinMode:(KonashiDigitalIOPin)pin mode:(KonashiPinMode)mode
{
	return [impl_ pinMode:pin mode:mode];
}

- (KonashiResult) pinModeAll:(int)mode
{
	return [impl_ pinModeAll:mode];
}

- (KonashiResult) pinPullup:(KonashiDigitalIOPin)pin mode:(KonashiPinMode)mode
{
	return [impl_ pinPullup:pin mode:mode];
}

- (KonashiResult) pinPullupAll:(int)mode
{
	return [impl_ pinPullupAll:mode];
}

- (KonashiLevel) digitalRead:(KonashiDigitalIOPin)pin
{
	return [impl_ digitalRead:pin];
}

- (int) digitalReadAll
{
	return [impl_ digitalReadAll];
}

- (KonashiResult) digitalWrite:(KonashiDigitalIOPin)pin value:(KonashiLevel)value
{
	return [impl_ digitalWrite:pin value:value];
}

- (KonashiResult) digitalWriteAll:(int)value
{
	return [impl_ digitalWriteAll:value];
}

- (KonashiResult) pwmMode:(KonashiDigitalIOPin)pin mode:(KonashiPWMMode)mode
{
	return [impl_ pwmMode:pin mode:mode];
}

- (KonashiResult) pwmPeriod:(KonashiDigitalIOPin)pin period:(unsigned int)period
{
	return [impl_ pwmPeriod:pin period:period];
}

- (KonashiResult) pwmDuty:(KonashiDigitalIOPin)pin duty:(unsigned int)duty
{
	return [impl_ pwmDuty:pin duty:duty];
}

- (KonashiResult) pwmLedDrive:(KonashiDigitalIOPin)pin dutyRatio:(int)ratio
{
	return [impl_ pwmLedDrive:pin dutyRatio:ratio];
}

- (KonashiResult) readValueAio:(KonashiAnalogIOPin)pin
{
	return [impl_ readValueAio:pin];
}

- (int) analogReference
{
	return [impl_ analogReference];
}

- (KonashiResult) analogReadRequest:(KonashiAnalogIOPin)pin
{
	return [impl_ analogReadRequest:pin];
}

- (int) analogRead:(KonashiAnalogIOPin)pin
{
	return [impl_ analogRead:pin];
}

- (KonashiResult) analogWrite:(KonashiAnalogIOPin)pin milliVolt:(int)milliVolt
{
	return [impl_ analogWrite:pin milliVolt:milliVolt];
}

- (KonashiResult) i2cMode:(KonashiI2CMode)mode
{
	return [impl_ i2cMode:mode];
}

- (KonashiResult) i2cSendCondition:(KonashiI2CCondition)condition
{
	return [impl_ i2cSendCondition:condition];
}

- (KonashiResult) i2cStartCondition
{
	return [impl_ i2cStartCondition];
}

- (KonashiResult) i2cRestartCondition
{
	return [impl_ i2cRestartCondition];
}

- (KonashiResult) i2cStopCondition
{
	return [impl_ i2cStopCondition];
}

- (KonashiResult) i2cWrite:(int)length data:(unsigned char*)data address:(unsigned char)address
{
	return [impl_ i2cWrite:length data:data address:address];
}

- (KonashiResult) i2cReadRequest:(int)length address:(unsigned char)address
{
	return [impl_ i2cReadRequest:length address:address];
}

- (KonashiResult) i2cRead:(int)length data:(unsigned char*)data
{
	return [impl_ i2cRead:length data:data];
}

- (KonashiResult) uartMode:(KonashiUartMode)mode
{
	return [impl_ uartMode:mode];
}

- (KonashiResult) uartBaudrate:(KonashiUartBaudrate)baudrate
{
	return [impl_ uartBaudrate:baudrate];
}

- (KonashiResult) uartWrite:(unsigned char)data
{
	return [impl_ uartWrite:data];
}

- (unsigned char) uartRead
{
	return [impl_ uartRead];
}

- (KonashiResult) reset
{
	return [impl_ reset];
}

- (KonashiResult) batteryLevelReadRequest
{
	return [impl_ batteryLevelReadRequest];
}

- (int) batteryLevelRead
{
	return [impl_ batteryLevelRead];
}

- (KonashiResult) signalStrengthReadRequest
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
		if ([service.UUID kns_isEqualToUUID:[[KNSKonashiPeripheralImpl class] serviceUUID]]) {
			impl_ = (KNSKonashiPeripheralImpl<KNSPeripheralImplProtocol>*)[[KNSKonashiPeripheralImpl alloc] initWithPeripheral:peripheral];
			break;
		}
		else if ([service.UUID kns_isEqualToUUID:[[KNSKoshianPeripheralImpl class] serviceUUID]]){
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