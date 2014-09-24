/* ========================================================================
 * Konashi.h
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


#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>
#import "KonashiConstant.h"
#import "KNSPeripheralImpls.h"
#import "KNSPeripheral.h"
#import "KNSUUIDExtern.h"

// Konashi interface
@interface Konashi : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>
{
	NSString *findName;
	BOOL isReady;
	BOOL isCallFind;
    NSMutableArray *peripherals;
    CBCentralManager *cm;
}

@property (nonatomic, readonly) KNSPeripheral *activePeripheral;

// Singleton
+ (Konashi *) shared;

// Konashi control methods
+ (int) initialize;
+ (int) find;
+ (int) findWithName:(NSString*)name;
+ (int) disconnect;
+ (BOOL) isConnected;
+ (BOOL) isReady;
+ (NSString *)peripheralName;

// Digital PIO methods
+ (int) pinMode:(int)pin mode:(int)mode;
+ (int) pinModeAll:(int)mode;
+ (int) pinPullup:(int)pin mode:(int)mode;
+ (int) pinPullupAll:(int)mode;
+ (int) digitalRead:(int)pin;
+ (int) digitalReadAll;
+ (int) digitalWrite:(int)pin value:(int)value;
+ (int) digitalWriteAll:(int)value;

// PWM methods
+ (int) pwmMode:(int)pin mode:(int)mode;
+ (int) pwmPeriod:(int)pin period:(unsigned int)period;
+ (int) pwmDuty:(int)pin duty:(unsigned int)duty;
+ (int) pwmLedDrive:(int)pin dutyRatio:(int)ratio;

// Analog IO methods
+ (int) analogReference;
+ (int) analogReadRequest:(int)pin;
+ (int) analogRead:(int)pin;
+ (int) analogWrite:(int)pin milliVolt:(int)milliVolt;

// I2C methods
+ (int) i2cMode:(int)mode;
+ (int) i2cStartCondition;
+ (int) i2cRestartCondition;
+ (int) i2cStopCondition;
+ (int) i2cWrite:(int)length data:(unsigned char*)data address:(unsigned char)address;
+ (int) i2cReadRequest:(int)length address:(unsigned char)address;
+ (int) i2cRead:(int)length data:(unsigned char*)data;

// UART methods
+ (int) uartMode:(int)mode;
+ (int) uartBaudrate:(int)baudrate;
+ (int) uartWrite:(unsigned char)data;
+ (unsigned char) uartRead;

// Konashi hardware methods
+ (int) reset;
+ (int) batteryLevelReadRequest;
+ (int) batteryLevelRead;
+ (int) signalStrengthReadRequest;
+ (int) signalStrengthRead;


// Konashi event methods
+ (void) addObserver:(id)notificationObserver selector:(SEL)notificationSelector name:(NSString*)notificationName;
+ (void) removeObserver:(id)notificationObserver;

@end
