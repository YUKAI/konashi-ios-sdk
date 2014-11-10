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
#import "KNSHandlerManager.h"

// Konashi interface
@interface Konashi : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>
{
	NSString *findName;
	BOOL isReady;
	BOOL isCallFind;
    NSMutableArray *peripherals;
    CBCentralManager *cm;
	
	KNSHandlerManager *handlerManager;
}

@property (nonatomic, readonly) KNSPeripheral *activePeripheral;

/**
 *  このHandlerはKonashiが接続された際に呼び出されます。
 */
@property (nonatomic, copy) KonashiEventHandler connectedHandler;

/**
 *  このHandlerはKonashiが切断された際に呼び出されます。
 */
@property (nonatomic, copy) KonashiEventHandler disconnectedHandler;

/**
 *  このHandlerはKonashiが使用可能状態になった際に呼び出されます。
 */
@property (nonatomic, copy) KonashiEventHandler readyHandler;

/**
 *  このHandlerはKonashiPinModeInputに設定されているPIOの値が変化した際に呼び出されます。
 */
@property (nonatomic, copy) KonashiDigitalPinDidChangeValueHandler digitalInputDidChangeValueHandler;

/**
 *  このHandlerはKonashiPinModeOutputに設定されているPIOの値が変化した際に呼び出されます。
 */
@property (nonatomic, copy) KonashiDigitalPinDidChangeValueHandler digitalOutputDidChangeValueHandler;

/**
 *  このHandlerはAIOの値が変化した際に呼び出されます。
 */
@property (nonatomic, copy) KonashiAnalogPinDidChangeValueHandler analogPinDidChangeValueHandler;

/**
 *  このHandlerはUartで値を受信した際に呼び出されます。
 */
@property (nonatomic, copy) KonashiUartRxCompleteHandler uartRxCompleteHandler;

/**
 *  このHandlerはI2Cで接続されたモジュールからデータを読みだした際に呼び出されます。
 */
@property (nonatomic, copy) KonashiI2CReadCompleteHandler i2cReadCompleteHandler;

/**
 *  このHandlerはバッテリー残量の値を取得した際に呼び出されます。
 */
@property (nonatomic, copy) KonashiBatteryLevelDidUpdateHandler batteryLevelDidUpdateHandler;

/**
 *  このHandlerはRSSIが変化した際に呼び出されます。
 */
@property (nonatomic, copy) KonashiSignalStrengthDidUpdateHandler signalStrengthDidUpdateHandler;

// Singleton
+ (Konashi *) shared;

// Konashi control methods
+ (KonashiResult) initialize;
+ (KonashiResult) find;
+ (KonashiResult) findWithName:(NSString*)name;
+ (NSString *)softwareRevisionString;
+ (KonashiResult) disconnect;
+ (BOOL) isConnected;
+ (BOOL) isReady;
+ (NSString *)peripheralName;

// Digital PIO methods
+ (KonashiResult) pinMode:(KonashiDigitalIOPin)pin mode:(KonashiPinMode)mode;
+ (KonashiResult) pinModeAll:(int)mode;
+ (KonashiResult) digitalWrite:(KonashiDigitalIOPin)pin value:(KonashiLevel)value;
+ (KonashiResult) digitalWriteAll:(int)value;
+ (KonashiResult) pinPullup:(KonashiDigitalIOPin)pin mode:(KonashiPinMode)mode;
+ (KonashiResult) pinPullupAll:(int)mode;

// PWM methods
+ (KonashiResult) pwmMode:(KonashiDigitalIOPin)pin mode:(KonashiPWMMode)mode;
+ (KonashiResult) pwmPeriod:(KonashiDigitalIOPin)pin period:(unsigned int)period;
+ (KonashiResult) pwmDuty:(KonashiDigitalIOPin)pin duty:(unsigned int)duty;
+ (KonashiResult) pwmLedDrive:(KonashiDigitalIOPin)pin dutyRatio:(int)ratio;

// Analog IO methods
+ (int) analogReference;
+ (KonashiResult) analogReadRequest:(KonashiAnalogIOPin)pin;
+ (KonashiResult) analogWrite:(KonashiAnalogIOPin)pin milliVolt:(int)milliVolt;

// I2C methods
+ (KonashiResult) i2cMode:(KonashiI2CMode)mode;
+ (KonashiResult) i2cStartCondition;
+ (KonashiResult) i2cRestartCondition;
+ (KonashiResult) i2cStopCondition;
+ (KonashiResult) i2cWrite:(int)length data:(unsigned char*)data address:(unsigned char)address;
+ (KonashiResult) i2cReadRequest:(int)length address:(unsigned char)address;

// UART methods
+ (KonashiResult) uartMode:(KonashiUartMode)mode;
+ (KonashiResult) uartBaudrate:(KonashiUartBaudrate)baudrate;
+ (KonashiResult) uartWrite:(unsigned char)data;

// Konashi hardware methods
+ (KonashiResult) reset;
+ (KonashiResult) batteryLevelReadRequest;
+ (KonashiResult) signalStrengthReadRequest;

// Konashi event methods
+ (void) addObserver:(id)notificationObserver selector:(SEL)notificationSelector name:(NSString*)notificationName;
+ (void) removeObserver:(id)notificationObserver;

@end
