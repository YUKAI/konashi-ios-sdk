//
//  KonashiPeripheral.h
//  Konashi
//
//  Created by Akira Matsuda on 9/18/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "KonashiConstant.h"
#import "KNSPeripheralImplProtocol.h"
#import "KNSPeripheralBaseImpl.h"
#import "CBUUID+Konashi.h"
#import "CBService+Konashi.h"
#import "CBPeripheral+Konashi.h"
#import "KNSHandlerManager.h"

@interface KNSPeripheral : NSObject <CBPeripheralDelegate>

@property (nonatomic, readonly, getter=isReady) BOOL ready;
@property (nonatomic, readonly) KNSPeripheralBaseImpl<KNSPeripheralImplProtocol> *impl;
@property (nonatomic, strong) KNSHandlerManager *handlerManager;
@property (nonatomic, readonly) NSString *softwareRevisionString;

/// ---------------------------------
/// @name Event handler
/// ---------------------------------

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

- (instancetype)initWithPeripheral:(CBPeripheral *)p;
- (void)writeData:(NSData *)data serviceUUID:(CBUUID*)uuid characteristicUUID:(CBUUID*)charasteristicUUID;
- (void)readDataWithServiceUUID:(CBUUID*)uuid characteristicUUID:(CBUUID*)charasteristicUUID;
- (void)notificationWithServiceUUID:(CBUUID*)uuid characteristicUUID:(CBUUID*)characteristicUUID on:(BOOL)on;

- (CBPeripheral *)peripheral;
- (CBPeripheralState)state;

- (KonashiResult) pinMode:(KonashiDigitalIOPin)pin mode:(KonashiPinMode)mode;
- (KonashiResult) pinModeAll:(int)mode;
- (KonashiResult) pinPullup:(KonashiDigitalIOPin)pin mode:(KonashiPinMode)mode;
- (KonashiResult) pinPullupAll:(int)mode;
- (KonashiLevel) digitalRead:(KonashiDigitalIOPin)pin;
- (int) digitalReadAll;
- (KonashiResult) digitalWrite:(KonashiDigitalIOPin)pin value:(KonashiLevel)value;
- (KonashiResult) digitalWriteAll:(int)value;

- (KonashiResult) pwmMode:(KonashiDigitalIOPin)pin mode:(KonashiPWMMode)mode;
- (KonashiResult) pwmPeriod:(KonashiDigitalIOPin)pin period:(unsigned int)period;
- (KonashiResult) pwmDuty:(KonashiDigitalIOPin)pin duty:(unsigned int)duty;
- (KonashiResult) pwmLedDrive:(KonashiDigitalIOPin)pin dutyRatio:(int)ratio;

- (KonashiResult) readValueAio:(KonashiAnalogIOPin)pin;

- (int) analogReference;
- (KonashiResult) analogReadRequest:(KonashiAnalogIOPin)pin;
- (int) analogRead:(KonashiAnalogIOPin)pin;
- (KonashiResult) analogWrite:(KonashiAnalogIOPin)pin milliVolt:(int)milliVolt;

- (KonashiResult) i2cMode:(KonashiI2CMode)mode;
- (KonashiResult) i2cSendCondition:(KonashiI2CCondition)condition;
- (KonashiResult) i2cStartCondition;
- (KonashiResult) i2cRestartCondition;
- (KonashiResult) i2cStopCondition;
- (KonashiResult) i2cWrite:(int)length data:(unsigned char*)data address:(unsigned char)address;
- (KonashiResult) i2cWriteData:(NSData *)data address:(unsigned char)address;
- (KonashiResult) i2cReadRequest:(int)length address:(unsigned char)address;
- (KonashiResult) i2cRead:(int)length data:(unsigned char*)data;
- (NSData *) i2cReadData;

- (KonashiResult) uartMode:(KonashiUartMode)mode baudrate:(KonashiUartBaudrate)baudrate;
- (KonashiResult) uartMode:(KonashiUartMode)mode;
- (KonashiResult) uartBaudrate:(KonashiUartBaudrate)baudrate;
- (KonashiResult) uartWrite:(unsigned char)data;
- (KonashiResult) uartWriteData:(NSData *)data;
- (NSData *) readUartData;

- (KonashiResult) reset;
- (KonashiResult) batteryLevelReadRequest;
- (int) batteryLevelRead;
- (KonashiResult) signalStrengthReadRequest;
- (int) signalStrengthRead;

- (void)enablePIOInputNotification;
- (void)enableUART_RXNotification;

@end
