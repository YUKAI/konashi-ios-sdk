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
#import "Konashi+UI.h"
#import "CBUUID+Konashi.h"

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




#pragma mark -
#pragma mark - Konashi control public methods

+ (KonashiResult) initialize
{
    return [[Konashi shared] _initializeKonashi];
}

+ (KonashiResult) find
{
    return [[Konashi shared] _findModule:KonashiFindTimeoutInterval];
}

+ (KonashiResult) findWithName:(NSString*)name
{
    return [[Konashi shared] _findModuleWithName:name timeout:KonashiFindTimeoutInterval];
}

+ (NSString *)softwareRevisionString
{
	return [[Konashi shared].activePeripheral softwareRevisionString];
}

+ (KonashiResult) disconnect
{
    return [[Konashi shared] _disconnectModule];
}

+ (BOOL) isConnected
{
    return [[Konashi shared] _isConnected];
}

+ (BOOL) isReady
{
    return [[Konashi shared] _isReady];
}

+ (NSString *) peripheralName
{
    return [[Konashi shared] _peripheralName];
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

+ (KonashiResult) digitalWrite:(KonashiDigitalIOPin)pin value:(KonashiLevel)value
{
	return [[Konashi shared].activePeripheral digitalWrite:pin value:value];
}

+ (KonashiResult) digitalWriteAll:(int)value
{
	return [[Konashi shared].activePeripheral digitalWriteAll:value];
}

+ (KonashiResult) pinPullup:(KonashiDigitalIOPin)pin mode:(KonashiPinMode)mode
{
    return [[Konashi shared].activePeripheral pinPullup:pin mode:mode];
}

+ (KonashiResult) pinPullupAll:(int)mode
{
    return [[Konashi shared].activePeripheral pinPullupAll:mode];
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

- (instancetype)init
{
	self = [super init];
	if (self) {
		handlerManager = [KNSHandlerManager new];
	}
	
	return self;
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

#pragma mark -
#pragma mark - Konashi public event methods

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

#pragma mark -
#pragma mark - Konashi private event methods

- (void) postNotification:(NSString*)notificationName
{
    NSNotification *n = [NSNotification notificationWithName:notificationName object:self];
    [[NSNotificationCenter defaultCenter] postNotification:n];
}

#pragma mark -
#pragma mark - Konashi control private methods

- (KonashiResult) _initializeKonashi
{
    if(!cm){
        cm = [[CBCentralManager alloc] initWithDelegate:[Konashi shared] queue:nil];
        return KonashiResultSuccess;
    } else {
        return KonashiResultFailure;
    }
}

- (KonashiResult) _findModule:(int) timeout
{
    if(self.activePeripheral && self.activePeripheral.state == CBPeripheralStateConnected){
        return KonashiResultFailure;
    }
        
    if (cm.state  != CBCentralManagerStatePoweredOn) {
        KNS_LOG(@"CoreBluetooth not correctly initialized !");
        KNS_LOG(@"State = %ld (%@)", cm.state, NSStringFromCBCentralManagerState(cm.state));
		
        isCallFind = YES;
        
        return KonashiResultSuccess;
    }
    
    if(peripherals) peripherals = nil;
    
    [NSTimer scheduledTimerWithTimeInterval:(float)timeout target:self selector:@selector(finishScanModule:) userInfo:nil repeats:NO];
    
    [cm scanForPeripheralsWithServices:nil options:0];
    
    return KonashiResultSuccess;
}

- (KonashiResult) _findModuleWithName:(NSString*)name timeout:(int)timeout{
    if(self.activePeripheral && self.activePeripheral.state == CBPeripheralStateConnected){
        return KonashiResultFailure;
    }
        
    if (cm.state  != CBCentralManagerStatePoweredOn) {
        KNS_LOG(@"CoreBluetooth not correctly initialized !");
        KNS_LOG(@"State = %ld (%@)", cm.state, NSStringFromCBCentralManagerState(cm.state));
        
        isCallFind = YES;
        findName = name;
        
        return KonashiResultSuccess;
    }
    
    if(peripherals) peripherals = nil;
    
    [NSTimer scheduledTimerWithTimeInterval:(float)timeout target:self selector:@selector(finishScanModuleWithName:) userInfo:name repeats:NO];

        
    [cm scanForPeripheralsWithServices:nil options:0];
    
    return KonashiResultSuccess;
}

- (void) finishScanModuleWithName:(NSTimer *)timer
{
    [cm stopScan];
    NSString *targetname = [timer userInfo];
    KNS_LOG(@"Peripherals: %lu", (unsigned long)[peripherals count]);
    BOOL targetIsExist = NO;
    int indexOfTarget = 0;
    if ( [peripherals count] > 0 ) {
        for (int i = 0; i < [peripherals count]; i++) {
            if ([[[peripherals objectAtIndex:i] name] isEqualToString:targetname]) {
                targetIsExist = YES;
                indexOfTarget = i;
            }
        }
    }
    if (targetIsExist) {
        [self connectTargetPeripheral:indexOfTarget];
    } else {
        [[Konashi shared] postNotification:KonashiEventPeripheralNotFoundNotification];
    }
}

- (void) finishScanModule:(NSTimer *)timer
{
    [cm stopScan];
    
    KNS_LOG(@"Peripherals: %lu", (unsigned long)[peripherals count]);
    
    if ( [peripherals count] > 0 ) {
        [[Konashi shared] postNotification:KonashiEventPeripheralFoundNotification];
		[self showModulePicker];
    } else {
        [[Konashi shared] postNotification:KonashiEventNoPeripheralsAvailableNotification];
    }
}

- (void) connectPeripheral:(CBPeripheral *)peripheral
{
#ifdef KONASHI_DEBUG
    NSString* name = peripheral.name;
    KNS_LOG(@"Connecting %@(UUID: %@)", name, peripheral.identifier.UUIDString);
#endif
    
    [cm connectPeripheral:peripheral options:nil];
}

- (void) readyModule
{
    // set konashi property
    isReady = YES;
    
	[[NSNotificationCenter defaultCenter] postNotificationName:KonashiEventReadyToUseNotification object:nil];
	
    // Enable PIO input notification
	[_activePeripheral enablePIOInputNotification];
	
    // Enable UART RX notification
	[_activePeripheral enableUART_RXNotification];
}

- (KonashiResult) _disconnectModule
{
    if(self.activePeripheral && self.activePeripheral.state == CBPeripheralStateConnected){
        [cm cancelPeripheralConnection:self.activePeripheral.peripheral];
        return KonashiResultSuccess;
    }
    else{
        return KonashiResultFailure;
    }
}

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
        return self.activePeripheral.findName;
    } else {
        return @"";
    }
}

- (void)connectTargetPeripheral:(int)indexOfTarget
{
    KNS_LOG(@"Select %@", [[peripherals objectAtIndex:indexOfTarget] name]);
	
    [self connectPeripheral:[peripherals objectAtIndex:indexOfTarget]];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    KNS_LOG(@"Status of CoreBluetooth central manager changed %ld (%@)\r\n", central.state, NSStringFromCBCentralManagerState(cm.state));

    if (central.state == CBCentralManagerStatePoweredOn) {
        [[Konashi shared] postNotification:KonashiEventCentralManagerPowerOnNotification];
        
        // Check already find
        if(isCallFind){
            isCallFind = NO;

            if([findName length] > 0){
                KNS_LOG(@"Try findWithName");
                [Konashi findWithName:findName];
                findName = @"";
            } else {
                KNS_LOG(@"Try find");
                [Konashi find];
            }
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    KNS_LOG(@"didDiscoverPeripheral");

    if (!peripherals){
        peripherals = [NSMutableArray array];
    }
    
    /*for(int i = 0; i < peripherals.count; i++) {
        CBPeripheral *p = [peripherals objectAtIndex:i];
        
        if ([self UUIDSAreEqual:p.UUID u2:peripheral.UUID]) {
            [peripherals replaceObjectAtIndex:i withObject:peripheral];
            KNS_LOG(@"Duplicate UUID found updating ...");
            return;
        }
    }*/

    [peripherals addObject:peripheral];
    KNS_LOG(@"New UUID, adding:%@", peripheral.name);
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    KNS_LOG(@"Connect to peripheral with UUID : %@ successfull", peripheral.identifier.UUIDString);
	_activePeripheral = [[KNSPeripheral alloc] initWithPeripheral:peripheral];
	_activePeripheral.handlerManager = handlerManager;
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    KNS_LOG(@"Disconnect from the peripheral: %@, error: %@", [peripheral name], error);
	
	if (handlerManager.disconnectedHandler) {
		handlerManager.disconnectedHandler();
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:KonashiEventDisconnectedNotification object:nil];
}

#pragma mark - Deprecated

#pragma mark - digital

+ (KonashiLevel) digitalRead:(KonashiDigitalIOPin)pin
{
	return [[Konashi shared].activePeripheral digitalRead:pin];
}

+ (int) digitalReadAll
{
	return [[Konashi shared].activePeripheral digitalReadAll];
}

#pragma mark - analog

+ (int) analogRead:(KonashiAnalogIOPin)pin
{
	return [[Konashi shared].activePeripheral analogRead:pin];
}

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

@end
