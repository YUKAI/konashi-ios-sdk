/* ========================================================================
 * Konashi.m
 *
 * http://konashi.ux-xu.com
 * ========================================================================
 * Copyright 2013 Yukai Engineering Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ======================================================================== */

#import <QuartzCore/QuartzCore.h>
#import "KNSPeripheralImpls.h"
#import "KonashiUtils.h"
#import "Konashi.h"
#import "KNSHandlerManager.h"
#import "KNSCentralManager+UI.h"
#import "CBUUID+Konashi.h"

@interface Konashi ()

@property (nonatomic, strong) NSString *findName;
@property (nonatomic, assign) BOOL callFind;
@property (nonatomic, strong) KNSHandlerManager *handlerManager;

@end

@implementation Konashi

#pragma mark -
#pragma mark - Singleton

+ (Konashi *) shared
{
	static Konashi *_konashi = nil;
	
	@synchronized (self){
		static dispatch_once_t pred;
		dispatch_once(&pred, ^{
			_konashi = [[Konashi alloc] init];
		});
	}
	
	return _konashi;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		[KNSCentralManager sharedInstance];
		self.handlerManager = [KNSHandlerManager new];
		[[NSNotificationCenter defaultCenter] addObserverForName:KonashiEventCentralManagerPowerOnNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
			if (_callFind) {
				_callFind = NO;
				if (self.findName) {
					KNS_LOG(@"Try findWithName");
					[Konashi findWithName:self.findName];
				}
				else {
					[Konashi find];
				}
			}
		}];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readyToUse:) name:KonashiEventReadyToUseNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserverForName:KonashiEventConnectedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
			if ([Konashi shared].connectedHandler) {
				[Konashi shared].connectedHandler();
			}
		}];
		[[NSNotificationCenter defaultCenter] addObserverForName:KonashiEventDisconnectedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
			if ([Konashi shared].disconnectedHandler) {
				[Konashi shared].disconnectedHandler();
			}
		}];
	}
	
	return self;
}

- (void)readyToUse:(NSNotification *)note
{
	KNSPeripheral *connectedPeripheral = [note userInfo][KonashiPeripheralKey];
	KNS_LOG(@"Peripheral(UUID : %@) is ready to use.", connectedPeripheral.peripheral.identifier.UUIDString);
	_activePeripheral = connectedPeripheral;
	_activePeripheral.handlerManager = self.handlerManager;
	// Enable PIO input notification
	[_activePeripheral enablePIOInputNotification];
	// Enable UART RX notification
	[_activePeripheral enableUART_RXNotification];
	if (self.readyHandler) {
		self.readyHandler();
	}
}

#pragma mark -
#pragma mark - Konashi control public methods

+ (KonashiResult) find
{
	if([Konashi shared].activePeripheral && [Konashi shared].activePeripheral.state == CBPeripheralStateConnected){
		return KonashiResultFailure;
	}
	
	if ([KNSCentralManager sharedInstance].state  != CBCentralManagerStatePoweredOn) {
		KNS_LOG(@"CoreBluetooth not correctly initialized !");
		KNS_LOG(@"State = %ld (%@)", (long)[KNSCentralManager sharedInstance].state, NSStringFromCBCentralManagerState([KNSCentralManager sharedInstance].state));
		[Konashi shared].callFind = YES;
		return KonashiResultSuccess;
	}
	
	[[KNSCentralManager sharedInstance] showPeripherals];
	
	return KonashiResultSuccess;
}

+ (KonashiResult) findWithName:(NSString*)name
{
	if([Konashi shared].activePeripheral && [Konashi shared].activePeripheral.state == CBPeripheralStateConnected){
		return KonashiResultFailure;
	}
	
	if ([KNSCentralManager sharedInstance].state  != CBCentralManagerStatePoweredOn) {
		KNS_LOG(@"CoreBluetooth not correctly initialized !");
		KNS_LOG(@"State = %ld (%@)", (long)[KNSCentralManager sharedInstance].state, NSStringFromCBCentralManagerState([KNSCentralManager sharedInstance].state));
		[Konashi shared].callFind = YES;
		[Konashi shared].findName = name;
		return KonashiResultSuccess;
	}
	[[KNSCentralManager sharedInstance] connectWithName:name timeout:KonashiFindTimeoutInterval connectedHandler:^(KNSPeripheral *connectedPeripheral) {
	}];
	
	return KonashiResultSuccess;
}

+ (NSString *)softwareRevisionString
{
	return [[Konashi shared].activePeripheral softwareRevisionString];
}

+ (KonashiResult) disconnect
{
	if([Konashi shared].activePeripheral && [Konashi shared].activePeripheral.state == CBPeripheralStateConnected){
		[[KNSCentralManager sharedInstance] cancelPeripheralConnection:[Konashi shared].activePeripheral.peripheral];
		return KonashiResultSuccess;
	}
	else{
		return KonashiResultFailure;
	}
}

+ (BOOL) isConnected
{
	return ([Konashi shared].activePeripheral && [Konashi shared].activePeripheral.state == CBPeripheralStateConnected);
}

+ (BOOL) isReady
{
	return [[Konashi shared].activePeripheral isReady];
}

+ (NSString *) peripheralName
{
	return [Konashi shared].activePeripheral.peripheral.name;
}

#pragma mark -
#pragma mark - Konashi PIO public methods

+ (KonashiResult) pinMode:(KonashiDigitalIOPin)pin mode:(KonashiPinMode)mode
{
	return [[Konashi shared].activePeripheral pinMode:pin mode:mode];
}

+ (KonashiResult) pinModeAll:(int)mode
{
	return [[Konashi shared].activePeripheral pinModeAll:mode];
}

+ (KonashiResult) pinPullup:(KonashiDigitalIOPin)pin mode:(KonashiPinMode)mode
{
	return [[Konashi shared].activePeripheral pinPullup:pin mode:mode];
}

+ (KonashiResult) pinPullupAll:(int)mode
{
	return [[Konashi shared].activePeripheral pinPullupAll:mode];
}

+ (KonashiResult) digitalWrite:(KonashiDigitalIOPin)pin value:(KonashiLevel)value
{
	return [[Konashi shared].activePeripheral digitalWrite:pin value:value];
}

+ (KonashiResult) digitalWriteAll:(int)value
{
	return [[Konashi shared].activePeripheral digitalWriteAll:value];
}

+ (KonashiLevel) digitalRead:(KonashiDigitalIOPin)pin
{
	return [[Konashi shared].activePeripheral digitalRead:pin];
}

+ (int) digitalReadAll
{
	return [[Konashi shared].activePeripheral digitalReadAll];
}

#pragma mark -
#pragma mark - Konashi PWM public methods

+ (KonashiResult) pwmMode:(KonashiDigitalIOPin)pin mode:(KonashiPWMMode)mode
{
	return [[Konashi shared].activePeripheral pwmMode:pin mode:mode];
}

+ (KonashiResult) pwmPeriod:(KonashiDigitalIOPin)pin period:(unsigned int)period
{
	return [[Konashi shared].activePeripheral pwmPeriod:pin period:period];
}

+ (KonashiResult) pwmDuty:(KonashiDigitalIOPin)pin duty:(unsigned int)duty
{
	return [[Konashi shared].activePeripheral pwmDuty:pin duty:duty];
}

+ (KonashiResult) pwmLedDrive:(KonashiDigitalIOPin)pin dutyRatio:(int)ratio
{
	return [[Konashi shared].activePeripheral pwmLedDrive:pin dutyRatio:ratio];
}

#pragma mark -
#pragma mark - Konashi analog IO public methods

+ (int) analogReference
{
	return [[Konashi shared].activePeripheral analogReference];
}

+ (KonashiResult) analogReadRequest:(KonashiAnalogIOPin)pin
{
	return [[Konashi shared].activePeripheral analogReadRequest:pin];
}

+ (KonashiResult) analogWrite:(KonashiAnalogIOPin)pin milliVolt:(int)milliVolt
{
	return [[Konashi shared].activePeripheral analogWrite:pin milliVolt:(int)milliVolt];
}

+ (int) analogRead:(KonashiAnalogIOPin)pin
{
	return [[Konashi shared].activePeripheral analogRead:pin];
}

#pragma mark -
#pragma mark - Konashi I2C public methods

+ (KonashiResult) i2cMode:(KonashiI2CMode)mode
{
	return [[Konashi shared].activePeripheral i2cMode:mode];
}

+ (KonashiResult) i2cStartCondition
{
	return [[Konashi shared].activePeripheral i2cSendCondition:KonashiI2CConditionStart];
}

+ (KonashiResult) i2cRestartCondition
{
	return [[Konashi shared].activePeripheral i2cSendCondition:KonashiI2CConditionRestart];
}

+ (KonashiResult) i2cStopCondition
{
	return [[Konashi shared].activePeripheral i2cSendCondition:KonashiI2CConditionStop];
}

+ (KonashiResult)i2cWriteData:(NSData *)data address:(unsigned char)address
{
	return [[Konashi shared].activePeripheral i2cWriteData:data address:address];
}

+ (KonashiResult) i2cWriteString:(NSString *)data address:(unsigned char)address
{
	return [[Konashi shared].activePeripheral i2cWrite:(int)MIN(data.length, [[[Konashi shared].activePeripheral.impl class] i2cDataMaxLength]) data:(unsigned char *)data.UTF8String address:address];
}

+ (KonashiResult) i2cReadRequest:(int)length address:(unsigned char)address
{
	return [[Konashi shared].activePeripheral i2cReadRequest:length address:address];
}

+ (NSData *)i2cReadData
{
	return [[Konashi shared].activePeripheral i2cReadData];
}

#pragma mark -
#pragma mark - Konashi UART public methods

+ (KonashiResult) uartMode:(KonashiUartMode)mode baudrate:(KonashiUartBaudrate)baudrate
{
	return [[Konashi shared].activePeripheral uartMode:mode baudrate:baudrate];
}

+ (KonashiResult) uartWriteData:(NSData *)data
{
	return [[Konashi shared].activePeripheral uartWriteData:data];
}

+ (KonashiResult) uartWriteString:(NSString *)string
{
	return [[Konashi shared].activePeripheral uartWriteData:[string dataUsingEncoding:NSASCIIStringEncoding]];
}

+ (NSData *)readUartData
{
	return [[Konashi shared].activePeripheral readUartData];
}

#pragma mark -
#pragma mark - Konashi hardware public methods

+ (KonashiResult) reset
{
	return [[Konashi shared].activePeripheral reset];
}

+ (KonashiResult) batteryLevelReadRequest
{
	return [[Konashi shared].activePeripheral batteryLevelReadRequest];
}

+ (KonashiResult) signalStrengthReadRequest
{
	return [[Konashi shared].activePeripheral signalStrengthReadRequest];
}

#pragma mark -
#pragma mark - Blocks

- (void)setConnectedHandler:(void (^)())connectedHandler
{
	self.handlerManager.connectedHandler = connectedHandler;
}

- (void (^)())connectedHandler
{
	return self.handlerManager.connectedHandler;
}

- (void)setDisconnectedHandler:(void (^)())disconnectedHandler
{
	self.handlerManager.disconnectedHandler = disconnectedHandler;
}

- (void (^)())disconnectedHandler
{
	return self.handlerManager.disconnectedHandler;
}

- (void)setReadyHandler:(void (^)())readyHandler
{
	self.handlerManager.readyHandler = readyHandler;
}

- (void (^)())readyHandler
{
	return self.handlerManager.readyHandler;
}

- (void)setDigitalInputDidChangeValueHandler:(void (^)(KonashiDigitalIOPin, int))digitalInputDidChangeValueHandler
{
	self.handlerManager.digitalInputDidChangeValueHandler = digitalInputDidChangeValueHandler;
}

- (void (^)(KonashiDigitalIOPin, int))digitalInputDidChangeValueHandler
{
	return self.handlerManager.digitalInputDidChangeValueHandler;
}

- (void)setDigitalOutputDidChangeValueHandler:(void (^)(KonashiDigitalIOPin, int))digitalOutputDidChangeValueHandler
{
	self.handlerManager.digitalOutputDidChangeValueHandler = digitalOutputDidChangeValueHandler;
}

- (void (^)(KonashiDigitalIOPin, int))digitalOutputDidChangeValueHandler
{
	return self.handlerManager.digitalOutputDidChangeValueHandler;
}

- (void)setAnalogPinDidChangeValueHandler:(void (^)(KonashiAnalogIOPin, int))analogPinDidChangeValueHandler
{
	self.handlerManager.analogPinDidChangeValueHandler = analogPinDidChangeValueHandler;
}

- (void (^)(KonashiAnalogIOPin, int))analogPinDidChangeValueHandler
{
	return self.handlerManager.analogPinDidChangeValueHandler;
}

- (void)setUartRxCompleteHandler:(void (^)(NSData *))uartRxCompleteHandler
{
	self.handlerManager.uartRxCompleteHandler = uartRxCompleteHandler;
}

- (void (^)(NSData *))uartRxCompleteHandler
{
	return self.handlerManager.uartRxCompleteHandler;
}

- (void)setI2cReadCompleteHandler:(void (^)(NSData *))i2cReadCompleteHandler
{
	self.handlerManager.i2cReadCompleteHandler = i2cReadCompleteHandler;
}

- (void (^)(NSData *))i2cReadCompleteHandler
{
	return self.handlerManager.i2cReadCompleteHandler;
}

- (void)setBatteryLevelDidUpdateHandler:(void (^)(int))batteryLevelDidUpdateHandler
{
	self.handlerManager.batteryLevelDidUpdateHandler = batteryLevelDidUpdateHandler;
}

- (void (^)(int))batteryLevelDidUpdateHandler
{
	return self.handlerManager.batteryLevelDidUpdateHandler;
}

- (void)setSignalStrengthDidUpdateHandler:(void (^)(int))signalStrengthDidUpdateHandler
{
	self.handlerManager.signalStrengthDidUpdateHandler = signalStrengthDidUpdateHandler;
}

- (void (^)(int))signalStrengthDidUpdateHandler
{
	return self.handlerManager.signalStrengthDidUpdateHandler;
}

- (void)setSpiWriteCompleteHandler:(void (^)())spiWriteCompleteHandler
{
	self.handlerManager.spiWriteCompleteHandler = spiWriteCompleteHandler;
}

- (void (^)())spiWriteCompleteHandler
{
	return self.handlerManager.spiWriteCompleteHandler;
}

- (void)setSpiReadCompleteHandler:(void (^)(NSData *))spiReadCompleteHandler
{
	self.handlerManager.spiReadCompleteHandler = spiReadCompleteHandler;
}

- (void (^)(NSData *))spiReadCompleteHandler
{
	return self.handlerManager.spiReadCompleteHandler;
}

#pragma mark - Depricated methods

- (BOOL) _isConnected
{
	return (self.activePeripheral && self.activePeripheral.state == CBPeripheralStateConnected);
}

- (BOOL) _isReady
{
	return [[Konashi shared].activePeripheral isReady];
}

- (NSString *) _peripheralName
{
	if(self.activePeripheral && self.activePeripheral.state == CBPeripheralStateConnected){
		return self.activePeripheral.peripheral.name;
	} else {
		return @"";
	}
}

#pragma mark - Deprecated

#pragma mark - digital

#pragma mark - analog

#pragma mark - I2C

+ (KonashiResult) i2cWrite:(int)length data:(unsigned char*)data address:(unsigned char)address
{
	return [[Konashi shared].activePeripheral i2cWrite:length data:data address:address];
}

+ (KonashiResult) i2cRead:(int)length data:(unsigned char*)data
{
	return [[Konashi shared].activePeripheral i2cRead:length data:data];
}

#pragma mark - Uart

+ (KonashiResult) uartMode:(KonashiUartMode)mode
{
	return [[Konashi shared].activePeripheral uartMode:mode];
}

+ (KonashiResult) uartBaudrate:(KonashiUartBaudrate)baudrate
{
	return [[Konashi shared].activePeripheral uartBaudrate:baudrate];
}

+ (KonashiResult) uartWrite:(unsigned char)data
{
	return [[Konashi shared].activePeripheral uartWrite:data];
}

+ (unsigned char) uartRead
{
	NSData *d = [[Konashi shared].activePeripheral readUartData];
	unsigned char data;
	[d getBytes:&data length:1];
	return data;
}

#pragma mark - SPI

+ (KonashiResult)spiMode:(KonashiSPIMode)mode speed:(KonashiSPISpeed)speed bitOrder:(KonashiSPIBitOrder)bitOrder
{
	return [[Konashi shared].activePeripheral spiMode:mode speed:speed bitOrder:bitOrder];
}

+ (KonashiResult)spiWrite:(NSData *)data
{
	return [[Konashi shared].activePeripheral spiWrite:data];
}

+ (KonashiResult)spiReadRequest
{
	return [[Konashi shared].activePeripheral spiReadRequest];
}

+ (NSData *)spiReadData
{
	return [[Konashi shared].activePeripheral spiReadData];
}

#pragma mark - Hardware

+ (int) batteryLevelRead
{
	return [[Konashi shared].activePeripheral batteryLevelRead];
}

+ (int) signalStrengthRead
{
	return [[Konashi shared].activePeripheral signalStrengthRead];
}

@end
