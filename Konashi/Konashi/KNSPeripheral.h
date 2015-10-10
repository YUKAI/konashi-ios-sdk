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
@property (nonatomic, copy) void (^connectedHandler)();

/**
 *  このHandlerはKonashiが切断された際に呼び出されます。
 */
@property (nonatomic, copy) void (^disconnectedHandler)();

/**
 *  このHandlerはKonashiが使用可能状態になった際に呼び出されます。
 */
@property (nonatomic, copy) void (^readyHandler)();

/**
 *  このHandlerはKonashiPinModeInputに設定されているPIOの値が変化した際に呼び出されます。
 */
@property (nonatomic, copy) void (^digitalInputDidChangeValueHandler)(KonashiDigitalIOPin pin, int value);

/**
 *  このHandlerはKonashiPinModeOutputに設定されているPIOの値が変化した際に呼び出されます。
 */
@property (nonatomic, copy) void (^digitalOutputDidChangeValueHandler)(KonashiDigitalIOPin pin, int value);

/**
 *  このHandlerはAIOの値が変化した際に呼び出されます。
 */
@property (nonatomic, copy) void (^analogPinDidChangeValueHandler)(KonashiAnalogIOPin pin, int value);

/**
 *  このHandlerはUartで値を受信した際に呼び出されます。
 */
@property (nonatomic, copy) void (^uartRxCompleteHandler)(NSData *data);

/**
 *  このHandlerはI2Cで接続されたモジュールからデータを読みだした際に呼び出されます。
 */
@property (nonatomic, copy) void (^i2cReadCompleteHandler)(NSData *data);

/**
 *  このHandlerはバッテリー残量の値を取得した際に呼び出されます。
 */
@property (nonatomic, copy) void (^batteryLevelDidUpdateHandler)(int value);

/**
 *  このHandlerはRSSIが変化した際に呼び出されます。
 */
@property (nonatomic, copy) void (^signalStrengthDidUpdateHandler)(int value);

/**
 *  このHandlerはSPI経由でのデータ書き込み完了時に呼び出されます。呼びだされた瞬間からSPIモジュールから受け取るデータを取得することができます。
 * @note このHanderはSPI機能が追加されたファームウェアを搭載したkoshianでのみ呼びだされます。 +spiReadRequest メソッドを呼び出すことでkoshianからデータを読み出すことが可能です。
 */
@property (nonatomic, copy) void (^spiWriteCompleteHandler)();

/**
 *  このHandlerは +spiReadRequest メソッドを用いてデータを受信した時に呼び出されます。
 * @param data 受信したデータ
 * @note このHanderはSPI機能が追加されたファームウェアを搭載したkoshianでのみ呼びだされます。
 */
@property (nonatomic, copy) void (^spiReadCompleteHandler)(NSData *data);

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

- (KonashiResult)spiMode:(KonashiSPIMode)mode speed:(KonashiSPISpeed)speed bitOrder:(KonashiSPIBitOrder)bitOrder;
- (KonashiResult)spiWrite:(NSData *)data;
- (KonashiResult)spiReadRequest;
- (NSData *)spiReadData;

- (KonashiResult) reset;
- (KonashiResult) batteryLevelReadRequest;
- (int) batteryLevelRead;
- (KonashiResult) signalStrengthReadRequest;
- (int) signalStrengthRead;

- (void)enablePIOInputNotification;
- (void)enableUART_RXNotification;
- (void)enableSPI_MISONotification;

@end
