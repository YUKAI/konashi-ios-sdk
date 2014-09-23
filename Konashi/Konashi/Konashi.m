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

+ (int) initialize
{
    return [[Konashi shared] _initializeKonashi];
}

+ (int) find
{
    return [[Konashi shared] _findModule:KONASHI_FIND_TIMEOUT];
}

+ (int) findWithName:(NSString*)name
{
    return [[Konashi shared] _findModuleWithName:name timeout:KONASHI_FIND_TIMEOUT];
}

+ (int) disconnect
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

+ (int) pinMode:(int)pin mode:(int)mode
{    
    return [[Konashi shared].activePeripheral pinMode:pin mode:mode];
}

+ (int) pinModeAll:(int)mode
{
    return [[Konashi shared].activePeripheral pinModeAll:mode];
}

+ (int) pinPullup:(int)pin mode:(int)mode
{
    return [[Konashi shared].activePeripheral pinPullup:pin mode:mode];
}

+ (int) pinPullupAll:(int)mode
{
    return [[Konashi shared].activePeripheral pinPullupAll:mode];
}

+ (int) digitalRead:(int)pin
{
    return [[Konashi shared].activePeripheral digitalRead:pin];
}

+ (int) digitalReadAll
{
    return [[Konashi shared].activePeripheral digitalReadAll];
}

+ (int) digitalWrite:(int)pin value:(int)value
{
    return [[Konashi shared].activePeripheral digitalWrite:pin value:value];
}

+ (int) digitalWriteAll:(int)value
{
    return [[Konashi shared].activePeripheral digitalWriteAll:value];
}




#pragma mark -
#pragma mark - Konashi PWM public methods

+ (int) pwmMode:(int)pin mode:(int)mode
{
    return [[Konashi shared].activePeripheral pwmMode:pin mode:mode];
}

+ (int) pwmPeriod:(int)pin period:(unsigned int)period
{
    return [[Konashi shared].activePeripheral pwmPeriod:pin period:period];
}

+ (int) pwmDuty:(int)pin duty:(unsigned int)duty
{
    return [[Konashi shared].activePeripheral pwmDuty:pin duty:duty];
}

+ (int) pwmLedDrive:(int)pin dutyRatio:(int)ratio
{
    return [[Konashi shared].activePeripheral pwmLedDrive:pin dutyRatio:ratio];
}




#pragma mark -
#pragma mark - Konashi analog IO public methods

+ (int) analogReference
{
    return KONASHI_ANALOG_REFERENCE;
}

+ (int) analogReadRequest:(int)pin
{
    return [[Konashi shared].activePeripheral analogReadRequest:pin];
}

+ (int) analogRead:(int)pin
{
    return [[Konashi shared].activePeripheral analogRead:pin];
}

+ (int) analogWrite:(int)pin milliVolt:(int)milliVolt
{
    return [[Konashi shared].activePeripheral analogWrite:pin milliVolt:(int)milliVolt];
}




#pragma mark -
#pragma mark - Konashi I2C public methods

+ (int) i2cMode:(int)mode
{
    return [[Konashi shared].activePeripheral i2cMode:mode];
}

+ (int) i2cStartCondition
{
    return [[Konashi shared].activePeripheral i2cSendCondition:KONASHI_I2C_START_CONDITION];
}

+ (int) i2cRestartCondition
{
    return [[Konashi shared].activePeripheral i2cSendCondition:KONASHI_I2C_RESTART_CONDITION];
}

+ (int) i2cStopCondition
{
    return [[Konashi shared].activePeripheral i2cSendCondition:KONASHI_I2C_STOP_CONDITION];
}

+ (int) i2cWrite:(int)length data:(unsigned char*)data address:(unsigned char)address
{
    return [[Konashi shared].activePeripheral i2cWrite:length data:data address:address];
}

+ (int) i2cReadRequest:(int)length address:(unsigned char)address
{
    return [[Konashi shared].activePeripheral i2cReadRequest:length address:address];
}

+ (int) i2cRead:(int)length data:(unsigned char*)data
{
    return [[Konashi shared].activePeripheral i2cRead:length data:data];
}




#pragma mark -
#pragma mark - Konashi UART public methods

+ (int) uartMode:(int)mode
{
    return [[Konashi shared].activePeripheral uartMode:mode];
}

+ (int) uartBaudrate:(int)baudrate
{
    return [[Konashi shared].activePeripheral uartBaudrate:baudrate];
}

+ (int) uartWrite:(unsigned char)data
{
    return [[Konashi shared].activePeripheral uartWrite:data];
}

+ (unsigned char) uartRead
{
    return [[Konashi shared].activePeripheral uartRead];
}




#pragma mark -
#pragma mark - Konashi hardware public methods

+ (int) reset
{
    return [[Konashi shared].activePeripheral reset];
}

+ (int) batteryLevelReadRequest
{
    return [[Konashi shared].activePeripheral batteryLevelReadRequest];
}

+ (int) batteryLevelRead
{
    return [[Konashi shared].activePeripheral batteryLevelRead];
}

+ (int) signalStrengthReadRequest
{
    return [[Konashi shared].activePeripheral signalStrengthReadRequest];
}

+ (int) signalStrengthRead
{
    return [[Konashi shared].activePeripheral signalStrengthRead];
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

- (int) _initializeKonashi
{
    if(!cm){
        cm = [[CBCentralManager alloc] initWithDelegate:[Konashi shared] queue:nil];
        return KONASHI_SUCCESS;
    } else {
        return KONASHI_FAILURE;
    }
}

- (int) _findModule:(int) timeout
{
    if(self.activePeripheral && self.activePeripheral.state == CBPeripheralStateConnected){
        return KONASHI_FAILURE;
    }
        
    if (cm.state  != CBCentralManagerStatePoweredOn) {
        KNS_LOG(@"CoreBluetooth not correctly initialized !");
        KNS_LOG(@"State = %ld (%@)", cm.state, NSStringFromCBCentralManagerState(cm.state));
		
        isCallFind = YES;
        
        return KONASHI_SUCCESS;
    }
    
    if(peripherals) peripherals = nil;
    
    [NSTimer scheduledTimerWithTimeInterval:(float)timeout target:self selector:@selector(finishScanModule:) userInfo:nil repeats:NO];
    
    [cm scanForPeripheralsWithServices:nil options:0];
    
    return KONASHI_SUCCESS;
}

- (int) _findModuleWithName:(NSString*)name timeout:(int)timeout{
    if(self.activePeripheral && self.activePeripheral.state == CBPeripheralStateConnected){
        return KONASHI_FAILURE;
    }
        
    if (cm.state  != CBCentralManagerStatePoweredOn) {
        KNS_LOG(@"CoreBluetooth not correctly initialized !");
        KNS_LOG(@"State = %ld (%@)", cm.state, NSStringFromCBCentralManagerState(cm.state));
        
        isCallFind = YES;
        findName = name;
        
        return KONASHI_SUCCESS;
    }
    
    if(peripherals) peripherals = nil;
    
    [NSTimer scheduledTimerWithTimeInterval:(float)timeout target:self selector:@selector(finishScanModuleWithName:) userInfo:name repeats:NO];

        
    [cm scanForPeripheralsWithServices:nil options:0];
    
    return KONASHI_SUCCESS;
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
        [[Konashi shared] postNotification:KONASHI_EVENT_PERIPHERAL_NOT_FOUND];
    }
}

- (void) finishScanModule:(NSTimer *)timer
{
    [cm stopScan];
    
    KNS_LOG(@"Peripherals: %lu", (unsigned long)[peripherals count]);
    
    if ( [peripherals count] > 0 ) {
        [[Konashi shared] postNotification:KONASHI_EVENT_PERIPHERAL_FOUND];
		[self showModulePicker];
    } else {
        [[Konashi shared] postNotification:KONASHI_EVENT_NO_PERIPHERALS_AVAILABLE];
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
    
	[[NSNotificationCenter defaultCenter] postNotificationName:KONASHI_EVENT_READY object:nil];
	
    // Enable PIO input notification
	[_activePeripheral enablePIOInputNotification];
	
    // Enable UART RX notification
	[_activePeripheral enableUART_RXNotification];
}

- (int) _disconnectModule
{
    if(self.activePeripheral && self.activePeripheral.state == CBPeripheralStateConnected){
        [cm cancelPeripheralConnection:self.activePeripheral.peripheral];
        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
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
        [[Konashi shared] postNotification:KONASHI_EVENT_CENTRAL_MANAGER_POWERED_ON];
        
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
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    KNS_LOG(@"Disconnect from the peripheral: %@, error: %@", [peripheral name], error);
    
	[[NSNotificationCenter defaultCenter] postNotificationName:KONASHI_EVENT_DISCONNECTED object:nil];
}

@end
