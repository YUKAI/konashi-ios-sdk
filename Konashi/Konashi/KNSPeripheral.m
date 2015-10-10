//
//  KonashiPeripheral.m
//  Konashi
//
//  Created by Akira Matsuda on 9/18/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "KNSPeripheral.h"
#import "KNSPeripheralImpls.h"
#import "KNSCentralManager.h"

@interface KNSPeripheral ()
{
	NSString *findName;
	BOOL isCallFind;
}

@property (nonatomic, readonly) CBPeripheral *assignedPeripheral;

@end

@implementation KNSPeripheral

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.handlerManager = [KNSHandlerManager new];
	}
	
	return self;
}

- (instancetype)initWithPeripheral:(CBPeripheral *)p
{
	self = [self init];
	if (self) {
		_assignedPeripheral = p;
		p.delegate = self;
	}
	
	return self;
}

#pragma mark -
#pragma mark - Blocks

- (void)setHandlerManager:(KNSHandlerManager *)handlerManager
{
	_handlerManager = handlerManager;
	_impl.handlerManager = _handlerManager;
}

- (void)setConnectedHandler:(void (^)())connectedHandler
{
	_handlerManager.connectedHandler = connectedHandler;
}

- (void (^)())connectedHandler
{
	return _handlerManager.connectedHandler;
}

- (void)setDisconnectedHandler:(void (^)())disconnectedHandler
{
	_handlerManager.disconnectedHandler = disconnectedHandler;
}

- (void (^)())disconnectedHandler
{
	return _handlerManager.disconnectedHandler;
}

- (void)setReadyHandler:(void (^)())readyHandler
{
	_handlerManager.readyHandler = readyHandler;
}

- (void (^)())readyHandler
{
	return _handlerManager.readyHandler;
}

- (void)setDigitalInputDidChangeValueHandler:(void (^)(KonashiDigitalIOPin, int))digitalInputDidChangeValueHandler
{
	_handlerManager.digitalInputDidChangeValueHandler = digitalInputDidChangeValueHandler;
}

- (void (^)(KonashiDigitalIOPin, int))digitalInputDidChangeValueHandler
{
	return _handlerManager.digitalInputDidChangeValueHandler;
}

- (void)setDigitalOutputDidChangeValueHandler:(void (^)(KonashiDigitalIOPin, int))digitalOutputDidChangeValueHandler
{
	_handlerManager.digitalOutputDidChangeValueHandler = digitalOutputDidChangeValueHandler;
}

- (void (^)(KonashiDigitalIOPin, int))digitalOutputDidChangeValueHandler
{
	return _handlerManager.digitalOutputDidChangeValueHandler;
}

- (void)setAnalogPinDidChangeValueHandler:(void (^)(KonashiAnalogIOPin, int))analogPinDidChangeValueHandler
{
	_handlerManager.analogPinDidChangeValueHandler = analogPinDidChangeValueHandler;
}

- (void (^)(KonashiAnalogIOPin, int))analogPinDidChangeValueHandler
{
	return _handlerManager.analogPinDidChangeValueHandler;
}

- (void)setUartRxCompleteHandler:(void (^)(NSData *))uartRxCompleteHandler
{
	_handlerManager.uartRxCompleteHandler = uartRxCompleteHandler;
}

- (void (^)(NSData *))uartRxCompleteHandler
{
	return _handlerManager.uartRxCompleteHandler;
}

- (void)setI2cReadCompleteHandler:(void (^)(NSData *))i2cReadCompleteHandler
{
	_handlerManager.i2cReadCompleteHandler = i2cReadCompleteHandler;
}

- (void (^)(NSData *))i2cReadCompleteHandler
{
	return _handlerManager.i2cReadCompleteHandler;
}

- (void)setBatteryLevelDidUpdateHandler:(void (^)(int))batteryLevelDidUpdateHandler
{
	_handlerManager.batteryLevelDidUpdateHandler = batteryLevelDidUpdateHandler;
}

- (void (^)(int))batteryLevelDidUpdateHandler
{
	return _handlerManager.batteryLevelDidUpdateHandler;
}

- (void)setSignalStrengthDidUpdateHandler:(void (^)(int))signalStrengthDidUpdateHandler
{
	_handlerManager.signalStrengthDidUpdateHandler = signalStrengthDidUpdateHandler;
}

- (void (^)(int))signalStrengthDidUpdateHandler
{
	return _handlerManager.signalStrengthDidUpdateHandler;
}

- (void)setSpiWriteCompleteHandler:(void (^)())spiWriteCompleteHandler
{
	_handlerManager.spiWriteCompleteHandler = spiWriteCompleteHandler;
}

- (void (^)())spiWriteCompleteHandler
{
	return _handlerManager.spiWriteCompleteHandler;
}

- (void)setSpiReadCompleteHandler:(void (^)(NSData *))spiReadCompleteHandler
{
	_handlerManager.spiReadCompleteHandler = spiReadCompleteHandler;
}

- (void (^)(NSData *))spiReadCompleteHandler
{
	return _handlerManager.spiReadCompleteHandler;
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
	return _impl.peripheral ?: self.assignedPeripheral;
}

- (CBPeripheralState)state
{
	return _impl.peripheral.state;
}

- (BOOL)isReady
{
	return _impl.isReady;
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

#pragma mark - SPI

- (KonashiResult)spiMode:(KonashiSPIMode)mode speed:(KonashiSPISpeed)speed bitOrder:(KonashiSPIBitOrder)bitOrder
{
	KonashiResult result = KonashiResultFailure;
	if ([_impl isKindOfClass:[KNSKoshianPeripheralImpl class]]) {
		result = [(KNSKoshianPeripheralImpl *)_impl spiMode:mode speed:speed bitOrder:bitOrder];
	}
	
	return result;
}

- (KonashiResult)spiWrite:(NSData *)data
{
	KonashiResult result = KonashiResultFailure;
	if ([_impl isKindOfClass:[KNSKoshianPeripheralImpl class]]) {
		result = [(KNSKoshianPeripheralImpl *)_impl spiWrite:data];
	}
	
	return result;
}

- (KonashiResult)spiReadRequest
{
	KonashiResult result = KonashiResultFailure;
	if ([_impl isKindOfClass:[KNSKoshianPeripheralImpl class]]) {
		result = [(KNSKoshianPeripheralImpl *)_impl spiReadRequest];
	}
	
	return result;
}

- (NSData *)spiReadData
{
	NSData *data = nil;
	if ([_impl isKindOfClass:[KNSKoshianPeripheralImpl class]]) {
		data = [(KNSKoshianPeripheralImpl *)_impl spiReadData];
	}
	
	return data;
}

#pragma markr Hardware

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
		[[NSNotificationCenter defaultCenter] addObserverForName:KonashiEventImplReadyToUseNotification object:_impl queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
			[[NSNotificationCenter defaultCenter] postNotificationName:KonashiEventReadyToUseNotification object:nil userInfo:@{KonashiPeripheralKey:self}];
		}];
		[[NSNotificationCenter defaultCenter] postNotificationName:KonashiEventConnectedNotification object:self userInfo:@{KonashiPeripheralKey:self}];
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

- (void)enableSPI_MISONotification
{
	if ([_impl isKindOfClass:[KNSKoshianPeripheralImpl class]]) {
		[(KNSKoshianPeripheralImpl *)_impl enableSPINotification];
	}
}

@end