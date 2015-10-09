//
//  KNSPeripheralImplProtocol.h
//  Konashi
//
//  Created by Akira Matsuda on 9/20/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@protocol KNSPeripheralImplProtocol <NSObject>

@required
- (void)discoverCharacteristics;

- (NSInteger)uartDataMaxLength;
+ (NSInteger)i2cDataMaxLength;
+ (NSInteger)levelServiceReadLength;
+ (NSInteger)pioInputNotificationReadLength;
+ (NSInteger)analogReadLength;
+ (NSInteger)uartRX_NotificationReadLength;
+ (NSInteger)hardwareLowBatteryNotificationReadLength;

// UUID
+ (CBUUID *)batteryServiceUUID;
+ (CBUUID *)levelServiceUUID;
+ (CBUUID *)powerStateUUID;
+ (CBUUID *)serviceUUID;
// PIO
+ (CBUUID *)pioSettingUUID;
+ (CBUUID *)pioPullupUUID;
+ (CBUUID *)pioOutputUUID;
+ (CBUUID *)pioInputNotificationUUID;

// PWM
+ (CBUUID *)pwmConfigUUID;
+ (CBUUID *)pwmParamUUID;
+ (CBUUID *)pwmDutyUUID;

// Analog
+ (CBUUID *)analogDriveUUID;
+ (CBUUID *)analogReadUUIDWithPinNumber:(NSInteger)pin;

// I2C
+ (CBUUID *)i2cConfigUUID;
+ (CBUUID *)i2cStartStopUUID;
+ (CBUUID *)i2cWriteUUID;
+ (CBUUID *)i2cReadParamUUID;
+ (CBUUID *)i2cReadUUID;

// UART
+ (CBUUID *)uartConfigUUID;
+ (CBUUID *)uartBaudrateUUID;
+ (CBUUID *)uartTX_UUID;
+ (CBUUID *)uartRX_NotificationUUID;

// Hardware
+ (CBUUID *)hardwareResetUUID;
+ (CBUUID *)lowBatteryNotificationUUID;
+ (int) analogReference;

@optional
- (CBPeripheralState)state;
- (BOOL)isReady;

- (KonashiResult)writeValuePioSetting;
- (KonashiResult)writeValuePioPullup;
- (KonashiResult)writeValuePioOutput;

- (KonashiResult) pinMode:(KonashiDigitalIOPin)pin mode:(KonashiPinMode)mode;
- (KonashiResult) pinModeAll:(int)mode;
- (KonashiResult) pinPullup:(KonashiDigitalIOPin)pin mode:(KonashiPinMode)mode;
- (KonashiResult) pinPullupAll:(int)mode;
- (KonashiLevel) digitalRead:(KonashiDigitalIOPin)pin;
- (int) digitalReadAll;
- (KonashiResult) digitalWrite:(KonashiDigitalIOPin)pin value:(KonashiLevel)value;
- (KonashiResult) digitalWriteAll:(int)value;
- (void)digitalIODidUpdate:(NSData *)data;

- (KonashiResult) writeValuePwmSetting;
- (KonashiResult) writeValuePwmPeriod:(KonashiDigitalIOPin)pin;
- (KonashiResult) writeValuePwmDuty:(KonashiDigitalIOPin)pin;

- (KonashiResult) pwmMode:(KonashiDigitalIOPin)pin mode:(KonashiPWMMode)mode;
- (KonashiResult) pwmPeriod:(KonashiDigitalIOPin)pin period:(unsigned int)period;
- (KonashiResult) pwmDuty:(KonashiDigitalIOPin)pin duty:(unsigned int)duty;
- (KonashiResult) pwmLedDrive:(KonashiDigitalIOPin)pin dutyRatio:(int)ratio;

- (KonashiResult) readValueAio:(KonashiAnalogIOPin)pin;

- (KonashiResult) analogReadRequest:(KonashiAnalogIOPin)pin;
- (int) analogRead:(KonashiAnalogIOPin)pin;
- (KonashiResult) analogWrite:(KonashiAnalogIOPin)pin milliVolt:(int)milliVolt;
- (void)analogIODidUpdate:(NSData *)data pin:(KonashiAnalogIOPin)pin;

- (KonashiResult) i2cMode:(KonashiI2CMode)mode;
- (KonashiResult) i2cSendCondition:(KonashiI2CCondition)condition;
- (KonashiResult) i2cStartCondition;
- (KonashiResult) i2cRestartCondition;
- (KonashiResult) i2cStopCondition;
- (KonashiResult) i2cWrite:(int)length data:(unsigned char*)data address:(unsigned char)address;
- (KonashiResult) i2cWriteData:(NSData *)data address:(unsigned char)address;
- (KonashiResult) i2cReadRequest:(int)length address:(unsigned char)address;
- (KonashiResult) i2cRead:(int)length data:(unsigned char*)data;
- (NSData *)i2cReadData;
- (void)i2cDataDidUpdate:(NSData *)data;

- (KonashiResult) uartMode:(KonashiUartMode)mode baudrate:(KonashiUartBaudrate)baudrate;
- (KonashiResult) uartMode:(KonashiUartMode)mode;
- (KonashiResult) uartBaudrate:(KonashiUartBaudrate)baudrate;
- (KonashiResult) uartWriteData:(NSData *)data;
- (NSData *) readUartData;
- (void)uartDataDidUpdate:(NSData *)data;

- (void)didReceiveSoftwareRevisionStringData:(NSData *)data;
- (KonashiResult) reset;
- (KonashiResult) batteryLevelReadRequest;
- (void)batteryLevelDataDidUpdate:(NSData *)data;
- (int) batteryLevelRead;
- (KonashiResult) signalStrengthReadRequest;
- (int) signalStrengthRead;
- (void)enablePIOInputNotification;
- (void)enableUART_RXNotification;

@end