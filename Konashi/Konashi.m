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
#include <objc/runtime.h>
#import "Konashi.h"
#import "KonashiDb.h"

@interface CBCentralManagerBlocks : NSObject <CBCentralManagerDelegate>

@property (nonatomic, copy) void (^didUpdateStateBlock)(CBCentralManager *central);
@property (nonatomic, copy) void (^willRestoreStateBlock)(CBCentralManager *central, NSDictionary *dict);
@property (nonatomic, copy) void (^didRetrievePeripheralsBlock)(CBCentralManager *central, NSArray *peripherals);
@property (nonatomic, copy) void (^didRetrieveConnectedPeripheralsBlock)(CBCentralManager *central, NSArray *peripherals);
@property (nonatomic, copy) void (^didFailToConnectPeripheralBlock)(CBCentralManager *central, CBPeripheral *peripheral, NSError *error);
@property (nonatomic, copy) void (^didDiscoverPeripheralBlock)(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI);
@property (nonatomic, copy) void (^didDisconnectPeripheralBlock)(CBCentralManager *central, CBPeripheral *peripheral, NSError *error);
@property (nonatomic, copy) void (^didConnectPeripheral)(CBCentralManager *central, CBPeripheral *peripheral);

@end

@interface CBCentralManager (Blocks)

@property (nonatomic, copy) CBCentralManagerBlocks *blocksDelegate;

- (instancetype)initBlcoksDelegateWithQueue:(dispatch_block_t)queue;

@end

@implementation CBCentralManagerBlocks

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
	if (self.didUpdateStateBlock) {
		self.didUpdateStateBlock(central);
	}
}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict
{
	if (self.willRestoreStateBlock) {
		self.willRestoreStateBlock(central, dict);
	}
}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
	if (self.didRetrievePeripheralsBlock) {
		self.didRetrievePeripheralsBlock(central, peripherals);
	}
}

- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
	if (self.didRetrieveConnectedPeripheralsBlock) {
		self.didRetrieveConnectedPeripheralsBlock(central, peripherals);
	}
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
	if (self.didFailToConnectPeripheralBlock) {
		self.didFailToConnectPeripheralBlock(central, peripheral, error);
	}
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
	if (self.didDiscoverPeripheralBlock) {
		self.didDiscoverPeripheralBlock(central, peripheral, advertisementData, RSSI);
	}
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
	if (self.didDisconnectPeripheralBlock) {
		self.didDisconnectPeripheralBlock(central, peripheral, error);
	}
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
	if (self.didConnectPeripheral) {
		self.didConnectPeripheral(central, peripheral);
	}
}

@end

@implementation CBCentralManager (Blocks)
@dynamic blocksDelegate;

static NSString *kCBCentralManagerBlocksKey = @"CBCentralManagerBlocksDelegate";

- (void)setBlocksDelegate:(CBCentralManagerBlocks *)blocksDelegate
{
	objc_setAssociatedObject(self, (__bridge const void *)(kCBCentralManagerBlocksKey), blocksDelegate, OBJC_ASSOCIATION_RETAIN);
}

- (CBCentralManagerBlocks *)blocksDelegate
{
	return (id)objc_getAssociatedObject(self, (__bridge const void *)(kCBCentralManagerBlocksKey));
}

- (instancetype)initBlcoksDelegateWithQueue:(dispatch_block_t)queue
{
	CBCentralManagerBlocks *blockDelegate = [[CBCentralManagerBlocks alloc] init];
	[self setBlocksDelegate:blockDelegate];
	self = [self initWithDelegate:self.blocksDelegate queue:queue];
	
	return self;
}

@end

@implementation Konashi

#pragma mark -
#pragma mark - Singleton

+ (Konashi *)sharedKonashi
{
    static Konashi *_konashi = nil;
    
    @synchronized (self){
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            _konashi = [[Konashi alloc] init];
			[_konashi _initialize];
        });
    }
    
    return _konashi;
}

#pragma mark -
#pragma mark - Konashi control public methods

static CBCentralManager *c;
static NSMutableSet *globalPeripherals;
+ (void)discover:(void (^)(NSArray *array, BOOL *stop))discoverBlocks timeoutBlock:(void (^)(NSArray *array))timeoutBlock timeoutInterval:(NSTimeInterval)timeoutInterval
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		globalPeripherals = [NSMutableSet new];
		c = [[CBCentralManager alloc] initBlcoksDelegateWithQueue:nil];
	});
	[globalPeripherals removeAllObjects];
	
	NSTimer *t = [NSTimer scheduledTimerWithTimeInterval:timeoutInterval target:[self class] selector:@selector(stopScan:) userInfo:@{@"callback":[timeoutBlock copy]} repeats:YES];
	[c.blocksDelegate setDidUpdateStateBlock:^(CBCentralManager *center) {
		if (center.state == CBCentralManagerStatePoweredOn) {
			[center scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(NO)}];
		}
	}];
	[c.blocksDelegate setDidDiscoverPeripheralBlock:^(CBCentralManager *center, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
		[globalPeripherals addObject:peripheral];
		BOOL stop = NO;
		discoverBlocks(globalPeripherals.allObjects, &stop);
		if (stop == YES) {
			[self stopScan:t];
		}
	}];
	
	if (c.state == CBCentralManagerStatePoweredOn) {
		[c scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(NO)}];
	}
}

+ (void)stopScan:(NSTimer *)timer
{
	[c stopScan];
	void (^timeoutBlock)(NSArray *array) = timer.userInfo[@"callback"];
	timeoutBlock(globalPeripherals.allObjects);
	[timer invalidate];
}

+ (Konashi *)createKonashiWithConnectedHandler:(KonashiEventHandler)connectedHandler disconnectedHandler:(KonashiEventHandler)disconnectedHander readyHandler:(KonashiEventHandler)readyHandler
{
	Konashi *konashi = [[Konashi alloc] init];
	konashi.connectedHander = connectedHandler;
	konashi.disconnectedHander = disconnectedHander;
	konashi.readyHander = readyHandler;
	[konashi _initialize];
	
	return konashi;
}

- (KonashiResult)connect
{
    return [self findModule:KonashiFindTimeoutInterval];
}

- (KonashiResult)disconnect
{
	KonashiResult result = KonashiResultFailed;
	if (activePeripheral && activePeripheral.isConnected) {
        [cm cancelPeripheralConnection:activePeripheral];
        result = KonashiResultSuccess;
    }
    
	return result;
}

- (BOOL)isConnected
{
    return (activePeripheral && activePeripheral.isConnected);
}

- (BOOL)isReadyToUse
{
    return readyToUse;
}

- (NSString *)peripheralName
{
	NSString *name = @"";
	if (activePeripheral && activePeripheral.isConnected) {
        name = activePeripheral.name;
    }
	
	return name;
}

#pragma mark -
#pragma mark - Konashi PIO public methods

- (KonashiResult)pinMode:(KonashiDigitalIOPin)pin mode:(KonashiPinMode)mode
{
	KonashiResult result = KonashiResultFailed;
	if (pin >= KonashiDigitalIO0 && pin <= KonashiDigitalIO7 && (mode == KonashiPinModeOutput || mode == KonashiPinModeInput)) {
        // Set value
        if (mode == KonashiPinModeOutput) {
            pioSetting |= 0x01 << pin;
        }
        else {
            pioSetting &= ~(0x01 << pin) & 0xFF;
        }
        
        // Write value
        result = [self _writeValuePioSetting];
    }
	
	return result;
}

- (KonashiResult)pinModeAll:(unsigned char)mode
{
	KonashiResult result = KonashiResultFailed;
	if (mode >= 0x00 && mode <= 0xFF) {
        // Set value
        pioSetting = mode;
        
        // Write value
        result = [self _writeValuePioSetting];
    }
	
    return result;
}

- (KonashiResult)pinPullup:(KonashiDigitalIOPin)pin mode:(KonashiPinMode)mode
{
	KonashiResult result = KonashiResultFailed;
	if (pin >= KonashiDigitalIO0 && pin <= KonashiDigitalIO7 && (mode == KonashiPinModePullup || mode == KonashiPinModeNoPulls)) {
        // Set value
        if (mode == KonashiPinModePullup) {
            pioPullup |= 0x01 << pin;
        }
		else {
            pioPullup &= ~(0x01 << pin) & 0xFF;
        }
        
        // Write value
        result = [self _writeValuePioPullup];
    }
	
	return result;
}

- (KonashiResult)pinPullupAll:(unsigned char)mode
{
	KonashiResult result = KonashiResultFailed;
	if (mode >= 0x00 && mode <= 0xFF) {
        // Set value
        pioPullup = mode;
        
        // Write value
        result = [self _writeValuePioPullup];
    }
	
    return result;
}

- (KonashiResult)digitalRead:(KonashiDigitalIOPin)pin
{
	KonashiResult result = KonashiResultFailed;
	if (pin >= KonashiDigitalIO0 && pin <= KonashiDigitalIO7) {
        result = (pioInput >> pin) & 0x01;
    }
	
    return result;
}

- (unsigned char)digitalReadAll
{
	return pioInput;
}

- (KonashiResult)digitalWrite:(KonashiDigitalIOPin)pin value:(KonashiLevel)value
{
	KonashiResult result = KonashiResultFailed;
	if (pin >= KonashiDigitalIO0 && pin <= KonashiDigitalIO7 && (value == KonashiLevelHigh || value == KonashiLevelLow)) {
        // Set value
        if (value == KonashiLevelHigh) {
            pioOutput |= 0x01 << pin;
        }
        else {
            pioOutput &= ~(0x01 << pin) & 0xFF;
        }
		if (self.digitalOutputDidChangeValueHandler) {
			self.digitalOutputDidChangeValueHandler(self, pin, value);
		}
        
        // Write value
        result = [self _writeValuePioOutput];
    }
	
    return result;
}

- (KonashiResult)digitalWriteAll:(unsigned char)value
{
	KonashiResult result = KonashiResultFailed;
	if (value >= 0x00 && value <= 0xFF) {
        // Set value
        pioOutput = value;
        
        // Write value
        result = [self _writeValuePioOutput];
    }
    
    return result;
}

#pragma mark -
#pragma mark - Konashi PWM public methods

- (KonashiResult)setPWMMode:(KonashiDigitalIOPin)pin mode:(KonashiPWMMode)mode
{
	KonashiResult result = KonashiResultFailed;
	if (pin >= KonashiDigitalIO0 && pin <= KonashiDigitalIO7 && (mode == KonashiPWMModeDisable || mode == KonashiPWMModeEnable || mode == KonashiPWMModeEnableLED )) {
        // Set value
        if (mode == KonashiPWMModeEnable || mode == KonashiPWMModeEnableLED) {
            pwmSetting |= 0x01 << pin;
        }
        else {
            pwmSetting &= ~(0x01 << pin) & 0xFF;
        }
        
        if (mode == KonashiPWMModeEnableLED) {
            [self setPWMPeriod:pin period:KonashiLEDPeriod];
            [self pwmLedDrive:pin dutyRatio:0.0];
        }
        
        // Write value
        result = [self _writeValuePwmSetting];
    }
	
    return result;
}

- (KonashiResult)setPWMPeriod:(KonashiDigitalIOPin)pin period:(unsigned int)period
{
	KonashiResult result = KonashiResultFailed;
	if (pin >= KonashiDigitalIO0 && pin <= KonashiDigitalIO7 && pwmDuty[pin] <= period) {
        pwmPeriod[pin] = period;
        result = [self _writeValuePwmPeriod:pin];
    }
	
    return result;
}

- (KonashiResult)setPWMDuty:(KonashiDigitalIOPin)pin duty:(unsigned int)duty
{
	KonashiResult result = KonashiResultFailed;
	if (pin >= KonashiDigitalIO0 && pin <= KonashiDigitalIO7 && duty <= pwmPeriod[pin]) {
        pwmDuty[pin] = duty;
        result = [self _writeValuePwmDuty:pin];
    }
	
    return result;
}

- (int)pwmLedDrive:(KonashiDigitalIOPin)pin dutyRatio:(int)ratio
{
	int duty;
    
    if (ratio < 0.0) {
        ratio = 0.0;
    }
    if (ratio > 100.0) {
        ratio = 100.0;
    }
    
    duty = (int)(KonashiLEDPeriod * ratio / 100);
    
    return [self setPWMDuty:pin duty:duty];
}

#pragma mark -
#pragma mark - Konashi analog IO public methods

- (int)analogReference
{
    return KonashiAnalogReference;
}

- (KonashiResult)analogReadRequest:(KonashiAnalogIOPin)pin
{
	KonashiResult result = KonashiResultFailed;
	if (pin >= KonashiAnalogIO0 && pin <= KonashiAnalogIO2) {
        result = [self _readValueAio:pin];
    }
	
    return result;
}

- (KonashiResult)analogRead:(KonashiAnalogIOPin)pin
{
	KonashiResult result = KonashiResultFailed;
	if (pin >= KonashiAnalogIO0 && pin <= KonashiAnalogIO2) {
        result = analogValue[pin];
    }
	
    return result;
}

- (KonashiResult)analogWrite:(KonashiAnalogIOPin)pin milliVolt:(int)milliVolt
{
	KonashiResult result = KonashiResultFailed;
	if (pin >= KonashiAnalogIO0 && pin <= KonashiAnalogIO2 && milliVolt >= 0 && milliVolt <= KonashiAnalogReference &&
		activePeripheral && activePeripheral.isConnected) {
        Byte t[] = {pin, (milliVolt>>8)&0xFF, milliVolt&0xFF};
        NSData *d = [[NSData alloc] initWithBytes:t length:3];
        [self writeValue:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_ANALOG_DRIVE_UUID p:activePeripheral data:d];
        
        result = KonashiResultSuccess;
    }
    
    return result;
}

#pragma mark -
#pragma mark - Konashi I2C public methods

- (KonashiResult)setI2CMode:(KonashiI2CMode)mode
{
	KonashiResult result = KonashiResultFailed;
	if ((mode == KonashiI2CModeDisable || mode == KonashiI2CModeEnable ||
		 mode == KonashiI2CModeEnable100K || mode == KonashiI2CModeEnable400K) &&
		activePeripheral && activePeripheral.isConnected) {
        i2cSetting = mode;
        
        Byte t = mode;
        NSData *d = [[NSData alloc] initWithBytes:&t length:1];
        [self writeValue:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_I2C_CONFIG_UUID p:activePeripheral data:d];
        
        result = KonashiResultSuccess;
    }
	
    return result;
}

- (KonashiResult)i2cStartCondition
{
    return [self i2cSendCondition:KonashiI2CConditionStart];
}

- (KonashiResult)i2cRestartCondition
{
    return [self i2cSendCondition:KonashiI2CConditionRestart];
}

- (KonashiResult)i2cStopCondition
{
    return [self i2cSendCondition:KonashiI2CConditionStop];
}

- (KonashiResult)i2cWrite:(int)length data:(unsigned char*)data address:(unsigned char)address
{
	int i;
    unsigned char t[KonashiI2CDataMaxLength];
    KonashiResult result = KonashiResultFailed;
    if (length > 0 && (i2cSetting == KonashiI2CModeEnable || i2cSetting == KonashiI2CModeEnable100K || i2cSetting == KonashiI2CModeEnable400K) &&
		activePeripheral && activePeripheral.isConnected) {
        t[0] = length + 1;
        t[1] = (address << 1) & 0b11111110;
        for (i = 0; i < length; i++) {
            t[i+2] = data[i];
        }
        
        NSData *d = [[NSData alloc] initWithBytes:t length:length+2];
        
        [self writeValue:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_I2C_WRITE_UUID p:activePeripheral data:d];
        
        result = KonashiResultSuccess;
    }
	
    return result;
}

- (KonashiResult)i2cReadRequest:(int)length address:(unsigned char)address
{
	KonashiResult result = KonashiResultFailed;
	if (length > 0 && (i2cSetting == KonashiI2CModeEnable || i2cSetting == KonashiI2CModeEnable100K || i2cSetting == KonashiI2CModeEnable400K) &&
		activePeripheral && activePeripheral.isConnected) {
        
        // set variables
        i2cReadAddress = (address<<1)|0x1;
        i2cReadDataLength = length;
        
        // Set read params
        Byte t[] = {length, i2cReadAddress};
        NSData *d = [[NSData alloc] initWithBytes:t length:2];
        [self writeValue:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_I2C_READ_PARAM_UIUD p:activePeripheral data:d];
        
        // Request read i2c value
        [self readValue:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_I2C_READ_UUID p:activePeripheral];
        
        result = KonashiResultSuccess;
    }
	
    return result;
}

- (KonashiResult)i2cRead:(int)length data:(unsigned char*)data
{
	int i;
	KonashiResult result = KonashiResultFailed;
	if (length==i2cReadDataLength) {
		for (i = 0; i < i2cReadDataLength; i++) {
			data[i] = i2cReadData[i];
		}
		result = KonashiResultSuccess;
	}
	
	return result;
}

#pragma mark -
#pragma mark - Konashi UART public methods

- (KonashiResult)setUartMode:(KonashiUartMode)mode
{
	KonashiResult result = KonashiResultFailed;
	if (activePeripheral && activePeripheral.isConnected &&
		(mode == KonashiUartModeDisable || mode == KonashiUartModeEnable )) {
        Byte t = mode;
        NSData *d = [[NSData alloc] initWithBytes:&t length:1];
        [self writeValue:KONASHI_SERVICE_UUID
      characteristicUUID:KONASHI_UART_CONFIG_UUID
                       p:activePeripheral
                    data:d];
        
        uartSetting = mode;
        
        result = KonashiResultSuccess;
    }
	
    return result;
}

- (KonashiResult)setUartBaudrate:(KonashiUartRate)baudrate
{
	KonashiResult result = KonashiResultFailed;
	if (activePeripheral && activePeripheral.isConnected && uartSetting == KonashiUartModeDisable) {
        if(baudrate == KonashiUartRate2K4 ||
           baudrate == KonashiUartRate9K6
		   ) {
            Byte t[] = {(baudrate>>8)&0xff, baudrate&0xff};
            NSData *d = [[NSData alloc] initWithBytes:t length:2];
            [self writeValue:KONASHI_SERVICE_UUID
          characteristicUUID:KONASHI_UART_BAUDRATE_UUID
                           p:activePeripheral
                        data:d];
            
            uartBaudrate = baudrate;
            
            result = KonashiResultSuccess;
        }
    }
	
    return result;
}

- (KonashiResult)uartWrite:(unsigned char)data
{
	KonashiResult result = KonashiResultFailed;
	if (activePeripheral && activePeripheral.isConnected && uartSetting == KonashiUartModeEnable) {
        NSData *d = [[NSData alloc] initWithBytes:&data length:1];
        [self writeValue:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_UART_TX_UUID p:activePeripheral data:d];
        
        result = KonashiResultSuccess;
    }
    
    return result;
}

- (unsigned char)uartRead
{
    return uartRxData;
}

#pragma mark -
#pragma mark - Konashi hardware public methods

- (KonashiResult)reset
{
	KonashiResult result = KonashiResultFailed;
	if (activePeripheral && activePeripheral.isConnected) {
        Byte t = 1;
        NSData *d = [[NSData alloc] initWithBytes:&t length:1];
        [self writeValue:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_HARDWARE_RESET_UUID p:activePeripheral data:d];
        
        result = KonashiResultSuccess;
    }
	
    return result;
}

- (KonashiResult)batteryLevelReadRequest
{
	KonashiResult result = KonashiResultFailed;
	if (activePeripheral && activePeripheral.isConnected) {
        [self readValue:KONASHI_BATT_SERVICE_UUID characteristicUUID:KONASHI_LEVEL_SERVICE_UUID p:activePeripheral];
        
        result = KonashiResultSuccess;
    }
	
    return result;
}

- (int)batteryLevelRead
{
    return batteryLevel;
}

- (KonashiResult)signalStrengthReadRequest
{
	KonashiResult result = KonashiResultFailed;
	
	if (activePeripheral && activePeripheral.isConnected) {
        [activePeripheral readRSSI];
        result = KonashiResultSuccess;
    }
	
    return result;
}

- (int)signalStrengthRead
{
    return rssi;
}

#pragma mark -
#pragma mark - Konashi public event methods

- (void)addObserver:(id)notificationObserver selector:(SEL)notificationSelector name:(NSString*)notificationName
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:notificationObserver selector:notificationSelector name:notificationName object:nil];
}

- (void)removeObserver:(id)notificationObserver
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:notificationObserver];
}

#pragma mark -
#pragma mark - Konashi private event methods

- (void)postNotification:(NSString*)notificationName
{
    NSNotification *n = [NSNotification notificationWithName:notificationName object:self];
    [[NSNotificationCenter defaultCenter] postNotification:n];
}

#pragma mark -
#pragma mark - Konashi control private methods

- (KonashiResult)_initialize
{
    if (!cm){
        cm = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        [self _initializeVariables];
        return KonashiResultSuccess;
    }
	else {
        return KonashiResultFailed;
    }
}

- (void)_initializeVariables
{
    int i;
    
    // Digital PIO
    pioSetting = 0;
    pioPullup = 0;
    pioInput = 0;
    pioOutput = 0;
    
    // PWM
    pwmSetting = 0;
    for(i = 0; i < 8; i++){
        pwmPeriod[i] = 0;
        pwmDuty[i] = 0;
    }
    
    // Analog IO
    for(i = 0; i < 3; i++){
        analogValue[i] = 0;
    }
    
    // I2C
    i2cSetting = KonashiI2CModeDisable;
    for(i = 0; i < KonashiI2CDataMaxLength; i++){
        i2cReadData[i] = 0;
    }
    i2cReadDataLength = 0;
    i2cReadAddress = 0;
    
    // UART
    uartSetting = KonashiUartModeDisable;
    uartBaudrate = KonashiUartRate9K6;
    
    // RSSI
    rssi = 0;
    
    // others
    readyToUse = NO;
    findMethodCalled = NO;
    findName = @"";
}

- (KonashiResult)findModule:(NSTimeInterval)timeout
{
	if (activePeripheral && activePeripheral.isConnected) {
        return KonashiResultFailed;
    }
	
    if (cm.state != CBCentralManagerStatePoweredOn) {
        KNS_LOG(@"CoreBluetooth not correctly initialized !");
        KNS_LOG(@"State = %ld (%@)", (long)cm.state, [self centralManagerStateToString:cm.state]);
        
        findMethodCalled = YES;
        
        return KonashiResultSuccess;
    }
    
    if (peripherals) {
		peripherals = nil;
	}
    
    [NSTimer scheduledTimerWithTimeInterval:(float)timeout target:self selector:@selector(finishScanModule:) userInfo:nil repeats:NO];
    
    [cm scanForPeripheralsWithServices:nil options:0];
    
    return KonashiResultSuccess;
}

- (KonashiResult)connectWithName:(NSString*)name
{
	return [self connectWithName:name timeout:KonashiFindTimeoutInterval];
}

- (KonashiResult)connectWithName:(NSString*)name timeout:(NSTimeInterval)timeout{
    if (activePeripheral && activePeripheral.isConnected) {
        return KonashiResultFailed;
    }
        
    if (cm.state  != CBCentralManagerStatePoweredOn) {
        KNS_LOG(@"CoreBluetooth not correctly initialized !");
        KNS_LOG(@"State = %ld (%@)", (long)cm.state, [self centralManagerStateToString:cm.state]);
        
        findMethodCalled = YES;
        findName = name;
        
        return KonashiResultSuccess;
    }
    
    if (peripherals) {
		peripherals = nil;
	}
    
    [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(finishScanModuleWithName:) userInfo:name repeats:NO];

    [cm scanForPeripheralsWithServices:nil options:0];
    
    return KonashiResultSuccess;
}

- (void)finishScanModuleWithName:(NSTimer *)timer
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
        [self postNotification:KONASHI_EVENT_PERIPHERAL_NOT_FOUND];
    }
}

- (void)finishScanModule:(NSTimer *)timer
{
    [cm stopScan];
    
    KNS_LOG(@"Peripherals: %lu", (unsigned long)[peripherals count]);
    
    if ([peripherals count] > 0) {
        [self postNotification:KONASHI_EVENT_PERIPHERAL_FOUND];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
            [self showModulePickeriPad];    //iPad
        }
		else {
            [self showModulePicker];        //else
        }
    }
	else {
        [self postNotification:KONASHI_EVENT_NO_PERIPHERALS_AVAILABLE];
    }
}

- (void)connectPeripheral:(CBPeripheral *)peripheral
{
#ifdef KONASHI_DEBUG
    NSString* name = peripheral.name;
    KNS_LOG(@"Connecting %@(UUID: %@)", name, [self UUIDToString:peripheral.UUID]);
#endif
    
    activePeripheral = peripheral;
    activePeripheral.delegate = self;
    [cm connectPeripheral:activePeripheral options:nil];
}

- (void)readyModule
{
    CBPeripheral *p = activePeripheral;
    
    // set konashi property
    readyToUse = YES;
    
	if (self.readyHander) {
		self.readyHander(self);
	}
	else {
		[self postNotification:KONASHI_EVENT_READY];
	}
    
    // Enable PIO input notification
    [self notification:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_PIO_INPUT_NOTIFICATION_UUID p:p on:YES];
    
    // Enable UART RX notification
    [self notification:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_UART_RX_NOTIFICATION_UUID p:p on:YES];
}

#pragma mark -
#pragma mark - Konashi PIO private methods

- (KonashiResult)_pinMode:(int)pin mode:(int)mode
{
    if (pin >= KonashiDigitalIO0 && pin <= KonashiDigitalIO7 && (mode == KonashiPinModeOutput || mode == KonashiPinModeInput)) {
        // Set value
        if (mode == KonashiPinModeOutput){
            pioSetting |= 0x01 << pin;
        }
        else {
            pioSetting &= ~(0x01 << pin) & 0xFF;
        }
        
        // Write value
        return [self _writeValuePioSetting];
    }
    else {
        return KonashiResultFailed;
    }
}

- (KonashiResult)_pinModeAll:(int)mode
{
    if (mode >= 0x00 && mode <= 0xFF){
        // Set value
        pioSetting = mode;
        
        // Write value
        return [self _writeValuePioSetting];
    }
    else {
        return KonashiResultFailed;
    }
}

- (KonashiResult)_writeValuePioSetting
{
    if (activePeripheral && activePeripheral.isConnected) {
        KNS_LOG(@"PioSetting: %d", pioSetting);
        
        Byte t = (Byte)pioSetting;
        NSData *d = [[NSData alloc] initWithBytes:&t length:1];
        [self writeValue:KONASHI_SERVICE_UUID
      characteristicUUID:KONASHI_PIO_SETTING_UUID
                       p:activePeripheral
                    data:d];
                
        return KonashiResultSuccess;
    }
	else {
        return KonashiResultFailed;
    }
}

- (KonashiResult)_writeValuePioPullup
{
    if (activePeripheral && activePeripheral.isConnected) {
        KNS_LOG(@"PioPullup: %d", pioPullup);

        Byte t = (Byte)pioPullup;
        NSData *d = [[NSData alloc] initWithBytes:&t length:1];
        [self writeValue:KONASHI_SERVICE_UUID
      characteristicUUID:KONASHI_PIO_PULLUP_UUID
                       p:activePeripheral
                    data:d];
                
        return KonashiResultSuccess;
    }
	else {
        return KonashiResultFailed;
    }
}

- (KonashiResult)_writeValuePioOutput
{
    if (activePeripheral && activePeripheral.isConnected) {
        KNS_LOG(@"PioOutput: %d", pioOutput);
        
        Byte t = (Byte)pioOutput;
        NSData *d = [[NSData alloc] initWithBytes:&t length:1];
        [self writeValue:KONASHI_SERVICE_UUID
      characteristicUUID:KONASHI_PIO_OUTPUT_UUID
                       p:activePeripheral
                    data:d];
                
        return KonashiResultSuccess;
    }
	else {
        return KonashiResultFailed;
    }
}

#pragma mark -
#pragma mark - Konashi PWM private methods

- (KonashiResult)_writeValuePwmSetting
{
    if (activePeripheral && activePeripheral.isConnected) {
        KNS_LOG(@"PwmSetting: %d", pwmSetting);
        
        Byte t = (Byte)pwmSetting;
        NSData *d = [[NSData alloc] initWithBytes:&t length:1];
        [self writeValue:KONASHI_SERVICE_UUID
      characteristicUUID:KONASHI_PWM_CONFIG_UUID
                       p:activePeripheral
                    data:d];
                
        return KonashiResultSuccess;
    }
	else {
        return KonashiResultFailed;
    }
}

- (KonashiResult)_writeValuePwmPeriod:(int)pin
{
    if (activePeripheral && activePeripheral.isConnected) {
        Byte t[] = {pin,
                    (unsigned char)((pwmPeriod[pin] >> 24) & 0xFF),
                    (unsigned char)((pwmPeriod[pin] >> 16) & 0xFF),
                    (unsigned char)((pwmPeriod[pin] >> 8) & 0xFF),
                    (unsigned char)((pwmPeriod[pin] >> 0) & 0xFF)};
        
        NSData *d = [[NSData alloc] initWithBytes:t length:5];
        [self writeValue:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_PWM_PARAM_UUID p:activePeripheral data:d];
        
        KNS_LOG(@"PwmPeriod: %d", pwmPeriod[pin]);

        return KonashiResultSuccess;
    }
    else {
        return KonashiResultFailed;
    }
}

- (KonashiResult)_writeValuePwmDuty:(int)pin
{
    if (activePeripheral && activePeripheral.isConnected) {
        Byte t[] = {pin,
            (unsigned char)((pwmDuty[pin] >> 24) & 0xFF),
            (unsigned char)((pwmDuty[pin] >> 16) & 0xFF),
            (unsigned char)((pwmDuty[pin] >> 8) & 0xFF),
            (unsigned char)((pwmDuty[pin] >> 0) & 0xFF)};

        NSData *d = [[NSData alloc] initWithBytes:t length:5];
        [self writeValue:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_PWM_DUTY_UUID p:activePeripheral data:d];
        
        KNS_LOG(@"pwmDuty: %d", pwmDuty[pin]);

        return KonashiResultSuccess;
    }
    else {
        return KonashiResultFailed;
    }
}

#pragma mark -
#pragma mark - Konashi analog IO private methods

- (KonashiResult)_readValueAio:(KonashiAnalogIOPin)pin
{
	KonashiResult result = KonashiResultFailed;
    if (activePeripheral && activePeripheral.isConnected) {
		int uuid;
        if (pin == KonashiAnalogIO0) {
            uuid = KONASHI_ANALOG_READ0_UUID;
        }
        else if (pin == KonashiAnalogIO1) {
            uuid = KONASHI_ANALOG_READ1_UUID;
        }
        else {   // AIO2
            uuid = KONASHI_ANALOG_READ2_UUID;
        }
        
        [self readValue:KONASHI_SERVICE_UUID characteristicUUID:uuid p:activePeripheral];
        
        result = KonashiResultSuccess;
    }
	
	return result;
}

#pragma mark -
#pragma mark - Konashi I2C private methods

- (KonashiResult)i2cSendCondition:(int)condition
{
    if ((condition == KonashiI2CConditionStart || condition == KonashiI2CConditionRestart ||
       condition == KonashiI2CConditionStop) && activePeripheral && activePeripheral.isConnected) {
        Byte t = condition;
        NSData *d = [[NSData alloc] initWithBytes:&t length:1];
        [self writeValue:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_I2C_START_STOP_UUID p:activePeripheral data:d];
        
        return KonashiResultSuccess;
    }
    else {
        return KonashiResultFailed;
    }
}

#pragma mark -
#pragma mark - Konashi module picker methods

- (void)showModulePicker
{
    UIView *rootView = [[[UIApplication sharedApplication] keyWindow] rootViewController].view;
    
    pickerViewPopup = [[UIActionSheet alloc] initWithTitle:@"Select Module"
                                                  delegate:self
                                         cancelButtonTitle:nil
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:nil];
    
    // Add the picker
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	toolBar.barStyle = UIBarStyleBlackOpaque;
	[toolBar sizeToFit];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    label.text = @"Select";
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:24];
    [label sizeToFit];
    UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithCustomView:label];
    
	UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pushPickerCancel)];
	UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pushPickerDone)];
	
    NSArray *items = [NSArray arrayWithObjects:cancel, spacer, title, spacer, done, nil];
	[toolBar setItems:items animated:YES];
    
    [pickerViewPopup addSubview:toolBar];
    [pickerViewPopup addSubview:picker];
    [pickerViewPopup showInView:rootView];
    
    [pickerViewPopup setBounds:CGRectMake(0, 0, 320, 464)];
}

- (void)showModulePickeriPad
{
    UIView *rootView = [[[UIApplication sharedApplication] keyWindow] rootViewController].view;
    
    // Add the picker
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	toolBar.barStyle = UIBarStyleBlackOpaque;
	[toolBar sizeToFit];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    label.text = @"Select";
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:18];
    [label sizeToFit];
    UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithCustomView:label];
    
	UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pushPickerCancel_pad)];
	UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    spacer.width=60;
	UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pushPickerDone_pad)];
	
    NSArray *items = [NSArray arrayWithObjects:cancel, spacer, title, spacer, done, nil];
	[toolBar setItems:items animated:YES];
    [toolBar sizeToFit];
    
    UIViewController *pickerViewController;
    pickerViewController=[[UIViewController alloc] init];
    [pickerViewController.view addSubview:toolBar];
    [pickerViewController.view addSubview:picker.viewForBaselineLayout];
    
    pickerViewPopup_pad = [[UIPopoverController alloc] initWithContentViewController: pickerViewController];
    
    [pickerViewPopup_pad presentPopoverFromRect:CGRectMake(0, 0, 10, 10) inView:rootView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [peripherals count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *module[64];
    
    for (int i = 0; i < peripherals.count; i++) {
        CBPeripheral *p = [peripherals objectAtIndex:i];
        module[i] = p.name;
    }
    
    return module[row];
}

- (void)pushPickerCancel
{
    [pickerViewPopup dismissWithClickedButtonIndex:0 animated:YES];
    [self postNotification:KONASHI_EVENT_PERIPHERAL_SELECTOR_DISMISSED];
}

- (void)pushPickerDone
{
    [pickerViewPopup dismissWithClickedButtonIndex:0 animated:YES];
    
    NSInteger selectedIndex = [picker selectedRowInComponent:0];
    
    KNS_LOG(@"Select %@", [[peripherals objectAtIndex:selectedIndex] name]);
    
    [self connectPeripheral:[peripherals objectAtIndex:selectedIndex]];
}

- (void)pushPickerCancel_pad
{
    [pickerViewPopup_pad dismissPopoverAnimated:YES];
    [self postNotification:KONASHI_EVENT_PERIPHERAL_SELECTOR_DISMISSED];
}

- (void)pushPickerDone_pad
{
    [pickerViewPopup_pad dismissPopoverAnimated:YES];
    
    NSInteger selectedIndex = [picker selectedRowInComponent:0];
    
    KNS_LOG(@"Select %@", [[peripherals objectAtIndex:selectedIndex] name]);
    
    [self connectPeripheral:[peripherals objectAtIndex:selectedIndex]];
}

- (void)connectTargetPeripheral:(int)indexOfTarget
{
    KNS_LOG(@"Select %@", [[peripherals objectAtIndex:indexOfTarget] name]);
    
    [self connectPeripheral:[peripherals objectAtIndex:indexOfTarget]];
}

#pragma mark -
#pragma mark - Konashi BLE methods

- (NSString *)centralManagerStateToString: (int)state
{
    switch(state) {
        case CBCentralManagerStateUnknown:
            return @"State unknown (CBCentralManagerStateUnknown)";
        case CBCentralManagerStateResetting:
            return @"State resetting (CBCentralManagerStateUnknown)";
        case CBCentralManagerStateUnsupported:
            return @"State BLE unsupported (CBCentralManagerStateResetting)";
        case CBCentralManagerStateUnauthorized:
            return @"State unauthorized (CBCentralManagerStateUnauthorized)";
        case CBCentralManagerStatePoweredOff:
            return @"State BLE powered off (CBCentralManagerStatePoweredOff)";
        case CBCentralManagerStatePoweredOn:
            return @"State powered up and ready (CBCentralManagerStatePoweredOn)";
        default:
            return @"State unknown";
    }
    
    return @"Unknown state";
}

- (void)writeValue:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data
{
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:p];
    if (!service) {
        KNS_LOG(@"Could not find service with UUID %@ on peripheral with UUID %@", [self CBUUIDToString:su], [self UUIDToString:p.UUID]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        KNS_LOG(@"Could not find characteristic with UUID %@ on service with UUID %@ on peripheral with UUID %@", [self CBUUIDToString:cu], [self CBUUIDToString:su], [self UUIDToString:p.UUID]);
        return;
    }
    [p writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
    [NSThread sleepForTimeInterval:0.03];
}

- (void)readValue:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p
{
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:p];
    if (!service) {
        KNS_LOG(@"Could not find service with UUID %@ on peripheral with UUID %@\r\n", [self CBUUIDToString:su], [self UUIDToString:p.UUID]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        KNS_LOG(@"Could not find characteristic with UUID %@ on service with UUID %@ on peripheral with UUID %@", [self CBUUIDToString:cu], [self CBUUIDToString:su], [self UUIDToString:p.UUID]);
        return;
    }
    [p readValueForCharacteristic:characteristic];
}

- (void)notification:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p on:(BOOL)on
{
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:p];
        
    if (!service) {
        KNS_LOG(@"Could not find service with UUID %@ on peripheral with UUID %@", [self CBUUIDToString:su], [self UUIDToString:p.UUID]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        KNS_LOG(@"Could not find characteristic with UUID %@ on service with UUID %@ on peripheral with UUID %@", [self CBUUIDToString:cu], [self CBUUIDToString:su], [self UUIDToString:p.UUID]);
        return;
    }
    [p setNotifyValue:on forCharacteristic:characteristic];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    KNS_LOG(@"Status of CoreBluetooth central manager changed %ld (%@)\r\n", central.state, [self centralManagerStateToString:central.state]);

    if (central.state == CBCentralManagerStatePoweredOn) {
		if (self.centralManagerPoweredOnHandler) {
			self.centralManagerPoweredOnHandler(self);
		}
		else {
			[self postNotification:KONASHI_EVENT_CENTRAL_MANAGER_POWERED_ON];
		}
        
        // Check already find
        if (findMethodCalled) {
            findMethodCalled = NO;

            if ([findName length] > 0) {
                KNS_LOG(@"Try findWithName");
                [self connectWithName:findName];
                findName = @"";
            }
			else {
                KNS_LOG(@"Try find");
                [self connect];
            }
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    KNS_LOG(@"didDiscoverPeripheral");

    if (!peripherals) {
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

    [self->peripherals addObject:peripheral];    
    KNS_LOG(@"New UUID, adding:%@", peripheral.name);
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    KNS_LOG(@"Connect to peripheral with UUID : %@ successfull", [self UUIDToString:peripheral.UUID]);
    
    activePeripheral = peripheral;
    
	if (self.connectedHander) {
		self.connectedHander(self);
	}
	else {
		[self postNotification:KONASHI_EVENT_CONNECTED];
	}

    [activePeripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    KNS_LOG(@"Disconnect from the peripheral: %@", [peripheral name]);
	
	if (self.disconnectedHander) {
		self.disconnectedHander(self);
	}
	else {
		[self postNotification:KONASHI_EVENT_DISCONNECTED];
	}
	
	[self _initializeVariables];
}

- (int)UUIDSAreEqual:(CFUUIDRef)u1 u2:(CFUUIDRef)u2
{
    CFUUIDBytes b1 = CFUUIDGetUUIDBytes(u1);
    CFUUIDBytes b2 = CFUUIDGetUUIDBytes(u2);
    if (memcmp(&b1, &b2, 16) == 0) {
        return 1;
    }
    else return 0;
}

- (void)getAllServicesFromMoudle:(CBPeripheral *)p
{
    [p discoverServices:nil]; // Discover all services without filter
}

- (void)getAllCharacteristicsFromMoudle:(CBPeripheral *)p
{
    for (int i = 0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        KNS_LOG(@"Fetching characteristics for service with UUID : %@", [self CBUUIDToString:s.UUID]);
        [p discoverCharacteristics:nil forService:s];
    }
}

- (NSString *)CBUUIDToString:(CBUUID *) UUID
{
    return [UUID.data description];
}

- (NSString *)UUIDToString:(CFUUIDRef)UUID
{
    if (!UUID) return @"NULL";
    CFStringRef s = CFUUIDCreateString(NULL, UUID);
    return (__bridge NSString *)s;
}

- (int)compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2
{
    char b1[16];
    char b2[16];
    [UUID1.data getBytes:b1];
    [UUID2.data getBytes:b2];
    if (memcmp(b1, b2, UUID1.data.length) == 0)return 1;
    else return 0;
}

- (int)compareCBUUIDToInt:(CBUUID *)UUID1 UUID2:(UInt16)UUID2
{
    char b1[16];
    [UUID1.data getBytes:b1];
    UInt16 b2 = [self swap:UUID2];
    if (memcmp(b1, (char *)&b2, 2) == 0) return 1;
    else return 0;
}

- (UInt16)CBUUIDToInt:(CBUUID *) UUID
{
    char b1[16];
    [UUID.data getBytes:b1];
    return ((b1[0] << 8) | b1[1]);
}

- (CBUUID*)IntToCBUUID:(UInt16)UUID
{
    char t[16];
    t[0] = ((UUID >> 8) & 0xff); t[1] = (UUID & 0xff);
    NSData *data = [[NSData alloc] initWithBytes:t length:16];
    return [CBUUID UUIDWithData:data];
}

- (CBService *)findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p
{
    for (int i = 0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        if ([self compareCBUUID:s.UUID UUID2:UUID]) return s;
    }
    return nil;
}

- (CBCharacteristic *)findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service
{
    for (int i=0; i < service.characteristics.count; i++) {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        if ([self compareCBUUID:c.UUID UUID2:UUID]) return c;
    }
    return nil;
}

- (UInt16)swap:(UInt16)s
{
    UInt16 temp = s << 8;
    temp |= (s >> 8);
    return temp;
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (!error) {
        KNS_LOG(@"Characteristics of service with UUID : %@ found", [self CBUUIDToString:service.UUID]);

#ifdef KONASHI_DEBUG
        for (int i = 0; i < service.characteristics.count; i++) {
            CBCharacteristic *c = [service.characteristics objectAtIndex:i];
            KNS_LOG(@"Found characteristic %@", [self CBUUIDToString:c.UUID]);
        }
#endif
        
        CBService *s = [peripheral.services objectAtIndex:(peripheral.services.count - 1)];
        if ([self compareCBUUID:service.UUID UUID2:s.UUID]) {
            KNS_LOG(@"Finished discovering all services' characteristics");
            [self readyModule];
        }
    }
    else {
        KNS_LOG(@"ERROR: Characteristic discorvery unsuccessfull!");
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
	
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error
{
	
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (!error) {
        KNS_LOG(@"Services of peripheral with UUID : %@ found", [self UUIDToString:peripheral.UUID]);
        [self getAllCharacteristicsFromMoudle:peripheral];
    }
    else {
        KNS_LOG(@"Service discovery was unsuccessfull !");
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{    
    KNS_LOG(@"didUpdateNotificationStateForCharacteristic");
    
    if (!error) {
        KNS_LOG(@"Updated notification state for characteristic with UUID %@ on service with  UUID %@ on peripheral with UUID %@",[self CBUUIDToString:characteristic.UUID],[self CBUUIDToString:characteristic.service.UUID], [self UUIDToString:peripheral.UUID]);
    }
    else {
        KNS_LOG(@"Error in setting notification state for characteristic with UUID %@ on service with  UUID %@ on peripheral with UUID %@",[self CBUUIDToString:characteristic.UUID], [self CBUUIDToString:characteristic.service.UUID], [self UUIDToString:peripheral.UUID]);
        KNS_LOG(@"Error code was %@", [error description]);
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    UInt16 characteristicUUID = [self CBUUIDToInt:characteristic.UUID];
    unsigned char byte[32];
    
    KNS_LOG(@"didUpdateValueForCharacteristic");
    
    if (!error) {
        switch(characteristicUUID){
            case KONASHI_PIO_INPUT_NOTIFICATION_UUID:{
				[characteristic.value getBytes:&byte length:KONASHI_PIO_INPUT_NOTIFICATION_READ_LEN];
				int xor = (piobyte[0] ^ byte[0]) & (0xff ^ pioSetting);
                [characteristic.value getBytes:&piobyte length:KONASHI_PIO_INPUT_NOTIFICATION_READ_LEN];
                pioInput = byte[0];
				if (self.digitalInputDidChangeValueHandler) {
					for (int i = 7; i >= 0; i--) {
						if (xor & 1 << i) {
							self.digitalInputDidChangeValueHandler(self, i, [self digitalRead:i]);
						}
					}
				}
				else {
					[self postNotification:KONASHI_EVENT_UPDATE_PIO_INPUT];
				}
                
                break;
            }

            case KONASHI_ANALOG_READ0_UUID:
            case KONASHI_ANALOG_READ1_UUID:
            case KONASHI_ANALOG_READ2_UUID:{
				int index = characteristicUUID & 0x000F - 8;
                [characteristic.value getBytes:&byte length:KONASHI_ANALOG_READ_LEN];
                analogValue[index] = byte[0]<<8 | byte[1];
                int value = analogValue[index];
				if (self.analogPinDidChangeValueHandler) {
					self.analogPinDidChangeValueHandler(self, index, value);
				}
				else {
					[self postNotification:KONASHI_EVENT_UPDATE_ANALOG_VALUE];
					[self postNotification:@[KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO0, KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO1, KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO2][index]];
				}
                
                break;
            }
            
            case KONASHI_I2C_READ_UUID:{
                [characteristic.value getBytes:i2cReadData length:i2cReadDataLength];
                 // [0]: MSB
                if (self.i2cReadCompleteHandler) {
					self.i2cReadCompleteHandler(self, i2cReadData);
				}
				else {
					[self postNotification:KONASHI_EVENT_I2C_READ_COMPLETE];
				}
                
                break;
            }
                
            case KONASHI_UART_RX_NOTIFICATION_UUID:{
                [characteristic.value getBytes:&uartRxData length:1];
                // [0]: MSB
                
				if (self.uartRxCompleteHandler) {
					self.uartRxCompleteHandler(self, uartRxData);
				}
				else {
					[self postNotification:KONASHI_EVENT_UART_RX_COMPLETE];
				}
                
                break;
            }
                
            case KONASHI_LEVEL_SERVICE_UUID:{
                [characteristic.value getBytes:&byte length:KONASHI_LEVEL_SERVICE_READ_LEN];
                batteryLevel = byte[0];
                if (self.batteryLevelDidUpdateHandler) {
					self.batteryLevelDidUpdateHandler(self, batteryLevel);
				}
				else {
					[self postNotification:KONASHI_EVENT_UPDATE_BATTERY_LEVEL];
				}
                
                break;
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    KNS_LOG(@"didUpdateValueForDescriptor");
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    KNS_LOG(@"didWriteValueForCharacteristic");
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    KNS_LOG(@"didWriteValueForDescriptor");
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    KNS_LOG(@"peripheralDidUpdateRSSI");
    
    rssi = [peripheral.RSSI intValue];
    
	if (self.signalStrengthDidUpdateHandler) {
		self.signalStrengthDidUpdateHandler(self, rssi);
	}
	else {
		[self postNotification:KONASHI_EVENT_UPDATE_SIGNAL_STRENGTH];
	}
}

@end
