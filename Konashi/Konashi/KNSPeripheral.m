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
	[_impl writeData:data serviceUUID:uuid characteristicUUID:charasteristicUUID];
}

- (void)readDataWithServiceUUID:(CBUUID*)uuid characteristicUUID:(CBUUID*)charasteristicUUID
{
	[_impl readDataWithServiceUUID:uuid characteristicUUID:charasteristicUUID];
}

- (void)notificationWithServiceUUID:(CBUUID*)uuid characteristicUUID:(CBUUID*)characteristicUUID on:(BOOL)on
{
	[_impl notificationWithServiceUUID:uuid characteristicUUID:characteristicUUID on:on];
}

#pragma mark -

- (CBPeripheral *)peripheral
{
	return _impl.peripheral;
}

- (CBPeripheralState)state
{
	return _impl.peripheral.state;
}

- (BOOL)isReady
{
	return _impl.isReady;
}

- (NSString *)findName
{
	return _impl.findName;
}

- (NSString *)softwareRevisionString
{
	return _impl.softwareRevisionString;
}


#pragma mark - Digital

- (KonashiResult) pinMode:(KonashiDigitalIOPin)pin mode:(KonashiPinMode)mode
{
	return [_impl pinMode:pin mode:mode];
}

- (KonashiResult) pinModeAll:(int)mode
{
	return [_impl pinModeAll:mode];
}

- (KonashiResult) pinPullup:(KonashiDigitalIOPin)pin mode:(KonashiPinMode)mode
{
	return [_impl pinPullup:pin mode:mode];
}

- (KonashiResult) pinPullupAll:(int)mode
{
	return [_impl pinPullupAll:mode];
}

- (KonashiLevel) digitalRead:(KonashiDigitalIOPin)pin
{
	return [_impl digitalRead:pin];
}

- (int) digitalReadAll
{
	return [_impl digitalReadAll];
}

- (KonashiResult) digitalWrite:(KonashiDigitalIOPin)pin value:(KonashiLevel)value
{
	return [_impl digitalWrite:pin value:value];
}

- (KonashiResult) digitalWriteAll:(int)value
{
	return [_impl digitalWriteAll:value];
}

#pragma mark PWM

- (KonashiResult) pwmMode:(KonashiDigitalIOPin)pin mode:(KonashiPWMMode)mode
{
	return [_impl pwmMode:pin mode:mode];
}

- (KonashiResult) pwmPeriod:(KonashiDigitalIOPin)pin period:(unsigned int)period
{
	return [_impl pwmPeriod:pin period:period];
}

- (KonashiResult) pwmDuty:(KonashiDigitalIOPin)pin duty:(unsigned int)duty
{
	return [_impl pwmDuty:pin duty:duty];
}

- (KonashiResult) pwmLedDrive:(KonashiDigitalIOPin)pin dutyRatio:(int)ratio
{
	return [_impl pwmLedDrive:pin dutyRatio:ratio];
}

- (KonashiResult) readValueAio:(KonashiAnalogIOPin)pin
{
	return [_impl readValueAio:pin];
}

#pragma mark - Analog

- (int) analogReference
{
	return [[_impl class] analogReference];
}

- (KonashiResult) analogReadRequest:(KonashiAnalogIOPin)pin
{
	return [_impl analogReadRequest:pin];
}

- (int) analogRead:(KonashiAnalogIOPin)pin
{
	return [_impl analogRead:pin];
}

- (KonashiResult) analogWrite:(KonashiAnalogIOPin)pin milliVolt:(int)milliVolt
{
	return [_impl analogWrite:pin milliVolt:milliVolt];
}

#pragma mark - I2C

- (KonashiResult) i2cMode:(KonashiI2CMode)mode
{
	return [_impl i2cMode:mode];
}

- (KonashiResult) i2cSendCondition:(KonashiI2CCondition)condition
{
	return [_impl i2cSendCondition:condition];
}

- (KonashiResult) i2cStartCondition
{
	return [_impl i2cStartCondition];
}

- (KonashiResult) i2cRestartCondition
{
	return [_impl i2cRestartCondition];
}

- (KonashiResult) i2cStopCondition
{
	return [_impl i2cStopCondition];
}

- (KonashiResult) i2cWrite:(int)length data:(unsigned char*)data address:(unsigned char)address
{
	return [_impl i2cWrite:length data:data address:address];
}

- (KonashiResult) i2cWriteData:(NSData *)data address:(unsigned char)address
{
	return [_impl i2cWriteData:data address:address];
}

- (KonashiResult) i2cReadRequest:(int)length address:(unsigned char)address
{
	return [_impl i2cReadRequest:length address:address];
}

- (KonashiResult) i2cRead:(int)length data:(unsigned char*)data
{
	return [_impl i2cRead:length data:data];
}

- (NSData *)i2cReadData
{
	return [_impl i2cReadData];
}

#pragma mark - UART

- (KonashiResult) uartMode:(KonashiUartMode)mode baudrate:(KonashiUartBaudrate)baudrate
{
	return [_impl uartMode:mode baudrate:baudrate];
}

- (KonashiResult) uartMode:(KonashiUartMode)mode
{
	return [_impl uartMode:mode];
}

- (KonashiResult) uartBaudrate:(KonashiUartBaudrate)baudrate
{
	return [_impl uartBaudrate:baudrate];
}

- (KonashiResult) uartWrite:(unsigned char)data
{
	return [_impl uartWriteData:[NSData dataWithBytes:&data length:1]];
}

- (KonashiResult) uartWriteData:(NSData *)data
{
	return [_impl uartWriteData:data];
}

- (NSData *) readUartData
{
	return [_impl readUartData];
}

- (KonashiResult) reset
{
	return [_impl reset];
}

- (KonashiResult) batteryLevelReadRequest
{
	return [_impl batteryLevelReadRequest];
}

- (int) batteryLevelRead
{
	return [_impl batteryLevelRead];
}

- (KonashiResult) signalStrengthReadRequest
{
	return [_impl signalStrengthReadRequest];
}

- (int) signalStrengthRead
{
	return [_impl signalStrengthRead];
}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
	for (CBService *service in peripheral.services) {
		if ([service.UUID kns_isEqualToUUID:[[KNSKonashiPeripheralImpl class] serviceUUID]]) {
			_impl = (KNSKonashiPeripheralImpl<KNSPeripheralImplProtocol>*)[[KNSKonashiPeripheralImpl alloc] initWithPeripheral:peripheral];
			break;
		}
		else if ([service.UUID kns_isEqualToUUID:[[KNSKoshianPeripheralImpl class] serviceUUID]]){
			_impl = (KNSKoshianPeripheralImpl<KNSPeripheralImplProtocol>*)[[KNSKoshianPeripheralImpl alloc] initWithPeripheral:peripheral];
			break;
		}
	}
	
	if (_impl != nil) {
		if (self.handlerManager.connectedHandler) {
			self.handlerManager.connectedHandler();
		}
		_impl.handlerManager = self.handlerManager;
		[[NSNotificationCenter defaultCenter] postNotificationName:KonashiEventConnectedNotification object:nil];
	}
}

- (void)enablePIOInputNotification
{
	[_impl enablePIOInputNotification];
}

- (void)enableUART_RXNotification
{
	[_impl enableUART_RXNotification];
}

@end