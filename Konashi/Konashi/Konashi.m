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
{
	NSString *findName;
	KNSHandlerManager *handlerManager;
}

@property (nonatomic, assign) BOOL callFind;

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
		handlerManager = [KNSHandlerManager new];
		__weak typeof(findName) bfindName = findName;
		[[NSNotificationCenter defaultCenter] addObserverForName:KonashiEventCentralManagerPowerOnNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
			if (_callFind) {
				_callFind = NO;
				if (bfindName) {
					KNS_LOG(@"Try findWithName");
					[Konashi findWithName:bfindName];
				}
				else {
					[Konashi find];
				}
			}
		}];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readyToUse:) name:KonashiEventReadyToUseNotification object:nil];
	}
	
	return self;
}

- (void)readyToUse:(NSNotification *)note
{
	KNSPeripheral *connectedPeripheral = [note userInfo][KonashiPeripheralKey];
	KNS_LOG(@"Peripheral(UUID : %@) is ready to use.", connectedPeripheral.peripheral.identifier.UUIDString);
	_activePeripheral = connectedPeripheral;
	_activePeripheral.handlerManager = handlerManager;
	// Enable PIO input notification
	[_activePeripheral enablePIOInputNotification];
	// Enable UART RX notification
	[_activePeripheral enableUART_RXNotification];
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

- (void)setConnectedHandler:(KonashiEventHandler)connectedHander
{
	handlerManager.connectedHandler = connectedHander;
}

- (void)setDisconnectedHandler:(KonashiEventHandler)disconnectedHandler
{
	handlerManager.disconnectedHandler = disconnectedHandler;
}

- (void)setReadyHandler:(KonashiEventHandler)readyHander
{
	handlerManager.readyHandler = readyHander;
}

- (void)setDigitalInputDidChangeValueHandler:(KonashiDigitalPinDidChangeValueHandler)digitalInputDidChangeValueHandler
{
	handlerManager.digitalInputDidChangeValueHandler = digitalInputDidChangeValueHandler;
}

- (void)setDigitalOutputDidChangeValueHandler:(KonashiDigitalPinDidChangeValueHandler)digitalOutputDidChangeValueHandler
{
	handlerManager.digitalOutputDidChangeValueHandler = digitalOutputDidChangeValueHandler;
}

- (void)setAnalogPinDidChangeValueHandler:(KonashiAnalogPinDidChangeValueHandler)analogPinDidChangeValueHandler
{
	handlerManager.analogPinDidChangeValueHandler = analogPinDidChangeValueHandler;
}

- (void)setUartRxCompleteHandler:(KonashiUartRxCompleteHandler)uartRxCompleteHandler
{
	handlerManager.uartRxCompleteHandler = uartRxCompleteHandler;
}

- (void)setI2cReadCompleteHandler:(KonashiI2CReadCompleteHandler)i2cReadCompleteHandler
{
	handlerManager.i2cReadCompleteHandler = i2cReadCompleteHandler;
}

- (void)setBatteryLevelDidUpdateHandler:(KonashiBatteryLevelDidUpdateHandler)batteryLevelDidUpdateHandler
{
	handlerManager.batteryLevelDidUpdateHandler = batteryLevelDidUpdateHandler;
}

- (void)setSignalStrengthDidUpdateHandler:(KonashiSignalStrengthDidUpdateHandler)signalStrengthDidUpdateHandler
{
	handlerManager.signalStrengthDidUpdateHandler = signalStrengthDidUpdateHandler;
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

#pragma mark - Hardware

+ (int) batteryLevelRead
{
	return [[Konashi shared].activePeripheral batteryLevelRead];
}

+ (int) signalStrengthRead
{
	return [[Konashi shared].activePeripheral signalStrengthRead];
}

#pragma mark - Notification

+ (void) addObserver:(id)notificationObserver selector:(SEL)notificationSelector name:(NSString*)notificationName
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:notificationObserver selector:notificationSelector name:notificationName object:nil];
}

+ (void) removeObserver:(id)notificationObserver
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:notificationObserver];
}

- (void) postNotification:(NSString*)notificationName
{
	NSNotification *n = [NSNotification notificationWithName:notificationName object:self];
	[[NSNotificationCenter defaultCenter] postNotification:n];
}

@end
